## Simple h2e application that starts cowboy on localhost:8443 with self
## signed certificates serving http/2

### using it

make sure you have curl compiled for http/2 support, test it with:
```
curl --http2 -I nghttp2.org
```

if you get 'Unsupposed version':
```
$ sudo apt-get install g++ make binutils autoconf automake autotools-dev libtool pkg-config \
  zlib1g-dev libcunit1-dev libssl-dev libxml2-dev libev-dev libevent-dev libjansson-dev \
  libjemalloc-dev cython python3-dev python-setuptools

# Build nghttp2 from source
git clone https://github.com/tatsuhiro-t/nghttp2.git
cd nghttp2
autoreconf -i
automake
autoconf
./configure
make
sudo make install

cd ~
sudo apt-get build-dep curl
wget tar -xvjf curl-7.52.1.tar.gz  
tar -xvzf curl-7.52.1.tar.gz
cd curl-7.52.1
./configure --with-nghttp2=/usr/local --with-ssl
make
sudo make install
sudo ldconfig
```

Then try it:
```
curl --http2 -I nghttp2.org
```

Once working, compile the example, and start it ( exposes tcpv4 port 8443 )
```
$ make
$ ./start-dev/sh
```

Example:
```
$ curl -vvv --insecure https://192.168.1.11:8443
* Rebuilt URL to: https://192.168.1.11:8443/
*   Trying 192.168.1.11...
* TCP_NODELAY set
* Connected to 192.168.1.11 (192.168.1.11) port 8443 (#0)
* ALPN, offering h2
* ALPN, offering http/1.1
* Cipher selection: ALL:!EXPORT:!EXPORT40:!EXPORT56:!aNULL:!LOW:!RC4:@STRENGTH
* successfully set certificate verify locations:
*   CAfile: /etc/ssl/certs/ca-certificates.crt
  CApath: none
* TLSv1.2 (OUT), TLS header, Certificate Status (22):
* TLSv1.2 (OUT), TLS handshake, Client hello (1):
* TLSv1.2 (IN), TLS handshake, Server hello (2):
* TLSv1.2 (IN), TLS handshake, Certificate (11):
* TLSv1.2 (IN), TLS handshake, Server key exchange (12):
* TLSv1.2 (IN), TLS handshake, Server finished (14):
* TLSv1.2 (OUT), TLS handshake, Client key exchange (16):
* TLSv1.2 (OUT), TLS change cipher, Client hello (1):
* TLSv1.2 (OUT), TLS handshake, Finished (20):
* TLSv1.2 (IN), TLS change cipher, Client hello (1):
* TLSv1.2 (IN), TLS handshake, Finished (20):
* SSL connection using TLSv1.2 / ECDHE-RSA-AES256-GCM-SHA384
* ALPN, server accepted to use h2
* Server certificate:
*  subject: C=US; ST=Texas; O=Nine Nines; OU=Cowboy; CN=localhost
*  start date: Feb 28 05:23:34 2013 GMT
*  expire date: Feb 23 05:23:34 2033 GMT
*  issuer: C=US; ST=Texas; O=Nine Nines; OU=Cowboy; CN=ROOT CA
*  SSL certificate verify result: self signed certificate in certificate chain (19), continuing anyway.
* Using HTTP2, server supports multi-use
* Connection state changed (HTTP/2 confirmed)
* Copying HTTP/2 data in stream buffer to connection buffer after upgrade: len=0
* Using Stream ID: 1 (easy handle 0x1c58f70)
> GET / HTTP/1.1
> Host: 192.168.1.11:8443
> User-Agent: curl/7.52.1
> Accept: */*
> 
* Connection state changed (MAX_CONCURRENT_STREAMS updated)!
< HTTP/2 200 
< content-length: 12
< content-type: text/plain
< date: Wed, 08 Feb 2017 15:44:07 GMT
< server: Cowboy
< 
* Curl_http_done: called premature == 0
* Connection #0 to host 192.168.1.11 left intact
Hello world! 
```
