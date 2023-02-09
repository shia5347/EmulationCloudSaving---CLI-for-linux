#!/bin/bash

GAME_DIR="/home/rgbarch/ps2games/SLUS*"

./EmulationCloud.sh -r && pcsx2 $GAME_DIR --fullscreen 
./EmulationCloud.sh -u
