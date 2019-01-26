#!/bin/bash

mvn -f apps/luncherapi/pom.xml clean install
mvn -f apps/clustering/pom.xml clean install

cp apps/clustering/target/clustering-1.0-SNAPSHOT.jar clustering.jar
cp apps/luncherapi/target/luncherapi-0.0.1-SNAPSHOT.jar luncherapi.jar
