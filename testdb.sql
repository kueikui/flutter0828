-- 创建数据库
CREATE DATABASE IF NOT EXISTS testdb;

-- 使用创建的数据库
USE testdb;

-- 创建表
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    gender INT,
    phone VARCHAR(10),
    email  VARCHAR(100),
    password VARCHAR(100)
);
drop table  IF EXISTS users;

-- 插入一些测试数据
INSERT INTO users (name, age,gender,phone,email) VALUES ('Alice', 30,1,09123,'alice@gmail.com');
INSERT INTO users (name, age,gender,phone,email) VALUES ('Bob', 25,2,09456,'bob@gmail.com');
INSERT INTO users (name, age,gender,phone,email) VALUES ('Charlie', 35,1,09789,'charlie@gmail.com');
INSERT INTO users (name, age, gender, phone, email, password) VALUES ('David', 28, 1, '0923456789', 'david@gmail.com', 'password4');
INSERT INTO users (name, age, gender, phone, email, password) VALUES ('Eve', 22, 2, '0956789123', 'eve@gmail.com', 'password5');

SELECT * FROM testdb.users;
SHOW GRANTS FOR 'root'@'localhost';
table users;
