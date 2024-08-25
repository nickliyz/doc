# implement CCC3.0 SPAKE2+

code:
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <openssl/ssl.h>
#include <openssl/ec.h>
#include <openssl/err.h>
#include <openssl/bn.h>
#include <openssl/ecdsa.h>
#include <openssl/rand.h>
#include <openssl/evp.h>
#include <openssl/sha.h>

EC_POINT *hex2point(const char *hex, EC_GROUP *group) {
    EC_POINT *P = EC_POINT_new(group);
    EC_POINT_hex2point(group, hex, P, NULL);
    BIGNUM *x = BN_new(); BIGNUM *y = BN_new();
    EC_POINT_get_affine_coordinates_GFp(group, P, x, y, NULL);
    printf("EC_POINT = %s, %s\n", BN_bn2hex(x), BN_bn2hex(y));

    return P;
}

int scrypt(const unsigned char *passphrase, int passphrase_len,
           const unsigned char *salt, int salt_len,
           int N, int r, int p, int dkLen, unsigned char *out_key) {
    // Generate derived key using PBKDF2-HMAC-SHA256
    PKCS5_PBKDF2_HMAC(passphrase, passphrase_len, salt, salt_len, N, EVP_sha256(), dkLen, out_key);

    // Perform memory-hard operation
    // Simulate memory operations (for demonstration purposes)
    // The final derived key
    // Clean up
    return 1;
}

void EC_POINT_sub(EC_GROUP *group, EC_POINT *r, EC_POINT *a, EC_POINT *b) {
    BN_CTX *bn_ctx = BN_CTX_new();
    BIGNUM *a_x = BN_new();
    BIGNUM *a_y = BN_new();
    EC_POINT_get_affine_coordinates_GFp(group, a, a_x, a_y, bn_ctx);

    BIGNUM *b_x = BN_new();
    BIGNUM *b_y = BN_new();
    EC_POINT_get_affine_coordinates_GFp(group, b, b_x, b_y, bn_ctx);

    EC_KEY *ec_key = EC_KEY_new_by_curve_name(NID_X9_62_prime256v1);
    const BIGNUM *n = EC_GROUP_get0_order(group);

    BIGNUM *sub_x = BN_new();
    BIGNUM *sub_y = BN_new();
    BN_sub(sub_x, a_x, b_x);
    BN_sub(sub_y, a_y, b_y);

    BN_mod(sub_x, sub_x, n, bn_ctx);
    BN_mod(sub_y, sub_y, n, bn_ctx);

    EC_POINT_get_affine_coordinates_GFp(group, r, sub_x, sub_y, NULL);
}

