<?php

##############################################################################
# Required configuration
# You *have* to review these settings for Baïkal to run properly
#
# Timezone of your users, if unsure, check http://en.wikipedia.org/wiki/List_of_tz_database_time_zones
define("PROJECT_TIMEZONE", "Europe/Paris");

# CardDAV ON/OFF switch; default TRUE
define("BAIKAL_CARD_ENABLED", true);

# CalDAV ON/OFF switch; default TRUE
define("BAIKAL_CAL_ENABLED", true);

# CalDAV invite From: mail address (comment or leave blank to disable notifications)
define("BAIKAL_INVITE_FROM", $_ENV['EMAIL']);

# WebDAV authentication type; default Digest
define("BAIKAL_DAV_AUTH_TYPE", "Digest");

# Baïkal Web admin password hash; Set via Baïkal Web Admin
define("BAIKAL_ADMIN_PASSWORDHASH", md5('admin:'.$_ENV['BAIKAL_AUTH_REALM'].':'.$_ENV['BAIKAL_ADMIN_PASSWORD']));
