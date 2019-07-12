<?php

##############################################################################
# Required configuration
# You *have* to review these settings for Baïkal to run properly
#
# Timezone of your users, if unsure, check http://en.wikipedia.org/wiki/List_of_tz_database_time_zones
define("PROJECT_TIMEZONE", "Europe/Paris");

# CardDAV ON/OFF switch; default TRUE
define("BAIKAL_CARD_ENABLED", TRUE);

# CalDAV ON/OFF switch; default TRUE
define("BAIKAL_CAL_ENABLED", TRUE);

# WebDAV authentication type; default Digest
define("BAIKAL_DAV_AUTH_TYPE", "Digest");

# Baïkal Web admin password hash; Set via Baïkal Web Admin
define("BAIKAL_ADMIN_PASSWORDHASH", '5fe794627e1f841f8debba065e2c807a'); // test
