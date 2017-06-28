from config import *

DEBUG = True

# Enable the test module
MODULE_BLACKLIST.remove('test')
# Log
CONSOLE_LOG_LEVEL = INFO
FILE_LOG_LEVEL = DEBUG

DEFAULT_SERVER = '127.0.0.1'

UPGRADE_CHECK_ENABLED = True

SERVER_MODE = False
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
