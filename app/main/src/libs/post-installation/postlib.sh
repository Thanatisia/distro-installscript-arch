#!/bin/env bash
<<EOF
Post-Installer helper functions
EOF

# =========================== #
# Post-Installation Functions #
# =========================== #
# User Management
get_users_Home()
{
	#
	# Get the home directory of a user
	#
	USER_NAME=$1
	HOME_DIR=""
	if [[ ! "$USER_NAME"  == "" ]]; then
		# Not Empty
		HOME_DIR=$(su - $USER_NAME -c "echo \$HOME")
	fi
	echo "$HOME_DIR"
}
check_user_Exists()
{
	#
	# Check if user exists
	#
	user_name="$1"
	exist_Token="0"
	delimiter=":"
	res_Existence="$(getent passwd $user_name)"

	if [[ ! "$res_Existence" == "" ]]; then
		# Something is found
		# Check if is the user
		res_is_User=$(echo "$res_Existence" | grep "^$user_name:" | cut -d ':' -f1)

		if [[ "$res_is_User" == "$user_name" ]]; then
			exist_Token="1"
		fi
	fi

	echo "$exist_Token"
}
useradd_get_default_Params()
{
    #
    # Useradd
    #   - Get Default Parameters
    #
    declare -A params=(
        [group]="$(useradd -D | grep GROUP | cut -d '=' -f2)"
        [home]="$(useradd -D | grep HOME | cut -d '=' -f2)"
        [inactive]="$(useradd -D | grep INACTIVE | cut -d '=' -f2)"
        [expire]="$(useradd -D | grep EXPIRE | cut -d '=' -f2)"
        [shell]="$(useradd -D | grep SHELL | cut -d '=' -f2)"
        [skeleton-path]="$(useradd -D | grep SKEL | cut -d '=' -f2)"
        [create-mail-spool]="$(useradd -D | grep CREATE_MAIL_SPOOL | cut -d '=' -f2)"
    )
    default_Params=()

    keywords=(
        "GROUP"
        "HOME"
        "INACTIVE"
        "EXPIRE"
        "SHELL"
        "SKEL"
        "CREATE_MAIL_SPOOL"
    )
    for k in "${keywords[@]}"; do
        # Put all keywords with the default values
        # default_Params[$k]="$(useradd -D | grep $k | cut -d '=' -f2)"
        default_Params+=("$(useradd -D | grep $k | cut -d '=' -f2)")
    done

    echo "${default_Params[@]}"
}
get_all_users()
{
	#
	# Check if user exists
	#
	exist_Token="0"
	delimiter=":"
	res_Existence="$(getent passwd)"
    all_users=($(cut -d ':' -f1 /etc/group | tr '\n' ' '))

	echo "${all_users[@]}"
}
get_user_primary_group()
{
    #
    # Just retrieves the user's primary group (-g)
    #
    user_name="$1"
    primary_group="$(id -gn $user_name)"
    echo "$primary_group"
}
create_user()
{
    # =========================================
    # :: Function to create user lol
    #   1. Append all arguments into the command
    #   2. Execute command and create
    # =========================================

    # --- Head
    ### Parameters ###
    u_name="$1"                 # User Name
    # Get individual parameters
    u_primary_Group="$2"        # Primary Group
    u_secondary_Groups="$3"     # Secondary Groups
    u_home_Dir="$4"             # Home Directory
    u_other_Params="$5"         # Any other parameters after the first 3

    # Local variables
    u_create_Command="useradd"
    create_Token="0"            # 0 : not Created; 1 : Created

    # --- Processing
    # Get Parameters
    if [[ ! "$u_home_Dir" == "NIL" ]]; then
        # If Home Directory is not Empty
        u_create_Command+=" -m "
        u_create_Command+=" -d $u_home_Dir "
    fi

    if [[ ! "$u_primary_Group" == "NIL" ]]; then
        # If Primary Group is Not Empty
        u_create_Command+=" -g $u_primary_Group "
    fi

    if [[ ! "$u_secondary_Groups" == "NIL" ]]; then
        # If Primary Group is Not Empty
        u_create_Command+=" -G $u_secondary_Groups "
    fi

    if [[ ! "$u_other_Params" == "NIL" ]]; then
        # If there are any miscellenous parameters
        u_create_Command+=" $u_other_Params "
    fi

    u_create_Command+="$u_name"

    # --- Output
    # Return Create Command
	echo "$u_create_Command"
}

