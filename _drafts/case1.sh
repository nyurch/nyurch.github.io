#!/bin/bash


## Developed for Linux
## License: GNU GPL v.3		http://www.gnu.org/licenses/gpl-3.0.en.html
	VERSION='1'
## Destiny: Install Update Clean etc.
## Script usage: bash script_name


##========================================={
##		i18n - Multilanguage support
##		https://www.gnu.org/software/bash/manual/bash.html#Locale-Translation
	TEXTDOMAIN=update
	TEXTDOMAINDIR="/usr/share/locale"
##=========================================}


##========================================={
##		Exit from script when any command fails
##		https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
#	set -e
##=========================================}


##========================================={
##	Style of echo
BOLD='1'
ITALIC='3'
UNDERLINED='4'
##	Color of echo and Style
RC='\e[0m'	# Reset Color
CN=';36' 	# Cyan ECHO
GN=';32'	# Green ECHO
YW=';33'	# Yellow ECHO
RD=';31'	# Red ECHO
##  The order is important in echo, styles first then color.

DEBUG_ECHO() {
    echo -e "\e[${CN}m Debug: ${1}${RC}"
}

INFO_ECHO() {
    echo -e "\e[${GN}m Info: ${1}${RC}"
}

WARN_ECHO() {
    echo -e "\e[${BOLD}${YW}m Warning: ${1}${RC}"
}

ERROR_ECHO() {
	##	https://www.gnu.org/software/bash/manual/html_node/Exit-Status.html
    echo -e "\e[${BOLD}${RD}m Error: ${1}${RC} ; exit status = $?"
	exit 1
}
##=========================================}


##========================================={
##		Allows you to quickly turn "ON" all additional messages to debug errors.
##		Switch to "OFF" to disable / switch to "ON" to enable. 
DEBUG="OFF"

DEBUG()
{
    if [[ "$DEBUG" == "ON" ]] ; then
		DEBUG_ECHO "$1"
    fi
##		You can also set: 
#  set -xv
}
##=========================================}


##========================================={
## Check root running
[[ $EUID -ne 0 ]] && ERROR_ECHO $" This script must be run as root. "
##=========================================}


##========================================={
## Options
case $1 in
	"--help"|"-h")
		echo " --gui-zenity                  Script will be displayed with zenity graphical user interface."
		echo " --gui-yad                     Script will be displayed with yad graphical user interface."
		echo " --gui-gtkdialog               Script will be displayed with gtkdialog graphical user interface."
		echo " --gui-dialog                  Script will be displayed with dialog graphical user interface."
		echo " --gui-whiptail                Script will be displayed with whiptail graphical user interface."
		echo " --help              -h        Show this help."
		echo " --version           -v        Display version information for this script."
	;;
	"--gui-zenity")
		[[ -z $(type -P zenity) ]] && ERROR_ECHO $" zenity is not installed, so you can not use it. "
		GUI='zenity'

		## BUG --> Zenity in Linux Mint have bug with windows, by default they are too narrow, so I added option "--no-wrap" or I added defined dimensions.  
		##    https://unix.stackexchange.com/questions/80082/zenity-dialog-windows-have-excessive-height-and-cannot-be-resized-bug-workaroun   

		##	Source code:  https://gitlab.gnome.org/GNOME/zenity
		##	Examples:     https://renenyffenegger.ch/notes/Linux/shell/commands/zenity
	;;
	"--gui-yad")
		[[ -z $(type -P yad) ]] && ERROR_ECHO $" yad is not installed, so you can not use it. "
		GUI='yad'

		## BUG --> Yad in Linux Mint have the same bug like Zenity with windows, by default they are too narrow.

		##	Home page:  https://sourceforge.net/projects/yad-dialog/
		##  "v1cont" source code:  https://github.com/v1cont/yad
		##  Examples:  http://smokey01.com/yad/
		##  Examples:  https://sourceforge.net/p/yad-dialog/wiki/browse_pages/
	;;
	"--gui-gtkdialog")
		[[ -z $(type -P gtkdialog) ]] && ERROR_ECHO $" gtkdialog is not installed, so you can not use it. "
		GUI='gtkdialog'

		##  I know. You don't have gtkdialog in Linux Mint :) But now you know more.
		
		##		About gtkdialog for shell / Bash
		##	About GtkDialog:  http://murga-linux.com/puppy/viewtopic.php?p=274035#274035
		##	User Manual: http://xpt.sourceforge.net/techdocs/language/gtkdialog/gtkde03-GtkdialogUserManual/
		##	Wiki: http://01micko.com/reference/
		##	Examples: http://xpt.sourceforge.net/techdocs/language/gtkdialog/gtkde02-GtkdialogExamples/single/
		##	Other Examples: 
		##	1. examples inside gtkdialog source code: https://github.com/oshazard/gtkdialog/tree/master/examples
		##	2. more inside magazines: http://pclosmag.com/html/Issues/200910/page21.html
	;;
	"--gui-dialog")
		[[ -z $(type -P dialog) ]] && ERROR_ECHO $" dialog is not installed, so you can not use it. "
		GUI='dialog'

		##		dialog: /usr/bin/dialog
		##  Home page:  https://invisible-island.net/dialog/dialog.html
		##  Examples:   https://www.foxinfotech.in/2019/04/linux-dialog-examples.html
	;;
	"--gui-whiptail")
		[[ -z $(type -P whiptail) ]] && ERROR_ECHO $" whiptail is not installed, so you can not use it. "
		GUI='whiptail'

		##		whiptail: /usr/bin/whiptail --> yet another GUI for scripts.
		##  Examples:  https://www.xmodulo.com/create-dialog-boxes-interactive-shell-script.html

