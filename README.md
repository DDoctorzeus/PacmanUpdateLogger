# PacmanUpdateLogger

A simple (yet useful) script that stores the names of updated packages after an update for easy downgrading on the Pacman Package Manager (the default package manager of Arch Linux).

This Program/Script Is Lisenced Under GNU V3 (https://www.gnu.org/licenses/gpl-3.0.en.html) and comes with ABSOLUTELY NO WARRANTY. You may distribute, modify and run it however you must not claim it as your own nor sublisence it.

Please note this was written for my personal workstation and I have released it on github in case anyone else finds it useful or wants to contribute.. :) Please know that while this logs upgraded packages it still relies on users to be smart and not use it blindly. I (and Techtonic Software) take no repsonsibility for any damage to systems which utilize it through either the script or its output/log files (YOUVE BEEN WARNED).

This script compares upgraded packages in the main pacman log ("/var/log/pacman.log") to those in your package cache (default "/var/cache/pacman/pkg") and logs a record of these packages in "/var/log/pacman_upgrades" with a datestamp. This allows easy downgrade of packages after an upgrade if needed rather than having to manually search the logs for each package while still attempting to hold true to the "KISS" philosophy ("Keep It Simple, Stupid").

This repo also contains a pacman hook (to be placed in "/usr/share/libalpm/hooks/") to execute the script after each pacman upgrade which is highly recommended to use.

Install:

1. Copy "pacman_updatelogger.sh" to "/usr/local/sbin/".
2. Ensure "pacman_updatelogger.sh" is owned by root and has execute permissions for its owner and no write permissions to any other user or group (e.g. "sudo chown root:root pacman_updatelogger.sh&&sudo chmod 744 pacman_updatelogger.sh").
3. Copy "LogPacmanUpgrade.hook" to "/usr/share/libalpm/hooks/".
3. Change the owner of "LogPacmanUpgrade.hook" to root and ensure only root has write permissions (e.g. "sudo chown root:root LogPacmanUpgrade.hook&&sudo chmod 644 LogPacmanUpgrade.hook")

After each pacman upgrade a new log file should then appear under "/var/log/pacman_upgrades/"


Downgrading Packages From Logs:

1. CHECK THE LOG FILE FIRST TO MAKE SURE IT LOOKS OK.
2. Navigate to "/var/cache/pacman/pkg" (or wherever your pacman cache dir is located).
3. Execute a downgrade using log file contents as input (e.g. (assuming "210125_155553.log" is the name of the log file): "sudo pacman -U - < /var/log/pacman_upgrades/210125_155553.log").
4. If pacman flags any errors (such as duplicate packages) I recommend you create a copy of the log file elsewhere and edit it as needed before attempting the downgrade on the new file.