#!/usr/bin/env python3.6

import os
import subprocess
from os.path import expanduser

print('Installing metalock template...')
home = expanduser('~')
home_datadir = os.path.join(home, '.local/share/metalock/themes/badabing')
destdir = os.path.join(home, '.local/share/metalock/themes')
print('install to ', home_datadir)
subprocess.call(['mkdir', '-p', home_datadir])
subprocess.call(['cp', '-r', './themes/badabing', destdir])

