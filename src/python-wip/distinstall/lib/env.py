"""
Environment Variable support
"""
# Import Built-in Libraries
import os
import sys

# Declare classes
class Environment():
    """
    Environment Variable Support
    """
    def __init__(self):
        """
        Constructor
        """
        self.TARGET_DISK_NAME = os.environ.get("TARGET_DISK_NAME")
