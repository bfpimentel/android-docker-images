FROM gradle:5.4.1-jdk8

USER root

ENV BUILD_TOOLS_VERSION "29.0.2"
ENV SDK_TOOLS_API "29"
ENV SDK_TOOLS_VERSION "4333796"
ENV ANDROID_HOME "/usr/local/android-sdk"

RUN mkdir "$ANDROID_HOME" .android \
    && cd "$ANDROID_HOME" \
    && curl -o sdk.zip "https://dl.google.com/android/repository/sdk-tools-linux-${SDK_TOOLS_VERSION}.zip" \
    && unzip sdk.zip \
    && rm sdk.zip \
    && mkdir "$ANDROID_HOME/licenses" || true \
    && echo "24333f8a63b6825ea9c5514f83c2829b004d1fee" > "$ANDROID_HOME/licenses/android-sdk-license"

RUN $ANDROID_HOME/tools/bin/sdkmanager --update && \
    $ANDROID_HOME/tools/bin/sdkmanager "build-tools;${BUILD_TOOLS_VERSION}" \
    "platforms;android-${SDK_TOOLS_API}" \
    "platform-tools"

RUN apt-get update && \
    apt-get install build-essential -y && \
    apt-get install file -y && \
    apt-get install apt-utils -y