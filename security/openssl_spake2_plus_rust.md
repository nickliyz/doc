# implement CCC3.0 SPAKE2+ with openssl in rust

code
```rust

#![allow(non_snake_case)]

extern crate openssl;

use std::ops::Add;

use openssl::{bn::{BigNum, BigNumContext}, ec::PointConversionForm};
use openssl::ec::{EcGroup, EcPoint};use hex;

extern crate scrypt;
use scrypt::ScryptParams;

use rand::Rng;

fn main() {
    println!("Hello, world!");

    let ONE = BigNum::from_u32(1).unwrap();

    let ec_group = EcGroup::from_curve_name(openssl::nid::Nid::X9_62_PRIME256V1).unwrap();
    let G = ec_group.generator();

    let mut bn_ctx: BigNumContext = BigNumContext::new().unwrap();
    // Convert G to uncompressed format and get its coordinates
    let g_bytes = G
        .to_bytes(&ec_group, PointConversionForm::UNCOMPRESSED, &mut bn_ctx)
        .expect("Failed to convert G to bytes");

    println!("G: {:?}", hex::encode(g_bytes));
    let mut n = BigNum::new().unwrap();
    ec_group.order(&mut n, &mut bn_ctx).unwrap();
    println!("n: {}", n.to_hex_str().unwrap());
    let mut h = BigNum::new().unwrap();
    ec_group.cofactor(&mut h, &mut bn_ctx).unwrap();
    println!("h: {}", h.to_hex_str().unwrap());

    let mut nMinusOne = BigNum::from_slice(n.to_vec().as_slice()).unwrap();
    nMinusOne.sub_word(1).unwrap();
    println!("nMinusOne: {}", nMinusOne.to_hex_str().unwrap());

    let M: &str = "048624e6926e81d7d6e43f636868528282c451d5ecfa3de74cab078011a4827d5e53fcc6d0e990f9da157e1125640f86d0a0739cc4dbd7efe4fcb4e541f8150ac7";
    let M = hex::decode(M).unwrap();
    let M = EcPoint::from_bytes(&ec_group, &M, &mut bn_ctx).unwrap();
    let m_bytes = M.to_bytes(ec_group.as_ref(), openssl::ec::PointConversionForm::UNCOMPRESSED, &mut bn_ctx).unwrap();
    println!("M: {}", hex::encode(m_bytes.as_slice()));

    let N: &str = "0408adacc492da7806cfbd43ac770f4e8dae0260bc31ce34fcee9fb39a628db19a3922ab64dafa3adda43fb35e1941704cf67af0bf70ea506a51993dc85e2e118c";
    let N = hex::decode(N).unwrap();
    let N = EcPoint::from_bytes(&ec_group, &N, &mut bn_ctx).unwrap();
    let n_bytes = N.to_bytes(ec_group.as_ref(), openssl::ec::PointConversionForm::UNCOMPRESSED, &mut bn_ctx).unwrap();
    println!("N: {}", hex::encode(n_bytes.as_slice()));

    const PASSWORD_KEY_LENGTH: usize = 40;
    let scrypt_params = ScryptParams::new(15, 8, 1).unwrap();
    let salt: [u8; PASSWORD_KEY_LENGTH] = [0; PASSWORD_KEY_LENGTH];
    let mut pwKey: [u8; PASSWORD_KEY_LENGTH * 2] = [0; PASSWORD_KEY_LENGTH * 2];
    scrypt::scrypt("000000".as_bytes(), &salt, &scrypt_params, &mut pwKey).unwrap();
    println!("pwKey: {}", hex::encode(pwKey));
    let mut _z0 = BigNum::new().unwrap();

    _z0.copy_from_slice(&pwKey[0..PASSWORD_KEY_LENGTH]).unwrap();
    println!("z0: {}", _z0.to_hex_str().unwrap());
    let mut z0 = BigNum::new().unwrap();
    z0.mod_exp(&_z0, &ONE, &nMinusOne, &mut bn_ctx).unwrap();
    let mut _z1 = BigNum::new().unwrap();
    _z1.copy_from_slice(&pwKey[PASSWORD_KEY_LENGTH..(PASSWORD_KEY_LENGTH * 2)]).unwrap();
    let mut z1 = BigNum::new().unwrap();
    z1.mod_exp(&_z1, &ONE, &nMinusOne, &mut bn_ctx).unwrap();

    let w0 = z0.add(&ONE);
    println!("w0: {}", w0.to_hex_str().unwrap());

    let w1 = z1.add(&ONE);
    println!("w1: {}", w1.to_hex_str().unwrap());

    let mut rng = rand::thread_rng();
    let mut x: [u8; 32] = [0; 32];
    rng.fill(&mut x);
    let _x: BigNum = BigNum::from_slice(&x).unwrap();
    println!("x: {}", _x.to_hex_str().unwrap());

    // let _x = BigNum::from_u32(123456).unwrap();
    let mut x = BigNum::new().unwrap();
    x.mod_exp(&_x, &ONE, &nMinusOne, &mut bn_ctx).unwrap();
    println!("x: {}", x.to_hex_str().unwrap());

    let mut y: [u8; 32] = [0; 32];
    rng.fill(&mut y);
    let _y: BigNum = BigNum::from_slice(&y).unwrap();
    println!("x: {}", _y.to_hex_str().unwrap());
    // let mut _y = BigNum::from_u32(654321).unwrap();
    let mut y = BigNum::new().unwrap();
    y.mod_exp(&_y, &ONE, &nMinusOne, &mut bn_ctx).unwrap();
    println!("y: {}", y.to_hex_str().unwrap());

    let mut X = EcPoint::new(&ec_group).unwrap();
    X.mul_full(&ec_group, &x, &M, &w0, &mut bn_ctx).unwrap();
    println!("X: {}", hex::encode(X.to_bytes(ec_group.as_ref(), openssl::ec::PointConversionForm::UNCOMPRESSED, &mut bn_ctx).unwrap()));

    let mut Y = EcPoint::new(&ec_group).unwrap();
    Y.mul_full(&ec_group, &y, &N, &w0, &mut bn_ctx).unwrap();
    println!("Y: {}", hex::encode(Y.to_bytes(ec_group.as_ref(), openssl::ec::PointConversionForm::UNCOMPRESSED, &mut bn_ctx).unwrap()));

    let mut L = EcPoint::new(&ec_group).unwrap();
    L.mul(&ec_group, &G, &w1, &mut bn_ctx).unwrap();
    println!("L: {}", hex::encode(L.to_bytes(ec_group.as_ref(), openssl::ec::PointConversionForm::UNCOMPRESSED, &mut bn_ctx).unwrap()));

    let mut Zp_add = EcPoint::new(&ec_group).unwrap();
    let mut N_mul_w0 = EcPoint::new(&ec_group).unwrap();
    N_mul_w0.mul(&ec_group, &N, &w0, &mut bn_ctx).unwrap();
    N_mul_w0.invert(&ec_group, &mut bn_ctx).unwrap();
    Zp_add.add(&ec_group, &Y, &N_mul_w0, &mut bn_ctx).unwrap();
    let mut Zp = EcPoint::new(&ec_group).unwrap();
    Zp.mul(&ec_group, &Zp_add, &x, &mut bn_ctx).unwrap();
    println!("Zp: {}", hex::encode(Zp.to_bytes(ec_group.as_ref(), openssl::ec::PointConversionForm::UNCOMPRESSED, &mut bn_ctx).unwrap()));

    let mut Vp = EcPoint::new(&ec_group).unwrap();
    Vp.mul(&ec_group, &Zp_add, &w1, &mut bn_ctx).unwrap();
    println!("Vp: {}", hex::encode(Vp.to_bytes(ec_group.as_ref(), openssl::ec::PointConversionForm::UNCOMPRESSED, &mut bn_ctx).unwrap()));

    let mut Zv_sub = EcPoint::new(&ec_group).unwrap();
    let mut M_mul_w0 = EcPoint::new(&ec_group).unwrap();
    M_mul_w0.mul(&ec_group, &M, &w0, &mut bn_ctx).unwrap();
    M_mul_w0.invert(&ec_group, &mut bn_ctx).unwrap();
    Zv_sub.add(&ec_group, &X, &M_mul_w0, &mut bn_ctx).unwrap();
    let mut Zv = EcPoint::new(&ec_group).unwrap();
    Zv.mul(&ec_group, &Zv_sub, &y, &mut bn_ctx).unwrap();
    println!("Zv: {}", hex::encode(Zv.to_bytes(ec_group.as_ref(), openssl::ec::PointConversionForm::UNCOMPRESSED, &mut bn_ctx).unwrap()));

    let mut Vv = EcPoint::new(&ec_group).unwrap();
    Vv.mul(&ec_group, &L, &y, &mut bn_ctx).unwrap();
    println!("Vv: {}", hex::encode(Vv.to_bytes(ec_group.as_ref(), openssl::ec::PointConversionForm::UNCOMPRESSED, &mut bn_ctx).unwrap()));
}
```