# Docker & Cloud 9

## Installer gpg (Gnu Privatcy Guard)

* https://www.gnupg.org/download/

* Last ned klassen felles privatnøkkel fra Canvas og importer denne 

```
gpg --import secret.asc
```

Se at du har importert nøkkel ved å kjøre følgende kommando
```
gpg --list-secret-keys
```

Output skal se omtrent slik ut 
```
-----------------------------------
sec   ed25519 2021-09-20 [SC] [expires: 2023-09-20]
      565076CBD1F5654153FACE76B82F2BB942F5F90A
uid           [ unknown] pgr301
ssb   cv25519 2021-09-20 [E]
```

Du kan nå dekryptere passordet til din bruker 

* Windowsbrukere: Gå hit. https://base64.guru/converter/decode/file - lim inn det krypterte passordet, og last ned filen application.bin

* Kjør 
```
gpg --decrypt application.bin
```

* Osx

Osx brukere kan gjøre base64 dekoding og dekryptering i en kommando 
```
  echo -n `base64 enkodet kryptert passord` | base64 --decode | gpg --decrypt
```
Du vil nå se passordet, for eksempel "9s1Lsd0#". Passordet skal være 8 tegn langt. Ignorer eventuelt % tegn på slutten av linja. 
Når du har passordet, går du til Cloud9 url for din bruker. Kontonummer skal være 244530008913. Log inn bildet skal se omtrent slik ut

<img title="Login" alt="Loign" src="img/1.png">

# Dagens oppgave - Dockerize en Spring Boot applikasjon - og push den til docker hub

Åpne ditt Cloid 9 utviklingsmiljø, gå til terminalen og skriv 

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

Først må vi installere Maven i Cloud9
```
sudo wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
sudo sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo
sudo yum install -y apache-maven
```

Vi må også oppgradere til Java 8

```
sudo yum -y install java-1.8.0-openjdk-devel
```

Vi må få Operativsystemet til å bruke den siste versjon av Java
```
sudo update-alternatives --config java
sudo update-alternatives --config javac
```

Vi skal nå bruke Cloud9 miljøet til å lage et Docker image av en enkel Spring Boot applikasjon

* Klon dette repositoriet inn i ditt cloud9 miljø med 

```
git clone https://github.com/PGR301-2021/04-cd-part-2.git
cd 04-cd-part-2
```

Test at du kan bygge og kjøre applikasjonen med 

```
mvn spring-boot:run
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
docker build . --tag pgr301 --build-arg JAR_FILE=./target/<artifactname>
```
Artifactname er filnavnet på JAR filen.  Merk at dere må bygge med Maven eller Gradle før dere kjører kommandoen. Hvis dere bygger med Maven er ikke JAR_FILE
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

https://hub.docker.com/signup

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

## Del på Cancas Chat

Når dere har pushet container image til Docker Hub - del navnet på slack (brukernavn/image) - og forsøk å kjøre andre sine images slik 

```
 docker run -p 8080:8080 glennbech/pgr301
```
Husk port mappings!

# Liste over Docker kommandoer dere kommer til å trenge;

* docker tag
* docker build - lager docker image basert på docker files
* docker ps - hva kjører?
* docker images - hva har jeg bygget ?
* docker run - start en container (fra et image)
* docker logs - se på loggen fra en container
* docker exec --it <image> bash - "logge inn" i en container for å se hva som skjer for debug (inception)


Bonusoppgaver; 

- Registrer deg for Google Cloud Platfor (GCP) og se på tjeneste Google Cloud Run - https://cloud.google.com/run/ - gjør tutorial https://cloud.google.com/run/docs/quickstarts/build-and-deploy
- Les om Docker i travis CI https://docs.travis-ci.com/user/docker/ 
- Jeg har skamløst kopiert strategien med å bygge docker containere fra travis fra  i fjor. Har det skjedd noe nytt? Er  det enklere måter å bygge Docker container images fra Traivs og pushe til Docker hub? Gjør research og del på Slack eller Cancas :-)
- Se på rammeverket https://www.togglz.org/
- Se på terraform som kommer snart...  https://learn.hashicorp.com/tutorials/terraform/install-cli
