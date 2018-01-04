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

## Installing app to a Shopify Store

1. Go to `/login` and enter myshopify url of the shop and install the app to shop.
2. Edit the `sections/product-template.liquid` in shop's code to include the question form.
3. Add a new `assets/product-questions.scss.liquid` in shop's code to change the design of the form.
4. Change the relevant layout in shop code to include above scss file.
5. In Apps section of shop dashboard, edit proxy URL to `http://<shop-name>.myshopify.com/a/` and subpath `q`.
