#!/bin/bash

#the script will run immediately from etc 
cd /etc

#check if phonebook database directory exists or not
if [ -e phonebookDB ]
	then
	
	#if exists, enter it
	cd phonebookDB
	
		#check if phonebook database text file exists or not
		if [  -e phonebookDB.txt ] 
		then
		
		#if exists, change the mode for all(user, group, others) to read, write and 			execute
		sudo chmod a+rwx phonebookDB.txt
	
		else

		#if it doesn't exist, creat it then change mode 
		sudo touch phonebookDB.txt
		sudo chmod a+rwx phonebookDB.txt
		fi	

	#if the phone book database doesn't exist, create aone and creat the phone book text file
	else 
	sudo mkdir phonebookDB
	cd phonebookDB
	sudo touch phonebookDB.txt
	sudo chmod a+rwx phonebookDB.txt
	fi

#check on the user entered options 
case $1 in 

#i for insert mode
-i)

	read -p "Enter a new name " name

	#search file for entered name
	exist=$(grep  "^$name\b :" phonebookDB.txt) 
	
	#if the name does not exist, it will be add to the text file
	if [ "$exist" == '' ]
	then		
		#if flag = 0, phone number is not decimal 
		#if flag = 1, phone number is decimal
		flag=0

		while [ "$flag" != 1  ]
		do
			read -p "Enter a number " number
	
			#check if the entered number from the user is a decimal number 
			#decimal holdes a regex for decimal numbers 
			decimal='^[0-9]+$'
		
			if ! [[ "$number" =~ $decimal ]] 
			then
				sudo echo "error: Not a number." 
			else
				flag=1
			fi
		done

		#append the new name to the phone book data base
		sudo echo "$name : $number">> phonebookDB.txt

	else
		sudo echo "the entered name already exists. "
		sudo echo 'press ctrl+z to exit '
		sudo echo "press 1 to change it's number to a new one."
 		sudo echo "press 2 to append a new number to it."
		read -p "enter your choice " choice

		#check the entered choice
		if [ "$choice" == 1 ]
		then

			#delete the name from the text file 
			sudo sed -i "/^${name}\b :/d" phonebookDB.txt
 
			#if flag = 0, phone number is not decimal 
			#if flag = 1, phone number is decimal
			flag=0

			while [ "$flag" != 1  ]
			do
				read -p "Enter a number " number
		
				#check if the entered number from the user is a decimal number 
				#decimal holdes a regex for decimal numbers 
				decimal='^[0-9]+$'
		
				if ! [[ "$number" =~ $decimal ]] 
				then
					sudo echo "error: Not a number." 
				else
					flag=1
				fi
			done

			#append the new name to the phone book data base
			sudo echo "$name : $number">> phonebookDB.txt
	
		elif [ "$choice" == 2 ]
		then
			#if flag = 0, phone number is not decimal 
			#if flag = 1, phone number is decimal
			flag=0

			while [ "$flag" != 1  ]
			do
				read -p "Enter another number " number_n
		
				#check if the entered number from the user is a decimal number 
				#decimal holdes a regex for decimal numbers 
				decimal='^[0-9]+$'
		
				if ! [[ "$number_n" =~ $decimal ]] 
				then
					sudo echo "error: Not a number." 
				else
					flag=1
				fi
			done
			
			#append the new number to the existing user
			sudo sed -i "/^${name}\b :/s/$/ : ${number_n}/" phonebookDB.txt
		fi
	

	fi
;;

-v)
	#sort the text file, so the names are in alphabatical order.
	sudo sort phonebookDB.txt

;;

-s)  

	read -p "Enter a name to search " name
	grep "$name" phonebookDB.txt 
;;

-e)
	#deletes the whole file
	sudo rm phonebookDB.txt 2> /dev/null
	
	#recreate a new empty datbase tet file
	sudo touch phonebookDB.txt
;;

-d)
	read -p "Enter a name to delete " name

	#search file for entered name
	exist=$(grep  "^$name" phonebookDB.txt) 
	
	#if the name does not exist, a message appers to the user to reenter a name
	if [ "$exist" == '' ]
	then	
		sudo echo "the entered name does not exist."
	#if the name exists.
	else
		#show to the user all the names that match.
		sudo echo "the name(s) that match "
		grep  "^$name" phonebookDB.txt 

		#ask the user to enter the specifc name to delete.
		read -p "enter the specific name to delete " name 
	fi	
	
	#delete the name from the database
	sudo sed -i "/^${name}\b :/d" phonebookDB.txt 
;;
*)

	sudo echo "Avilable options are:"
	sudo echo "-i: insert new contact name and number to the phone book."
	sudo echo "-v: view all saved contact details." 
	sudo echo "-s: search by contact name. "
	sudo echo "-e: delete all recoords."
	sudo echo "-d: delete only one contact name."
;;
esac;


