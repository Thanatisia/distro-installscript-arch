import os
import sys

def test_reference(pos):
    def increment(pos):
        # pos += 1
        print(pos, "+ 1 = ", pos+1)
        return pos+1

    pos = increment(pos)
    increment(pos)
    increment(pos)
    increment(pos)
    increment(pos)

def main():
    pos:int = 0
    test_reference(pos)
    print(pos)

if __name__ == "__main__":
    main()
