CREATE DATABASE IF NOT EXISTS `standardfile`;
CREATE USER 'standardfile'@'%' IDENTIFIED BY 'test';
GRANT ALL ON `standardfile`.* TO 'standardfile'@'%';

CREATE DATABASE IF NOT EXISTS `passbolt`;
CREATE USER 'passbolt'@'%' IDENTIFIED BY 'test';
GRANT ALL ON `passbolt`.* TO 'passbolt'@'%';