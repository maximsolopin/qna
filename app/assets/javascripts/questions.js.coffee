$ ->
  $('.question-block').bind 'ajax:success', '.votes', (e, data, status, xhr) ->
     question = $.parseJSON(xhr.responseText)
     $(".question-votes#question_#{question.id}").html(JST["templates/vote"]({object: question}))