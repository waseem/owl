## Updating Shopify Script Tag

script tag id `3376906267`

```
$ bundle exec rails c
irb> ShopifyAPI::Session.setup(api_key: ENV['SHOPIFY_CLIENT_API_KEY'], secret: ENV['SHOPIFY_CLIENT_API_SECRET'])
irb> shop = Shop.first
irb> session = ShopifyAPI::Session.new(shop.shopify_domain, shop.shopify_token)
irb> ShopifyAPI::Base.activate_session(session)
irb> script_tag = ShopifyAPI::ScriptTag.find(3376906267)
irb> script_tag.src = "https://f81ade74.ngrok.io/question.js"
irb> script_tag.save
```

## Compiling Storefront Javascript

* In `development` environment

    `$ coffee --no-header --output public/question.js -wc lib/assets/javascripts/`

## Potential features that come with paid plan

* Searching of questions and answers
* Votes on Questions/Sorted by votes
