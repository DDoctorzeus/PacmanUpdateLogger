#!/bin/bash

#Static Vars
PACMANLOGFILE='/var/log/pacman.log';
PACKAGECACHEDIR='/var/cache/pacman/pkg';
LOGFILELOCATION='/var/log/pacman_upgrades';

#Like to declare variables first
SETDATE=$(date +"%Y-%m-%d");
UPGRADELOGS=();
CACHEDPACKAGES=();
CURRENTPACKAGE_NAME='';
CURRENTPACKAGE_VERSION='';
NEWLOGFILE="$LOGFILELOCATION/$(date +'%y%m%d_%H%M%S').log"
NEWLOGERRORFILE="$LOGFILELOCATION/$(date +'%y%m%d_%H%M%S')_errors.log";
CURRENTPACKAGE='';
NEWPACKAGELIST=();

#Handle Arguments
if [ $# -eq 1 ]; then
    SETDATE=$1;
fi

#Check running as root
if [ "$USER" != "root" ]; then
    echo "This script must be run as root!";
    exit 1;
fi

#If log file location does not already exist, create it
if [ ! -d $LOGFILELOCATION ]; then
    mkdir $LOGFILELOCATION;

    #Output log note
    echo -e "Files in this folder were created by 'pacman update logger': (https://github.com/TechtonicSoftware/PacmanUpdateLogger).\n\nThey represent the file names of old packages that were upgraded on the date of the file name." > "$LOGFILELOCATION/Note.txt";
fi

#Get Upgrade Logs and all packages in package cache
UPGRADELOGS=($(cat $PACMANLOGFILE | grep -a 'upgraded' | grep -a $SETDATE | sed 's/.*upgraded //' | sed 's/ (/,/' | sed 's/ ->*.*//'));
CACHEDPACKAGES="$(ls $PACKAGECACHEDIR)";

#Loop through attempting to find each one
for UPGRADELOG in "${UPGRADELOGS[@]}"; do

    #Grab values
    CURRENTPACKAGE_NAME="$(echo $UPGRADELOG | cut -d ',' -f1)";
    CURRENTPACKAGE_VERSION="$(echo $UPGRADELOG | cut -d ',' -f2)";
    CURRENTPACKAGE=$(echo "$CACHEDPACKAGES" | grep $CURRENTPACKAGE_NAME | grep $CURRENTPACKAGE_VERSION);
    
    #If we have not found a package then log the error in a seprate file, otherwise add it
    if [[ "$CURRENTPACKAGE" == '' ]]; then
        printf "WARNING: Could not find package %s with version %s in %s." $CURRENTPACKAGE_NAME $CURRENTPACKAGE_VERSION $PACKAGECACHEDIR >> $NEWLOGERRORFILE;
    else
        NEWPACKAGELIST+=("$CURRENTPACKAGE");
    fi
done

#Finally dump package list to log file
echo "${NEWPACKAGELIST[@]}" | sed 's/ /\n/g' | sort -u > $NEWLOGFILE;
#echo "${NEWPACKAGELIST[@]}" | sed 's/ /\n/g' | sort -u