int main(int, char**){
    printf("Hello, from spake2plus!\n");

    OpenSSL_add_all_algorithms();

    EC_KEY *ec_key = EC_KEY_new_by_curve_name(NID_X9_62_prime256v1);

    const EC_GROUP *group = EC_KEY_get0_group(ec_key);
    const EC_POINT *G = EC_GROUP_get0_generator(group);
    const BIGNUM *n = EC_GROUP_get0_order(group);
    const BIGNUM *h = EC_GROUP_get0_cofactor(group);
    const BIGNUM *p = BN_new();
    EC_GROUP_get_curve_GFp(group, p, NULL, NULL, NULL);

    printf("P-256 Curve Parameters:\n");
    printf("G (Generator): %s\n", BN_bn2hex(EC_POINT_point2bn(group, G, EC_KEY_get_conv_form(ec_key), NULL, NULL)));
    printf("n (Order) = %s\n", BN_bn2hex(n));
    printf("p (p) = %s\n", BN_bn2hex(p));
    printf("h (Cofactor) = %s\n", BN_bn2hex(h));

    const char *context = "SPAKE2+-P256-SHA256-HKDF-SHA256-HMAC-SHA256 Test Vectors";
    const char *idProver = "client";
    const char *idVerifier = "server";

    const char *P256_M = "048624e6926e81d7d6e43f636868528282c451d5ecfa3de74cab078011a4827d5e53fcc6d0e990f9da157e1125640f86d0a0739cc4dbd7efe4fcb4e541f8150ac7";
    const char *P256_N = "0408adacc492da7806cfbd43ac770f4e8dae0260bc31ce34fcee9fb39a628db19a3922ab64dafa3adda43fb35e1941704cf67af0bf70ea506a51993dc85e2e118c";

    unsigned char *m_data = (unsigned char *)malloc(65);
    for (size_t i = 0; i < 65; ++i)
        sscanf(P256_M + 2 + i * 2, "%02x", &m_data[i]);

    EC_POINT *M = hex2point(P256_M, group);
    EC_POINT *N = hex2point(P256_N, group);

    const BIGNUM *numOne = BN_new();
    BN_one(numOne);
    const BIGNUM *nMinusOne = BN_new();
    BN_sub(nMinusOne, n, numOne);
    printf("numOne: %s\n", BN_bn2hex(numOne));
    printf("nMinusOne: %s\n", BN_bn2hex(nMinusOne));

    const int PASSWORD_KEY_LENGTH = 40;
    unsigned char pwSalt[PASSWORD_KEY_LENGTH] = {0};
    // RAND_bytes(pwSalt, PASSWORD_KEY_LENGTH);
    memset(pwSalt, 0xFF, PASSWORD_KEY_LENGTH);
    printf("Random Bytes: ");
    for (int i = 0; i < PASSWORD_KEY_LENGTH; ++i) {
        printf("%02x", pwSalt[i]);
    }
    printf("\n");

    const int SCRYPT_COST_PARAMETERS = 32768;
    const int SCRYPT_BLOCK_SIZE = 8;
    const int SCRYPT_PARALLELIZATION_PARAMETER = 1;

    const char *password = "000000";
    unsigned char key[PASSWORD_KEY_LENGTH * 2];
    scrypt(password, strlen((const char *)password),
                pwSalt, PASSWORD_KEY_LENGTH,
                SCRYPT_COST_PARAMETERS, 
                SCRYPT_BLOCK_SIZE, 
                SCRYPT_PARALLELIZATION_PARAMETER, 
                PASSWORD_KEY_LENGTH * 2, key);
    printf("key: ");
    for (int i = 0; i < PASSWORD_KEY_LENGTH * 2; ++i) {
        printf("%02x", key[i]);
    }
    printf("\n");

    BIGNUM *z0 = BN_new();
    BIGNUM *z1 = BN_new();
    BN_bin2bn(key, 40, z0);
    BN_bin2bn(key + 40, 40, z1);
    BN_CTX *bn_ctx = BN_CTX_new();
    BIGNUM *w0 = BN_new();
    BIGNUM *w1 = BN_new();
    BIGNUM *w0_mod = BN_new();
    BIGNUM *w1_mod = BN_new();
    BN_mod(w0_mod, z0, nMinusOne, bn_ctx);
    BN_add(w0, w0_mod, numOne);
    BN_mod(w1_mod, z1, nMinusOne, bn_ctx);
    BN_add(w1, w1_mod, numOne);

    printf("w0: %s\n", BN_bn2hex(w0));
    printf("w1: %s\n", BN_bn2hex(w1));
    int is_valid_num = BN_cmp(w0, BN_value_one()) > 0 &&
                               BN_cmp(w0, n) < 0;
    printf("w0 is valid: %s\n", is_valid_num ? "Yes" : "No");
    is_valid_num = BN_cmp(w1, BN_value_one()) > 0 &&
                               BN_cmp(w1, n) < 0;
    printf("w1 is valid: %s\n", is_valid_num ? "Yes" : "No");
    EC_POINT *L = EC_POINT_new(group);
    EC_POINT_mul(group, L, w0, NULL, NULL, bn_ctx);
    BIGNUM *_x = BN_new();
    BIGNUM *_y = BN_new();
    EC_POINT_get_affine_coordinates_GFp(group, L, _x, _y, bn_ctx);
    printf("L = %s, %s\n", BN_bn2hex(_x), BN_bn2hex(_y));
    int is_on_curve = EC_POINT_is_on_curve(group, L, NULL);
    printf("Is point L on curve: %s\n", is_on_curve ? "Yes" : "No");

    BIGNUM *y = BN_new();
    BN_rand_range(y, n);

    printf("y: %s\n", BN_bn2hex(y));
    is_valid_num = BN_cmp(y, BN_value_one()) > 0 &&
                               BN_cmp(y, n) < 0;
    printf("y is valid: %s\n", is_valid_num ? "Yes" : "No");
    EC_POINT *Y = EC_POINT_new(group);
    EC_POINT_mul(group, Y, y, N, w0, bn_ctx);
    EC_POINT_get_affine_coordinates_GFp(group, Y, _x, _y, bn_ctx);
    printf("Y = %s, %s\n", BN_bn2hex(_x), BN_bn2hex(_y));
    is_on_curve = EC_POINT_is_on_curve(group, Y, NULL);
    printf("Is point Y on curve: %s\n", is_on_curve ? "Yes" : "No");

    BIGNUM *x = BN_new();
    BN_rand_range(x, n);

    printf("x: %s\n", BN_bn2hex(x));
    is_valid_num = BN_cmp(x, BN_value_one()) > 0 &&
                               BN_cmp(x, n) < 0;
    printf("x is valid: %s\n", is_valid_num ? "Yes" : "No");
    EC_POINT *X = EC_POINT_new(group);
    EC_POINT_mul(group, X, x, M, w0, bn_ctx);
    EC_POINT_get_affine_coordinates_GFp(group, X, _x, _y, bn_ctx);
    printf("X = %s, %s\n", BN_bn2hex(_x), BN_bn2hex(_y));
    is_on_curve = EC_POINT_is_on_curve(group, X, NULL);
    printf("Is point X on curve: %s\n", is_on_curve ? "Yes" : "No");

    // Y = G * y + N * w0
    // z1 = (Y - (N * w0)) * x
    EC_POINT *Z1 = EC_POINT_new(group);
    EC_POINT *N_mul_w0 = EC_POINT_new(group);
    EC_POINT_mul(group, N_mul_w0, NULL, N, w0, bn_ctx);
    EC_POINT_invert(group, N_mul_w0, bn_ctx);
    EC_POINT *Y_sub = EC_POINT_new(group);
    EC_POINT_add(group, Y_sub, Y, N_mul_w0, bn_ctx);

    // Y - (N * w0)
    // EC_POINT_sub(group, Y_sub, Y, N_mul_w0);
    EC_POINT_mul(group, Z1, NULL, Y_sub, x, bn_ctx);
    EC_POINT_get_affine_coordinates_GFp(group, Z1, _x, _y, bn_ctx);
    printf("Z1 = %s, %s\n", BN_bn2hex(_x), BN_bn2hex(_y));

    // z2 = (X - (M * w0)) * y
    EC_POINT *Z2 = EC_POINT_new(group);
    EC_POINT *M_mul_w0 = EC_POINT_new(group);
    EC_POINT_mul(group, M_mul_w0, NULL, M, w0, bn_ctx);
    EC_POINT_invert(group, M_mul_w0, bn_ctx);
    EC_POINT *X_sub = EC_POINT_new(group);
    EC_POINT_add(group, X_sub, X, M_mul_w0, bn_ctx);

    // X - (M * w0)
    // EC_POINT_sub(group, X_sub, X, M_mul_w0);
    EC_POINT_mul(group, Z2, NULL, X_sub, y, bn_ctx);
    EC_POINT_get_affine_coordinates_GFp(group, Z2, _x, _y, bn_ctx);
    printf("Z2 = %s, %s\n", BN_bn2hex(_x), BN_bn2hex(_y));

    // EC_POINT_cmp(): 1 if the points are not equal
    int is_equal = !EC_POINT_cmp(group, Z1, Z2, bn_ctx);
    printf("Z1 == Z2 : %s", is_equal ? "Yes" : "NO");

    return 0;
}
```