#==============={
		##  Exist also "gxmessage" and "xmessage" , but I don't see the possibility of creating a menu.
		##  gxmessage: /usr/bin/gxmessage --> yet another GUI for scripts.
		##  11-utils: /usr/bin/xmessage  --> yet another GUI for scripts.
		##	Examples:  https://appuals.com/use-xmessage-app-inside-shell-scripts/
#==============={
	;;
	"--version"|"-v")
		echo "Version = $VERSION"
	;; 
esac
##=========================================}


##========================================={
function WINDOW_INFO() {
			case "$GUI" in
				'zenity')      zenity --info --text "$1" --no-wrap ;;
				'yad')         yad --image=info --title "Info" --text="$1" --width=250 --height=200;;
				'gtkdialog')   
					export WindowInfo='
					<window title="WindowInfo" icon-name="gtk-dialog-info">
						<vbox> 
							<frame>
						<hbox>
							<pixmap icon_size="6">
								<input file stock="gtk-dialog-info"></input>
							</pixmap>
						<vbox>
							<text>
								<label>'"$1"'</label>
							</text>
						</vbox>
						</hbox>
							</frame>
						<hbox>
							<button ok>
							</button>
						</hbox>
						</vbox> 
					</window>'
						gtkdialog -c  --program WindowInfo
				 ;;
				'dialog')      dialog   --title "Info" --msgbox "$1" 15 40   ;;
				'whiptail')    whiptail --title "Info" --msgbox "$1" 15 40   ;;
				*)  INFO_ECHO "$1" ;;
			esac
}

function WINDOW_ERROR() {
			case "$GUI" in
				'zenity')      zenity --error --text "$1" --no-wrap ; exit 1 ;;
				'yad')         yad --image=error --title "Error" --width=200 --text="$1" --width=250 --height=200 ; exit 1 ;;
				'gtkdialog')
					export WindowError='
					<window title="WindowError" icon-name="gtk-dialog-error">
						<vbox> 
							<frame>
						<hbox>
							<pixmap icon_size="6">
								<input file stock="gtk-dialog-error"></input>
							</pixmap>
						<vbox>
							<text>
								<label>'"$1"'</label>
							</text>
						</vbox>
						</hbox>
							</frame>
						<hbox>
							<button ok>
							</button>
						</hbox>
						</vbox> 
					</window>'
						gtkdialog -c  --program WindowError ; exit 1 
				;;
				'dialog')      dialog   --title "Error" --msgbox "$1" 15 40 ; exit 1   ;;
				'whiptail')    whiptail --title "Error" --msgbox "$1" 15 40 ; exit 1   ;;
				*)  ERROR_ECHO "$1" ;;
			esac
}

function CATCH_ERROR() {
if [ "$STATUS" -ne 0 ]; then
	echo "Error: $CATCH_OUTPUT ; $STATUS" | tee -a app.upload.log
	WINDOW_ERROR "Error: Open app.upload.log to see errors."
else
	echo "$CATCH_OUTPUT ; $STATUS" | tee -a app.upload.log
fi
}
##=========================================}


