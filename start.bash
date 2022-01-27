#!/bin/bash
chmod +x GetJava.sh
./GetJava.sh
chmod +x --recursive JavaDL
cd server
if [ ! -f Purpur.jar ]; then
  curl --output purpur.jar https://api.purpurmc.org/v2/purpur/1.18.1/latest/download
fi
../JavaDL/Java/bin/java -Xmx4G -Xmn4G -jar Purpur.jar
cd ..
