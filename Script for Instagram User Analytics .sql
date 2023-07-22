# TOP 5 USER OF INSTAGRAM ALONG WITH THIER USERNAME
SELECT 
    *
FROM
    users
ORDER BY created_at
LIMIT 5;



# INSTAGRAM USERS WHO HAVE NEVER POSTED ON THE PLATFORM
SELECT 
    id, username
FROM
    users
WHERE
    id NOT IN (SELECT 
            user_id
        FROM
            photos);

# DECLARING A CONTEST WINNER WHO GETS THE MOST LIKES ON A SINGLE PHOTO.
WITH MOST_LIKE As
(
	SELECT 
			PHOTO_ID,
		COUNT(PHOTO_ID) OVER ( PARTITION BY PHOTO_ID ) AS MAX_LIKES
	FROM 
			LIKES
	ORDER BY 
			MAX_LIKES DESC
	LIMIT 1),

PHOTOS_LIKE AS 
(
	SELECT 
		ML.MAX_LIKES,P.ID,P.IMAGE_URL,P.USER_ID 
    FROM 
		MOST_LIKE AS ML
    LEFT JOIN 
		PHOTOS AS P
	ON P.ID = ML.PHOTO_ID)


SELECT 
		U.ID, U.USERNAME,PL.MAX_LIKES,PL.IMAGE_URL
FROM 
	USERS U
INNER JOIN 
	PHOTOS_LIKE PL
ON PL.USER_ID = U.ID;


# Identify and suggest the top 5 most commonly used hashtags on the platform
with tag_detail as
(
	select 
		photo_id,tag_id,
		count(tag_id) over (partition by tag_id ) as total_tags
	from 
		photo_tags)


select 
	tags.tag_name,tag_detail.total_tags as tags_count 
from
		tag_detail
inner join 
		tags
on tag_detail.tag_id = tags.id
group by 
		tag_name
order by 
		total_tags desc
limit 5;


# What day of the week do most users register on?
SELECT 
    DAYNAME(CREATED_AT) AS WEEKDAY,
    COUNT(DAYNAME(CREATED_AT)) AS USER_REGISTERED
FROM
    USERS
GROUP BY WEEKDAY
ORDER BY USER_REGISTERED DESC
LIMIT 2;


# B) Investor Metrics:

# Calculate the average number of posts per user on Instagram. 
# Also, provide the total number of photos on Instagram divided by the total number of users.
SELECT 
    (SELECT 
            COUNT(id)
        FROM
            photos) / (SELECT 
            COUNT(DISTINCT (user_id))
        FROM
            photos) AS avg_number_of_post,
    (SELECT 
            COUNT(id)
        FROM
            photos) / (SELECT 
            COUNT(id)
        FROM
            users) AS photo_divide_by_users;



# Identify users (potential bots) who have liked every single photo on the site,
# As this is not typically possible for a normal user.
SELECT 
    u.username AS Bot_Username,
    l.user_id AS ID,
    COUNT(user_id) AS Number_of_post_liked
FROM
    users AS u
        JOIN
    likes AS l ON u.id = l.user_id
GROUP BY user_id
HAVING Number_of_post_liked = 257;








