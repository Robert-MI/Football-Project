USE mydb;

-- QUERIES

SELECT 
    *
FROM
    AssociationOfficePhone;

SELECT 
    *
FROM
    Players
WHERE
    age = 25;
    
-- Get all the players that don't have a national team

SELECT 
    *
FROM
    Players p
WHERE
    p.nationalTeam IS NULL;
    
-- Get all the players that have a club team and order them with their salaries

SELECT 
    *
FROM
    Players p
WHERE
    p.nationalTeam IS NOT NULL
ORDER BY salary ASC;

-- Get all the players who are from Barcelona

SELECT 
    *
FROM
    Players p,
    ClubTeam ct
WHERE
    p.clubTeam = ct.idClubTeam
        AND ct.name = 'Barcelona';
    
-- Get the list of all players who have more than 500000000 salary and order them by alphabetical order of their fullName. 

SELECT 
    CONCAT(firstName, ' ', lastName) AS fullName
FROM
    Players
WHERE
    salary > 500000000
ORDER BY fullName;

-- Get all the associations that have names that contains 'af' ..... 
-- will not write the begining or end since they will be repetitions

SELECT 
    *
FROM
    Association a
WHERE
    name LIKE '%af%';

-- Get the total sum of the trophies of the Club Teams

SELECT 
    SUM(trophies) totalSumOfTrophies
FROM
    ClubTeam
WHERE
    trophies IS NOT NULL;

-- Get all players who play in Real Madrid and have a score more than 90

SELECT 
    firstName, lastName, score
FROM
    Players p,
    ClubTeam ct
WHERE
    p.clubTeam = ct.idClubTeam
        AND ct.name = 'Real Madrid'
GROUP BY firstName , lastName , score
HAVING score > 90;

-- Get the names of all players who are playing in Barcelona and have more salary than all the players in Real Madrid

SELECT 
    CONCAT(p.firstName, ' ', p.lastName) AS fullName
FROM
    Players p,
    ClubTeam ct
WHERE
    p.clubTeam = ct.idClubTeam
        AND ct.name = 'Barcelona'
        AND salary > ALL (SELECT 
            salary
        FROM
            Players p,
            ClubTeam ct
        WHERE
            p.clubTeam = ct.idClubTeam
                AND ct.name = 'Real Madrid');

-- Get all the players that dont play in the Armenian national Team fancy way 

SELECT 
    *
FROM
    Players p
WHERE
    p.nationalTeam IS NULL
        OR p.nationalTeam NOT IN (SELECT 
            nationalTeam
        FROM
            Players p,
            Countries c
        WHERE
            p.nationalTeam = c.idCountries
                AND c.name = 'Armenia');
    
-- Get the stadium owner names who belong to a club team that has more rating than 75 and 
-- that club team belongs to a country with population more than 3 million
    
SELECT 
    s.owner
FROM
    ClubTeam ct,
    Countries c,
    Stadium s
WHERE
    ct.stadium = s.idStadium
        AND ct.rating > 75
        AND ct.country = c.idCountries
        AND c.population > 3000000;
    
-- Get all the countries that have national Teams

SELECT DISTINCT
    name
FROM
    Countries
        NATURAL JOIN
    NationalTeam;

-- VIews

CREATE VIEW playersView AS
    SELECT 
        idPlayers, firstName, score
    FROM
        Players;

SELECT 
    firstName
FROM
    playersView
WHERE
    score = 100;

CREATE VIEW playersTotalSalary AS
    SELECT 
        clubTeam, SUM(salary) totalSalary
    FROM
        Players p,
        ClubTeam ct
    GROUP BY clubTeam;

SELECT 
    *
FROM
    playersTotalSalary
ORDER BY totalSalary;

drop view playersTotalSalaryInRealMadrid;

CREATE VIEW playersTotalSalaryInRealMadrid AS
    SELECT 
        clubTeam, name, SUM(salary) totalSalary
    FROM
        Players p,
        ClubTeam ct
    WHERE
        p.clubTeam = ct.idClubTeam
            AND ct.name = 'Real Madrid'
    GROUP BY clubTeam;

SELECT 
    *
FROM
    playersTotalSalaryInRealMadrid;
    
-- Function
-- Gets age and gets the date of birth by subtracting from currant date

drop function getyear;

delimiter //
create function getyear(age int)
returns INT deterministic
begin
	return year(curdate()) - age;
end//

delimiter ;


SELECT GETYEAR(22);

