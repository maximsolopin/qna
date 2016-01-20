$ ->
  $('.question-votes').bind 'ajax:success', '.votes', (e, data, status, xhr) ->
     question = $.parseJSON(xhr.responseText);
     $(".question-votes#question_#{question.id}").html(JST["templates/vote"]({object: question}))

  PrivatePub.subscribe "/questions", (data, channel) ->
    question = $.parseJSON(data['question']);
    $('.question-list').append(JST['templates/question']({question: question}));

  question_id = $('.question').data('questionId');
  PrivatePub.subscribe "/questions/" + question_id + "/comments", (data, channel) ->
    comment = $.parseJSON(data['comment']);
    $('.new_comment #comment_body').val('');
    $(".comments-list#question_#{comment.commentable_id}").append(JST['templates/comment']({comment: comment}));
