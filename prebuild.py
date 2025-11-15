import os
import shutil

if __name__ == "__main__":
    lib='TODO'
    if os.name == 'nt':
        lib = os.path.join('C:\\', 'Dev', 'Python313', 'libs', 'python313.lib')
        shutil.copy(lib, os.getcwd())
    else:
        print('TODO')
