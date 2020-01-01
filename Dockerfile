FROM openjdk:8-alpine

ENV BUILD_TOOLS "28.0.3"
ENV SDK_TOOLS_API "28"
ENV SDK_TOOLS_VERSION "4333796"
ENV ANDROID_HOME "/opt/sdk"
ENV GLIBC_VERSION "2.28-r0"

# GLIBC
RUN apk add --no-cache --virtual=.build-dependencies wget unzip ca-certificates bash && \
    wget https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -O /etc/apk/keys/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk -O /tmp/glibc.apk && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk -O /tmp/glibc-bin.apk && \
    apk add --no-cache /tmp/glibc.apk /tmp/glibc-bin.apk && \
    rm -rf /tmp/*

# Android SDK
RUN wget http://dl.google.com/android/repository/sdk-tools-linux-${SDK_TOOLS_VERSION}.zip -O /tmp/tools.zip && \
    mkdir -p ${ANDROID_HOME} && \
    unzip /tmp/tools.zip -d ${ANDROID_HOME} && \
    rm -v /tmp/tools.zip
RUN export PATH=$PATH:$ANDROID_HOME/tools/bin && \
    mkdir -p /root/.android/ && touch /root/.android/repositories.cfg && \
    yes | sdkmanager "--licenses" && \
    sdkmanager --verbose "build-tools;${BUILD_TOOLS}" "platform-tools" "platforms;android-${SDK_TOOLS_API}" \
    && sdkmanager --verbose "extras;android;m2repository" "extras;google;google_play_services" "extras;google;m2repository"