# Post-Installation Stages
postinstallation()
{
	#
	# Post-Installation Recommendations and TODOs 
	# - To be seperated into its own individual scripts for running
	# 

	### Header ###

	# Local Variable
	postinstall_commands=()

	### Body ###
	# =========== #
	# Enable Sudo #
	# =========== #
	postinstall_commands+=(
        "echo \(+\) Enable sudo"
        "sed -i 's/^#\s*\(%wheel\s\+ALL=(ALL:ALL)\s\+ALL\)/\1/' /etc/sudoers"				# PostInstall Must Do | Step 1: Enable sudo for group 'wheel'
	)

	# =============== #
	# User Management #
	# =============== #
	postinstall_commands+=(
	    "echo \(+\) User Management"
    )
    # Loop through all users in user_profiles and
    # See if it exists, follow above documentation
    for u_ID in "${!user_Info[@]}"; do
		curr_user="${user_Info[$u_ID]}"
		curr_user_Params=($(seperate_by_Delim $curr_user ','))
    
        # Get individual parameters
		u_name="${curr_user_Params[0]}"					# User Name
        u_primary_Group="${curr_user_Params[1]}"        # Primary Group
        u_secondary_Groups="${curr_user_Params[2]}"     # Secondary Groups
        u_home_Dir="${curr_user_Params[3]}"             # Home Directory
        u_other_Params="${curr_user_Params[@]:4}"       # Any other parameters after the first 3

		# Check if user exists
        echo -e "(+) Checking for user $u_name..."
        u_Exists=`arch-chroot $dir_Mount /bin/bash -c "getent passwd $u_name"` #  Check if user exists | Empty if Not Found

        if [[ "$u_Exists" == "" ]]; then
            # 0 : Does not exist
            echo "(-) User [$u_name] does not exist"

            u_create_Command="useradd"
            # Get Parameters
            if [[ ! "$u_home_Dir" == "NIL" ]]; then
                # If Home Directory is not Empty
                u_create_Command+=" -m "
                u_create_Command+=" -d $u_home_Dir "
            fi

            if [[ ! "$u_primary_Group" == "NIL" ]]; then
                # If Primary Group is Not Empty
                u_create_Command+=" -g $u_primary_Group "
            fi

            if [[ ! "$u_secondary_Groups" == "NIL" ]]; then
                # If Primary Group is Not Empty
                u_create_Command+=" -G $u_secondary_Groups "
            fi

            if [[ ! "$u_other_Params" == "NIL" ]]; then
                # If there are any miscellenous parameters
                u_create_Command+=" $u_other_Params "
            fi

            u_create_Command+="$u_name"

			postinstall_commands+=(
				"$u_create_Command"
                "echo \"\t(+) Password change for $u_name\""
				"if [[ \"\$?\" == \"0\" ]]; then"
                "	passwd $u_name"
				"fi"
			)
        fi
    done
	
	
	### Footer ###

	# =============== #
	# Execute Command #
	# =============== #

	# Combine into a string
	cmd_str=""
	for c in "${postinstall_commands[@]}"; do
		cmd_str+="\n$c"
	done
	
	# Cat commands into script file in mount root
	mount_Root=$dir_Mount/root
	script_to_exe=postinstall-comms.sh
	if [[ "$MODE" == "DEBUG" ]]; then
		# echo "echo -e "$cmd_str" > $mount_Root/$script_to_exe"
		echo -e "$cmd_str"
	else
		echo -e "$cmd_str" > $mount_Root/$script_to_exe
	fi

	# Change Permission and Execute command
	if [[ "$MODE" == "DEBUG" ]]; then
		echo "chmod +x $mount_Root/$script_to_exe"
		echo "arch-chroot $dir_Mount /bin/bash -c "/root/$script_to_exe""
	else
		chmod +x $mount_Root/$script_to_exe
		arch-chroot $dir_Mount /bin/bash -c "/root/$script_to_exe"
	fi
	
	external_scripts+=(
		### Append all external scripts used ###
		$mount_Root/$script_to_exe
	)
}

