import os
from glob import glob

if __name__ == "__main__":
    extp = '*.so'
    if os.name == 'nt':
        extp '*.pyd'

    for ext in glob(extp):
        os.remove(ext)

    os.remove(os.path.join('source', 'iana.d'))
