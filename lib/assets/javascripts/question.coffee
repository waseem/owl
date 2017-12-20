loadScript = (url, callback) ->
  script = document.createElement('script')
  script.type = 'text/javascript'

  # If the browser is IE
  if script.readyState
    script.onreadystatechange = ->
      if script.readyState == 'loaded' || script.readyState == 'complete'
        script.onreadystatechange = null
        callback()
  else
    script.onload = ->
      callback()

  script.src = url
  document.getElementsByTagName("head")[0].appendChild(script)

myAppJavascript = ($) ->
  window.QuestionApp =
    init: ->
      @boundDisplayInitialQuestions = @displayInitialQuestions.bind(@)
      @boundFetchAndDisplayQuestions = @fetchAndDisplayQuestions.bind(@)
      @boundDisplayQuestions = @displayQuestions.bind(@)
      @boundHandleFailure = @handleFailure.bind(@)
      @boundCreateQuestionsHTML = @createQuestionsHTML.bind(@)
      @boundCreateAnswersHTML = @createAnswersHTML.bind(@)
      @boundQuestionHTML = @questionHTML.bind(@)
      @boundAnswerHTML = @answerHTML.bind(@)
      @boundInitEvents = @initEvents.bind(@)
      @boundSubmitQuestion = @submitQuestion.bind(@)
      @boundMoreQuestionLinkEvent = @moreQuestionLinkEvent.bind(@)
      @boundAddOrRemoveMoreQuestionsLink = @addOrRemoveMoreQuestionsLink.bind(@)
      @boundHandleQuestionSubmission = @handleQuestionSubmission.bind(@)
      @boundSuccessfulQuestionSubmission = @successfulQuestionSubmission.bind(@)
      @boundFailedQuestionSubmission = @failedQuestionSubmission.bind(@)
      @boundDisplayNextPageOfQuestions = @displayNextPageOfQuestions.bind(@)

      @boundInitEvents()
      @

    initEvents: ->
      @boundSubmitQuestion()
      @boundMoreQuestionLinkEvent()

    submitQuestion: ->
      $('form#product-question-form').submit(@boundHandleQuestionSubmission)

    moreQuestionLinkEvent: ->
      $('a#show-more-questions').click(@boundDisplayNextPageOfQuestions)

    displayNextPageOfQuestions: ->
      next_page = $('a#show-more-questions').data('current-page') + 1
      @boundFetchAndDisplayQuestions(next_page)

    handleQuestionSubmission: (event) ->
      event.preventDefault()
      $.post(
        url: event.currentTarget.action
        data: $(event.currentTarget).serialize()
        dataType: "json"
      ).done(@boundSuccessfulQuestionSubmission)
        .fail(@boundFailedQuestionSubmission)

    successfulQuestionSubmission: (questionJSON, status, jqXHR) ->
      document.getElementById("product-question-form").reset()
      questionsJSON = {
        questions: [questionJSON.question]
      }
      @boundDisplayQuestions(questionsJSON)

    failedQuestionSubmission: (jqXHR) ->
      console.log(jqXHR.responseJSON)

    displayInitialQuestions: ->
      @boundFetchAndDisplayQuestions(1)

    fetchAndDisplayQuestions: (page) ->
      productJSON = JSON.parse($('script#product-questions-data').text())
      # Make /a/q/ part of the url configurable.
      # A shop may change the proxy URL in APP specific settings
      $.getJSON("/a/q/products/#{productJSON.id}/questions.json", { page: page }, @boundDisplayQuestions)
        .fail(@boundHandleFailure)

    displayQuestions: (questionsJSON) ->
      $('ul#top-questions-and-answers-list').append(@boundCreateQuestionsHTML(questionsJSON.questions))
      @boundAddOrRemoveMoreQuestionsLink(questionsJSON.pagination)

    handleFailure: (jqXHR) ->
      console.log(jqXHR.responseJSON)

    addOrRemoveMoreQuestionsLink: (pagination) ->
      if pagination.is_last_page
        $('a#show-more-questions').hide()
      else
        $('a#show-more-questions').data('current-page', pagination.current_page).show()

    createQuestionsHTML: (questions) ->
      html = ""
      $.each(questions, (index, question) =>
        html += @boundQuestionHTML(question)
      )
      html

    createAnswersHTML: (answers) ->
      html = ""
      $.each(answers, (index, answer) =>
        html += @boundAnswerHTML(answer)
      )
      html

    answerHTML: (answer) ->
      "
      <div class='answer'>
        #{answer.body}
        <div class='answer-created-at'>
          on #{answer.created_at}
        </div>
      </div>
      "

    questionHTML: (question) ->
      "
      <li class='question-and-answer-container'>
        <div class='question-and-answer'>
          <div class='question-container'>
            <div class='question-header'><span class='question-text'>Question:</span></div>
            <div class='question-body'>#{question.body}</div>
          </div>

          <div class='answers-container'>
            <div class='answer-header'><span class='answer-text'>Answer:</span></div>
            <div class='answers'>
              #{@boundCreateAnswersHTML(question.answers)}
            </div>
          </div>
        </div>
      </li>
      "

  window.QuestionApp.init()
  window.QuestionApp.displayInitialQuestions()

if(typeof(jQuery) is 'undefined' or parseFloat(jQuery.fn.jquery < 1.7))
  loadScript('//ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js', ->
    jQuery321 = jQuery.noConflict(true)
    myAppJavascript(jQuery321)
  )

else
  myAppJavascript(jQuery)
