#!/bin/sh
set -e
LibArchive=$(pwd)/libarchive
BSDTarLocation=$LibArchive/bsdtar
chmod +x $BSDTarLocation
alias bsdtar=$BSDTarLocation
if [ ! -d "JavaDL" ]; then
  echo "Downloading GetJava..."
  # wget -qO- https://github.com/MokiyCodes/GetJava/archive/refs/heads/main.zip | bsdtar -xvf- -C .
  curl -#L https://github.com/MokiyCodes/GetJava/archive/refs/heads/main.zip | bsdtar -xf- -C .
  echo "Moving GetJava-main to JavaDL..."
  mv GetJava-main JavaDL
  echo "Adding Execute Permissions to GetJava..."
  chmod +x JavaDL --recursive
fi
echo "Running GetJava..."
cd JavaDL
chmod +x GetJava.sh
./GetJava.sh
cd ..

chmod +x --recursive JavaDL
cd server
if [ ! -f Purpur.jar ]; then
  curl --output Purpur.jar https://api.purpurmc.org/v2/purpur/1.18.1/latest/download
fi

if [ ! -d plugins ]; then
  echo "Plugins directory not found - Downloading Plugins..."
  mkdir plugins
  cd plugins

  Plugin() {
    echo "Downloading $1..."
    curl -o $1.jar -L $2 --silent
  }
  #
  # General Plugins
  #
  Plugin "Vault" "https://dev.bukkit.org/projects/vault/files/latest"
  Plugin "SuperVanish" "https://dev.bukkit.org/projects/supervanish/files/latest"
  Plugin "WorldEdit" "https://dev.bukkit.org/projects/worldedit/files/latest"
  Plugin "HolographicDisplays" "https://dev.bukkit.org/projects/holographic-displays/files/latest"
  Plugin "MultiverseCore" "https://dev.bukkit.org/projects/multiverse-core/files/latest"
  Plugin "SinglePlayerSleep" "https://dev.bukkit.org/projects/singleplayersleep2/files/latest"
  Plugin "PlugManX" "https://dev.bukkit.org/projects/plugmanx/files/latest"
  Plugin "LuckPerms 5.3.98" "https://ci.lucko.me/job/LuckPerms/1398/artifact/bukkit/loader/build/libs/LuckPerms-Bukkit-5.3.98.jar"

  #
  # Essentials
  #
  EssentialsVersion="2.19.2"
  EssFile="EssentialsX-${EssentialsVersion}"

  Essentials() {
    echo "Downloading EssentialsX/$2 at v${EssentialsVersion}"
    curl -o ${EssFile}-$2.jar -L https://github.com/EssentialsX/Essentials/releases/download/${EssentialsVersion}/EssentialsX$1-${EssentialsVersion}.jar --silent
  }

  Essentials '' Core
  Essentials Chat Chat
  Essentials Spawn Spawn
  Essentials Discord Discord

  cd ..
fi
if [ "$NGROK_KEY" ]; then
	echo "Found NGROK_KEY environment variable. Purpur will run in a seperate thread, and ngrok will run in the foreground using NGROK_KEY as the key."
	echo "Sleeping for 3 seconds..."
	sleep 3
	echo "Starting Purpur..."
	../JavaDL/Java/bin/java -Xmx2G -Xmn2G -jar Purpur.jar >/dev/null &
	echo "Starting ngrok using key..."
	chmod +x ../ngrok
	../ngrok authtoken $NGROK_KEY
	../ngrok tcp 25565
else
	echo "Starting Purpur..."
	../JavaDL/Java/bin/java -Xmx2G -Xmn2G -jar Purpur.jar >/dev/null &
fi;
