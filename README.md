# Rails 5 API x `devise_token_auth` demo

A complete demonstration of user authentication with `devise_token_auth` for Rails 5 API-only apps, complete with Rspec tests!

 * rails 5.0.2
 * devise_token_auth 0.1.40
 * rspec-rails 3.5
 * factory_girl_rails 4.8.0


### What's inside?

This is a simple RESTful API app that requires authentication to perform actions on a list of `Item`s.

### Installation

```
git clone https://github.com/b-ggs/rails5-api-devise-token-auth-demo.git
cd rails5-api-devise-token-auth-demo
bundle install
```

### Sample Usage

First, start by running the server.

```
bundle exec rails s
```

Now, you can start sending requests to the server.

I personally use [Postman](https://chrome.google.com/webstore/detail/postman/fhbjgbiflinjbdggehcddcbncdddomop?hl=en) to make API calls, but you can also use `curl`. Also, these examples will asssume you're running the server off of `localhost:3000`.

The following will guide you through creating a new user account, confirming your account via e-mail, logging in, and consuming the API with your new credentials.

#### Creating a new user

To create a user, we need to send a `POST` request to `/auth`.

For this example, I'll be sending a request with the following parameters:

```
username:boggs
password:foobarbar
email:hello@boggs.xyz
```

##### cURL:

```
curl -X POST -H "Cache-Control: no-cache" -H "Postman-Token: fad0eaee-1310-477f-4d95-c9242e1fa252" -H "Content-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW" -F "username=boggs" -F "password=foobarbar" -F "email=hello@boggs.xyz" "http://localhost:3000/auth/"
```

##### Response body:

```
{
  "status": "success",
  "data": {
    "id": 3,
    "provider": "email",
    "uid": "hello@boggs.xyz",
    "username": "boggs",
    "email": "hello@boggs.xyz",
    "created_at": "2017-03-04T21:16:21.417Z",
    "updated_at": "2017-03-04T21:16:21.417Z"
  }
}
```

#### Confirming your e-mail

Now that you've created your user account, you'll need to confirm it through a link sent via e-mail.

I've set ActionMailer to send the confirmation e-mail via SMTP to `localhost:1025`.

You can use [mailcatcher](https://mailcatcher.me) to receive the e-mail.

Alternatively, you can check the server logs to find the link.

The link should look something like this:

```
http://localhost/auth/confirmation?config=default&confirmation_token=uozenax3E4ubSC4b2uXH&redirect_url=%2F
```

You will need to replace `localhost` with `localhost:3000` for this link to work.

Clicking on this link should yield a blank page, since I haven't set up a view for it to redirect to, but don't worry, once you've visited it, your account should have been confirmed.


#### Logging in

Once you've confirmed your account, you can now login with your new user account by sending a `POST` request with your e-mail and password as the parameters.

```
email:hello@boggs.xyz
password:foobarbar
```

##### cURL:

```
curl -X POST -H "Cache-Control: no-cache" -H "Postman-Token: 89906518-6c6d-4fa3-196e-401556bd5f58" -H "Content-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW" -F "email=hello@boggs.xyz" -F "password=foobarbar" "http://localhost:3000/auth/sign_in"
```

##### Response header: 

```
access-token:p0nDME1Mi0QlkRluYTDbMA
client:H765wjD5dZBSi6RL5W9wWA
expiry:1489872742
token-type:Bearer
uid:hello@boggs.xyz
```

##### Response body:

```
{
  "status": "success",
  "data": {
    "id": 3,
    "provider": "email",
    "uid": "hello@boggs.xyz",
    "username": "boggs",
    "email": "hello@boggs.xyz",
    "created_at": "2017-03-04T21:16:21.417Z",
    "updated_at": "2017-03-04T21:16:21.417Z"
  }
}
```

And now you're all set up to interact with the Items part of the API.

#### Access-Token usage and management

We'll be using the `access-token`, `client`, `expiry`, `token-type`, and `uid` returned to us upon signing in, in order to interact with the parts of the API that require authentication.

One thing to note is that the `access-token` expires after every use. In order to make requests after this, you'll need to save the `access-token` returned to you from your previous successful request.

Every successful request will return a new `access-token` and `expiry` which you will be using to create new requests.

To read more about this, check out [this specific part](https://github.com/lynndylanhurley/devise_token_auth#token-header-format) of the `devise_token_auth` README.

#### Creating a new item

In order to create a new item, we need to specify its `name`, `description`, and `quantity`.

For this example, we'll be sending a `POST` request to `/items` with the following parameters:

```
name:Orange
description:This orange is round and colored orange.
quantity:10
```

But, since this action requires authentication, we'll be sending over the headers we received earlier as headers for this request:

```
access-token:p0nDME1Mi0QlkRluYTDbMA
client:H765wjD5dZBSi6RL5W9wWA
expiry:1489872742
token-type:Bearer
uid:hello@boggs.xyz
```

##### cURL:

```
curl -X POST -H "access-token: p0nDME1Mi0QlkRluYTDbMA" -H "client: H765wjD5dZBSi6RL5W9wWA" -H "expiry: 1489872742" -H "token-type: Bearer" -H "uid: hello@boggs.xyz" -H "Cache-Control: no-cache" -H "Postman-Token: 6bac7d3a-6632-52f5-8c79-118352cabce1" -H "Content-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW" -F "name=Orange" -F "description=This orange is round and colored orange." -F "quantity=10" "http://localhost:3000/items"
```

##### Response header: 

```
access-token:COfvHFlY8SHlIlWXAwN9sg
client:H765wjD5dZBSi6RL5W9wWA
expiry:1489873916
token-type:Bearer
uid:hello@boggs.xyz
```

##### Response body:

```
{
  "message": "Successfully created new item.",
  "item": {
    "id": 2,
    "name": "Orange",
    "description": "This orange is round and colored orange.",
    "quantity": 10,
    "created_at": "2017-03-04T21:51:56.203Z",
    "updated_at": "2017-03-04T21:51:56.203Z"
  }
}
```

Now you've successfully created a new item!

For good measure, let's create one more item. This time, with the following parameters: 

```
name:Mango
description:This mango is delicious.
quantity:20
```

Don't forget, we need to use the response headers we got earlier from creating the `Orange` item.

```
access-token:COfvHFlY8SHlIlWXAwN9sg
client:H765wjD5dZBSi6RL5W9wWA
expiry:1489873916
token-type:Bearer
uid:hello@boggs.xyz
```

##### cURL:

```
curl -X POST -H "access-token: COfvHFlY8SHlIlWXAwN9sg" -H "client: H765wjD5dZBSi6RL5W9wWA" -H "expiry: 1489873916" -H "token-type: Bearer" -H "uid: hello@boggs.xyz" -H "Cache-Control: no-cache" -H "Postman-Token: cc95d649-ef6f-b6fe-2cd6-3c452e2bbfd9" -H "Content-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW" -F "name=Mango" -F "description=This mango is delicious." -F "quantity=20" "http://localhost:3000/items"
```

##### Response header:

```
access-token:KaBjWWW03363t4e2hTZR6Q
client:H765wjD5dZBSi6RL5W9wWA
expiry:1489874232
token-type:Bearer
uid:hello@boggs.xyz
```

##### Response body:

```
{
  "message": "Successfully created new item.",
  "item": {
    "id": 3,
    "name": "Mango",
    "description": "This mango is delicious.",
    "quantity": 20,
    "created_at": "2017-03-04T21:57:12.604Z",
    "updated_at": "2017-03-04T21:57:12.604Z"
  }
}
```


#### Viewing all saved items

Now, let's get a list of all the item's we've saved in the database.

To do that, we'll send a `GET` request to `/items` with the headers from our previous request.

```
access-token:KaBjWWW03363t4e2hTZR6Q
client:H765wjD5dZBSi6RL5W9wWA
expiry:1489874232
token-type:Bearer
uid:hello@boggs.xyz
```

Let's check out what we've got.

##### cURL:

```
curl -X GET -H "access-token: KaBjWWW03363t4e2hTZR6Q" -H "client: H765wjD5dZBSi6RL5W9wWA" -H "expiry: 1489874232" -H "token-type: Bearer" -H "uid: hello@boggs.xyz" -H "Cache-Control: no-cache" -H "Postman-Token: 70de162f-6fb7-28f9-8a57-1605876ed8ce" "http://localhost:3000/items"
```

##### Response header:

```
access-token:RV0SB2Zfe_Sj8tU1D_juRw
client:H765wjD5dZBSi6RL5W9wWA
expiry:1489874407
token-type:Bearer
uid:hello@boggs.xyz
```

##### Response body:

```
{
  "items": [
    {
      "id": 2,
      "name": "Orange",
      "description": "This orange is round and colored orange.",
      "quantity": 10,
      "created_at": "2017-03-04T21:51:56.203Z",
      "updated_at": "2017-03-04T21:51:56.203Z"
    },
    {
      "id": 3,
      "name": "Mango",
      "description": "This mango is delicious.",
      "quantity": 20,
      "created_at": "2017-03-04T21:57:12.604Z",
      "updated_at": "2017-03-04T21:57:12.604Z"
    }
  ]
}
```

#### Other available actions

I implemented all the REST methods for Items so, apart from `GET /items` and `POST /items`, you can also play around with `GET /items/:id`, `PUT /items/:id`, and `DELETE /items/:id`.


### Making it your own

This is a fully configured Rails 5 API app with `devise_token_auth`, so you can start your project on top of this just by removing the `Item` model and `ItemsController`, and adding your own models and controllers.

### Issues / Contributions

If I've screwed up somewhere, let me know by opening an [issue](https://github.com/b-ggs/rails5-api-devise-token-auth-demo/issues), or submitting a [pull request](https://github.com/b-ggs/rails5-api-devise-token-auth-demo/pulls).

Alternatively, I can be found on [Twitter](https://twitter.com/b_ggs).
