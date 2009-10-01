python ./setup.py build_ext --inplace

import pylibshout
s = pylibshout.Shout()
s.host = 'localhost'
s.password = 'hackme'
s.mount = 'test.ogg'
s.open()

['agent',
 'audio_info',
 'close',
 'delay',
 'description',
 'dumpfile',
 'format',
 'genre',
 'get_connected',
 'host',
 'mount',
 'name',
 'nonblocking',
 'open',
 'password',
 'port',
 'protocol',
 'public',
 'queuelen',
 'send',
 'set_metadata',
 'sync',
 'url',
 'user']
