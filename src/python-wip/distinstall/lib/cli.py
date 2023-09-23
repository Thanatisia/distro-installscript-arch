"""
Command Line Argument Parser
"""
import os
import sys

class CLIParser():
    """
    Initialization and setup
    """
    def __init__(self):
        """
        Initialize Class
        """
        self.configurations = {
            "optionals" : {
                ## Flags
                "help" : False,
                "version" : False,
                "generate-config" : False,
                ## Configurations
                "CUSTOM_CONFIGURATION_FILENAME" : None,
                "TARGET_DISK_NAME" : None,
                "EDITOR" : None,
                "MODE" : None,
                "CFDISK_TARGET" : None,
                "FDISK_TARGET" : None,
            },
            "positionals" : []
        }
        self.exec = sys.argv[0]
        self.argv = sys.argv[1:]
        self.argc = len(self.argv)
        self.start()

    def get_cli_arguments(self):
        """
        Get CLI arguments
        """
        global configurations, exec, argc, argv

        # Initialize Variables
        i:int = 0
        argv = self.argv
        argc = self.argc
        configurations = self.configurations

        # Check if there are options
        if argc > 0:
            # If there are CLI argument/options
            # Loop through all arguments
            while( i < argc ):
                # Get current argument
                curr_arg = argv[i]

                # Switch-case through the arguments
                if (curr_arg == "-c") or (curr_arg == "--config"):
                    """
                    Specify custom configuration file name
                    """
                    ## Set custom configuration file name
                    i, cfg_name = self.get_cli_subarguments(argv, i)
                    ### Check if argument is empty
                    if cfg_name != "":
                        # Not Empty
                        # Set element into configuration file
                        configurations["optionals"]["CUSTOM_CONFIGURATION_FILENAME"] = cfg_name
                    else:
                        # Configuration file not specified
                        print("Configuration file not specified.")
                        exit(1)
                elif (curr_arg == "-d") or (curr_arg == "--target-disk"):
                    """
                    Specify target disk name/label (i.e. /dev/sdX)
                    """
                    ## Set target disk name
                    i, target_disk_name = self.get_cli_subarguments(argv, i)
                    ### Check if argument is empty
                    if target_disk_name != "":
                        # Not Empty
                        # Set element into configurations file
                        configurations["optionals"]["TARGET_DISK_NAME"] = target_disk_name
                    else:
                        # not specified
                        print("Target disk not specified.")
                        exit(1)
                elif (curr_arg == "-e") or (curr_arg == "--editor"):
                    """
                    Specify Editor
                    """
                    ## Set editor
                    i, editor = self.get_cli_subarguments(argv, i)
                    ### Check if argument is empty
                    if editor != "":
                        # Not Empty
                        # Set element into configurations file
                        configurations["optionals"]["EDITOR"] = editor
                    else:
                        # not specified
                        print("Editor not specified.")
                        exit(1)
                elif (curr_arg == "-m") or (curr_arg == "--mode"):
                    """
                    Specify mode of execution - DEBUG | RELEASE
                    """
                    ## Set mode
                    i, mode = self.get_cli_subarguments(argv, i)

                    ### Check if argument is empty
                    if mode == "":
                        # Mode is not specified
                        ## Set default Mode
                        mode = "DEBUG"

                    # Set element into configurations file
                    configurations["optionals"]["MODE"] = mode
                elif (curr_arg == "--cfdisk"):
                    """
                    Open up cfdisk for manual partition configuration
                    """
                    # Initialize variables
                    TARGET_DISK_NAME = os.environ.get("TARGET_DISK_NAME")

                    # Check if TARGET_DISK_NAME is specified
                    if TARGET_DISK_NAME == None:
                        ## Not found
                        print("Target Disk Label/name (i.e. /dev/sdX) is not specified")
                        exit(1)
                    
                    # Found - set cfdisk target
                    configurations["optionals"]["CFDISK_TARGET"] = TARGET_DISK_NAME
                elif (curr_arg == "--fdisk"):
                    """
                    Open up fdisk for manual partition configuration
                    """
                    # Initialize variables
                    TARGET_DISK_NAME = os.environ.get("TARGET_DISK_NAME")

                    # Check if TARGET_DISK_NAME is specified
                    if TARGET_DISK_NAME == None:
                        ## Not found
                        print("Target Disk Label/name (i.e. /dev/sdX) is not specified")
                        exit(1)
                    
                    # Found - set cfdisk target
                    configurations["optionals"]["FDISK_TARGET"] = TARGET_DISK_NAME
                elif (curr_arg == "-g") or (curr_arg == "--generate-config"):
                    """
                    Generate Configuration File
                    """
                    configurations["optionals"]["generate-config"] = True
                elif (curr_arg == "-h") or (curr_arg == "--help"):
                    # Display help menu
                    configurations["optionals"]["help"] = True
                elif (curr_arg == "-v") or (curr_arg == "--version"):
                    # Display system version information
                    configurations["optionals"]["version"] = True
                else:
                    # Remaining: Positionals
                    configurations["positionals"].append(curr_arg)

                # Increment index
                i += 1
        else:
            print("No arguments provided.")

        # Substitute global configurations to class variable
        self.configurations = configurations

    def get_cli_subarguments(self, argv, pos):
        """
        Get CLI subarguments
        """
        ### Get next index position
        next_pos = pos+1

        ### Check if argument list is bigger than the next position
        if len(argv) > next_pos:
            ### Get element in next position
            next_element = argv[next_pos]
            # Increment and shift by 1 space to skip the provided argument
            pos += 1
        else:
            # Configuration file not specified
            next_element = ""

        return pos, next_element

    def process_cli_arguments(self):
        """
        Process CLI arguments
        """
        # Declare global variables
        global optionals, positionals

        # Process
        optionals = configurations["optionals"]
        positionals = configurations["positionals"]

        # Output
        return [optionals, positionals]

    def start(self):
        """
        Startparsing
        """
        self.get_cli_arguments()
        self.optionals, self.positionals = self.process_cli_arguments()


