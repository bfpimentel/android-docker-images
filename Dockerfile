FROM openjdk:8-jdk

USER root

ENV BUILD_TOOLS_VERSION "29.0.2"
ENV SDK_TOOLS_API "29"
ENV SDK_TOOLS_VERSION "4333796"
ENV ANDROID_HOME "/usr/local/android-sdk"
ENV SONAR_SCANNER_HOME "/usr/local/sonar-scanner"

RUN mkdir "$ANDROID_HOME" .android && \
    cd "$ANDROID_HOME" && \
    curl -o sdk.zip "https://dl.google.com/android/repository/sdk-tools-linux-${SDK_TOOLS_VERSION}.zip" && \
    unzip -q sdk.zip && \
    rm sdk.zip && \
    mkdir "$ANDROID_HOME/licenses" || true && \
    echo "24333f8a63b6825ea9c5514f83c2829b004d1fee" > "$ANDROID_HOME/licenses/android-sdk-license" && \
    $ANDROID_HOME/tools/bin/sdkmanager --update | grep -v = || true && \
    $ANDROID_HOME/tools/bin/sdkmanager "build-tools;${BUILD_TOOLS_VERSION}" \
    "platforms;android-${SDK_TOOLS_API}" \
    "platform-tools" | grep -v = || true

RUN apt-get update && \
    apt-get install build-essential -y && \
    apt-get install file -y && \
    apt-get install apt-utils -y

RUN command curl -sSL https://rvm.io/mpapis.asc | gpg --import && \
    command curl -sSL https://rvm.io/pkuczynski.asc | gpg --import && \
    curl -sSL https://get.rvm.io | bash -s stable --ruby && \
    . /usr/local/rvm/scripts/rvm && \
    rvm install 2.6.5 && \
    gem install bundler && \
    gem install fastlane -NV

RUN curl -o sonar-scanner.zip "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.2.0.1873-linux.zip" && \
    unzip -q sonar-scanner.zip && \
    rm sonar-scanner.zip && \
    mkdir ${SONAR_SCANNER_HOME} && \
    mv sonar-scanner-4.2.0.1873-linux/* ${SONAR_SCANNER_HOME} && \
    rm sonar-scanner-4.2.0.1873-linux && \
    export PATH="$PATH:${SONAR_SCANNER_HOME}/bin" && \
    sonar-scanner -v