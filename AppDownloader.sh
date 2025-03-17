#!/bin/bash


# Prompts the user for apps and stores it array
read -p "Which app(s) would you like to download? " -a applications

# Validate  sudo credentials

sudo -v

if [ $? -ne 0 ];
then 
	echo "Sudo authentication failed. Exit code 1"
	exit 1
fi


# Checks if any input was provided
if [ ${#applications[@]} -eq 0  ]; then
	echo "No application entered."
	exit 1
fi

# Downloads each application in the array if it exists 
for app in "${applications[@]}";
	do
		echo "Checking if $app already installed...."
		dnf info "$app"
		if [ $? -eq 1]; then
					echo "Installing $app"
					sudo dnf install "$app" -y 
				       	if [ $? -eq 0 ]; then
						echo 
                        			echo "Downloadng of $app complete!" 
						else
						echo "Error downloading $app"
               				 fi
				 else
					 echo "$app already installed"

		fi
	done
exit 0
