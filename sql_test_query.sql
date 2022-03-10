create database amazon_test;

/* importing the data and preparing the data*/

CREATE TABLE film (
    id INT,
    title VARCHAR(255),
    release_year YEAR,
    country VARCHAR(255),
    duration INT,
    language VARCHAR(255),
    certification VARCHAR(255),
    gross INT,
    budget INT
);

select * from film;

CREATE TABLE people (
    id INT,
    name_ VARCHAR(255),
    birthdate VARCHAR(250),
    deathdate VARCHAR(50)
);
alter table people modify column birthdate date;
alter table people modify column deathdate date;
select * from people;


CREATE TABLE role (
    id INT,
    film_id INT,
    people_id INT,
    role VARCHAR(255)
);
select * from role;

CREATE TABLE review (
    id INT,
    name VARCHAR(255),
    birthdate VARCHAR(50),
    deathdate VARCHAR(50),
    imdb_score VARCHAR(50),
    num_votes INT,
    facebook_likes INT
);
select * from review;

alter table review modify column imdb_score real;
alter table review modify column birthdate date;
alter table review modify column deathdate date;

/* performing the joins*/

select f.id,f.title,f.release_year, f.country, f.duration, f.language, f.gross, f.budget,
       p.id, p.name_, p.birthdate, p.deathdate,
       r.id, r.role,
       v.id, v.name, v.birthdate, v.deathdate, v.imdb_score
from film f
INNER JOIN people p ON f.id = p.id
INNER JOIN role r ON r.id = p.id
INNER JOIN review v ON v.id = r.id;
---------------------------------------------

create table film_data
as
select f.id,f.title,f.release_year, f.country, f.duration, f.language, f.gross, f.budget,
       p.name_, p.birthdate, p.deathdate,
       r.role,
       v.imdb_score
from film f
INNER JOIN people p ON f.id = p.id
INNER JOIN role r ON r.id = p.id
INNER JOIN review v ON v.id = r.id;

select * from film_data;

/*
Display name, film title, language, release year, imdb score(rating) of
 all the actors who have acted in English films released between 1940 and 1960 (both included)
 with imdb rating higher than 5.*/

select name_, title, language, release_year, imdb_score from film_data where role = "actor" and language = "english" and release_year between '1940' and '1960';

/*
Display the film title, director name and imdb rating of the "alive" directors who have 
directed films in USA and are more than 50 years with imdb rating more than 6.
*/

select title, name_, imdb_score, role, round (datediff(now(),birthdate)/365,0) age 
from film_data 
where (country = 'USA' and imdb_score > 6 and role = 'director') and round (datediff(now(),birthdate)/365,0) > 50;

/*
Display name, language, & name of director of top 3 films as per imdb rating in each year */

select name_, language, role, title, imdb_score, release_year from film_data where role = 'director' order by release_year desc, imdb_score desc;

/*
Find the films with duration greater than the average duration of films
 released in that particular year for all years between 1940 to 1960 (both included).*/
 
Select title, duration, release_year from film_data where (duration > (SELECT AVG(duration) FROM film_data)) and (release_year between '1940' and '1960');

/*
Find the difference between the average imdb rating of movies released before 1950 and the average rating of movies released after 1950.
*/

select title,
(select round(avg(imdb_score),2) from film_data where release_year < 1950) AS before_1950,
(select round(avg(imdb_score),2) from film_data where release_year > 1950) AS after_1950,
((select round(avg(imdb_score),2) from film_data where release_year < 1950) - 
(select round(avg(imdb_score),2) from film_data where release_year > 1950)) AS avg_diff
from film_data;


/*Display the initials (first letter of first name and last name), full name, film title, release year of film 
for the people who were a part of the English films whose revenue (gross) was greater than the budget.*/

select * from film_data;

select name_, 
concat(left(substring_index(name_, ' ', 1),1), 
left(substring_index(name_, ' ', -1),1)) initials, 
title, 
release_year, 
language, 
gross, 
budget 
from film_data 
where language = 'english' and (gross > budget);



