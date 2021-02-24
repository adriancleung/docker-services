#!/bin/sh
# docker-services.sh
# CLI tool to orchestrate my docker services
#
# Version: 1.0.0
# Author: Adrian Leung <contact@adrianleung.dev>
#
# -------------------------------- MIT LICENSE --------------------------------
# MIT License
# 
# Copyright (c) 2021 Adrian Leung
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# -----------------------------------------------------------------------------

IFS=$'\t'
commands=("up\tdown\trestart")
unset IFS

validate_argument() {
  if [[ "\t${commands[@]}\t" =~ "\t$1\t" ]]; then
    return 1
  else
    echo "Command $1 not found"
    print_usage
    exit 1
  fi
}

print_usage() {
  printf "\nUsage: %s [all | FILENAME] [COMMAND]\n" "$(basename "$0")"
  printf "  FILENAME: should be in the format docker-compose.SERVICE_NAME.yml\n\n"
  printf "Commands:\n"
  printf "  %-12s" "up"
  printf "Create and start containers\n"
  printf "  %-12s" "down"
  printf "Stop and remove containers, networks, images, and volumes\n"
  printf "  %-12s" "restart"
  printf "Restart services\n"
}

execute_args() {
  validate_argument $2
  if [ $? -eq 1 ]; then
    case $2 in
      "up")
        docker-compose -p "$(cut -d'.' -f 3 <<< $1)" -f $1 up -d
      ;;
      "down")
        docker-compose -p "$(cut -d'.' -f 3 <<< $1)" -f $1 down
      ;;
      "restart")
        docker-compose -p "$(cut -d'.' -f 3 <<< $1)" -f $1 restart
      ;;
    esac
  fi
}

if [ $# -eq 0 ] || [ -z "$1" ]; then
  echo "No arguments supplied"
  print_usage
  exit 1
elif [ $# -eq 1 ]; then
  echo "Too few arguments supplied"
  print_usage
  exit 1
elif [ $# -gt 2 ]; then
  echo "Too many arguments supplied"
  print_usage
  exit 1
fi

if ! command -v docker &> /dev/null; then
  echo "Docker is not installed"
  exit 1
fi

if ! command -v docker-compose &> /dev/null; then
  echo "Docker Compose is not installed"
  exit 1
fi

if [ "$1" == "all" ]; then
  if [ ! -d "./services" ]; then
    echo "./services directory does not exists"
    exit 1
  else
    for f in ./services/docker-compose.*.yml
    do
      execute_args $f $2
    done
  fi
else
  if [ -f "$1" ]; then
    execute_args $1 $2
  else
    echo "$1 does not exists"
    exit 1
  fi
fi

exit 0
