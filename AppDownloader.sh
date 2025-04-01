#!/bin/bash

#Script to download multiple packages in Fedora/RHEL and Debian Systems
# Validate  sudo credentials

sudo -v

if [ $? -ne 0 ];
then 
	echo "Sudo authentication failed. "
	exit 1
fi

# Prompts the user for apps

read -p "Which app(s) would you like to download? " -a applications

# Checks for input 

if [ ${#applications[@]} -eq 0  ]; then
	echo "No application entered."
	exit 1
fi

# Convert input to lowercase

lowercase_app=()
for item in "${applications[@]}" ;
do
	lowercase_app+=("$(echo "$item" | tr '[:upper:]' '[:lower:]')")
done

failures=0
# Checks if app is already installed and downloads app
# 1.Fedora / RHEL systems

if command -v dnf &> /dev/null; then
for app in "${lowercase_app[@]}";
	do
		echo "Checking if $app is installed...."
		if yum list "$app" &> /dev/null; then
			echo "$app is already installed."
		else
			if dnf info "$app" &> /dev/null; then
					echo "Installing $app ..."
					sudo dnf install "$app" -y &> /dev/null 
				       	if [ $? -eq 0 ]; then
                        			echo -e "\nDownloading of $app complete!" 
					else
						echo "Error downloading $app"
					 	((failures++))
               				fi
			 else
					 echo "Error: $app not found in repositories"
					 ((failures++))
			fi
		fi
	done

 # 2.Debian Systems

elif command -v apt &> /dev/null && command -v dpkg &> /dev/null ; then
for app in "${lowercase_app[@]}";
	do
		echo "Checking if $app is installed...."
		if dpkg -l "$app" &> /dev/null; then
			echo "$app is already installed."
		else
			if apt-cache show "$app" &> /dev/null; then
					echo "Installing $app ..."
					sudo apt-get install "$app" -y &> /dev/null 
				       	if [ $? -eq 0 ]; then
                        			echo -e "\nDownloading of $app complete!" 
						else
						echo "Error downloading $app"
						((failures++))
               				 fi
			else
					 echo "Error: $app not found in repositories"
					 ((failures++))
			fi
		fi
	done
 # 2.Debian Systems

else
	echo "Unsuppoted system. Error downloading app(s)"
	exit 1
fi

if [ $failures -eq 0 ]; then
	echo "All apps installed successfully"
	exit 0
else
	echo "Some downloads failed"
	exit 1
fi
