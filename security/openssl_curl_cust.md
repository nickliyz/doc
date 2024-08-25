# cURL with openssl cust sign function
code:
```c
#include <stdio.h>
#include <math.h>
#include <string.h>
#include <curl/curl.h>
#include <openssl/x509v3.h>
#include <openssl/x509_vfy.h>
#include <openssl/crypto.h>
#include <openssl/lhash.h>
#include <openssl/objects.h>
#include <openssl/err.h>
#include <openssl/evp.h>
#include <openssl/x509.h>
#include <openssl/pkcs12.h>
#include <openssl/bio.h>
#include <openssl/ssl.h>
#include <openssl/engine.h>
#include <openssl/ec.h>
#include <openssl/obj_mac.h>
#include <openssl/ecdh.h>
#include <openssl/bn.h>
#include <openssl/core_names.h>

#include "cJSON.h"
#include <time.h>
#include <math.h>

const char *pst;
PKCS12 *p12;
EVP_PKEY *pkey;
X509 *usercert;
STACK_OF(X509) * ca;
BIO *errorbio;

int curlLogCallback(CURL *handle, curl_infotype type, char *data, size_t size, void *userptr)
{
	const char *text;
	(void)handle;

	switch (type) {
		case CURLINFO_TEXT:
			printf("[INFO] %.*s", (int)size, data);
			break;
		case CURLINFO_HEADER_IN:
		case CURLINFO_HEADER_OUT:
			printf("[HEADER] %.*s", (int)size, data);
			break;
		case CURLINFO_DATA_IN:
		case CURLINFO_DATA_OUT:
			printf("[DATA] %.*s", (int)size, data);
			break;
		default:
			return 0;
	}

	return 0;
}

const char *build_request(char *cur_version) {
	cJSON *json = cJSON_CreateObject();
	// ...
	return cJSON_PrintUnformatted(json);
}

static int EcKeySign(int type, const unsigned char* dgst, int dlen,
	unsigned char* sig, unsigned int* siglen,
	const BIGNUM* kinv, const BIGNUM* r,
	EC_KEY* eckey) {

	const char* key_path = (const char *)EC_KEY_get_ex_data(eckey, 0);
	const EC_KEY_METHOD* defaultMethod = EC_KEY_get_default_method();
	int (*psign)(int type, const unsigned char *dgst,
					int dlen, unsigned char *sig,
					unsigned int *siglen,
					const BIGNUM *kinv, const BIGNUM *r,
					EC_KEY *eckey);
	int (*psign_setup)(EC_KEY *eckey, BN_CTX *ctx_in,
						BIGNUM **kinvp, BIGNUM **rp);
	ECDSA_SIG *(*psign_sig)(const unsigned char *dgst,
					int dgst_len,
					const BIGNUM *in_kinv,
					const BIGNUM *in_r,
					EC_KEY *eckey);
	EC_KEY_METHOD_get_sign(defaultMethod, &psign, &psign_setup, &psign_sig);

	EC_KEY *realKey = NULL;
	FILE *file = fopen(key_path, "r");
	if (!file) {
		fprintf(stderr, "Failed to open private key file\n");
		return 1;
	}
	realKey = PEM_read_ECPrivateKey(file, NULL, NULL, NULL);
	fclose(file);
	if (!realKey) {
		fprintf(stderr, "Failed to read private key file\n");
		return 1;
	}

	ECDSA_SIG *ecdsaSig = psign_sig(dgst, dlen, kinv, r, realKey);

	unsigned char buffer[256] = { 0 };
	unsigned char* derSig = buffer;
	i2d_ECDSA_SIG(ecdsaSig,&derSig);
	memcpy(sig, buffer, derSig - buffer);
	*siglen = derSig - buffer;

	ECDSA_SIG_free(ecdsaSig);

	// printf("EcKeySign\n");
	return 1; 
}

static int EcKeyInit(EC_KEY* key) {
	// printf("EcKeyInit\n");
	return 1;
}
static void EcKeyFinish(EC_KEY* key) {
	printf("EcKeyFinish\n");
}

static int EcKeyVerify(int type, const unsigned
	char* dgst, int dgst_len,
	const unsigned char* sigbuf,
	int sig_len, EC_KEY* eckey) {

	const EC_KEY_METHOD* defaultMethod = EC_KEY_get_default_method();
	int (*pverify)(int type, const unsigned	char* dgst, int dgst_len, const unsigned char* sigbuf, int sig_len, EC_KEY * eckey) = NULL;
	int (*pverify_sig)(const unsigned char* dgst, int dgst_len, const ECDSA_SIG * sig, EC_KEY * eckey);

	EC_KEY_METHOD_get_verify(defaultMethod, &pverify, &pverify_sig);
	int ret = pverify(type, dgst, dgst_len, sigbuf,sig_len, eckey);
	printf("EcKeyVerify\n");
	return ret;
}

static int EcVerifySig (const unsigned char* dgst, int dgst_len, const ECDSA_SIG* sig, EC_KEY* eckey) {
	const EC_KEY_METHOD* defaultMethod = EC_KEY_get_default_method();
	int (*pverify)(int type, const unsigned	char* dgst, int dgst_len, const unsigned char* sigbuf, int sig_len, EC_KEY* eckey) = NULL;
	int (*pverify_sig)(const unsigned char* dgst, int dgst_len, const ECDSA_SIG* sig, EC_KEY* eckey) = NULL;


	EC_KEY_METHOD_get_verify(defaultMethod, &pverify, &pverify_sig);

	int ret = pverify_sig(dgst, dgst_len, sig, eckey);
	printf("EcVerifySig\n");
	return ret;
}

static int custEngineInit(ENGINE* e) {
	if (NULL != ENGINE_get_EC(e)) {
		return 1;
	}

	EC_KEY_METHOD* eckeyMethod = EC_KEY_METHOD_new(NULL);

	EC_KEY_METHOD_set_sign(eckeyMethod, EcKeySign, NULL, NULL);
	EC_KEY_METHOD_set_verify(eckeyMethod, EcKeyVerify, EcVerifySig);

	// int (*computeKey)(unsigned char **psec, size_t *pseclen, const EC_POINT *pub_key, const EC_KEY *ecdh);
	// EC_KEY_METHOD_set_compute_key(eckeyMethod, computeKey);

	EC_KEY_METHOD_set_init(eckeyMethod, EcKeyInit, EcKeyFinish, NULL, NULL, NULL, NULL);
	ENGINE_set_EC(e, eckeyMethod);
	return 1;
}

static int custEngineDestroy(ENGINE* e)
{
	printf("custEngineDestroy\n");
	if (e) {
		EC_KEY_METHOD* eckeyMethod = (EC_KEY_METHOD*)ENGINE_get_EC(e);

		if (NULL != eckeyMethod) {
			EC_KEY_METHOD_free(eckeyMethod);
		}

		ENGINE_free(e);
	}
	return 1;
}

static EVP_PKEY* custEngineLoadPrivkey(ENGINE* eng, const char* key_id,
	UI_METHOD* ui_method, void* callback_data) {
	printf("custEngineLoadPrivkey\n");
	EVP_PKEY* ret = NULL;
	return ret;
}

static int custEngineCtrl(ENGINE* e, int cmd, long i, void* p, void (*f) (void))
{	
	printf("custEngineCtrl\n");
	int ret;
	switch (cmd) {
	case 1:
		break;
	case 2:
		break;
	default:
		ret = 0;
	}
	return 0;
}



ENGINE *getCustEngine() {
	ENGINE* engine = ENGINE_new();
	ENGINE_set_id(engine, "cust engine");
	ENGINE_set_name(engine, "cust");
	ENGINE_set_flags(engine, ENGINE_FLAGS_NO_REGISTER_ALL);
	ENGINE_set_init_function(engine, custEngineInit);
	ENGINE_set_load_privkey_function(engine, custEngineLoadPrivkey);
	ENGINE_set_ctrl_function(engine, custEngineCtrl);

	ENGINE_set_finish_function(engine, custEngineInit);
	ENGINE_set_destroy_function(engine, custEngineDestroy);

	return engine;
}

typedef struct key_info {
	const char *key_path;
	const char *cert_path;
} key_info_t;

static CURLcode sslctxfun(CURL *curl, void *sslctx, void *parm)
{
	key_info_t *p = (key_info_t *) parm;
	printf("key path: %s\n", p->key_path);
	printf("cert path: %s\n", p->cert_path);
	SSL_CTX *ctx = (SSL_CTX *) sslctx;
	FILE *file = fopen(p->cert_path, "r");
	usercert = PEM_read_X509(file, NULL, NULL, NULL);

	if(!SSL_CTX_use_certificate(ctx, usercert)) {
		BIO_printf(errorbio, "SSL_CTX_use_certificate problem\n");
		goto err;
	}
	ENGINE *custEngine = getCustEngine();
	EC_KEY* ecPubKey = NULL;
	EVP_PKEY *pubKey;
	pubKey = X509_get_pubkey(usercert);
	if (!pubKey) {
		fprintf(stderr, "Failed to get public key from certificate\n");
		X509_free(usercert);
		return 1;
	}
	printf("pass X509_get_pubkey()\n");
	ecPubKey = EVP_PKEY_get1_EC_KEY(pubKey);
	if (!ecPubKey) {
		fprintf(stderr, "Failed to convert public key to EC_KEY\n");
		EVP_PKEY_free(pubKey);
		X509_free(usercert);
		return 1;
	}
	EC_GROUP* group = EC_KEY_get0_group(ecPubKey);
	// printf("pass EVP_PKEY_get1_EC_KEY()\n");
	EC_KEY* ecKey = EC_KEY_new_method(custEngine);
	EC_KEY_set_group(ecKey, group);
	EC_POINT *point = EC_KEY_get0_public_key(ecPubKey);
	EC_KEY_set_public_key(ecKey, point);
	EC_KEY_set_ex_data(ecKey, 0, p->key_path);
	// printf("pass EC_KEY_set_ex_data()\n");

	pkey = EVP_PKEY_new();
	EVP_PKEY_assign_EC_KEY(pkey, ecKey);

	if(!SSL_CTX_use_PrivateKey(ctx, pkey)) {
		BIO_printf(errorbio, "SSL_CTX_use_PrivateKey\n");
		goto err;
	}

	if(!SSL_CTX_check_private_key(ctx)) {
		BIO_printf(errorbio, "SSL_CTX_check_private_key\n");
		goto err;
	}

	SSL_CTX_set_quiet_shutdown(ctx, 1);
	SSL_CTX_set_cipher_list(ctx, "RC4-MD5");
	SSL_CTX_set_mode(ctx, SSL_MODE_AUTO_RETRY);

	X509_STORE_add_cert(SSL_CTX_get_cert_store(ctx),
						sk_X509_value(ca, sk_X509_num(ca)-1));

	return CURLE_OK;
	err:
	ERR_print_errors(errorbio);
	return CURLE_SSL_CERTPROBLEM;
}

static size_t progress_callback(void *clientp,
								 double dltotal,
								 double dlnow,
								 double ultotal,
								 double ulnow)
 {

	 int totaldotz = 40;
	double fract = dlnow / dltotal;
	int dotz = round(fract * totaldotz);

	int i = 0;
	printf("%3.0f%% [", fract * 100);
	for (;i < dotz; i++)
	printf("==");
	for (;i < totaldotz; i++)
	printf(" ");
	printf("]\r");
	fflush(stdout);

	 return 0; /* all is good */
 }

uint16_t g_sign_buf_size = 0;

static size_t write_data(void *ptr, size_t size, size_t nmemb, void *stream)
{
	g_sign_buf_size = size * nmemb;
	printf("size * nmemb: %lu\n", size * nmemb);

#if 0
	FILE* file = (FILE*)stream;
	return fwrite(ptr, size, nmemb, file);
#else
	char **output_buf = (char **)stream;
	*output_buf = (char *)malloc(size * nmemb);
	memset(*output_buf, 0x0, size * nmemb);
	memcpy(*output_buf, ptr, size * nmemb);
	return g_sign_buf_size;
#endif
}

EC_POINT* generateECCPublicPoint(const unsigned char* xBytes, const unsigned char* yBytes) {
    EC_KEY* ecKey = EC_KEY_new_by_curve_name(NID_X9_62_prime256v1);
    if (ecKey == NULL) {
        printf("Failed to create EC key.\n");
        return NULL;
    }

    BIGNUM* x = BN_bin2bn(xBytes, 32, NULL);
    BIGNUM* y = BN_bin2bn(yBytes, 32, NULL);

    EC_POINT* publicKeyPoint = EC_POINT_new(EC_KEY_get0_group(ecKey));
    if (publicKeyPoint == NULL) {
        printf("Failed to create EC point.\n");
        EC_KEY_free(ecKey);
        BN_free(x);
        BN_free(y);
        return NULL;
    }

    if (EC_POINT_set_affine_coordinates_GFp(EC_KEY_get0_group(ecKey), publicKeyPoint, x, y, NULL) != 1) {
        printf("Failed to set EC point coordinates.\n");
        EC_KEY_free(ecKey);
        BN_free(x);
        BN_free(y);
        return NULL;
    }

    BN_free(x);
    BN_free(y);

    EC_KEY_free(ecKey);
    return publicKeyPoint;
}

EVP_PKEY* generateECCPublicKey(const unsigned char* xBytes, const unsigned char* yBytes) {
    EVP_PKEY *key = NULL;
	OSSL_PARAM params[3];
	EVP_PKEY_CTX *gctx = EVP_PKEY_CTX_new_from_name(NULL, "EC", NULL);
	params[0] = OSSL_PARAM_construct_utf8_string(OSSL_PKEY_PARAM_GROUP_NAME,
                                                 "P-256", 0);
    params[1] = OSSL_PARAM_construct_end();
    EVP_PKEY_CTX_set_params(gctx, params);
	EVP_PKEY_generate(gctx, &key);

    return key;
}

int main(int argc, char *argv[])
{
	CURL *curl;
	CURLcode res;
	BIO *p12bio;

	const char *url = "https://test.com/test";
	const char *ca = "ca.crt";
	const char *key = "priv.key";
	const char *cert = "dev.crt";

	curl_global_init(CURL_GLOBAL_DEFAULT);
	OpenSSL_add_all_ciphers();
	OpenSSL_add_all_digests();
	ERR_load_crypto_strings();
	
	errorbio = BIO_new_fp(stderr, BIO_NOCLOSE);
 
	curl = curl_easy_init();

	const char *key_path = argv[3];
	const char *cert_path = argv[4];

	if(curl) {
		curl_easy_setopt(curl, CURLOPT_URL, url);
		curl_easy_setopt(curl, CURLOPT_SSL_VERIFYPEER, 1L);
		curl_easy_setopt(curl, CURLOPT_SSL_VERIFYHOST, 1L);
		curl_easy_setopt(curl, CURLOPT_CAINFO, ca); 
		curl_easy_setopt(curl, CURLOPT_NOPROGRESS, 0L);
		curl_easy_setopt(curl, CURLOPT_PROGRESSFUNCTION, progress_callback);
		curl_easy_setopt(curl, CURLOPT_POST, 1L);
		curl_easy_setopt(curl, CURLOPT_VERBOSE, 1L);

		curl_easy_setopt(curl, CURLOPT_DEBUGFUNCTION, curlLogCallback);

		res = curl_easy_setopt(curl, CURLOPT_SSL_CTX_FUNCTION, sslctxfun);

		if (res != CURLE_OK)
		BIO_printf(errorbio, "%d %s=%d %d\n", __LINE__,
					 "CURLOPT_SSL_CTX_FUNCTION", CURLOPT_SSL_CTX_FUNCTION, res);

		char *output = NULL;

		const char *data_to_post = build_request("P0308456 A0");
		printf("data_to_post: %s\n", data_to_post);

		key_info_t info = {
			key,
			cert
		};
		curl_easy_setopt(curl, CURLOPT_SSL_CTX_DATA, &info);
		curl_easy_setopt(curl, CURLOPT_WRITEDATA, &output);
		curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_data);

		curl_easy_setopt(curl, CURLOPT_POSTFIELDS, data_to_post);
		curl_easy_setopt(curl, CURLOPT_POSTFIELDSIZE, strlen(data_to_post));

		struct curl_slist *headers = NULL;
		headers = curl_slist_append(headers, "Content-Type: application/json");
		// ...
		curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);

		res = curl_easy_perform(curl);
		if(res != CURLE_OK)
		fprintf(stderr, "curl_easy_perform() failed: %s\n",
				curl_easy_strerror(res));
	 
		curl_easy_cleanup(curl);
	}

err:
	curl_global_cleanup();
 
	return 0;
}
```