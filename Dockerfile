FROM  eclipse-temurin:11

# Install Git and dependencies
RUN dpkg --add-architecture i386 \
 && apt-get update --allow-insecure-repositories \
 && apt-get install --allow-unauthenticated -y file git curl zip libncurses5:i386 libstdc++6:i386 zlib1g:i386 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists /var/cache/apt

# Set up environment variables
ENV ANDROID_HOME="/root/android-sdk-linux" \
    SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip" \
    CLI_URL="https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip" \
    GRADLE_URL="https://services.gradle.org/distributions/gradle-7.6-bin.zip"

WORKDIR /root/

# Download Android SDK
RUN curl -o /tmp/tools.zip $CLI_URL \
 && mkdir -p ${ANDROID_HOME}/cmdline-tools \
 && unzip -q /tmp/tools.zip -d ${ANDROID_HOME}/cmdline-tools \
 && mv ${ANDROID_HOME}/cmdline-tools/cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest \
 && rm -v /tmp/tools.zip \
 && mkdir -p /root/.android/ && touch /root/.android/repositories.cfg \
 && apt-get autoremove && apt-get autoclean

RUN yes | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --licenses 

# Install Gradle
RUN wget -q $GRADLE_URL -O /tmp/gradle.zip \
 && unzip -q /tmp/gradle.zip -d /tmp/ \
 && mv /tmp/gradle-7.6 /root/gradle \
 && rm /tmp/gradle.zip \
 && mkdir /root/.gradle

ENV PATH="/root/gradle/bin:${ANDROID_HOME}/cmdline-tools/latest/bin:${PATH}"
