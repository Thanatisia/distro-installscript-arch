"""
Distribution Installer ported to Python
"""
## Built-in
import os
import sys

## External Libraries
from setup import Setup

def init():
    """
    Application Initialization
    """
    global setup, fmt_Text, optionals, positionals

    # Initialize and setup class
    setup = Setup()
    setup.init_prog_Info("installer", "ArchLinux Profile Setup Installer", "Main", "v1.4.0", "DEBUG", "ArchLinux")

    # Process CLI arguments
    fmt_Text = setup.fmt_Text
    cliparser = setup.cliparser
    optionals = cliparser.optionals
    positionals = cliparser.positionals

def display_Options():
    print("Optionals: ")
    for k,v in optionals.items():
        curr_opt = k
        curr_val = v
        print("\t{} = {}".format(curr_opt, curr_val))

    print("")

    print("Positionals: ")
    for i in range(len(positionals)):
        curr_pos = positionals[i]
        print("\t{}: {}".format(i, curr_pos))

def generate_config():
    """
    Generate Configuration File
    """

def init_check():
    """
    Perform distribution installer pre-processing and pre-startup check
    """
    print(f"""
(S) Starting Initialization..."
    Program Name: {setup.PROGRAM_NAME}"
    Program Type: {setup.PROGRAM_TYPE}"
    Distro: {setup.DISTRO}"
          """)

    # Check if configuration file exists
    if os.path.isfile(setup.cfg_name):
        # File exists
        # Import Configuration File
        print("Import Configuration File")
    else:
        generate_config()
        print("please modify the variables and rerun the program again, thank you!")
        exit(1)

    # Initialize Variables
    setup.init_Variables()

    print("")

    print("(+) Verifying Environment Variables...")
    setup.system_Configs()

    if [[ "$TARGET_DISK_NAME" == "" ]]; then
        while [[ "$deviceParams_Name" == "" ]]; do
            echo -e "(-) TARGET_DISK_NAME not set"
            read -p "Please indicate target disk (i.e. /dev/sdX): " deviceParams_Name
        done
        echo -e "(+) Target disk set to $deviceParams_Name"

        device_Parameters["device_Name"]=$deviceParams_Name
    fi

    echo -e ""

    echo -e "(D) Initialization completed"

def begin_installer():
    """
    Begin installation process
    """

def body():
    """
    Begin CLI argument processing
    """
    ## Switch-case CLI positionals
    for i in range(len(positionals)):
        curr_pos = positionals[i]
        if (curr_pos == "start"):
            """
            Start the Installer
            """
            print(fmt_Text.processing("Starting installation process", delimiter="- "))

            print("")

            # Initialize and perform pre-processing and pre-startup checks
            init_check()

            # Start the main Installer
            begin_installer()

def main():
    display_Options()

    print("")

    body()

if __name__ == "__main__":
    init()
    main()
