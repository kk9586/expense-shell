#!/bin/bash

LOGS_FOLDER="/var/log/expense"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME-$TIMESTAMP.log"
mkdir -p $LOGS_FOLDER

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

USERID=$(id -u)
echo "User Id is : $USERID"

CHECK_ROOT(){
if [ $USERID -ne 0 ]
then 
   echo -e $R "please run this script with root priveleges" $N | tee -a $LOG_FILE
   exit 1
fi
} 


VALIDATE(){
       if [ $1 -eq 0 ]
          then  
            echo -e "$2 is $G success $N .. check it" | tee -a $LOG_FILE
            exit 1
          else 
            echo -e "$2 is $R failed. $N "  | tee -a $LOG_FILE
          fi
}

echo "script started executing at $(date)" | tee -a $LOG_FILE 

CHECK_ROOT

dnf install mysql-server -y &>>$LOG_FILE
VALIDATE $? "Installing mysql-server"

systemctl enable mysqld &>>$LOG_FILE
VALIDATE $? "enabled mysql server"

systemctl start mysqld &>>$LOG_FILE
VALIDATE $? "start mysql server"

mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOG_FILE
VALIDATE $? "setting root password"

