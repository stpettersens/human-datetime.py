import os
from glob import glob

if __name__ == "__main__":
    extp = '*.pyd' if os.name == 'nt' else '*.so'
    for ext in glob(extp):
        os.remove(ext)

    os.remove(os.path.join('source', 'iana.d'))
