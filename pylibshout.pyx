import sys

cdef extern from "sys/types.h":
    ctypedef unsigned int size_t
    ctypedef int ssize_t

cdef extern from "shout/shout.h":
    #types
    ctypedef struct shout_t
    ctypedef struct shout_metadata_t

    #methods
    void shout_init()
    void shout_shutdown()
    char *shout_version(int *major, int *minor, int *patch)
    shout_t *shout_new()
    void shout_free(shout_t *self)
    char *shout_get_error(shout_t *self)
    int shout_get_errno(shout_t *self)
    int shout_get_connected(shout_t *self)
    
    int shout_open(shout_t *self)
    int shout_close(shout_t *self)
    int shout_send(shout_t *self, unsigned char *data, size_t len)
    ssize_t shout_send_raw(shout_t *self, unsigned char *data, size_t len)
    ssize_t shout_queuelen(shout_t *self)
    void shout_sync(shout_t *self)
    int shout_delay(shout_t *self)

    #properties:
    int shout_set_host(shout_t *self, char *host)
    char *shout_get_host(shout_t *self)

    int shout_set_port(shout_t *self, unsigned short port)
    unsigned short shout_get_port(shout_t *self)

    int shout_set_user(shout_t *self, char *username)
    char *shout_get_user(shout_t *self)

    int shout_set_password(shout_t *, char *password)
    char *shout_get_password(shout_t *self)

    int shout_set_mount(shout_t *self, char *mount)
    char *shout_get_mount(shout_t *self)

    int shout_set_name(shout_t *self, char *name)
    char *shout_get_name(shout_t *self)

    int shout_set_url(shout_t *self, char *url)
    char *shout_get_url(shout_t *self)

    int shout_set_genre(shout_t *self, char *genre)
    char *shout_get_genre(shout_t *self)

    int shout_set_agent(shout_t *self, char *agent)
    char *shout_get_agent(shout_t *self)

    int shout_set_description(shout_t *self, char *description)
    char *shout_get_description(shout_t *self)

    int shout_set_dumpfile(shout_t *self, char *dumpfile)
    char *shout_get_dumpfile(shout_t *self)

    int shout_set_audio_info(shout_t *self, char *name, char *value)
    char *shout_get_audio_info(shout_t *self, char *name)

    int shout_set_public(shout_t *self, unsigned int make_public)
    unsigned int shout_get_public(shout_t *self)

    #takes a SHOUT_FORMAT_xxxx argument
    int shout_set_metadata(shout_t *self, shout_metadata_t *metadata)
    shout_metadata_t *shout_metadata_new()
    void shout_metadata_free(shout_metadata_t *self)
    int shout_metadata_add(shout_metadata_t *self, char *name, char *value)

    int shout_set_format(shout_t *self, unsigned int format)
    unsigned int shout_get_format(shout_t *self)

    #takes a SHOUT_PROTOCOL_xxxxx argument
    int shout_set_protocol(shout_t *self, unsigned int protocol)
    unsigned int shout_get_protocol(shout_t *self)

    #Instructs libshout to use nonblocking I/O. Must be called before
    #* shout_open (no switching back and forth midstream at the moment).
    int shout_set_nonblocking(shout_t* self, unsigned int nonblocking)
    unsigned int shout_get_nonblocking(shout_t *self)


SHOUTERR_SUCCES = 1
SHOUTERR_INSANE = -1
SHOUTERR_NOCONNECT = -2
SHOUTERR_NOLOGIN = -3
SHOUTERR_SOCKET = -4
SHOUTERR_MALLOC = -5
SHOUTERR_METADATA = -6
SHOUTERR_CONNECTED = -7
SHOUTERR_UNCONNECTED = -8
SHOUTERR_UNSUPPORTED = -9
SHOUTERR_BUSY = -10

SHOUT_FORMAT_OGG = 0
SHOUT_FORMAT_MP3 = 1
#backward-compatibility alias
SHOUT_FORMAT_VORBIS	= SHOUT_FORMAT_OGG

SHOUT_PROTOCOL_HTTP = 0
SHOUT_PROTOCOL_XAUDIOCAST = 1
SHOUT_PROTOCOL_ICY = 2

SHOUT_AI_BITRATE =  'bitrate'
SHOUT_AI_SAMPLERATE = 'samplerate'
SHOUT_AI_CHANNELS = 'channels'
SHOUT_AI_QUALITY = 'quality'

def version():
    cdef int *major
    cdef int *minor
    cdef int *patch
    return shout_version(major, minor, patch)

