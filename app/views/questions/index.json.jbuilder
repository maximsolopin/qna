json.extract! @question, :id, :title, :created_at
json.created_in_words time_ago_in_words(@question.created_at)
json.show_url question_path(@question)