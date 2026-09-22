Find all posts which were reacted to with a heart. For such posts output all columns from facebook_posts table.

SELECT DISTINCT p.*
FROM facebook_reactions r
INNER JOIN facebook_posts p
ON 
  r.post_id = p.post_id AND
  r.reaction = 'heart';