while true; do
	MSG_00=$"=   U P D A T E   M E N U   ="
	MSG_01=$"1. Full System Update/Upgrade"
	MSG_02=$"2. Clean and Fix APT Packages"
	MSG_03=$"3. Install balenaEtcher"
	MSG_04=$"4. Install Favorite Software"
	MSG_05=$"5. Exit/Quit"
	MSG_06=$"Enter Selection: "
	case "$GUI" in
		'zenity')   
					NMBR=$(zenity  --list  --text "Menu"  --radiolist  --column "$MSG_06" --column "Nr." --column "Option"  \
						False "1" "$MSG_01" False "2" "$MSG_02" False "3" "$MSG_03" False "4" "$MSG_04" False "5" "$MSG_05" --width=450 --height=250)
		;;
		'yad')      GUI_OUTPUT=$(yad  --list  --text "Menu" --radiolist  --column "$MSG_06" --column "Nr." --column "Option"  \
						False "1" "$MSG_01" False "2" "$MSG_02" False "3" "$MSG_03" False "4" "$MSG_04" False "5" "$MSG_05" --width=450 --height=250)
					NMBR=$(echo "$GUI_OUTPUT" | awk -F'|' '{print $2}')
		;;
		'gtkdialog')  
			export MENU_DIALOG='
			<vbox>
				<table>
					<width>500</width><height>200</height>
					<variable>TABLE</variable>
					<label>Nr|Column</label>
					<item>1|'"$MSG_01"'</item>
					<item>2|'"$MSG_02"'</item>
					<item>3|'"$MSG_03"'</item>
					<item>4|'"$MSG_04"'</item>
					<item>5|'"$MSG_05"'</item>
				</table>
			<hbox>
				<button ok></button>
			</hbox>
			</vbox>'

			GUI_OUTPUT=$(gtkdialog --program=MENU_DIALOG)
			NMBR=$(echo "$GUI_OUTPUT" | grep TABLE | awk -F'"' '{print $2}')

		;;
		'dialog')   NMBR=$(dialog   --title "Menu"  --clear  --cancel-label "Exit"  --menu "$MSG_06" 20 500 400 \
					"1" "$MSG_01"  "2" "$MSG_02"  "3" "$MSG_03"  "4" "$MSG_04"  "5" "$MSG_05" 3>&1 1>&2 2>&3)  
		;;
		'whiptail')   NMBR=$(dialog   --title "Menu"  --clear  --cancel-label "Exit"  --menu "$MSG_06" 16 100 9 \
					"1" "$MSG_01"  "2" "$MSG_02"  "3" "$MSG_03"  "4" "$MSG_04"  "5" "$MSG_05" 3>&1 1>&2 2>&3) 
		;;
		*)	clear
			echo "============================="
			echo "$MSG_00"
			echo "============================="
			echo "$MSG_01"
			echo "$MSG_02"
			echo "$MSG_03"
			echo "$MSG_04"
			echo "$MSG_05"
			echo "============================="
			read -p "$MSG_06" NMBR
		;;
	esac


	##  In condition "if" [ "$NMBR" -eq 1 ] Bash expects a number to compare. [ "$NMBR" -eq 1 ]
	##  Script will work, but Bash not will happy if you choose nothing or click a letter.
	##  Condition "case" or " [[ "$NMBR" == 1 ]] " will better idea.
	case "$NMBR" in
		1)
			CATCH_OUTPUT=$(apt update       2>&1) ; STATUS="$?" ; CATCH_ERROR
			CATCH_OUTPUT=$(apt full-upgrade 2>&1) ; STATUS="$?" ; CATCH_ERROR
			#CATCH_OUTPUT=$(Invented_broken_command_for_test_error 2>&1) ; STATUS="$?" ; CATCH_ERROR
			clear
			WINDOW_INFO $"System Updated - Returning to Menu"
			sleep 3s
		;;
		2)
			CATCH_OUTPUT=$(apt install -f 2>&1) ; STATUS="$?" ; CATCH_ERROR
			CATCH_OUTPUT=$(apt autoclean  2>&1) ; STATUS="$?" ; CATCH_ERROR
			CATCH_OUTPUT=$(apt autoremove 2>&1) ; STATUS="$?" ; CATCH_ERROR
			clear
			WINDOW_INFO $"System Cleaned - Returning to Menu"
			sleep 3s
		;;
		3)
			#CATCH_OUTPUT=$(curl -1sLf 'https://dl.cloudsmith.io/public/balena/etcher/setup.deb.sh' 2>&1) ; STATUS="$?" ; CATCH_ERROR
			#CATCH_OUTPUT=$(bash setup.deb.sh  2>&1) ; STATUS="$?" ; CATCH_ERROR
			#CATCH_OUTPUT=$(apt-get update     2>&1) ; STATUS="$?" ; CATCH_ERROR
			#CATCH_OUTPUT=$(apt-get install balena-etcher-electron 2>&1) ; STATUS="$?" ; CATCH_ERROR
			clear
			WINDOW_INFO $"Etcher Installed - Returning to Menu"
			sleep 3s
		;;
		4)
			FREE=$(df -k | grep "/$" | awk '{print$4}')
			## 1048576 kB = 1GB
			if [ "$FREE" -lt 5242880 ]; then 
				MSG_41=$"Only 5 GB free space. Insufficient disk space to add new apps.\n\nExiting..."
				WINDOW_ERROR  "$MSG_41"
			else
				#WINDOW_INFO $"Please wait, the installation will take some time." & CATCH_OUTPUT=$(apt install -yy stacer calibre kdenlive \
				#krita libreoffice scribus virtualbox inkscape gimp \
				#gparted gufw vlc simplescreenrecorder handbrake \
				#audacity git bleachbit ttf-mscorefonts-installer 2>&1) ; STATUS="$?" ; CATCH_ERROR
				clear
				MSG_42=$"Packages Installed - Returning to Menu"
				WINDOW_INFO  "$MSG_42"
				sleep 3s
			fi
		;;
		5)
			## clear --> scrolls the terminal lower then you see clear terminal
			clear
			exit 0
		;;
		"")
			echo "  Exiting."
			exit 0
		;;
		*)
			MSG_ELSE=$"Please select a number from the menu"
			WINDOW_INFO  "$MSG_ELSE"
			sleep 3s
		;;
	esac
done


exit 0
