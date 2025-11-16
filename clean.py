import os
from glob import glob

if __name__ == "__main__":
    if os.name == 'nt':
        for pyd in glob('*.pyd'):
            os.remove(pyd)

        os.remove(os.path.join('source', 'iana.d'))
    else:
        print('TODO')
