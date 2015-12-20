json.extract! @votable, :id
json.rating @votable.votes.rating
json.user_voted @votable.user_voted?(current_user)
json.vote_up_url vote_up_question_path(@votable)
json.vote_down_url vote_down_question_path(@votable)
json.vote_reset_url vote_reset_question_path(@votable)