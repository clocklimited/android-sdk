FROM debian:9
RUN apt-get update  \
        && apt-get install -y --no-install-recommends ca-certificates curl netbase wget  \
        && rm -rf /var/lib/apt/lists/*
RUN set -ex; if ! command -v gpg > /dev/null; then apt-get update; apt-get install -y --no-install-recommends gnupg dirmngr ; rm -rf /var/lib/apt/lists/*; fi
RUN apt-get update  \
        && apt-get install -y --no-install-recommends bzr git mercurial openssh-client subversion procps  \
        && rm -rf /var/lib/apt/lists/*
RUN apt-get update  \
        && apt-get install -y --no-install-recommends bzip2 unzip xz-utils  \
        && rm -rf /var/lib/apt/lists/*
ENV LANG=C.UTF-8
RUN { echo '#!/bin/sh'; echo 'set -e'; echo; echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; } > /usr/local/bin/docker-java-home  \
        && chmod +x /usr/local/bin/docker-java-home
RUN ln -svT "/usr/lib/jvm/java-8-openjdk-$(dpkg --print-architecture)" /docker-java-home
ENV JAVA_HOME=/docker-java-home
ENV JAVA_VERSION=8u181
ENV JAVA_DEBIAN_VERSION=8u181-b13-2~deb9u1
RUN set -ex; if [ ! -d /usr/share/man/man1 ]; then mkdir -p /usr/share/man/man1; fi; apt-get update; apt-get install -y --no-install-recommends openjdk-8-jdk="$JAVA_DEBIAN_VERSION" ; rm -rf /var/lib/apt/lists/*; [ "$(readlink -f "$JAVA_HOME")" = "$(docker-java-home)" ]; update-alternatives --get-selections | awk -v home="$(readlink -f "$JAVA_HOME")" 'index($3, home) == 1 { $2 = "manual"; print | "update-alternatives --set-selections" }'; update-alternatives --query java | grep -q 'Status: manual'
RUN dpkg --add-architecture i386  \
        && apt-get update  \
        && apt-get install -y file git curl zip libncurses5:i386 libstdc++6:i386 zlib1g:i386  \
        && apt-get clean  \
        && rm -rf /var/lib/apt/lists /var/cache/apt
ENV ANDROID_HOME=/root/android-sdk-linux SDK_URL=https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip GRADLE_URL=https://services.gradle.org/distributions/gradle-4.5.1-all.zip
WORKDIR /root/
RUN mkdir "$ANDROID_HOME" .android  \
        && cd "$ANDROID_HOME"  \
        && curl -o sdk.zip $SDK_URL  \
        && unzip sdk.zip  \
        && rm sdk.zip  \
        && yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses
RUN wget $GRADLE_URL -O gradle.zip  \
        && unzip gradle.zip  \
        && mv gradle-4.5.1 gradle  \
        && rm gradle.zip  \
        && mkdir .gradle
ENV PATH=/root/gradle/bin:/root/android-sdk-linux/tools:/root/android-sdk-linux/platform-tools:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
CMD ["bash"]
