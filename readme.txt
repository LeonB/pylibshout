python ./setup.py build_ext --inplace

import pylibshout
s = pylibshout.Shout()
s.host = 'localhost'
s.password = 'hackme'
s.mount = 'test.ogg'
s.open()