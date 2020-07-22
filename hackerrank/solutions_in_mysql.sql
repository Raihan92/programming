1. https://www.hackerrank.com/challenges/weather-observation-station-5/problem`
Solution:
SELECT CITY, LENGTH(CITY) FROM STATION ORDER BY LENGTH(CITY), CITY ASC LIMIT 1;
SELECT CITY, LENGTH(CITY) FROM STATION ORDER BY LENGTH(CITY) DESC LIMIT 1;

2. https://www.hackerrank.com/challenges/weather-observation-station-8/problem
Solution:
SELECT DISTINCT(CITY) FROM STATION 
WHERE UPPER(SUBSTR(CITY, 1, 1)) IN ('A','E','I','O','U')
AND UPPER(SUBSTR(CITY, LENGTH(CITY), 1)) IN ('A','E','I','O','U');

3. https://www.hackerrank.com/challenges/more-than-75-marks/problem
Solution:
SELECT NAME FROM STUDENTS
WHERE MARKS > 75
ORDER BY SUBSTR(NAME, LENGTH(NAME)-2, 3), ID ASC;

4. https://www.hackerrank.com/challenges/the-pads/problem
Solution:
SELECT CONCAT( NAME, CONCAT(CONCAT('(', SUBSTR(OCCUPATION, 1, 1)), ')')) 
FROM OCCUPATIONS
ORDER BY NAME ASC;

SELECT CONCAT('THERE ARE A TOTAL OF ', COUNT(OCCUPATION)), CONCAT(LOWER(OCCUPATION),'S.') 
FROM OCCUPATIONS 
GROUP BY OCCUPATION
ORDER BY COUNT(OCCUPATION), OCCUPATION ASC;

5. https://www.hackerrank.com/challenges/occupations/problem
Solution:
SET @r1=0, @r2=0, @r3 =0, @r4=0;
SELECT min(CASE WHEN occupation = 'doctor' THEN name END),
       min(CASE WHEN occupation = 'professor' THEN name END),
       min(CASE WHEN occupation = 'singer' THEN name END),
       min(CASE WHEN occupation = 'actor' THEN name END)
  FROM (SELECT name,
               occupation,
               CASE occupation
                  WHEN 'Doctor' THEN @r1 := @r1 + 1
                  WHEN 'Professor' THEN @r2 := @r2 + 1
                  WHEN 'Singer' THEN @r3 := @r3 + 1
                  WHEN 'Actor' THEN @r4 := @r4 + 1
               END
                  AS rn
          FROM OCCUPATIONS
        ORDER BY Name) AS t
GROUP BY rn;

6. https://www.hackerrank.com/challenges/binary-search-tree-1/problem
Solution:
SELECT BT.N,
    CASE
        WHEN BT.P IS NULL THEN 'Root'
        WHEN EXISTS (SELECT B.P FROM BST B WHERE B.P = BT.N) THEN 'Inner'        
        ELSE 'Leaf'
    END
FROM BST AS BT 
ORDER BY BT.N;

7. https://www.hackerrank.com/challenges/the-company/problem
Solution:
SELECT cc.company_code,
    cc.founder,
    COUNT(distinct lm.lead_manager_code),
    COUNT(distinct sm.senior_manager_code),
    COUNT(distinct mg.manager_code),
    COUNT(distinct em.employee_code)
FROM
    company cc
LEFT JOIN
    lead_manager lm
    ON (lm.company_code = cc.company_code)
LEFT JOIN 
    senior_manager sm
    ON (sm.lead_manager_code = lm.lead_manager_code)
LEFT JOIN 
    manager mg
    ON (mg.senior_manager_code = sm.senior_manager_code)
LEFT JOIN 
    employee em
    ON (em.manager_code = mg.manager_code)
GROUP BY
    cc.company_code, cc.founder
ORDER BY
    cc.company_code;

8. https://www.hackerrank.com/challenges/weather-observation-station-18/problem
Solution:
SELECT ROUND(MIN_DIFF_LAT_N + MIN_DIFF_LONG_W,4)
FROM (
    SELECT
        abs(min(LAT_N) - max(LAT_N)) as MIN_DIFF_LAT_N,
        abs(min(LONG_W) - max(LONG_W)) as MIN_DIFF_LONG_W
    from station
) ST;

