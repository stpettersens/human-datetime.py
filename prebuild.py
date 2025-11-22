import os
import sys
import shutil
import platform

if __name__ == "__main__":
    arch = platform.machine()

    if arch != 'x86_64':
        print('Sorry, only x86_64 machines are currently supported.')
        print(f'Your machine is {arch}.')
        sys.exit(-1)

    patch = '9'
    if os.name == 'posix':
        if os.system('grep alpine /etc/os-release > /dev/null') == 0:
            patch = '5'

    lib = os.path.join('/opt', 'python', f'3.13.{patch}', 'lib', 'libpython3.13.a')
    if os.name == 'nt':
        lib = os.path.join('C:\\', 'Dev', 'Python313', 'libs', 'python313.lib')

    shutil.copy(lib, os.getcwd())
