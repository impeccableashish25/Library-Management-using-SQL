-- Solving some common Business problem questions 

-- 1) Display some most borrowed books

SELECT
  b.id,
  b.title,
  b.author,
  COUNT(br.id) AS borrow_count
FROM books b
LEFT JOIN borrowings br ON b.id = br.book_id
GROUP BY b.id, b.title, b.author
ORDER BY borrow_count DESC, b.title
LIMIT 5;


-----------------------------------------------------------

-- 2) List the members with overdue books (borrowed > 30 days and not returned)
SELECT
  m.id,
  m.name,
  br.book_id,
  b.title,
  br.borrow_date
FROM members m
JOIN borrowings br ON m.id = br.member_id
JOIN books b ON br.book_id = b.id
WHERE br.return_date IS NULL
  AND br.borrow_date < (CURRENT_DATE - INTERVAL 30 DAY )
ORDER BY br.borrow_date;

------------------------------------------------------------------------------

-- 3) Display Category wise which book is most popular
WITH book_counts AS (
  SELECT
    b.id,
    b.title,
    b.category,
    COUNT(br.id) AS borrow_count
  FROM books b
  LEFT JOIN borrowings br ON b.id = br.book_id
  GROUP BY b.id, b.title, b.category
),
category_max AS (
  SELECT
    category,
    MAX(borrow_count) AS max_count
  FROM book_counts
  GROUP BY category
)
SELECT
  bc.category,
  bc.id   AS book_id,
  bc.title,
  bc.borrow_count
FROM book_counts bc
JOIN category_max cm
  ON bc.category = cm.category
 AND bc.borrow_count = cm.max_count
ORDER BY bc.category;


--------------------------------------------------------------------
-- 4) Members who borrowed more than 1 book in the same month . 

WITH member_month_counts AS (
  SELECT
    br.member_id,
    DATE_FORMAT(br.borrow_date, '%Y-%m-01') AS month_start,
    COUNT(br.id) AS books_borrowed
  FROM borrowings br
  GROUP BY br.member_id, DATE_FORMAT(br.borrow_date, '%Y-%m-01')
)

SELECT
  mm.member_id,
  m.name,
  mm.month_start,
  mm.books_borrowed
FROM member_month_counts mm
JOIN members m ON mm.member_id = m.id
WHERE mm.books_borrowed > 1
ORDER BY mm.member_id, mm.month_start;

------------------------------------------------------------------------------------

-- 5) Display how many books were borrowed each month 

SELECT 
    YEAR(borrow_date) AS year,
    MONTH(borrow_date) AS month,
    COUNT(*) AS total_books_borrowed
FROM borrowings
GROUP BY YEAR(borrow_date), MONTH(borrow_date)
ORDER BY year, month;


-- 6) Display top 5 most active members 

SELECT 
    m.id,
    m.name,
    COUNT(b.id) AS total_books_borrowed
FROM members m
JOIN borrowings b 
ON m.id = b.member_id
GROUP BY m.id, m.name
ORDER BY total_books_borrowed DESC
LIMIT 5;


-- 7) Average Book Borrow Duration

SELECT 
    AVG(DATEDIFF(return_date, borrow_date)) AS avg_borrow_duration_days
FROM borrowings
WHERE return_date IS NOT NULL;


-- 8) Which category book had the most popularity ?

SELECT 
    b.category,
    COUNT(br.id) AS total_borrowings
FROM books b
JOIN borrowings br 
ON b.id = br.book_id
GROUP BY b.category
ORDER BY total_borrowings DESC;


-- 9) List all the currently borrowed books (which have not been returned yet)

SELECT 
    m.name,
    b.title,
    br.borrow_date
FROM borrowings br
JOIN members m 
ON br.member_id = m.id
JOIN books b 
ON br.book_id = b.id
WHERE br.return_date IS NULL;


-- 10) Display top 5 most popular authors

SELECT 
    b.author,
    COUNT(br.id) AS total_borrowings
FROM books b
JOIN borrowings br 
ON b.id = br.id
GROUP BY b.author
ORDER BY total_borrowings DESC
LIMIT 5;


-- 11) Book return Analysis

SELECT 
    COUNT(*) AS total_borrowed,
    SUM(CASE WHEN return_date IS NOT NULL THEN 1 ELSE 0 END) AS total_returned,
    ROUND(
        (SUM(CASE WHEN return_date IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*)) * 100,
        2
    ) AS return_rate_percentage
FROM borrowings;


-- 12) Books which never been borrowed

SELECT 
    b.id,
    b.title
FROM books b
LEFT JOIN borrowings br
ON b.id = br.book_id
WHERE br.book_id IS NULL;