cdef class Shout:
    cdef shout_t *shout_t
    cdef shout_metadata_t *shout_metadata_t
    __audio_info = {}
    __metadata = {}

    def __init__(self):
        shout_init()
        self.shout_t = shout_new()
        self.shout_metadata_t = shout_metadata_new()

    def open(self):
        i = shout_open(self.shout_t)
        if i != 0:
            raise Exception(self.get_errno(), self.get_error())

    def send(self, data):
        i = shout_send(self.shout_t, data, len(data))
        if i != 0:
            raise Exception(self.get_errno(), self.get_error())

    def send_raw(self, data):
        i = shout_send_raw(self.shout_t, data, len(data))
        if i != 0:
            raise Exception(self.get_errno(), self.get_error())

    def queuelen(self):
        i = shout_queuelen(self.shout_t)
        if i != 0:
            raise Exception(self.get_errno(), self.get_error())

    def sync(self):
        shout_sync(self.shout_t)

    def delay(self):
        i = shout_delay(self.shout_t)
        if i != 0:
            raise Exception(self.get_errno(), self.get_error())

    def close(self):
        i = shout_close(self.shout_t)
        if i != 0:
            raise Exception(self.get_errno(), self.get_error())

    def get_error(self):
        return shout_get_error(self.shout_t)

    def get_errno(self):
        return shout_get_errno(self.shout_t)

    def __del(self):
        self.close()

    property host:
        "A doc string can go here."

        def __get__(self):
            "Defaults to localhost"
            return shout_get_host(self.shout_t)

        def __set__(self, host):
            host = str(host)
            i = shout_set_host(self.shout_t, host)
            if i != 0:
                raise Exception(i, 'Host is not correct')

    property port:
        "A doc string can go here."

        def __get__(self):
            "Defaults to 8000"
            return shout_get_port(self.shout_t)

        def __set__(self, port):
            port = int(port)
            i = shout_set_port(self.shout_t, port)
            if i != 0:
                raise Exception(i, 'Port is not correct')

    property user:
        "A doc string can go here."

        def __get__(self):
            return shout_get_user(self.shout_t)

        def __set__(self, user):
            user = str(user)
            i = shout_set_user(self.shout_t, user)
            if i != 0:
                raise Exception(i, 'User is not correct')

    property password:
        "A doc string can go here."

        def __get__(self):
            "Defaults to 8000"
            return shout_get_password(self.shout_t)

        def __set__(self, password):
            password = str(password)
            i = shout_set_password(self.shout_t, password)
            if i != 0:
                raise Exception(i, 'password is not correct')

    property mount:
        "A doc string can go here."

        def __get__(self):
            "Defaults to 8000"
            return shout_get_mount(self.shout_t)

        def __set__(self, mount):
            mount = str(mount)
            i = shout_set_mount(self.shout_t, mount)
            if i != 0:
                raise Exception(i, 'mount is not correct')

    property name:
        "A doc string can go here."

        def __get__(self):
            return shout_get_name(self.shout_t)

        def __set__(self, name):
            name = str(name)
            i = shout_set_name(self.shout_t, name)
            if i != 0:
                raise Exception(i, 'name is not correct')

    property url:
        "A doc string can go here."

        def __get__(self):
            return shout_get_url(self.shout_t)

        def __set__(self, url):
            url = str(url)
            i = shout_set_url(self.shout_t, url)
            if i != 0:
                raise Exception(i, 'url is not correct')

    property genre:
        "A doc string can go here."

        def __get__(self):
            return shout_get_genre(self.shout_t)

        def __set__(self, genre):
            genre = str(genre)
            i = shout_set_genre(self.shout_t, genre)
            if i != 0:
                raise Exception(i, 'genre is not correct')

    property agent:
        "A doc string can go here."

        def __get__(self):
            return shout_get_agent(self.shout_t)

        def __set__(self, agent):
            agent = str(agent)
            i = shout_set_agent(self.shout_t, agent)
            if i != 0:
                raise Exception(i, 'Agent is not correct')

    property description:
        "A doc string can go here."

        def __get__(self):
            return shout_get_agent(self.shout_t)

        def __set__(self, description):
            description = str(description)
            i = shout_set_description(self.shout_t, description)
            if i != 0:
                raise Exception(i, 'Description is not correct')

    property dumpfile:
        "A doc string can go here."

        def __get__(self):
            return shout_get_dumpfile(self.shout_t)

        def __set__(self, dumpfile):
            dumpfile = str(dumpfile)
            i = shout_set_dumpfile(self.shout_t, dumpfile)
            if i != 0:
                raise Exception(i, 'Dumpfile is not correct')

    property audio_info:
        "A doc string can go here."

        def __get__(self):
            return self.__audio_info

        def __set__(self, dict):
            #get the current module
            pylibshout = globals()['pylibshout']

            for key, value in dict.items():
                const = 'SHOUT_AI_%s' % key.upper()
                if hasattr(pylibshout, const):
                    value = str(value)
                    i = shout_set_audio_info(self.shout_t, key, value)
                    self.__audio_info[key] = value
                else:
                    raise Exception('%s is not a valid audio_info attribute' % key)

            if i != 0:
                raise Exception(i, 'Audio info is not correct')

    property metadata:
        "A doc string can go here."

        def __get__(self):
            return self.__metadata

        def __set__(self, dict):
            for key, value in dict.items():
                value = str(value)
                shout_metadata_add(self.shout_metadata_t, key, value)
                self.__metadata[key] = value

            i = shout_set_metadata(self.shout_t, self.shout_metadata_t)

            i = 0
            if i != 0:
                raise Exception(i, 'Metadata is not correct')
   
    property public:
        "A doc string can go here."

        def __get__(self):
            return shout_get_public(self.shout_t)

        def __set__(self, public):
            public = bool(public)
            i = shout_set_dumpfile(self.shout_t, public)
            if i != 0:
                raise Exception(i, 'Public is not correct')

    property format:
        "A doc string can go here."

        def __get__(self):
            return shout_get_format(self.shout_t)

        def __set__(self, format):
            format = int(format)
            i = shout_set_format(self.shout_t, format)
            if i != 0:
                raise Exception(i, 'Format is not correct')

    property protocol:
        "A doc string can go here."

        def __get__(self):
            return shout_get_protocol(self.shout_t)

        def __set__(self, protocol):
            protocol = int(protocol)
            i = shout_set_protocol(self.shout_t, protocol)
            if i != 0:
                raise Exception(i, 'Protocol is not correct')

    property nonblocking:
        "A doc string can go here."

        def __get__(self):
            return shout_get_nonblocking(self.shout_t)

        def __set__(self, nonblocking):
            nonblocking = int(nonblocking)
            i = shout_set_nonblocking(self.shout_t, nonblocking)
            if i != 0:
                raise Exception(i, 'Nonblocking is not correct')
