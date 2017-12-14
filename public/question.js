(function() {
  var loadScript, myAppJavascript;

  loadScript = function(url, callback) {
    var script;
    script = document.createElement('script');
    script.type = 'text/javascript';
    // If the browser is IE
    if (script.readyState) {
      script.onreadystatechange = function() {
        if (script.readyState === 'loaded' || script.readyState === 'complete') {
          script.onreadystatechange = null;
          return callback();
        }
      };
    } else {
      script.onload = function() {
        return callback();
      };
    }
    script.src = url;
    return document.getElementsByTagName("head")[0].appendChild(script);
  };

  myAppJavascript = function($) {
    window.QuestionApp = {
      init: function() {
        this.boundDisplayInitialQuestions = this.displayInitialQuestions.bind(this);
        this.boundFetchAndDisplayQuestions = this.fetchAndDisplayQuestions.bind(this);
        this.boundDisplayQuestions = this.displayQuestions.bind(this);
        this.boundHandleFailure = this.handleFailure.bind(this);
        this.boundCreateQuestionsHTML = this.createQuestionsHTML.bind(this);
        this.boundCreateAnswersHTML = this.createAnswersHTML.bind(this);
        this.boundQuestionHTML = this.questionHTML.bind(this);
        this.boundAnswerHTML = this.answerHTML.bind(this);
        this.boundInitEvents = this.initEvents.bind(this);
        this.boundSubmitQuestion = this.submitQuestion.bind(this);
        this.boundMoreQuestionLinkEvent = this.moreQuestionLinkEvent.bind(this);
        this.boundAddOrRemoveMoreQuestionsLink = this.addOrRemoveMoreQuestionsLink.bind(this);
        this.boundHandleQuestionSubmission = this.handleQuestionSubmission.bind(this);
        this.boundSuccessfulQuestionSubmission = this.successfulQuestionSubmission.bind(this);
        this.boundFailedQuestionSubmission = this.failedQuestionSubmission.bind(this);
        this.boundDisplayNextPageOfQuestions = this.displayNextPageOfQuestions.bind(this);
        this.boundInitEvents();
        return this;
      },
      initEvents: function() {
        this.boundSubmitQuestion();
        return this.boundMoreQuestionLinkEvent();
      },
      submitQuestion: function() {
        return $('form#product-question-form').submit(this.boundHandleQuestionSubmission);
      },
      moreQuestionLinkEvent: function() {
        return $('a#show-more-questions').click(this.boundDisplayNextPageOfQuestions);
      },
      displayNextPageOfQuestions: function() {
        var next_page;
        next_page = $('a#show-more-questions').data('current-page') + 1;
        return this.boundFetchAndDisplayQuestions(next_page);
      },
      handleQuestionSubmission: function(event) {
        event.preventDefault();
        return $.post({
          url: event.currentTarget.action,
          data: $(event.currentTarget).serialize(),
          dataType: "json"
        }).done(this.boundSuccessfulQuestionSubmission).fail(this.boundFailedQuestionSubmission);
      },
      successfulQuestionSubmission: function(questionJSON, status, jqXHR) {
        var questionsJSON;
        document.getElementById("product-question-form").reset();
        questionsJSON = {
          questions: [questionJSON.question]
        };
        return this.boundDisplayQuestions(questionsJSON);
      },
      failedQuestionSubmission: function(jqXHR) {
        return console.log(jqXHR.responseJSON);
      },
      displayInitialQuestions: function() {
        return this.boundFetchAndDisplayQuestions(1);
      },
      fetchAndDisplayQuestions: function(page) {
        var productJSON;
        productJSON = JSON.parse($('script#product-questions-data').text());
        // Make /a/q/ part of the url configurable.
        // A shop may change the proxy URL in APP specific settings
        return $.getJSON(`/a/q/products/${productJSON.id}/questions.json`, {
          page: page
        }, this.boundDisplayQuestions).fail(this.boundHandleFailure);
      },
      displayQuestions: function(questionsJSON) {
        $('ul#top-questions-and-answers-list').append(this.boundCreateQuestionsHTML(questionsJSON.questions));
        return this.boundAddOrRemoveMoreQuestionsLink(questionsJSON.pagination);
      },
      handleFailure: function(jqXHR) {
        return console.log(jqXHR.responseJSON);
      },
      addOrRemoveMoreQuestionsLink: function(pagination) {
        if (pagination.is_last_page) {
          return $('a#show-more-questions').hide();
        } else {
          return $('a#show-more-questions').data('current-page', pagination.current_page).show();
        }
      },
      createQuestionsHTML: function(questions) {
        var html;
        html = "";
        $.each(questions, (index, question) => {
          return html += this.boundQuestionHTML(question);
        });
        return html;
      },
      createAnswersHTML: function(answers) {
        var html;
        html = "";
        $.each(answers, (index, answer) => {
          return html += this.boundAnswerHTML(answer);
        });
        return html;
      },
      answerHTML: function(answer) {
        return `<div class='answer'> ${answer.body} <div class='answer-created-at'> on ${answer.created_at} </div> </div>`;
      },
      questionHTML: function(question) {
        return `<li class='question-and-answer-container'> <div class='votes-container'> <div class='votes-elements'> <div class='arrow up'></div> <div class='votes-score'>16</div> <div class='arrow down'></div> </div> </div> <div class='question-and-answer'> <div class='question-container'> <div class='question-header'><span class='question-text'>Question:</span></div> <div class='question-body'>${question.body}</div> </div> <div class='answers-container'> <div class='answer-header'><span class='answer-text'>Answer:</span></div> <div class='answers'> ${this.boundCreateAnswersHTML(question.answers)} </div> </div> </div> </li>`;
      }
    };
    window.QuestionApp.init();
    return window.QuestionApp.displayInitialQuestions();
  };

  if (typeof jQuery === 'undefined' || parseFloat(jQuery.fn.jquery < 1.7)) {
    loadScript('//ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js', function() {
      var jQuery321;
      jQuery321 = jQuery.noConflict(true);
      return myAppJavascript(jQuery321);
    });
  } else {
    myAppJavascript(jQuery);
  }

}).call(this);
