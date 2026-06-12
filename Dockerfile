# ===== STAGE 1 : BUILD =====
FROM maven:3.9.6-eclipse-temurin-17 AS build

WORKDIR /app

# Copier uniquement pom.xml d'abord (meilleur cache Docker)
COPY pom.xml .

# Télécharger dépendances (accélère builds futurs)
RUN mvn dependency:go-offline

# Copier le code source
COPY src ./src

# Build projet
RUN mvn clean package -DskipTests

# ===== STAGE 2 : RUNTIME =====
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Copier le jar généré
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
