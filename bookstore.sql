CREATE DATABASE bookstore_db;

USE bookstore_db;

-- 1. country
CREATE TABLE country (
    country_id INT AUTO_INCREMENT PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL UNIQUE
);
INSERT INTO country (country_name) VALUES ('Kenya'), ('USA'), ('UK');

-- 2. address
CREATE TABLE address (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    street VARCHAR(255),
    city VARCHAR(100),
    postal_code VARCHAR(20),
    country_id INT,
    FOREIGN KEY (country_id) REFERENCES country(country_id)
);
INSERT INTO address (street, city, postal_code, country_id) VALUES
('123 River Rd', 'Nairobi', '00100', 1),
('456 Oak St', 'New York', '16601', 2),
('456 Oak St', 'Kisumu', '40100', 1), -- Corrected postal code and country
('456 Oak St', 'Mombasa', '80100', 1); -- Corrected postal code and country

-- 3. address_status
CREATE TABLE address_status (
    status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(50) NOT NULL UNIQUE
);
INSERT INTO address_status (status_name) VALUES ('current'), ('old');

-- 4. customer
CREATE TABLE customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(150) UNIQUE,
    phone_number VARCHAR(20)
);
INSERT INTO customer (first_name, last_name, email, phone_number) VALUES
('Monica', 'Doe', 'monica@gmail.com', '+254700000001'),
('Muusi', 'Nzyoka', 'nzyoka@gmail.com', '+254700000002'),
('Wiltord', 'Ichingwa', 'wiltord@gmail.com', '+254700000003');

-- 5. customer_address
CREATE TABLE customer_address (
    customer_id INT,
    address_id INT,
    status_id INT,
    PRIMARY KEY (customer_id, address_id),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (address_id) REFERENCES address(address_id),
    FOREIGN KEY (status_id) REFERENCES address_status(status_id)
);
INSERT INTO customer_address VALUES (1, 1, 1), (2, 2, 1);

-- 6. publisher
CREATE TABLE publisher (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    publisher_name VARCHAR(150) NOT NULL
);
INSERT INTO publisher (publisher_name) VALUES ('Penguin Books'), ('Macmillan');

-- 7. book_language
CREATE TABLE book_language (
    language_id INT AUTO_INCREMENT PRIMARY KEY,
    language_name VARCHAR(100) NOT NULL UNIQUE
);
INSERT INTO book_language (language_name) VALUES ('English'), ('Swahili');

-- 8. book
CREATE TABLE book (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255),
    isbn VARCHAR(20) UNIQUE,
    price DECIMAL(8, 2),
    stock INT,
    publication_year YEAR,
    publisher_id INT,
    language_id INT,
    FOREIGN KEY (publisher_id) REFERENCES publisher(publisher_id),
    FOREIGN KEY (language_id) REFERENCES book_language(language_id)
);
INSERT INTO book (title, isbn, price, stock, publication_year, publisher_id, language_id) VALUES
('The River and the Source', '9781234567890', 1250.00, 10, 2000, 1, 1),
('Things Fall Apart', '9789876543210', 1450.00, 5, 1958, 2, 1);

-- 9. author
CREATE TABLE author (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100)
);
INSERT INTO author (first_name, last_name) VALUES ('Grace', 'Ogot'), ('Chinua', 'Achebe');

-- 10. book_author
CREATE TABLE book_author (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id),
    FOREIGN KEY (author_id) REFERENCES author(author_id)
);
INSERT INTO book_author VALUES (1, 1), (2, 2);

-- 11. shipping_method
CREATE TABLE shipping_method (
    method_id INT AUTO_INCREMENT PRIMARY KEY,
    method_name VARCHAR(100),
    cost DECIMAL(6,2)
);
INSERT INTO shipping_method (method_name, cost) VALUES ('Standard', 150.00), ('Express', 1000.00);

-- 12. order_status
CREATE TABLE order_status (
    status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(50) NOT NULL UNIQUE
);
INSERT INTO order_status (status_name) VALUES ('pending'), ('shipped'), ('delivered');

-- 13. customer_order
CREATE TABLE customer_order (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    shipping_method_id INT,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (shipping_method_id) REFERENCES shipping_method(method_id)
);
INSERT INTO customer_order (customer_id, shipping_method_id) VALUES (1, 1), (2, 2);

-- 14. order_line
CREATE TABLE order_line (
    order_id INT,
    book_id INT,
    quantity INT,
    price DECIMAL(8,2),
    total_price DECIMAL(10,2),
    PRIMARY KEY (order_id, book_id),
    FOREIGN KEY (order_id) REFERENCES customer_order(order_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id)
);
INSERT INTO order_line (order_id, book_id, quantity, price, total_price) 
VALUES (1, 1, 2, 1250.00, 2500.00), (2, 2, 1, 1450.00, 1450.00);

-- 15. order_history
CREATE TABLE order_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    status_id INT,
    changed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES customer_order(order_id),
    FOREIGN KEY (status_id) REFERENCES order_status(status_id)
);
INSERT INTO order_history (order_id, status_id) VALUES (1, 1), (1, 3), (2, 1);

-- Admin
CREATE USER 'Monica'@'%' IDENTIFIED BY 'admin@123';
GRANT ALL PRIVILEGES ON bookstore_db.* TO 'Monica'@'%';

-- Employee
CREATE USER 'Wiltord'@'%' IDENTIFIED BY 'employee@123';
GRANT SELECT ON bookstore_db.* TO 'Wiltord'@'%';

-- Developer
CREATE USER 'Nzyoka'@'%' IDENTIFIED BY 'dev@123';
GRANT SELECT, INSERT, UPDATE, DELETE ON bookstore_db.* TO 'Nzyoka'@'%';

-- Apply privileges
FLUSH PRIVILEGES;
