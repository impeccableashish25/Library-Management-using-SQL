create database librarydataanalysis;

use librarydataanalysis;

-- Drop existing tables if they exist 
DROP TABLE IF EXISTS borrowings;
DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS members;


-- Creating table named books
create table books (
id SERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  author TEXT NOT NULL,
  category TEXT NOT NULL
);

-- Creating table named members
CREATE TABLE members (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  join_date DATE NOT NULL
);

-- Creating table named borrowings
CREATE TABLE borrowings (
  id SERIAL PRIMARY KEY,
  book_id INT REFERENCES books(id),
  member_id INT REFERENCES members(id),
  borrow_date DATE NOT NULL,
  return_date DATE
);


-- Inserting some sample books
INSERT INTO books (title, author, category) VALUES
('The Hobbit', 'J.R.R. Tolkien', 'Fantasy'),
('The Fellowship of the Ring', 'J.R.R. Tolkien', 'Fantasy'),
('The Two Towers', 'J.R.R. Tolkien', 'Fantasy'),
('The Return of the King', 'J.R.R. Tolkien', 'Fantasy'),
('To Kill a Mockingbird', 'Harper Lee', 'Fiction'),
('1984', 'George Orwell', 'Fiction'),
('Pride and Prejudice', 'Jane Austen', 'Romance'),
('The Great Gatsby', 'F. Scott Fitzgerald', 'Fiction'),
('Clean Code', 'Robert C. Martin', 'Programming'),
('Design Patterns', 'Erich Gamma', 'Programming'),
("Man Search for Meaning","Viktor Frankl","Psychology"),
("Wolf Worm", 'T. Kingfisher', "Horror"),
("Japanese Gothic", "Kylie Lee Baker", "Horror"),
("Not Quite Dead Yet", "Holly Jackson", "Crime Thriller"),
("The Tenant", "Freida McFadden", "Crime Thriller"),
("Beautiful Ugly", "Alice Feeney", "Crime Thriller");

-- View the books table
SELECT * FROM books;


-- Insert sample members
INSERT INTO members (`name`, join_date) VALUES
('Katherine', '2024-05-03'),
('Luis', '2023-09-27'), 
('Oliver', '2024-07-12'),
('Maya', '2023-04-16'),
('Ranvijay', '2024-05-16'),
('Charlie', '2024-03-05'),
('Diana', '2024-03-20'),
('Ethan', '2024-04-01'),
('Navpreet', '2024-09-08'),
('Hiren', '2023-01-19'),
('Ashish', '2024-06-25');


-- Show whether the members table has been populated with data
SELECT * FROM members;

-- Insert borrowings (some returned, some overdue)
INSERT INTO borrowings (book_id, member_id, borrow_date, return_date) VALUES
(1, 1, '2025-01-01', '2025-01-20'),
(14, 9, '2025-01-14',NULL),    -- overdue if > 30 days
(2, 2, '2025-02-01', NULL),          
(5, 2, '2025-01-15', '2025-01-25'),
(16, 2, '2025-02-20', NULL),          -- overdue
(4, 8, '2025-02-18', '2025-02-23'),
(6, 3, '2025-02-10', '2025-02-20'),
(10, 3, '2025-03-01', NULL),         -- recently borrowed
(7, 9, '2025-03-03', NULL),
(11, 4, '2025-02-05', '2025-02-28'),
(15, 5, '2025-02-07', '2025-02-12'),
(9, 4, '2025-03-10', NULL),
(12, 5, '2025-03-01', NULL),          -- still with member
(13, 5, '2025-03-05', NULL);         -- still with member

-- View our borrow table along with complete details
SELECT * FROM borrowings;

DROP TABLE borrowings;
