#get today's date
#NOW=$(date +"%Y-%m-%d")
#export NOW='2018-03-26'
#!/bin/bash
NOW=$1
if ! [ -z $NOW ]
then
   echo $NOW
fi
