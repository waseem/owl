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
        return this;
      },
      displayInitialQuestions: function() {
        var productJSON;
        productJSON = JSON.parse($('script#product-questions-data').text());
        // Make /a/q/ part of the url configurable.
        // A shop may change the proxy URL in APP specific settings
        return $.getJSON(`/a/q/products/${productJSON.id}/questions.json`, this.boundDisplayQuestions).fail(this.boundHandleFailure);
      },
      displayQuestions: function(questionsJSON) {
        return $('#questions-list').append(this.boundCreateQuestionsHTML(questionsJSON.questions));
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
        return `<li>${question.body} ${question.created_at}</li>`;
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
