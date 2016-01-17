$ ->
  $('.answers').on 'click', '.edit-answer-link', (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId');
    $('div#answer-id-' + answer_id).hide();
    $('form#edit-answer-' + answer_id).show();

  $('.answer-votes').bind 'ajax:success', '.votes', (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText);
    $(".answer-votes#answer_#{answer.id}").html(JST["templates/vote"]({object: answer}));

  question_id = $('.question').data('questionId');
  PrivatePub.subscribe "/answers/" + question_id, (data, channel) ->
    answer = $.parseJSON(data['answer']);
    $('.new_answer #answer_body').val('');
    $('.answers').append(JST['templates/answer']({answer: answer}));
