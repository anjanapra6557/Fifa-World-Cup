create database fifa;

select * from goals;
select * from group1;
select * from matches;
select * from stadiums;
select * from teams;

-- The below given are the 16 queries about the world cup data on the basis of analysis:

/*1. How many goals were scored in the tournament? */
SELECT COUNT(G.Goal_ID) AS Total_Goals_Scored
FROM Goals G;

/*2. How many of them were scored in the group and knockout stage? */
SELECT G.Round, COUNT(G.Goal_ID) as Goals_Per_Round
FROM Goals G
WHERE G.Round IN (
'Group Stage', 'Round of 16', 'Quarter Final', 
'Semi Final', '3rd Place Playoff', 'Final'
)
GROUP BY G.Round
ORDER BY Goals_Per_Round DESC;

/*3. What were the amount of games won by each group winner? */
SELECT G.Team_Name, T.Wins, G.Position
FROM group1 G
JOIN Teams T ON G.Team_ID = T.Team_ID
WHERE G.Position = '1'
GROUP BY G.Team_Name, T.Wins, G.Position
ORDER BY T.Wins desc;

/*4. Show the goals scored and conceded for the teams that 
were eliminated in the group stage.*/
SELECT T.Team_Name, T.Goals_Scored, T.Goals_Conceded, T.Highest_Finish
FROM Teams T
WHERE T.Highest_Finish = 'Group Stage'
GROUP BY T.Team_Name, T.Goals_Scored, T.Goals_Conceded, T.Highest_Finish
ORDER BY T.Team_Name;

/*5. Which team had the highest amount of bookings (Red + Yellow Cards) */
SELECT T.Team_Name, 
MAX(T.Yellow_Cards + T.Red_Cards) AS Number_of_Bookings
FROM Teams T
GROUP BY T.Team_Name
ORDER BY Number_of_Bookings DESC
Limit 1;

/*6. Which team(s) collected no single point in the group stages? */
SELECT T.Team_Name, G.Points_Gained	
FROM Group1 G 
JOIN Teams T ON G.Group_ID = T.Group_ID
WHERE G.Points_Gained = '0'
GROUP BY T.Team_Name, G.Points_Gained;


/*7. Which player scored the highest number of goals? */
SELECT G.Goal_Scorer, COUNT(G.Goal_ID) AS Number_of_Goals
FROM Goals G
GROUP BY G.Goal_Scorer
ORDER BY Number_of_Goals DESC
Limit 1;

/*8. What was the latest minute in which the top scorer scored a goal? */
SELECT G.Goal_Scorer, G.Goal_Minute 
FROM Goals G
WHERE G.Goal_Scorer = 'Kylian Mbappe'
GROUP BY G.Goal_Scorer, G.Goal_Minute
ORDER BY Goal_Minute
Limit 1;

/*9. On which date was the last game at Al Janoub Stadium played? */
SELECT M.Date, M.Stadium_Name
FROM Matches M
WHERE M.Stadium_Name = 'Al Janoub Stadium'
GROUP BY M.Stadium_Name, M.Date
ORDER BY M.Date 
Limit 1;

/*10. What was the highest possible round that all 8 group winners could reach? */
SELECT G.Team_Name, T.Highest_Finish
FROM Group1 G
JOIN Teams T on G.Group_ID = T.Group_ID
WHERE G.Position = '1'
GROUP BY G.Team_Name, T.Highest_Finish, G.Position
ORDER BY G.Team_Name;

/*11. What were the teams that Lionel Messi and Kylian Mbappe scored against. */
SELECT G.Goal_Scorer, G.Scored_Against
FROM Goals G
WHERE G.Goal_Scorer = 'Lionel Messi' OR G.Goal_Scorer = 'Kylian Mbappe'
GROUP BY G.Goal_Scorer, G.Scored_Against;

/*12. Which teams had a negative goal difference? */
SELECT T.Team_Name, (T.Goals_Scored - T.Goals_Conceded) AS Goal_Difference
FROM Teams T
GROUP BY Team_Name, T.Goals_Scored, T.Goals_Conceded
HAVING T.Goals_Scored - T.Goals_Conceded < 0
ORDER BY Goal_Difference;

/*13. Which player scored the opening goal of the tournament and in which minute? */
SELECT G.Goal_Scorer, G.Goal_Minute
FROM Goals G
WHERE G.Goal_ID = 1
GROUP BY G.Goal_Scorer,G.Goal_Minute;

/*14. Which teams participated in Stadium 974? */
SELECT S.Stadium_Name, M.Home_Team, M.Away_Team
FROM Stadiums S
JOIN Matches M ON S.Stadium_ID = M.Stadium_ID
WHERE S.Stadium_Name LIKE '%974%';

/*15. How long did the tournament last? */
SELECT Date
FROM Matches 
WHERE Match_ID IN (1, 64);
SELECT DATEDIFF('2022-12-18','2022-11-20') AS Total_Days;


/*16. Assume that there was a 173rd goal scored in the Final for Argentina
by Lionel Messi in the 119th minute. Add the values to the goals table. */

INSERT INTO Goals (
Goal_ID, Goal_Scorer, Scored_Against, Round, 
     Goal_Minute, Minute_Format, Team_ID, Match_ID
)
VALUES (173, 'Lionel Messi', 'France', 'FINAL', 119, 'Extra Time',
  9, 64); 
 
set sql_safe_updates=0; 
DELETE FROM goals
WHERE Goal_ID=173;
