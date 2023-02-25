#/bin/bash

#Server information for FTP over TCL
FTP_USER="mugeneve@gmail.com"
FTP_PASSWD="" #NOTE TO SELF: Remove password when uploading repository
SERVER="s3.ca-central-1.wasabisys.com"
FOLDER="emulationcloudsave" 

#Saves information for the local computer
SAVESLOCAL="/home/rgbarch/.config/PCSX2/memcards" 

#Chosen protocol
#Options = "FTP", "SSHFTP"
PROTOCOL="LFTP"

#Game selection
GAME_SELECTION=""
PROMPT_MESSAGE="Please select a game: (Warning: tab is unsupported for retrieving files. Type the game name exactly to avoid creating unnecessary folders.)"
PROMPT_MESSAGE_UPLOAD="What save you want to upload? You may use tab for this."

#Notification
AUDIO_PATH="/home/shahrozBlueArch/EmulationCloudSaving-CLI-for-linux/Unlock.wav"

#Saves information
SAVE="Mcd*"

cd $SAVESLOCAL

if [ $# -eq 0 ]; then
	echo "No arguments supplied. Use -u for upload and -r for retrieve"
	exit 1
fi


if [ $@ == "-r" ] && [ $PROTOCOL = "LFTP" ]; then
	if lftp -u $FTP_USER,$FTP_PASSWD $SERVER -e "cd $FOLDER; ls; echo $PROMPT_MESSAGE; exit"; then
		#Read what game save user wants then create that directory localy
		read GAME_SELECTION
		mkdir -p $GAME_SELECTION
		#Move into the directory just created (if it has been)
		cd $GAME_SELECTION
		
		mkdir -p SAVES_DOWNLOADED
		cd SAVES_DOWNLOADED
		
		rm icon.png > /dev/null 2>&1

		if lftp -u $FTP_USER,$FTP_PASSWD $SERVER -e "cd $FOLDER; mget $GAME_SELECTION/$SAVE; get $GAME_SELECTION/icon.png; exit"; then
				mv * ../
				notify-send -i $SAVESLOCAL/$GAME_SELECTION/icon.png "$GAME_SELECTION - cloud save loaded"
				play $AUDIO_PATH > /dev/null 2>&1
		fi

	fi

else 
	if [ $@ == "-u" ] && [ $PROTOCOL = "LFTP" ]; then
		ls
		echo $PROMPT_MESSAGE_UPLOAD
		read -e GAME_SELECTION
		if lftp -u $FTP_USER,$FTP_PASSWD $SERVER -e "cd $FOLDER; cd $GAME_SELECTION; mput $GAME_SELECTION/$SAVE; exit"; then
			notify-send -i $SAVESLOCAL/$GAME_SELECTION/icon.png "$GAME_SELECTION - save uploaded"
			play $AUDIO_PATH > /dev/null 2>&1
		fi
	fi
	
fi
