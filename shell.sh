#!/bin/bash

source env
welcome="Bonjour professeur Falken, comment puis-je vous aider ?"
blue="\033[1;34m"

function init_screen()
{
  reset
}

function text_to_speech()
{
  text_to_read=$1
  espeak -v mb/mb-fr1 "$text_to_read" -s 120 > /dev/null 2>&1
}

function get_response()
{
  prompt='{"prompt":"'$1'","model":"text-davinci-003","temperature":0,"max_tokens":4000}'
  response=$(curl -s -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $OPENAI_API" -d "$prompt" https://api.openai.com/v1/completions)
  response_text=$(echo "response" |jq -r '.choices[0].text' |tail -n +2 2)> /dev/null
  echo "$response_text"
  echo 
}

function display_text()
{
  echo
  for (( L=0; L<${#1}; L++ ))
  do
    echo -en "$blue${1:$L:1}"
    sleep 0.055
  done
  echo
}

init_screen
text_to_speech "$welcome "&
display_text "$welcome"

while true
do
  read -p "> " prompt
  response_text=$(get_response "$prompt")
  text_to_speech "$response_text"&
  display_text "$response_text"
done
