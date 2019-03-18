#! /bin/bash

ls
pwd
whoami
echo "Имя пользователя $USER"
name="Maxon"
str="Username"
echo "$str $name"

#pwd
mydir=`pwd`
echo "My folder $mydir"
mydir2=$(pwd)
echo "My папка $mydir2"
num1=10
num2=15
num3=$(($num1+$num2))
echo "$num3"