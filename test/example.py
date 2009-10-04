#!/usr/bin/env python

import sys
sys.path.append('./')

# usage: ./example.py /path/to/file1 /path/to/file2 ...
import pylibshout
import string
import time

s = pylibshout.Shout()
print "Using libshout version %s" % pylibshout.version()

s.host = 'localhost'
# s.port = 8000
s.user = 'source'
s.password = 'hackme'
s.mount = "/pyshout"

# s.format = 'vorbis' | 'mp3'
s.format = pylibshout.SHOUT_FORMAT_OGG

# s.protocol = 'http' | 'xaudiocast' | 'icy'
s.protocol = pylibshout.SHOUT_PROTOCOL_HTTP

s.name = 'mine'
s.description = 'My mount'
s.genre = 'Rock \'n Roll'
s.url = 'beethoven.ogg' #??
# s.public = 0 | 1
# s.audio_info = { 'key': 'val', ... }
#  (keys are shout.SHOUT_AI_BITRATE, shout.SHOUT_AI_SAMPLERATE,
#   shout.SHOUT_AI_CHANNELS, shout.SHOUT_AI_QUALITY)
s.audio_info = {pylibshout.SHOUT_AI_BITRATE: 128}

s.open()

total = 0
st = time.time()
for fa in sys.argv[1:]:
    print "opening file %s" % fa
    f = open(fa)
    s.metadata = {'song': fa}

    nbuf = f.read(4096)
    while 1:
        buf = nbuf
        nbuf = f.read(4096)
        total = total + len(buf)
        if len(buf) == 0:
            break
        s.send(buf)
        s.sync()
    f.close()
    
    et = time.time()
    br = total*0.008/(et-st)
    print "Sent %d bytes in %d seconds (%f kbps)" % (total, et-st, br)

print s.close()
