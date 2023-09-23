"""
Formatting functions
"""
import os
import sys

class Text():
    """
    Text Formatting
    """
    def __init__(self, msg=""):
        """
        Class constructor
        """
        self.msg = msg

    def END(self, msg="Pause"):
        """
        Pause/End instruction
        """
        line = input(msg)

    def processing(self, msg="Processing...", format="", delimiter="- "):
        """
        Format processing/loading message
        """
        return "{}{}{}".format(delimiter, format, msg)
