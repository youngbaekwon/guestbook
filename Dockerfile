# docker image build -t yu3papa/k8s_guestbook:1.0 .
# docker image build -t yu3papa/k8s_guestbook:v1 .
# docker image build -t yu3papa/k8s_guestbook:v2 . <-- RollBack version
# docker image build -t yu3papa/k8s_guestbook:v3 . <-- Error Verion
# docker image build -t yu3papa/k8s_guestbook:v4 . <-- Patch Version

FROM openjdk:8

COPY target/guestbook-0.0.1-SNAPSHOT.jar /app/guestbook.jar

LABEL maintainer="HwanYeoul Jeong<coordinatorj@jadecross.com>" \
      title="Guestbook App" \
      version="1.0" \
      description="This image is guestbook service"

ENV APP_HOME /app
EXPOSE 8080
VOLUME /app/upload

WORKDIR $APP_HOME
ENTRYPOINT ["java", "-Dspring.profiles.active=k8s", "-jar", "guestbook.jar"]
