FROM ubuntu:18.04
RUN apt-get update -y
RUN apt-get install build-essential -y
RUN apt-get install git -y
RUN apt-get install wget -y

WORKDIR /tmp

RUN git clone https://github.com/arut/nginx-rtmp-module
RUN git clone https://github.com/openssl/openssl
RUN wget https://nginx.org/download/nginx-1.17.1.tar.gz
RUN tar xvf nginx-1.17.1.tar.gz

WORKDIR nginx-1.17.1
RUN ./configure \
--add-module=/tmp/nginx-rtmp-module \
--with-openssl=/tmp/openssl \
--without-http_rewrite_module \
--without-http_gzip_module \
&& make && make install

COPY nginx.conf /usr/local/nginx/conf/nginx.conf

CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]

WORKDIR /

EXPOSE 80
EXPOSE 1935