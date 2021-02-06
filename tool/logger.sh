#!/bin/bash

###################################################################                                                                                                                                                                                                                   
# Description : 
# Utility functions to perform logging.
#
###################################################################

readonly BLUE="\\033[1;34m"
readonly RED="\\033[1;31m"
readonly GREEN="\\033[1;32m"
readonly YELLOW="\\033[1;33m"
readonly MAGENTA="\\033[1;35m"
readonly GRAS="\033[1m"
readonly END="\\033[1;00m"
readonly CHECK_MARK="\xE2\x9C\x94"
readonly SUFFIX="TEZART"

####
## Display url link in output
## $1 message
## $2 url
log::url() {
	echo -e "\\e]8;;http://example.com\\aThis is a hyperlink\e]8;;\\a"
}

log::error() {
	echo -e "\n$RED [ERROR:$SUFFIX] $* $END" >&2
}

log::error_and_exit() {
	echo -e "\n$RED [ERROR:$SUFFIX] $*\n $END" >&2 && exit 1
}

log::info() {
	echo -e "\n$GREEN [INFO:$SUFFIX]$END $* $END"
}

log::info_success() {
	echo -e "\n$GREEN [INFO:$SUFFIX]$END $* $GREEN $CHECK_MARK $END"
}

log::info_and_exit() {
	echo -e "\n$GREEN [INFO:$SUFFIX] $* $END" && exit 0
}

log::debug() {
	[[ -n $DEBUG ]] && echo -e "\n$BLUE [DEBUG:$SUFFIX---] $* $END"
}

log::warn() {
	echo -e "\n$YELLOW [WARN:$SUFFIX] $* $END"
}

log::warn_and_exit() {
	echo -e "\n$YELLOW [WARN:$SUFFIX] $* $END" && exit 0
}

log::message_success() {
	echo -e " $* $GREEN $CHECK_MARK $END"
}

log::message_error() {
	echo -e " $* $RED x $END"
}

log::title() {
	echo -e "\n $* "
}  

log::title_success() {
	echo -e "\n $* $GREEN $CHECK_MARK $END"
}



log::message() {
	echo -e " $* "
}  


log::application(){
	echo -e "\n\n$GREEN$(cat $BASEDIR/../tool/info-tezart)$END"
}