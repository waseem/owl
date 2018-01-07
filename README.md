## Setting up Development environment

1. Clone the respository and do `bundle install` to install all the gems.
2. Create a Shopify App in Partners Dashboard and note down its API credentials.
3. Create a `.env` file with following content
```
SHOPIFY_CLIENT_API_KEY=<API key>
SHOPIFY_CLIENT_API_SECRET=<API secret key>

```
4. Create `config/database.yml` and `config/secrets.yml` with appropriate content
5. `bundle exec rake db:create:all`
6. `bundle exec rake db:migrate`
7. `bundle exec rspec spec`
8. Use [ngrok](https://ngrok.com/docs/2#expose) to expose your rails server to internet.
9. Change `App URL`, `Whitelisted redirection URL(s)` in Shopify App settings.
10. Change `App Proxy` URL with Sub path prefix of `a` and Sub path of `q` with ngrok URL generated in step 8 as Proxy URL.
11. `bundle exec rails s`
12. Visit `localhost:3000/login`


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
