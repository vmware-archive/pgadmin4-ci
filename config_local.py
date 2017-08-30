from config import *

DEBUG = True

# Enable the test module
MODULE_BLACKLIST.remove('test')
# Log
CONSOLE_LOG_LEVEL = DEBUG
FILE_LOG_LEVEL = DEBUG

DEFAULT_SERVER = '127.0.0.1'

UPGRADE_CHECK_ENABLED = False

SERVER_MODE = False
if IS_WIN:
    # Use the short path on windows
    DATA_DIR = os.path.realpath(
        os.path.join(fs_short_path(env('APPDATA')), u"pgAdmin")
    )
else:
    if SERVER_MODE:
        DATA_DIR = '/var/lib/pgadmin'
    else:
        DATA_DIR = os.path.realpath(os.path.expanduser(u'~/.pgadmin/'))

# Use a different config DB for each server mode.
if SERVER_MODE == False:
    SQLITE_PATH = os.path.join(
        DATA_DIR,
        'pgadmin4-desktop.db'
    )
else:
    SQLITE_PATH = os.path.join(
        DATA_DIR,
        'pgadmin4-server.db'
    )
if SERVER_MODE and not IS_WIN:
    LOG_FILE = '/var/log/pgadmin/pgadmin4.log'
else:
    LOG_FILE = os.path.join(DATA_DIR, 'pgadmin4.log')

SESSION_DB_PATH = os.path.join(DATA_DIR, 'sessions')
STORAGE_DIR = os.path.join(DATA_DIR, 'storage')
TEST_SQLITE_PATH = os.path.join(DATA_DIR, 'test_pgadmin4.db')


