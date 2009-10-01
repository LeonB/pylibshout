cdef extern from "shout/shout.h":
    #types
    ctypedef struct shout_t

    #methods
    void shout_init()
    shout_t *shout_new()
    int shout_open(shout_t *self)

    #properties:
    int shout_set_host(shout_t *self, char *host)
    char *shout_get_host(shout_t *self)

    int shout_set_port(shout_t *self, unsigned short port)
    unsigned short shout_get_port(shout_t *self)

    int shout_set_password(shout_t *, char *password)
    char *shout_get_password(shout_t *self)

    int shout_set_mount(shout_t *self, char *mount)
    char *shout_get_mount(shout_t *self)

cdef class Shout:
    cdef shout_t *shout_t

    def __init__(self):
        shout_init()
        self.shout_t = shout_new()

    def open(self):
        return shout_open(self.shout_t)

    def send(self):
        pass

    def sync(self):
        pass

    def close(self):
        pass

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