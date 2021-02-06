#!/bin/bash

# exit when any command fails
set -e

###################################################################                                                                                                                                                                                                                   
# Description : 
# Utility functions for dev, ci/cd operations ...
#
###################################################################

readonly BASEDIR=$( cd $( dirname $0 ) && pwd )

source $BASEDIR/../tool/logger.sh

#  ██╗   ██╗███████╗ █████╗  ██████╗ ███████╗
#  ██║   ██║██╔════╝██╔══██╗██╔════╝ ██╔════╝
#  ██║   ██║███████╗███████║██║  ███╗█████╗  
#  ██║   ██║╚════██║██╔══██║██║   ██║██╔══╝  
#  ╚██████╔╝███████║██║  ██║╚██████╔╝███████╗
#  ╚═════╝ ╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝

USAGE_HELP='Display this message'
USAGE_RUN_TESTS='Process to run tests'
USAGE_RUN_SETUP='Process to run the setup of the project'
USAGE_RUN_COVERAGE_DEV='Process to run the code coverage in dev environment'

usage() {

	log::application
	cat <<EOF

	Usage: Script used to perform dev, ci/cd operations

	OPTIONS:
	========
	--run-setup		$USAGE_RUN_SETUP
	--run-tests		$USAGE_RUN_TESTS
	--run-coverage-dev 	$USAGE_RUN_COVERAGE_DEV
	-h			$USAGE_HELP

EOF
}

###########
### PRIVATE 
###########

tezart::_check_localhost_chain() {
	retry=1
	isSanboxRunning=1
	while [[ retry -le 5 ]]
	do  
		curl -s localhost:20000/chains/main/mempool/pending_operations  > /dev/null && isSanboxRunning=0 && break
		log::warn "retry $retry : Unable to curl localhost:20000/chains/main/mempool/pending_operations"
		((retry=retry+1))
		sleep 1
	done
	
	if [[ isSanboxRunning -eq 0 ]]
	then
		log::title_success " - a tezos sandbox is running locally"
	else
		log::error_and_exit "Please read the README.md to run a tezos sandbox locally."
	fi

	
}

tezart::_check_requirements() {
	## check for docker
	if docker --version &>/dev/null
	then
		log::title_success " - docker is present on your system"
	else
		log::error_and_exit 'The docker is missing on your system. Please read the README.md to install it'
	fi

	## check for dart
	if dart --version &>/dev/null
	then
		log::title_success " - dart sdk is present on your system"
	else
		log::error_and_exit 'The dart sdk is missing on your system. Please read the README.md to install it'
	fi

	## check for lefthook
	if lefthook &>/dev/null
	then
		log::title_success " - lefthook is present on your system"
	else
		log::error_and_exit 'The Lefthook plugin is missing on your system. Please read the README.md to install it'
	fi

}

tezart::_init_env_var() {

	if [[ -f .env.tests ]]
	then
		log::warn "A .env.tests file is already found. the script won't generate a new one"
	else
		log::title_success " - a new .env.tests file is generated for your tests"
		cp .env.dist .env.tests
	fi
}

###########
### PUBLIC 
###########

tezart::run_coverage_dev() {
	log::info "$USAGE_RUN_COVERAGE_DEV :"

	pub get

	# Effective test coverage
	pub run test_coverage

	# Generate coverage info
	genhtml -o coverage coverage/lcov.info 

	# Open to see coverage info
	open coverage/index.html
}

tezart::run_setup() {
	log::info "$USAGE_RUN_SETUP :"

	tezart::_check_requirements
	tezart::_check_localhost_chain
	tezart::_init_env_var
}

tezart::run_tests() {
	log::info "$USAGE_RUN_TESTS :"

	tezart::_check_localhost_chain
	tezart::_init_env_var

	echo -e '\n'

	pub get
	pub run build_runner build
	pub run test
}

# ███╗   ███╗ █████╗ ██╗███╗   ██╗    
# ████╗ ████║██╔══██╗██║████╗  ██║    
# ██╔████╔██║███████║██║██╔██╗ ██║    
# ██║╚██╔╝██║██╔══██║██║██║╚██╗██║    
# ██║ ╚═╝ ██║██║  ██║██║██║ ╚████║    
# ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝    

#
## Optional parameters
RUN_TESTS=
RUN_SETUP=
RUN_COVERAGE_DEV=

main() {
	[[ -n $RUN_TESTS ]] && tezart::run_tests
	[[ -n $RUN_SETUP ]] && tezart::run_setup
	[[ -n $RUN_COVERAGE_DEV ]] && tezart::run_coverage_dev
	
	exit 0
}

#  ██████╗ ███████╗████████╗ ██████╗ ██████╗ ███████╗
# ██╔════╝ ██╔════╝╚══██╔══╝██╔═══██╗██╔══██╗██╔════╝
# ██║  ███╗█████╗     ██║   ██║   ██║██████╔╝███████╗
# ██║   ██║██╔══╝     ██║   ██║   ██║██╔═══╝ ╚════██║
# ╚██████╔╝███████╗   ██║   ╚██████╔╝██║     ███████║
#  ╚═════╝ ╚══════╝   ╚═╝    ╚═════╝ ╚═╝     ╚══════╝
                                                   
                                                                
while getopts :-:h option
do
	case $option in
		-)
			case $OPTARG in
				run-setup)
					RUN_SETUP=1
					;;
				run-tests)
					RUN_TESTS=1
					;;
				run-coverage-dev)
					RUN_COVERAGE_DEV=1
					;;
				*)
					log::error "Unknow parameter '--$OPTARG' !"
					usage
					exit 2
					;;
				esac
			;;
		:|?|h)
			[[ $option == \? ]] && log::error "The parameter -$OPTARG can't be used !"
			[[ $option == : ]] && log::error "The parameter  -$OPTARG needs an argument !"
			usage
			exit $([[ $option == h ]] && echo 0 || echo 2)
			;;
	esac
done

main
