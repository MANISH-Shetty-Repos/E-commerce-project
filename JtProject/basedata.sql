# SQL configs
SET SQL_MODE ='IGNORE_SPACE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

# create database and use it
CREATE DATABASE IF NOT EXISTS ecommjava;
USE ecommjava;

# create the category table
CREATE TABLE IF NOT EXISTS CATEGORY(
category_id int unique key not null auto_increment primary key,
name        varchar(255) null
);

# create the customer table
CREATE TABLE IF NOT EXISTS CUSTOMER(
id       int unique key not null auto_increment primary key,
address  varchar(255) null,
email    varchar(255) null,
password varchar(255) null,
role     varchar(255) null,
username varchar(255) null,
UNIQUE (username)
);

# create the product table
CREATE TABLE IF NOT EXISTS PRODUCT(
product_id  int unique key not null auto_increment primary key,
description varchar(255) null,
image       varchar(255) null,
name        varchar(255) null,
price       int null,
quantity    int null,
weight      int null,
category_id int null,
customer_id int null
);

# create indexes
CREATE INDEX FK7u438kvwr308xcwr4wbx36uiw
    ON PRODUCT (category_id);

CREATE INDEX FKt23apo8r9s2hse1dkt95ig0w5
    ON PRODUCT (customer_id);