postinstall_todo()
{
    echo "- Please proceed to follow the 'Post-Installation' series of guides"
	echo "and/or"
	echo "- Follow this list of recommendations:"
	echo "	[Post-Installation TODO]"
	echo "	1. Enable multilib repository : "
	echo "		Summary:"
	echo "			If you want to run 32-bit applications on your 64-bit systems"
	echo "			Uncomment/enable the multilib repository"
	echo "		i. Edit '/etc/pacman.conf'"
	echo "		ii. Uncomment [multilib]"
	echo "		iii. Uncomment 'include = /etc/pacman.d/mirrorlist' below [multilib]"
	echo "		WIP:"
	echo "			- Automatic removal of comments in a file"
	echo ""
	# Command and Control
	echo " 2. [To validate if is done] Set sudo priviledges"
	echo "		Summary:"
	echo "			Ability to use 'sudo'"
	echo "		i. Use 'visudo' to enter the sudo file safely"
	echo "			i.e."
	echo "				$EDITOR=vim sudo visudo"
	echo "		ii. Uncomment '%wheel ALL=(ALL) ALL' to allow all users under the group 'wheel' to access sudo (with password)"
	echo ""
	# Administrative
	echo " 3. Create user account"
	echo "		Summary:"
	echo "			Create user account"
	echo "		i. Add user using the 'useradd' command"
	echo "			useradd -m -g <primary group (default: <username>) -G <secondary/supplementary groups (default: wheel)> -d <custom-profile-directory-path> <username>"
	echo "			i.e."
	echo "				useradd -m -g wheel -d /home/profiles/admin admin"
	echo "				useradd -m -g users -G wheel -d /home/profiles/admin admin"
	echo "		ii. Set password to username"
	echo "			passwd <username>"
	echo "			i.e."
	echo "				let <username> be 'admin':"
	echo "					passswd admin"
	echo "		iii. Test user"
	echo "			su - <username>"
	echo "			sudo whoami"
	echo "		iv. If part iii works : User has been created."
	# System Maintenance
	echo " 4. Swap File"
	echo "		Summary:"
	echo "			Instead of using swap partitions which are hard to change size, consider using swap files instead"
	echo "			- Easy to resize"
	echo "			- Easy to remove"
	echo "			- Easy to add/allocate"
	echo "		i. Allocate/Create swap file"
	echo "			fallocate -l <size> /swapfile # <size> : in formats { MB | MiB | GB | GiB }"
	echo "			i.e."
	echo "				fallocate -l 8.0GB /swapfile"
	echo "		ii. Change permission of swapfile to read + write"
	echo "			chmod 600 /swapfile"
	echo "		iii. Make swapfile"
	echo "			mkswap /swapfile"
	echo "		iv. Enable the swap file to begin using it"
	echo "			swapon /swapfile"
	echo "		v. The operating system needs to know that it is safe to use this file everytime it boots up"
	echo "			echo \"# /swapfile\" | tee -a /etc/fstab"
	echo "			echo \"/swapfile none swap defaults 0 0\" | tee -a /etc/fstab"
	echo "			i.e."
	echo "				swapfile size = 4GB"
	echo "				fallocate -l 4G /swapfile"
	echo "				chmod 600 /swapfile"
	echo "				mkswap /swapfile"
	echo "				swapon /swapfile"
	echo "				echo \"# /swapfile\" | tee -a /etc/fstab"
	echo "				echo \"/swapfile none swap defaults 0 0\" | tee -a /etc/fstab"
	echo "		vi. Verify swap file"
	echo "			ls -lh /swapfile"
	echo "		vii. Verify swap file allocation"
	echo "			free -h"
	echo "		viii. If part vii works : Swap file has been created."
}

