FROM openjdk:8
VOLUME /tmp
ADD http://192.168.1.17:8081/repository/springboot-pipeline/com/esprit/examen/tpAchatProject/1.0/tpAchatProject-1.0.jar tpAchatProject-1.0.jar
EXPOSE 8090
ENTRYPOINT ["java","-jar","tpAchatProject-1.0.jar"]