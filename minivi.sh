#!/usr/bin/env bash
# Installation script, requires sudo rights
wget -c https://github.com/AlexanderShad/minivi/releases/download/0.10.3/minivi.tar.xz
sudo tar -xvf minivi.tar.xz -C $TMP/
rm minivi.tar.xz
sudo install -Dm755 $TMP/minivi /usr/bin/minivi
sudo rm $TMP/minivi
sudo mv -f $TMP/minivi.png /usr/share/icons/hicolor/128x128/apps/minivi.png
sudo mv -f $TMP/minivi.desktop /usr/share/applications/minivi.desktop
echo ''
rm minivi.sh
echo 'Done.'
