CREATE DATABASE IF NOT EXISTS mscartoes_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS msclientes_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE USER IF NOT EXISTS 'msuser'@'%' IDENTIFIED BY 'mspassword';
GRANT ALL PRIVILEGES ON mscartoes_db.* TO 'msuser'@'%';
GRANT ALL PRIVILEGES ON msclientes_db.* TO 'msuser'@'%';
FLUSH PRIVILEGES;
