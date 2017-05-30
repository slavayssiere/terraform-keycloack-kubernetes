#!/usr/bin/env bash
set -e

yum install java-1.8.0-openjdk* -y

mkdir -p /usr/local/DigitalExperienceManager/

wget https://s3-eu-west-1.amazonaws.com/jahia-cms-bin/DigitalExperienceManager-CommunityDistribution-7.2.0.1-r55404.jar -o /usr/local/DigitalExperienceManager/DigitalExperienceManager.jar

java -jar /usr/local/DigitalExperienceManager/DigitalExperienceManager.jar /tmp/auto-install.xml