postinstall_sanitize()
{
	# ========================== #
	#        Sanitize user       #
	#   To sanitize the account  #
	# from any unnecessary files #
	# ========================== #
	# Local Variables
	dir_Mount="${mount_Group["2"]}"

	number_of_external_scripts="${#external_scripts[@]}"
	echo -e "External Scripts created:"
	for ((i=0; i < $number_of_external_scripts; i++)); do
		echo "[$i] : [${external_scripts[$i]}]"
	done
	read -p "What would you like to do to the root scripts? [(C)opy to user|(D)elete|<Leave empty to do nothing>]: " action
	case "$action" in
		"C" | "Copy")
			read -p "Copy to which user? [(A)ll created users|(S)elect]: " users

			# Copy to stated users
			case "$users" in
				"A" | "All")
					# Loop through all users in user_profiles and
					# See if it exists, follow above documentation
					for u_ID in "${!user_Info[@]}"; do
						curr_user="${user_Info[$u_ID]}"
						curr_user_Params=($(seperate_by_Delim $curr_user ','))
					
						# Get individual parameters
						u_name="${curr_user_Params[0]}"					# User Name
						u_primary_Group="${curr_user_Params[1]}"        # Primary Group
						u_secondary_Groups="${curr_user_Params[2]}"     # Secondary Groups
						u_home_Dir="${curr_user_Params[3]}"             # Home Directory
						u_other_Params="${curr_user_Params[@]:4}"       # Any other parameters after the first 3

						echo "Copying from [$PWD] : curl_repositories.sh => /mnt/$u_home_Dir"
						cp curl_repositories.sh /mnt/$u_home_Dir/curl_repositories.sh														# Copy script from root to user
						arch-chroot $dir_Mount /bin/bash -c "chown -R $u_name:$u_primary_Group $u_home_Dir/curl_repositories.sh"		# Change ownership of file to user
					done
					;;
				"S" | "Select")
					# User Input
					read -p "User name: " sel_uhome
					sel_primary_group=$(arch-chroot $dir_Mount /bin/bash -c "su - $sel_uhome -c 'echo \$(id -gn $sel_uhome)'")
					sel_uhome_dir=$(arch-chroot $dir_Mount /bin/bash -c "su - $sel_uhome -c 'echo \$HOME'")
					echo "Copying from [$PWD] : curl_repositories.sh => /mnt/$sel_uhome_dir/curl_repositories.sh"
					cp curl_repositories.sh /mnt/$sel_uhome_dir/curl_repositories.sh
					arch-chroot $dir_Mount /bin/bash -c "chown -R $sel_uhome:$sel_primary_group $sel_uhome_dir/curl_repositories.sh"		# Change ownership of file to user
					;;
				*)
					;;
			esac

			# Reset script to let user delete if they want to
			postinstall_sanitize
			;;
		"D" | "Delete")
			read -p "Delete the scripts? [(Y)es|(N)o|(S)elect]: " del_conf
			# Yes - Delete
			# No - Nothing
			# Select - Allow user to choose
			case "$del_conf" in
				"Y" | "Yes") 
					# Delete all
					for ((i=0; i < $number_of_external_scripts; i++)); do
						if [[ "$MODE" == "DEBUG" ]]; then
							echo "rm -r ${external_scripts[$i]}"
						else
							rm -r ${external_scripts[$i]}
						fi
					done
					;;
				"S" | "Select")
					# Let user choose
					# Seperate all options with delimiter ','
					echo -e "Please enter all files you wish to delete\n	(Seperate all options with delimiter ',')"
					read -p "> : " del_selections
					# Seperate selected options with ',' delimited
					arr_Selected=($(seperate_by_Delim "$del_selections" ','))
					# Delete selected files if not empty
					if [[ ! "$del_selections" == "" ]]; then
						for sel in "${arr_Selected[@]}"; do
							# Delete selected files
							if [[ "$MODE" == "DEBUG" ]]; then
								echo "rm -r ${external_scripts[$sel]}"
							else
								rm -r ${external_scripts[$sel]}
							fi
						done
					fi
					;;
				*)
					;;
			esac
			;;
		*)
			echo "No action."
			;;
	esac
	echo "Sanitization Completed."
}


