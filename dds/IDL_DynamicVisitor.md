# DynamicType Visitor by Antlr4 Cpp Runtime

```C++
#include <iostream>
#include <any>
#include <antlr4-runtime.h>
#include <fastrtps/types/DynamicTypeBuilderFactory.h>
#include <fastrtps/types/DynamicTypeBuilder.h>
#include <fastrtps/types/DynamicType.h>
#include <fastrtps/types/DynamicTypeMember.h>
#include <fastrtps/types/DynamicData.h>

#include "IDLBaseVisitor.h"
#include "IDLLexer.h"
#include "IDLParser.h"

using namespace std;
using namespace antlr4::tree;
using namespace eprosima::fastrtps::types;

class DynamicTypeVisitor : public IDLBaseVisitor {
public:
    DynamicTypeBuilder *final = nullptr;
    std::map<std::string, DynamicTypeBuilder *> structs;
    DynamicTypeBuilderFactory *factory = DynamicTypeBuilderFactory::get_instance();

    any visitSigned_short_int(IDLParser::Signed_short_intContext *ctx) override {
        return factory->create_int16_builder();
    }

    any visitSigned_long_int(IDLParser::Signed_long_intContext *ctx) override {
        return factory->create_int32_builder();
    }

    any visitSigned_longlong_int(IDLParser::Signed_longlong_intContext *ctx) override {
        return factory->create_int64_builder();
    }

    any visitUnsigned_short_int(IDLParser::Unsigned_short_intContext *ctx) override {
        return factory->create_uint16_builder();
    }

    any visitUnsigned_long_int(IDLParser::Unsigned_long_intContext *ctx) override {
        return factory->create_uint32_builder();
    }

    any visitUnsigned_longlong_int(IDLParser::Unsigned_longlong_intContext *ctx) override {
        return factory->create_uint64_builder();
    }

    any visitBoolean_type(IDLParser::Boolean_typeContext *ctx) override {
        return factory->create_bool_builder();
    }

    any visitChar_type(IDLParser::Char_typeContext *ctx) override {
        return factory->create_char8_builder();
    }

    any visitOctet_type(IDLParser::Octet_typeContext *ctx) override {
        return factory->create_byte_builder();
    }

    any visitWide_char_type(IDLParser::Wide_char_typeContext *ctx) override {
        return factory->create_char16_builder();
    }

    any visitFloating_pt_type(IDLParser::Floating_pt_typeContext *ctx) override {
        auto type = ctx->getText();
        if (type == "float")
            return factory->create_float32_builder();
        else if (type == "double")
            return factory->create_float64_builder();
        else if (type == "longdouble")
            return factory->create_float128_builder();
        else
            return nullptr;
    }

    int bitbound = 0;
    any visitBitmask_type(IDLParser::Bitmask_typeContext *ctx) override {
        auto builder = factory->create_bitmask_builder(bitbound);
        auto identifier = ctx->identifier()->getText();
        auto bit_values = ctx->bit_values();
        int idx = 0;
        for (auto appl : bit_values->annotation_appl()) {
            auto id = bit_values->identifier()[idx];
            builder->add_empty_member(idx, id->getText());
            if (appl->scoped_name()->getText() == "position") {
                builder->apply_annotation_to_member(
                        idx,
                        "position",
                        "value",
                        appl->annotation_appl_params()->getText());
            }
            idx++;
        }

        bitbound = 0;
        return builder;
    }

    std::vector<std::string> namespaces;
    any visitModule(IDLParser::ModuleContext *ctx) override {
        namespaces.push_back(ctx->identifier()->getText());
        any ret = IDLBaseVisitor::visitModule(ctx);
        namespaces.pop_back();
        return ret;
    }

    any visitDefinition(IDLParser::DefinitionContext *ctx) override {
        if (ctx->aux_definition() != nullptr) {
            auto aux_definition = ctx->aux_definition();
            if (ctx->annotation_appl() != nullptr) {
                auto annotation_appl = ctx->annotation_appl();
                auto scoped_name = annotation_appl->scoped_name()->getText();
                if (scoped_name == "bit_bound") {
                    auto annotation_appl_params = annotation_appl->annotation_appl_params()->getText();
                    bitbound = std::atoi(annotation_appl_params.c_str());
                }
                DynamicTypeBuilder *builder = any_cast<DynamicTypeBuilder *>(visit(aux_definition));
                structs[builder->get_name()] = builder;
                return builder;
            }
        }
        return visitChildren(ctx);
    }

    any visitString_type(IDLParser::String_typeContext *ctx) override {
        if (ctx->positive_int_const() != nullptr) {
            auto bound_str = ctx->positive_int_const()->getText();
            auto bound = std::stoi(bound_str);
            return factory->create_string_builder(bound);
        } else {
            return factory->create_string_builder();
        }
    }

    any visitWide_string_type(IDLParser::Wide_string_typeContext *ctx) override {
        if (ctx->positive_int_const() != nullptr) {
            auto bound_str = ctx->positive_int_const()->getText();
            auto bound = std::stoi(bound_str);
            return factory->create_wstring_builder(bound);
        } else {
            return factory->create_wstring_builder();
        }
    }

    std::map<string, int> enum_values;

    any visitEnum_type(IDLParser::Enum_typeContext *ctx) override {
        DynamicTypeBuilder *builder = factory->create_enum_builder();
        auto identifier = ctx->identifier()->getText();
        builder->set_name(identifier);
        auto enumerator_list = ctx->enumerator_list();
        int idx = 0;
        for (auto enumerator : enumerator_list->enumerator()) {
            auto id = enumerator->identifier()->getText();
            builder->add_empty_member(idx, id);
            enum_values[id] = idx;
            idx++;
        }

        structs[identifier] = builder;
        return builder;
    }

    any visitUnion_type(IDLParser::Union_typeContext *ctx) override {
        auto identifier = ctx->identifier()->getText();
        DynamicTypeBuilder *switch_type_spec = nullptr;
        if (ctx->switch_type_spec()->scoped_name() != nullptr) {
            switch_type_spec = structs[ctx->switch_type_spec()->scoped_name()->getText()];
        } else {
            switch_type_spec = any_cast<DynamicTypeBuilder *>(visit(ctx->switch_type_spec()));
        }
        DynamicTypeBuilder *builder = factory->create_union_builder(switch_type_spec);
        builder->set_name(identifier);
        int idx = 0;
        for (auto case_stmt : ctx->switch_body()->case_stmt_list()->case_stmt()) {
            std::vector<uint64_t> labels;
            if (enum_values.count(case_stmt->const_exp()[0]->getText()) == 0) {
                labels.push_back(std::stoi(case_stmt->const_exp()[0]->getText()));
            } else {
                labels.push_back(enum_values[case_stmt->const_exp()[0]->getText()]);
            }
            auto element_spec = case_stmt->element_spec();
            auto declarator = element_spec->declarator()->simple_declarator()->getText();
            auto type_spec = element_spec->type_spec();
            if (type_spec->simple_type_spec() != nullptr) {
                auto simple_type_spec = type_spec->simple_type_spec();
                DynamicTypeBuilder *member = nullptr;
                if (simple_type_spec->scoped_name() != nullptr) {
                    auto scoped_name = simple_type_spec->scoped_name()->getText();
                    member = structs[simple_type_spec->scoped_name()->getText()];
                } else {
                    member = any_cast<DynamicTypeBuilder *>(visit(element_spec->type_spec()));
                }
                builder->add_member(
                        idx,
                        declarator,
                        member->build(),
                        std::to_string(idx),
                        labels,
                        false);
            }
            idx++;
        }
        structs[identifier] = builder;
        return builder;
    }

    any visitStruct_type(IDLParser::Struct_typeContext *ctx) override {
        std::string struct_name = ctx->identifier()->getText();
        DynamicTypeBuilder *builder = factory->create_struct_builder();
        builder->set_name(struct_name);
        std::vector<DynamicTypeBuilder *> vec = any_cast<std::vector<DynamicTypeBuilder *>>(
                visit(ctx->member_list()));
        int idx = 0;
        for (auto v : vec) {
            builder->add_member(idx, v->get_name(), v);
            idx++;
        }
        structs[struct_name] = builder;
        return builder;
    }

    any visitMember_list(IDLParser::Member_listContext *ctx) override {
        size_t n = ctx->children.size();
        std::vector<DynamicTypeBuilder *> vec;
        for (size_t i = 0; i < n; i++) {
            DynamicTypeBuilder *builder = any_cast<DynamicTypeBuilder *>(visit(ctx->children[i]));
            vec.push_back(builder);
        }

        return vec;
    }

    any visitMember_def(IDLParser::Member_defContext *ctx) override {
        if (ctx->member_def() != nullptr) {
            DynamicTypeBuilder *member = any_cast<DynamicTypeBuilder *>(visit(ctx->member_def()));
            if (ctx->annotation_appl() != nullptr) {
                std::string scoped_name = ctx->annotation_appl()->scoped_name()->getText();
                if (scoped_name == "key")
                    member->apply_annotation(
                            ANNOTATION_KEY_ID,
                            ANNOTATION_VALUE_ID,
                            CONST_TRUE);
            }
            return member;
        } else {
            return visit(ctx->member());
        }
    }

    any visitMap_type(IDLParser::Map_typeContext *ctx) override {
        auto simple_type_spec = ctx->simple_type_spec();
        auto key = simple_type_spec[0];
        DynamicTypeBuilder *keyBuilder = any_cast<DynamicTypeBuilder *>(visit(key));
        auto value = simple_type_spec[1];
        DynamicTypeBuilder *valueBuilder = any_cast<DynamicTypeBuilder *>(visit(value));
        return factory->create_map_builder(keyBuilder, valueBuilder);
    }

    any visitSequence_type(IDLParser::Sequence_typeContext *ctx) override {
        DynamicTypeBuilder *element_type = nullptr;
        element_type = any_cast<DynamicTypeBuilder *>(visit(ctx->simple_type_spec()));
        if (ctx->positive_int_const() != nullptr) {
            auto positive_int_const = ctx->positive_int_const();
            auto bound = std::atoi(positive_int_const->getText().c_str());
            return factory->create_sequence_builder(element_type, bound);
        }
        return factory->create_sequence_builder(element_type);
    }

    any visitSimple_type_spec(IDLParser::Simple_type_specContext *ctx) override {
        DynamicTypeBuilder *builder = nullptr;
        if (ctx->base_type_spec() != nullptr) {
            builder = any_cast<DynamicTypeBuilder *>(visit(ctx->base_type_spec()));
        } else if (ctx->template_type_spec() != nullptr) {
            builder = any_cast<DynamicTypeBuilder *>(visit(ctx->template_type_spec()));
        } else if (ctx->scoped_name() != nullptr) {
            auto scoped_name = ctx->scoped_name()->getText();
            builder = structs[scoped_name];
        }
        return builder;
    }

    any visitMember(IDLParser::MemberContext *ctx) override {
        DynamicTypeBuilder *builder = nullptr;
        if (ctx->type_spec() != nullptr) {
            auto type_spec = ctx->type_spec();
            if (type_spec->simple_type_spec() != nullptr) {
                auto simple_type_spec = type_spec->simple_type_spec();
                builder = any_cast<DynamicTypeBuilder *>(visit(simple_type_spec));
            }
        }
        if (ctx->declarators() != nullptr) {
            auto declarators = ctx->declarators();
            for (auto declarator : declarators->declarator()) {
                if (declarator->complex_declarator() != nullptr) {
                    auto complex_declarator = declarator->complex_declarator();
                    if (complex_declarator->array_declarator() != nullptr) {
                        auto array_declarator = complex_declarator->array_declarator();
                        auto fixed_array_size = array_declarator->fixed_array_size();
                        std::vector<uint32_t> dims;
                        for (auto array_size : fixed_array_size) {
                            auto dim = std::stoi(array_size->positive_int_const()->getText());
                            dims.push_back((uint32_t)dim);
                        }
                        DynamicTypeBuilder *bd = factory->create_array_builder(builder, dims);
                        builder = bd;
                        builder->set_name(array_declarator->ID()->getText());
                    }
                } else {
                    builder->set_name(ctx->declarators()->getText());
                }
            }
        }

        return builder;
    }

    any visitBitset_type(IDLParser::Bitset_typeContext *ctx) override {
        auto identifier = ctx->identifier()->getText();
        auto bitfield = ctx->bitfield();

        DynamicTypeBuilder *builder = factory->create_bitset_builder();
        int idx = 0;
        int position = 0;
        for (int i = 0; i < bitfield->children.size(); i++) {
            IDLParser::Bitfield_specContext *bitfield_spec = nullptr;
            if (antlr4::RuleContext::is(bitfield->children[i])) {
                IDLParser::Simple_declaratorsContext *simple_declarators = nullptr;
                if (bitfield_spec = dynamic_cast<IDLParser::Bitfield_specContext*>(
                        bitfield->children[i]); bitfield_spec != nullptr) {
                    DynamicTypeBuilder *bf = nullptr;
                    auto bits = std::atoi(bitfield_spec->positive_int_const()->getText().c_str());
                    if (bits == 1) {
                        bf = factory->create_bool_builder();
                    } else if (bits <= 8) {
                        bf = factory->create_byte_builder();
                    } else if (bits <= 16) {
                        bf = factory->create_uint16_builder();
                    } else if (bits <= 32) {
                        bf = factory->create_uint32_builder();
                    } else if (bits <=64) {
                        bf = factory->create_uint64_builder();
                    }
                    position += bits;
                    simple_declarators = dynamic_cast<IDLParser::Simple_declaratorsContext *>(
                            bitfield->children[i + 1]);
                    if (simple_declarators != nullptr) {
                        auto simple_declarator =
                                simple_declarators->simple_declarator()[0];
                        builder->add_member(idx, simple_declarator->getText(), bf);
                        builder->apply_annotation_to_member(
                                idx,
                                ANNOTATION_POSITION_ID,
                                "value",
                                std::to_string(position));
                        builder->apply_annotation_to_member(
                                idx,
                                ANNOTATION_BIT_BOUND_ID,
                                "value",
                                std::to_string(bits));
                        i++;
                    } else {
                        builder->add_member(idx, "", bf);
                    }
                    idx++;
                }
            }
        }
        structs[identifier] = builder;
        return builder;
    }
};

int main(int argc, const char* argv[]) {
    std::ifstream stream;
    stream.open(argv[1]);
    antlr4::ANTLRInputStream input(stream);
    IDLLexer lexer(&input);
    antlr4::CommonTokenStream tokens(&lexer);
    IDLParser parser(&tokens);

    antlr4::tree::ParseTree *tree = parser.specification();
    DynamicTypeVisitor visitor;
    visitor.visit(tree);
    for (auto st : visitor.structs) {
        printf("%s:\n", st.first.c_str());
        std::map<MemberId, DynamicTypeMember*> members;
        st.second->get_all_members(members);
        for (auto mem : members) {
            printf("\ttype(0x%02X) name: %s\n",
                   mem.second->get_descriptor()->get_kind(),
                   mem.second->get_name().c_str());
        }

        // print members names
        for (auto mem : members) {
            printf("\tname: %s\n", mem.second->get_name().c_str());
        }
        // print members types
        for (auto mem : members) {
            printf("\ttype: %s\n", mem.second->get_descriptor()->get_kind());
        }
    }

    return 0;
}
```