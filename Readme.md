THE AUTHENTICATOR
===================

THE AUTHENTICATOR DOES NOT CARE LETTER BEFORE AUTH. THE AUTHENTICATOR PROVIDE GOOD USER EXPERIENCE. THE AUTHENTICATOR BEND OAUTH TO WILL.

What is this?
-------------

This is a proof of concept Objective-C OAuth desktop client for Twitter that implements a login flow that mimics xAuth (Username + Password).

Why?
----

Because there's been hubbubb over the bad user experience associated with OAuth. This recurfaced recently when Twitter decided that all API clients except their own must use OAuth for authentication.

[http://daringfireball.net/2011/05/twitter_shit_sandwich](http://daringfireball.net/2011/05/twitter_shit_sandwich)

How?
----

The client embeds a WebKit view to do the authentication, but restyles Twitter's normal authentication dialog to look more like a native OS X window.

Practical?
----------

It's a giant hack, and probably violates some Term of Service clause. But it works.

License
-------

By Kim Ahlström, kim.ahlstrom@gmail.com

MIT License