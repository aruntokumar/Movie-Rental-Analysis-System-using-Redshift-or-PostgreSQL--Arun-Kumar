-- Movie Rental Analysis System (using Redshift or PostgreSQL)--

CREATE DATABASE Movierentel_DB

\C Movierentel_DB

-- MOVIE RENTEL TABLE --

CREATE TABLE rental_data (
    MOVIE_ID INT,
    CUSTOMER_ID INT,
    GENRE VARCHAR(50),
    RENTAL_DATE DATE,
    RETURN_DATE DATE,
    RENTAL_FEE NUMERIC(6, 2)
);

INSERT INTO rental_data (MOVIE_ID, CUSTOMER_ID, GENRE, RENTAL_DATE, RETURN_DATE, RENTAL_FEE) VALUES
(1001, 1, 'Action', '2025-02-01', '2025-02-03', 4.99),
(1002, 2, 'Drama', '2025-02-05', '2025-02-06', 3.99),
(1003, 1, 'Comedy', '2025-03-01', '2025-03-02', 2.99),
(1004, 3, 'Action', '2025-03-10', '2025-03-12', 4.99),
(1005, 2, 'Drama', '2025-03-15', '2025-03-17', 3.99),
(1006, 4, 'Sci-Fi', '2025-04-01', '2025-04-03', 5.49),
(1007, 3, 'Comedy', '2025-04-05', '2025-04-06', 2.99),
(1008, 5, 'Action', '2025-04-10', '2025-04-11', 4.99),
(1009, 4, 'Drama', '2025-04-15', '2025-04-17', 3.99),
(1100, 5, 'Horror', '2025-04-20', '2025-04-22', 4.49),
(1110, 1, 'Action', '2025-05-01', '2025-05-02', 4.99),
(1120, 2, 'Comedy', '2025-05-05', '2025-05-06', 2.99),
(1130, 5, 'Drama', '2025-05-10', '2025-05-12', 3.99),
(1140, 3, 'Horror', '2025-05-12', '2025-05-13', 4.49),
(1150, 1, 'Action', '2025-05-15', '2025-05-16', 4.99);

SELECT * FROM RENTAL_DATA

-- Drill Down: Analyze rentals from genre to individual movie level --

SELECT GENRE, MOVIE_ID, COUNT(*) AS RENTAL_COUNT, SUM(RENTAL_FEE) AS TOTAL_FEES
FROM rental_data
GROUP BY GENRE, MOVIE_ID
ORDER BY GENRE, MOVIE_ID;

-- Rollup: Summarize total rental fees by genre and then overall --

SELECT 
    COALESCE(GENRE, 'TOTAL') AS GENRE,
    SUM(RENTAL_FEE) AS TOTAL_RENTAL_FEES
FROM rental_data
GROUP BY ROLLUP(GENRE);

-- Cube: Analyze total rental fees across combinations of genre, rental date, and 
customer --

SELECT 
    COALESCE(GENRE, 'ALL') AS GENRE,
    COALESCE(RENTAL_DATE::TEXT, 'ALL') AS RENTAL_DATE,
    COALESCE(CAST(CUSTOMER_ID AS TEXT), 'ALL') AS CUSTOMER_ID,
    SUM(RENTAL_FEE) AS TOTAL_RENTAL_FEES
FROM rental_data
GROUP BY CUBE(GENRE, RENTAL_DATE, CUSTOMER_ID)
ORDER BY GENRE, RENTAL_DATE, CUSTOMER_ID;

-- Slice: Extract rentals only from the ‘Action’ genre --

SELECT *
FROM rental_data
WHERE GENRE = 'Action';

-- Dice: Extract rentals where GENRE = 'Action' or 'Drama' and RENTAL_DATE is in 
the last 3 months --

SELECT *
FROM rental_data
WHERE GENRE IN ('Action', 'Drama')
  AND RENTAL_DATE >= CURRENT_DATE - INTERVAL '3 months';
