json.extract! @answer, :id, :body
json.is_best @answer.best?
json.display_name @answer.user.display_name
json.answer_author user_signed_in? && @answer.user_id == current_user.id
json.answer_link answer_path(@answer)
json.answer_link_set_best set_best_answer_path(@answer)
json.created "#{time_ago_in_words(@answer.created_at)} ago"
json.attachments @answer.attachments do |a|
  json.id a.id
  json.name a.file.identifier
  json.url a.file.url
end
json.dom_id "#{dom_id(@answer)}"
json.insertion_template '<div class="nested-fields">
          <span class="btn btn-primary"><input type="file" name="answer[attachments_attributes][new_attachments][file]" id="answer_attachments_attributes_new_attachments_file" /></span><span class="btn btn-danger"><input type="hidden" name="answer[attachments_attributes][new_attachments][_destroy]" id="answer_attachments_attributes_new_attachments__destroy" value="false" /><a class="remove_fields dynamic" href="#"><i class="fa fa-trash-o fa-lg"></i></a></span>
</div>'