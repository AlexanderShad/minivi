#!/usr/bin/env bash
# Installation script, requires sudo rights
wget -c https://github.com/AlexanderShad/minivi/releases/download/0.9.0/minivi.tar.xz
tar -xvf minivi.tar.xz -C $TMP/
rm minivi.tar.xz
sudo install -Dm755 $TMP/minivi /usr/bin/minivi
rm $TMP/minivi
sudo mv $TMP/minivi.png /usr/share/icons/hicolor/128x128/apps/minivi.png
sudo mv $TMP/minivi.desktop /usr/share/applications/minivi.desktop
echo ''
echo 'Done.'
