import os
from glob import glob

if __name__ == "__main__":
    if os.name == 'nt':
        for pyd in glob('*.pyd'):
            os.remove(pyd)
    else:
        print('TODO')
