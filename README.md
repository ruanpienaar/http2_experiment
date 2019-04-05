## Simple h2e application that starts cowboy on localhost:8443 with self
## signed certificates serving http/2

### using it

## compile and start it ( exposes tcpv4 port 8443 )
```
$ make
$ ./start-dev.sh
```

## Using gun as a http2 client



## curl example:
```
$ curl --http2 -vvv --insecure https://localhost:8443
* Rebuilt URL to: https://localhost:8443/
*   Trying 127.0.0.1...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 8443 (#0)
* ALPN, offering h2
* ALPN, offering http/1.1
* successfully set certificate verify locations:
*   CAfile: /etc/ssl/certs/ca-certificates.crt
  CApath: /etc/ssl/certs
* TLSv1.2 (OUT), TLS handshake, Client hello (1):
* TLSv1.2 (IN), TLS handshake, Server hello (2):
* TLSv1.2 (IN), TLS handshake, Certificate (11):
* TLSv1.2 (IN), TLS handshake, Server key exchange (12):
* TLSv1.2 (IN), TLS handshake, Server finished (14):
* TLSv1.2 (OUT), TLS handshake, Client key exchange (16):
* TLSv1.2 (OUT), TLS change cipher, Client hello (1):
* TLSv1.2 (OUT), TLS handshake, Finished (20):
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
* Using Stream ID: 1 (easy handle 0x5588ae93d900)
> GET / HTTP/2
> Host: localhost:8443
> User-Agent: curl/7.58.0
> Accept: */*
>
* Connection state changed (MAX_CONCURRENT_STREAMS updated)!
< HTTP/2 200
< content-length: 12
< content-type: text/plain
< date: Fri, 05 Apr 2019 13:59:58 GMT
< server: Cowboy
<
* Connection #0 to host localhost left intact
Hello world!
```




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
