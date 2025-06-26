-- Users who posted a comment that got a reaction in the same day - by OS (of the device used to post the comment)

WITH comments_with_os_name AS (
  SELECT user_id, episode_uri, commentUri AS comment_uri, os_name
  FROM `spotify-interactivity.user_comments.comments_20250423` base_comments_metadata
  JOIN `core-x-insights.podcast_interactivity.logic_interaction_submit_comment` interaction_submit_comment
	ON base_comments_metadata.commentData.userCommentData.userId = interaction_submit_comment.user_id
		AND base_comments_metadata.entityUri = interaction_submit_comment.episode_uri
		AND DATE(base_comments_metadata.createDate) = DATE(interaction_submit_comment.ds)
)

SELECT 
  count(distinct user_id)
  ,count(distinct comment_uri)
  ,os_name
FROM comments_with_os_name
GROUP BY ALL

SELECT 
  os_name
  ,received_a_reaction
  ,count(distinct user_id)
FROM users_who_posted_a_comment_and_received_reaction
FROM comments_with_os_name
LEFT JOIN `spotify-interactivity.reactions.reactions_20250422` comments_reactions
  ON comments_reactions.entityUri = comments_with_os_name.commentUri
WHERE 
  comments.createDate = '2025-04-22'
  AND comments_reactions.createDate = '2025-04-22'
  AND interactions.action_name = 'submit_comment'



