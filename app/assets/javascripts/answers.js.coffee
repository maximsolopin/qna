$ ->
  $('.answers').on 'click', '.edit-answer-link', (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId');
    $('div#answer-id-' + answer_id).hide();
    $('form#edit-answer-' + answer_id).show();
