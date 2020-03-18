import sys
import os

def main(targets):

    if 'test-project' in targets:
        os.system('python etl.py')

    return

if __name__ == '__main__':
    targets = sys.argv[1:]
    main(targets)
