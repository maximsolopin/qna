json.extract! @question, :id, :title
json.created "asked #{time_ago_in_words(@question.created_at)} ago"
json.show_url question_path(@question)