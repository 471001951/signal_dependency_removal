FROM debian:unstable

RUN apt update && apt upgrade -y

RUN apt install -y wget gpg binutils xz-utils coreutils

RUN wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > /usr/share/keyrings/signal-desktop-keyring.gpg
RUN echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' | tee -a /etc/apt/sources.list.d/signal-xenial.list

RUN apt update

RUN apt download signal-desktop
RUN ar x signal*.deb

RUN mkdir -p package/DEBIAN

RUN tar -xf control.tar.gz -C package/DEBIAN
RUN tar -xf data.tar.xz -C package/
RUN sed -i 's/libappindicator1/libayatana-appindicator1/g' package/DEBIAN/control
RUN dpkg-deb -b package

FROM scratch

COPY --from=0 /bin/cat .
COPY --from=0 /lib/x86_64-linux-gnu/libc.so.6 .
COPY --from=0 /lib64/ld-linux-x86-64.so.2 .

COPY --from=0 package.deb .

ENV LD_LIBRARY_PATH="."

CMD ["./ld-linux-x86-64.so.2", "./cat" , "package.deb"]