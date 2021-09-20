# LAB 4

# Liste over Docker kommandoer dere kommer til å trenge; 

* docker tag 
* docker build - lager docker image basert på docker files
* docker ps - hva kjører? 
* docker images - hva har jeg bygget ? 
* docker run - start en container (fra et image)
* docker logs - se på loggen fra en container 
* docker exec --it <image> bash - "logge inn" i en container for å se hva som skjer for debug (inception) 

# Dagens oppgave - Dockerize en Spring Boot applikasjon - og push denne til docker hub

Før du starte må du ha Docker installert på maskinen din. Hvis du kjører

```docker run hello-world``` 

Skal du få en output som ser slik ut ; 

```Unable to find image hello-world:latest locally
 Pulling repository hello-world
 91c95931e552: Download complete
 a8219747be10: Download complete
 Status: 
 Downloaded newer image for hello-world:latest
 Hello from Docker.
 This message shows that your installation appears to be working correctly.

 To generate this message, Docker took the following steps:
  1. The Docker Engine CLI client contacted the Docker Engine daemon.
  2. The Docker Engine daemon pulled the "hello-world" image from the Docker Hub.
     (Assuming it was not already locally available.)
  3. The Docker Engine daemon created a new container from that image which runs the
     executable that produces the output you are currently reading.
  4. The Docker Engine daemon streamed that output to the Docker Engine CLI client, which sent it
     to your terminal.

 To try something more ambitious, you can run an Ubuntu container with:
  $ docker run -it ubuntu bash

 For more examples and ideas, visit:
  https://docs.docker.com/userguide/

```
For å lage en Docker Container av Spring Boot applikasjonen din må du lage en Dockerfile

```dockerfile
FROM openjdk:8-jdk-alpine
VOLUME /tmp
ARG JAR_FILE
COPY ${JAR_FILE} app.jar
ENTRYPOINT ["java","-jar","app.jar"]

```

For å bruke Docker til å lage et Container Image kjører dere; 
```sh
docker build . --tag pgr301 --build-arg JAR_FILE=./build/libs/<artifactname>
```
Artifactname er filnavnet på JAR filen. 
Merk at dere må bygge med Maven eller Gradle før dere kjører kommandoen. Hvis dere bygger med Maven er ikke JAR_FILE
argumentet build/libs men target/xyz... 


For å starte en Container, kan dere kjøre 

```sh
docker run pgr301:latest
```

Vent litt. Dette fungerte jo ikke; dere må eksponere port 8080 fra Containeren på maskinen din! Dette kalles port mapping. 

```bash
 docker run -p 8080:8080 pgr301:latest
 ```

Du skal nå kunne kjøre nå applikasjonen din fra nettleser. 

# Docker hub
 
Docker hub er en tjeneste som gjør det mulig å lagre container images sentralt, og dele disse med hele verden - eller bare et prosjekt eller team/organisasjon. 

For å fullføre denne labben må dere registrere dere på Dockerub. Dere skal deretter bygge et container images lokalt - og "pushe" dette til Docker Hub.

## Registrer deg som bruker på Docker Hub

https://www.docker.com/products/docker-hub

## Bygg container image og push til docker hub

```
docker login
docker tag <tag> <username>/<tag_remote>
docker push <username>/<tag_remote>
```

Eksempel

```
docker login
docker tag fantasticapp glennbech/fantasticapp
docker push glennbech/fantasticapp
```

Verdien <tag> er altså en *tag* som du bestemte deg for når du gjorde docker build (pgr301:latest for eksempel). <tag_remote> kan du bestemme deg for nå, fordi det er verdien som skal brukes for docker hub. 

## Del på Slack

Når dere har pushet container image til Docker Hub - del navnet på slack (brukernavn/image) - og forsøk å kjøre andre sine images slik 

```
 docker run -p 8080:8080 glennbech/pgr301
```
Husk port mappings!


# Travis bygger docker image 

Legg til følgende shell script i rotkatalogen til prosjektet 

```
    #!/bin/bash
    echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
    docker build . --tag <et navn du finner på for din app> --build-arg JAR_FILE=./target/din jar fil>
    docker tag  <et navn du finner på for din app>  glennbech/ <et navn du finner på for din app>
    docker push <ditt docker hub username>/<et navn du finner på for din app>
```

eksempel

```
#!/bin/bash
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
docker build . --tag pgr301-pingpong --build-arg JAR_FILE=./target/travisdemo-0.0.1-SNAPSHOT.jar
docker tag pgr301-pingpong  glennbech/pgr301-pingpong
docker push glennbech/pgr301-pingpong
```


Når travis kjører, trenger den å ha verdier for miljøvariablene $DOCKER_PASSWORD og $DOCKER_USERNAME
dette må settes med travis kommandolinje 

```
travis encrypt DOCKER_USERNAME=glennbech -add env.global
travis encrypt DOCKER_PASSWORD=sushh -add env.global
```

Etter du har kjørt disse to kommandoene vil du se at .travis.yml har endret seg og at du vil ha to krypterte verdier.
Dette er brukernavn og passord -og blir gjort tilgjengelig for Travis under bygget - og det er det som får 
denne linjen i scriptet til å fungere

``` bash 
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
```

Nå gjenstår det bare å få travis til å kjøre scriptet. Vi legger til "service" og "script" elementer

```
language: java

services:
- docker

script:
  - bash name_of_the_script_file

env:
  global:
      Values will be added by travis encrypt here...
```


Bonusoppgaver; 

- Registrer deg for Google Cloud Platfor (GCP) og se på tjeneste Google Cloud Run - https://cloud.google.com/run/ - gjør tutorial https://cloud.google.com/run/docs/quickstarts/build-and-deploy
- Les om Docker i travis CI https://docs.travis-ci.com/user/docker/ 
- Jeg har skamløst kopiert strategien med å bygge docker containere fra travis fra  i fjor. Har det skjedd noe nytt? Er  det enklere måter å bygge Docker container images fra Traivs og pushe til Docker hub? Gjør research og del på Slack eller Cancas :-)
- Se på rammeverket https://www.togglz.org/
- Se på terraform som kommer snart...  https://learn.hashicorp.com/tutorials/terraform/install-cli
