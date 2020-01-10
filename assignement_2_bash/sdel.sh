#!/bin/bash


#loop on the entered args (files and directories)
for item in $@
do 
	#move the files and directories to home to be able to move it's ziped to TRASH immediatly
	mv $item ~/
done

#change directory to home
cd ~

#see if TRASH directory exists or not
if [ ! -d "TRASH" ]
then 
	mkdir TRASH
fi

#cleans the TRASH every 2 days
find ~/TRASH/* -atime +2 -exec rm -rf {} \;



for item in $@
do 

	
	#make sure that the item is not ziped
	if [[ $(file --mime-type -b "$item") != application/gzip ]] 
	then

		#check if item is a directory
		if [ -d $item ]
		then

			#compress it's content (files)
			gzip -r "$item" 	
		
		fi	

		#compress the item
		tar cvzf "$item.tar.gz" $item/ 	

		#move the zip to TRASH
	        mv "$item.tar.gz" ~/TRASH

		#check ifdirectory
		if [ -d $item ]
		then 

			#remove a directory using -r
		 	rm -r $item	
		else

			#remove a file using rm only
			rm $item	
		fi

	#else the item is a zip
	else

		#move it immediatly to TRASH
	        mv "$item" ~/TRASH
	fi

done


	 
