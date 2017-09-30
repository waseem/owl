# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions


## Compiling Storefront Javascript

script tag id 3376906267

* In `development` environment

    `$ coffee --no-header --output public/question.js -wc lib/assets/javascripts/`

{% if template.name == 'product' %}
    <!--[if (gt IE 9)|!(IE)]><!--><script src="{{ 'question.js' | asset_url }}" defer="defer"></script><!--<![endif]-->
    <!--[if lte IE 9]><script src="{{ 'question.js' | asset_url }}"></script><![endif]-->
{% endif %}
