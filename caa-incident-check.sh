#!/usr/bin/env bash

# Flags
tld=""
version="0.0.1"
command="caa-incident-check"
args=()

# Functions
function execute() {

  if [ -z $args ]; then
    echo "Please provide a valid domain to check for."
    exit
  else
    domain=$args
  fi

  if [ $tld ]; then
      regtld=${tld//\./\\.}
      regtld=${tld//,/|}
  fi

  if [ $regtld ]; then
    output=`grep -o -P "([\.a-zA-Z0-9_-]*$domain($regtld)+).*(at [0-9]{4}-[0-9]{2}-[0-9]{2} [0-9:\.]+ [\+0-9A-Z ]*)" serials.txt | grep -o -P "([\.a-zA-Z0-9_-]*$domain($regtld)+)|(at [0-9]{4}-[0-9]{2}-[0-9]{2} [0-9:\.]+ [\+0-9A-Z ]*)"`
  else
    output=`grep -o -P "([\.a-zA-Z0-9_-]*$domain[\.a-zA-Z0-9_-]*).*(at [0-9]{4}-[0-9]{2}-[0-9]{2} [0-9:\.]+ [\+0-9A-Z ]*)" serials.txt | grep -o -P "([\.a-zA-Z0-9_-]*$domain[\.a-zA-Z0-9_-]*)|(at [0-9]{4}-[0-9]{2}-[0-9]{2} [0-9:\.]+ [\+0-9A-Z ]*)"`
  fi

  if [ ${#output[@]} -gt 0 ] && [ -n "${output//[$'\t\r\n ']}" ]; then
    output=${output//UTC/UTC\\n\\n}
    echo -e ">> Invalid license(s) found for the following domain(s): \n\n" $output
  else
    echo -e ">> No invalid license has been found for '$domain$tld'."
  fi
}

function usage() {
  echo -n "${command} [OPTION]... [DOMAIN]...

  Searches for a domain (with or without specific TLD(s)) in the Let's Encrypt official list of affected domains.
  If any match occur, it will be returned with details of domain and request date.

 ${bold}Options:${reset}
  -t, --tld         List of TLDs to look for, with dots and separeted by commas. (Ex. --tld=.com,.org,.net)
  -h, --help        Display this help and exit
      --version     Output version information and exit
"
}

# Options setting
optstring=h
unset options
while (($#)); do
  case $1 in
    -[!-]?*)
      for ((i=1; i < ${#1}; i++)); do
        c=${1:i:1}
        options+=("-$c")
        if [[ $optstring = *"$c:"* && ${1:i+1} ]]; then
          options+=("${1:i+1}")
          break
        fi
      done
      ;;
    --?*=*) options+=("${1%%=*}" "${1#*=}") ;;
    --) options+=(--endopts) ;;
    *) options+=("$1") ;;
  esac
  shift
done
set -- "${options[@]}"
unset options

while [[ $1 = -?* ]]; do
  case $1 in
    -h|--help) usage >&2; exit ;;
    --version) echo "$(basename $0) ${version}"; exit ;;
    -t|--tld) shift; tld=${1} ;;
    --endopts) shift; break ;;
    *) die "invalid option: '$1'." ;;
  esac
  shift
done
args+=("$@")

# Running
execute
exit