9. https://www.hackerrank.com/challenges/weather-observation-station-19/problem
Solution:
SELECT ROUND(SQRT(MIN_DIFF_LAT_N*MIN_DIFF_LAT_N + MIN_DIFF_LONG_W*MIN_DIFF_LONG_W),4)
FROM (
    SELECT
        abs(min(LAT_N) - max(LAT_N)) as MIN_DIFF_LAT_N,
        abs(min(LONG_W) - max(LONG_W)) as MIN_DIFF_LONG_W
    from station
) ST;

10. https://www.hackerrank.com/challenges/weather-observation-station-20/problem
Solution:
SET @r=0, @total_rows=0;
SELECT ROUND(ST.LAT_N,4)
FROM (
    SELECT
        LAT_N, 
        @r:=@r+1 as row_number, 
        @total_rows := @r
    from station
    ORDER BY LAT_N ASC
) ST
WHERE ST.row_number = (@total_rows+1)/2;

11. https://www.hackerrank.com/challenges/the-report/problem
Solution:
SELECT
    CASE
        WHEN ST.MARKS <= 70 THEN NULL
        ELSE ST.NAME
    END, 
    (
        SELECT 
            GRADE
        FROM GRADES GD
        WHERE ST.MARKS >= GD.MIN_MARK AND ST.MARKS <= GD.MAX_MARK
    ) AS C_GD,
    ST.MARKS
FROM STUDENTS ST
ORDER BY C_GD DESC, ST.NAME ASC;

12. https://www.hackerrank.com/challenges/harry-potter-and-wands/problem
Solution:
SELECT
    WD.id,
    WD_P.age,
    WD.coins_needed,
    WD.power
FROM wands AS WD
LEFT JOIN wands_property AS WD_P
ON WD.code = WD_P.code
WHERE WD_P.is_evil = 0
AND WD.coins_needed = 
    (
        SELECT min(coins_needed) 
        FROM wands as WD1
        LEFT JOIN wands_property as WD_P1 
        ON WD1.code = WD_P1.code 
        WHERE WD1.power = WD.power 
        AND WD_P1.age = WD_P.age
    )
ORDER BY WD.power DESC, WD_P.age DESC;

13. https://www.hackerrank.com/challenges/contest-leaderboard/problem
Solution:
SELECT HK.HACKER_ID, HK.NAME, SUM(MX_SCORE) AS SUM_VAL
FROM (SELECT HACKER_ID, CHALLENGE_ID, MAX(SCORE) AS MX_SCORE
      FROM SUBMISSIONS
      WHERE SCORE > 0
      GROUP BY HACKER_ID, CHALLENGE_ID) SB
JOIN HACKERS HK ON (HK.HACKER_ID = SB.HACKER_ID)
GROUP BY HK.HACKER_ID, HK.NAME
ORDER BY SUM_VAL DESC, HK.HACKER_ID ASC;

14. https://www.hackerrank.com/challenges/placements/problem
Solution:
SELECT
    distinct M_NAME
FROM
(
    SELECT
        ST.id AS M_ID,
        ST.name AS M_NAME,
        PK.salary AS M_SALARY,
        FD.friend_id AS F_ID,
        (
            SELECT PK_T.salary
            FROM packages PK_T
            WHERE PK_T.id = FD.friend_id
            AND ST.ID = FD.ID
        ) AS F_SALARY
    FROM students AS ST
    LEFT JOIN packages AS PK
    ON ST.ID = PK.ID
    LEFT JOIN friends AS FD
    ON ST.ID = PK.ID
    ORDER BY F_SALARY
) AS MN
WHERE MN.M_SALARY < F_SALARY;

15. https://www.hackerrank.com/challenges/symmetric-pairs/problem
Solution:
SET @r1=0, @r2=0;
SELECT
    TX,
    TY
FROM
(
    SELECT
        T1.X AS TX,
        T1.Y AS TY,
        ABS(T1.X-T2.Y) AS SX,
        ABS(T1.Y-T2.X) AS SY
    FROM
    (
        (SELECT X, Y, @r1 := @r1+1 as r1_n FROM functions order by X ASC) T1,
        (SELECT X, Y, @r2 := @r2+1 as r2_n FROM functions order by X ASC) T2
    )
    WHERE T1.r1_n != T2.r2_n
    AND T1.r1_n < T2.r2_n
    ORDER BY T1.X
) AS MN
WHERE MN.SX = 0 AND MN.SY = 0
GROUP BY TX, TY
HAVING COUNT(*) >= 1
ORDER BY TX;

