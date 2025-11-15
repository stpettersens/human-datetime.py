import os
import shutil
from glob import glob

if __name__ == "__main__":
    if os.name == 'nt':
        _dir = os.path.join('C:\\', 'Dev', 'Python313', 'Lib', 'site-packages')
        for pyd in glob('*.pyd'):
            if shutil.which('dumpbin') is not None:
                os.system(f'dumpbin /exports {pyd} | findstr PyInit_human_datetime_py')
            try:
                shutil.copy(pyd, os.path.join(_dir, pyd))
            except Exception as e:
                print('Is Python interpreter running?')
                print(e)
    else:
        print('TODO')
