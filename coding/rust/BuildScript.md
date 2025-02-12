## 参考资料
https://doc.rust-lang.org/cargo/reference/build-scripts.html

## BuildScript执行命令
```rust
let command = Command::new("sh")
    .spawn()
    .args(["xxx", "yyy"])
    .expect("sh command failed to start");
io::stdout().write(&command.stderr).unwrap();
```

## BuildScript生成绑定
```rust
let vbsbindings = bindgen::Builder::default()
        .header("xxx.h")
        .generate_comments(true)
        .derive_default(true)
        .clang_arg(format!("-I{}", binding_include))
        .generate()
        .expect("Unable to generate vbsbindings");

    let out_path = PathBuf::from(env::var("OUT_DIR").unwrap());

    vbsbindings
        .write_to_file(out_path.join("vbsbindings.rs"))
        .expect("Couldn't write vbsbindings!");
```

## BuildScript如何配置
参考：https://doc.rust-lang.org/cargo/reference/build-scripts.html