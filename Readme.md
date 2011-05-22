THE AUTHENTICATOR
===================

THE AUTHENTICATOR DOES NOT CARE LETTER BEFORE AUTH. THE AUTHENTICATOR PROVIDE GOOD USER EXPERIENCE. THE AUTHENTICATOR BEND OAUTH TO WILL.

What is this?
-------------

This is a proof of concept Objective-C OAuth desktop client for Twitter that implements a login flow that mimics xAuth (Username + Password) for a silky smooth user experience.

Why?
----

Because there's been hubbubb over the bad user experience associated with OAuth. This recurfaced recently when Twitter decided that all API clients except their own must use OAuth for authentication.

[http://daringfireball.net/2011/05/twitter_shit_sandwich](http://daringfireball.net/2011/05/twitter_shit_sandwich)

How?
----

The client embeds a WebKit view to do the authentication, but restyles Twitter's normal authentication dialog to look more like a native OS X window.

Once the user has logged in it uses Javascript to extract the verification PIN to retrieve the access token. 

<img src="https://github.com/Kimtaro/THE-AUTHENTICATOR/raw/master/screenshots/Step%201.png" />
<img src="https://github.com/Kimtaro/THE-AUTHENTICATOR/raw/master/screenshots/Step%202.png" />
<img src="https://github.com/Kimtaro/THE-AUTHENTICATOR/raw/master/screenshots/Step%203.png" />
<img src="https://github.com/Kimtaro/THE-AUTHENTICATOR/raw/master/screenshots/Step%204.png" />

Practical?
----------

It's a giant hack, and probably violates some Term of Service clause. But it works.

Caveats
------

- Needs more native styling
- Needs a few seconds to download the auth dialog before it can be shown. This can be remedied with some clever UX. 

License
-------

By Kim Ahlström, kim.ahlstrom@gmail.com

MIT License