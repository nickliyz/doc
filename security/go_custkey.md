# go with cust sign interface
code:
```go
package main

import (
	"crypto"
	"crypto/ecdsa"
	"crypto/md5"
	"crypto/sha256"
	"crypto/tls"
	"crypto/x509"
	"encoding/hex"
	"encoding/json"
	"encoding/pem"
	"fmt"
	"io"
	"net/http"
	"os"
)

type Key struct {
	EncKey string `json:"encKey"`
}

type KeyData struct {
	Type  string `json:"type"`
	Count int32  `json:"count"`
	Keys  []Key  `json:"keys"`
}

type Response struct {
	Data         []KeyData `json:"data"`
	RequestId    string    `json:"request_id"`
	ResultCode   string    `json:"result_code"`
	Debugmessage string    `json:"debug_msg"`
	ServerTime   uint64    `json:"server_time"`
}

type CustomKey struct {
	keyFile string
}

func (cpk CustomKey) Public() crypto.PublicKey {
	// only return the public key, not the private key
	keyPEMBlock, _ := os.ReadFile(cpk.keyFile)
	keyDERBlock, _ := pem.Decode(keyPEMBlock)
	key, _ := x509.ParsePKCS8PrivateKey(keyDERBlock.Bytes)
	return key.(*ecdsa.PrivateKey).Public()
}

func (cpk CustomKey) Sign(rand io.Reader, digest []byte, opts crypto.SignerOpts) (signature []byte, err error) {
	// at here, could call other interface to get the signature
	keyPEMBlock, _ := os.ReadFile(cpk.keyFile)
	keyDERBlock, _ := pem.Decode(keyPEMBlock)
	key, _ := x509.ParsePKCS8PrivateKey(keyDERBlock.Bytes)
	return key.(*ecdsa.PrivateKey).Sign(rand, digest, opts)
}

func main() {
	caCert, _ := os.ReadFile("Web_test-chain.pem")
	caCertPool := x509.NewCertPool()
	caCertPool.AppendCertsFromPEM(caCert)

	client := &http.Client{
		Transport: &http.Transport{
			TLSClientConfig: &tls.Config{
				InsecureSkipVerify: true,
				RootCAs:            caCertPool,
				GetClientCertificate: func(cri *tls.CertificateRequestInfo) (*tls.Certificate, error) {
					var certDERBlock *pem.Block

					keyFileName := "device.key"
					certFile := "/opt/work/dev.crt"
					certPEMBlock, _ := os.ReadFile(certFile)
					certDERBlock, _ = pem.Decode(certPEMBlock)
					var cert tls.Certificate
					cert.Certificate = append(cert.Certificate, certDERBlock.Bytes)
					cert.PrivateKey = CustomKey{
						keyFile: keyFileName,
					}
					return &cert, nil
				},
			},
		},
	}
	url := "https://xxx.com:4430"
	uri := "/api/xxxxxxx"
	method := "GET"
	APP_ID := "xxxxxxxx"
	APP_SECRET_TEST := "xyyyyyy"
	sn := "franli987654"
	hash_type := "sha256"
	args := uri + "?app_id=" + APP_ID + "&hash_type=" + hash_type + "&sn=" + sn // +...;
	dataToSign := method + args + APP_SECRET_TEST
	var hashString string
	if hash_type == "md5" {
		hash := md5.New()
		hash.Write([]byte(dataToSign))
		hashBytes := hash.Sum(nil)
		hashString = hex.EncodeToString(hashBytes)
	} else {
		hash := sha256.New()
		hash.Write([]byte(dataToSign))
		hashBytes := hash.Sum(nil)
		hashString = hex.EncodeToString(hashBytes)

	}
	url += args
	url += "&sign=" + hashString
	req, _ := http.NewRequest(method, url, nil)
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Accept", "*/*")
	req.Header.Set("Accept-Encoding", "gzip, deflate, br")
	req.Header.Set("Connection", "keep-alive")
	resp, err := client.Do(req)
	if err != nil {
		fmt.Println("GET error: ", err)
		return
	}
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusOK {
		fmt.Println("POST request error: ", resp.StatusCode)
		return
	}
	responseBody, _ := io.ReadAll(resp.Body)
	var response Response
	json.Unmarshal(responseBody, &response)
	for _, keyData := range response.Data {
		for _, key := range keyData.Keys {
			// ECIES 1.3 opeartions
			// ...
		}
	}
}
```