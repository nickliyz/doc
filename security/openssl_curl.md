# cURL with openssl

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
 
const char *pst;
PKCS12 *p12;
EVP_PKEY *pkey;
X509 *usercert;
STACK_OF(X509) * ca;
BIO *errorbio;

static CURLcode sslctxfun(CURL *curl, void *sslctx, void *parm)
{
  //sslctxparm *p = (sslctxparm *) parm;
  SSL_CTX *ctx = (SSL_CTX *) sslctx;

  if(!SSL_CTX_use_certificate(ctx, usercert)) {
    BIO_printf(errorbio, "SSL_CTX_use_certificate problem\n");
    goto err;
  }
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

  //SSL_CTX_set_verify_depth(ctx, 2);
  //SSL_CTX_set_verify(ctx, SSL_VERIFY_PEER, ZERO_NULL);
  //SSL_CTX_set_cert_verify_callback(ctx, ssl_app_verify_callback, parm);

  return CURLE_OK;
  err:
  ERR_print_errors(errorbio);
  return CURLE_SSL_CERTPROBLEM;

}

static size_t write_data(void *ptr, size_t size, size_t nmemb, void *stream)
{
  size_t written = fwrite(ptr, size, nmemb, (FILE *)stream);
  return written;
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
   	 /* use the values */

   return 0; /* all is good */
 }

int main(int argc, void *argv[])
{
  CURL *curl;
  CURLcode res;
  BIO *p12bio;
  static const char *pagefilename = "page.out"; 
  FILE *pagefile;

  curl_global_init(CURL_GLOBAL_DEFAULT);
  OpenSSL_add_all_ciphers();
  OpenSSL_add_all_digests();
  ERR_load_crypto_strings();
  
  errorbio = BIO_new_fp(stderr, BIO_NOCLOSE);
 
  curl = curl_easy_init();

  p12bio = BIO_new_file(argv[3], "rb");
  if(!p12bio) {
    BIO_printf(errorbio, "Error opening P12 file %s\n", (char *)argv[3]);
    goto err;
  }
  p12 = d2i_PKCS12_bio(p12bio, NULL);
  if(!p12) {
    BIO_printf(errorbio, "Cannot decode P12 structure %s\n", (char *)argv[3]);
    goto err;
  }

  ca = NULL;
  if(!(PKCS12_parse (p12, argv[4], &(pkey), &(usercert), &(ca) ) )) {
    BIO_printf(errorbio, "Invalid P12 structure in %s\n", (char *)argv[3]);
    goto err;
  }

  if(sk_X509_num(ca) <= 0) {
    BIO_printf(errorbio, "No trustworthy CA given.%s\n", (char *)argv[3]);
    //goto err;
  }

  //X509_print_ex(errorbio, usercert, 0, 0);

  if(curl) {
    curl_easy_setopt(curl, CURLOPT_URL, argv[1]);
    curl_easy_setopt(curl, CURLOPT_SSL_VERIFYPEER, 1L);
    curl_easy_setopt(curl, CURLOPT_SSL_VERIFYHOST, 1L);
	curl_easy_setopt(curl, CURLOPT_CAINFO, argv[2]); 
	curl_easy_setopt(curl, CURLOPT_NOPROGRESS, 0L);
	curl_easy_setopt(curl, CURLOPT_PROGRESSFUNCTION, progress_callback);

  	res = curl_easy_setopt(curl, CURLOPT_SSL_CTX_FUNCTION, sslctxfun);

	if (res != CURLE_OK)
		BIO_printf(errorbio, "%d %s=%d %d\n", __LINE__,
               "CURLOPT_SSL_CTX_FUNCTION", CURLOPT_SSL_CTX_FUNCTION, res);

	curl_easy_setopt(curl, CURLOPT_SSL_CTX_DATA, NULL);
	curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_data);

    /* open the file */
    pagefile = fopen(strrchr(argv[1], '/') + 1, "wb");
    if(pagefile) {

    /* write the page body to this file handle */
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, pagefile);

    /* Perform the request, res will get the return code */
    res = curl_easy_perform(curl);
    /* Check for errors */
    if(res != CURLE_OK)
      fprintf(stderr, "curl_easy_perform() failed: %s\n",
              curl_easy_strerror(res));
 
    }
    /* close the header file */
    fclose(pagefile);
    /* always cleanup */
    curl_easy_cleanup(curl);
  }

err:
  curl_global_cleanup();
 
  return 0;
}
```