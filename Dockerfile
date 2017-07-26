FROM centos:7


##INSTALL PACKAGES
RUN yum install -y unzip

##SETUP JAVA
RUN yum install -y \
       java-1.8.0-openjdk \
       java-1.8.0-openjdk-devel
       
ENV JAVA_HOME /etc/alternatives/jre

RUN java -version

##SETUP GRADLE
ARG GRADLE_VERSION=2.9

# download and install gradle
#ADD https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip gradle-$GRADLE_VERSION-bin.zip
COPY ./gradle-$GRADLE_VERSION-bin.zip gradle-$GRADLE_VERSION-bin.zip
RUN unzip -qq gradle-$GRADLE_VERSION-bin.zip \
  && rm gradle-$GRADLE_VERSION-bin.zip \
  && mkdir -p /usr/share/ \
  && mv gradle-$GRADLE_VERSION /usr/share/ \
  && ln -s /usr/share/gradle-$GRADLE_VERSION/bin/gradle /usr/bin/gradle

ENV GRADLE_HOME /usr/share/gradle-$GRADLE_VERSION

RUN gradle -v


#COPY PROJECT
ADD ./ /hello-karyon

RUN cd /hello-karyon && gradle clean fatJar



ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/hello-karyon/build/libs/hello-karyon-rxnetty-all-0.1.0.jar"]

## EXPOSE SERVLET PORT
EXPOSE 8080
