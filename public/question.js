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
        this.boundDisplayQuestions = this.displayQuestions.bind(this);
        this.boundHandleFailure = this.handleFailure.bind(this);
        this.boundCreateQuestionsHTML = this.createQuestionsHTML.bind(this);
        this.boundQuestionHTML = this.questionHTML.bind(this);
        this.boundInitEvents = this.initEvents.bind(this);
        this.boundSubmitQuestion = this.submitQuestion.bind(this);
        this.boundHandleQuestionSubmission = this.handleQuestionSubmission.bind(this);
        this.boundSuccessfulQuestionSubmission = this.successfulQuestionSubmission.bind(this);
        this.boundFailedQuestionSubmission = this.failedQuestionSubmission.bind(this);
        this.boundInitEvents();
        return this;
      },
      initEvents: function() {
        return this.boundSubmitQuestion();
      },
      submitQuestion: function() {
        return $('form#product-question-form').submit(this.boundHandleQuestionSubmission);
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
        var productJSON;
        productJSON = JSON.parse($('script#product-questions-data').text());
        // Make /a/q/ part of the url configurable.
        // A shop may change the proxy URL in APP specific settings
        return $.getJSON(`/a/q/products/${productJSON.id}/questions.json`, this.boundDisplayQuestions).fail(this.boundHandleFailure);
      },
      displayQuestions: function(questionsJSON) {
        return $('ul#top-questions-and-answers-list').append(this.boundCreateQuestionsHTML(questionsJSON.questions));
      },
      handleFailure: function(jqXHR) {
        return console.log(jqXHR.responseJSON);
      },
      createQuestionsHTML: function(questions) {
        var html;
        html = "";
        $.each(questions, (index, question) => {
          return html += this.boundQuestionHTML(question);
        });
        return html;
      },
      questionHTML: function(question) {
        return `<li class='question-and-answer-container'> <div class='votes-container'> <div class='votes-elements'> <div class='arrow up'></div> <div class='votes-score'>16</div> <div class='arrow down'></div> </div> </div> <div class='question-and-answer'> ${question.body} </div> </li>`;
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
