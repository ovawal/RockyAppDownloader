#!/bin/bash


# Prompts the user for apps and stores it array
read -p "Which app(s) would you like to download? " -a applications


# Checks if any input was provided
if [ ${#applications[@]} -eq 0  ]; then
	echo "No application entered."
	exit 1
fi

# Downloads each application in the array if it exists 
for app in "${applications[@]}";
	do
		if [ -n "$app" ]; then
					echo "Installing $app"
					sudo dnf install "$app" -y 
				       	if [ $? -eq 0 ]; then
                        			echo "Download complete!" 
						else
						echo "Error downloading $app"
               				 fi

		fi
	done
exit 0
