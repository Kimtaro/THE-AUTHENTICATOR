//
//  THE_AUTHENTICATORAppDelegate.m
//  THE AUTHENTICATOR
//
//  Created by Kim Ahlström on 2011-05-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "THE_AUTHENTICATORAppDelegate.h"

#define kConsumerKey		@""
#define kConsumerSecret		@""
#define kRequestTokenURL    @"https://api.twitter.com/oauth/request_token"
#define kAccessTokenURL     @"https://api.twitter.com/oauth/access_token"
#define kAuthorizeURL       @"https://api.twitter.com/oauth/authorize"

@implementation THE_AUTHENTICATORAppDelegate

@synthesize window;
@synthesize webView;
@synthesize statusTextField;
@synthesize requestToken;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Setup webView
	[webView setFrameLoadDelegate:self];

	// Setup consumer and URL
	OAConsumer *consumer = [[OAConsumer alloc] initWithKey:kConsumerKey
                                                    secret:kConsumerSecret];
	
    NSURL *url = [NSURL URLWithString:kRequestTokenURL];
		
	// Get request token
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
                                                                   consumer:consumer
                                                                      token:nil   // we don't have a Token yet
                                                                      realm:nil   // our service provider doesn't specify a realm
                                                          signatureProvider:nil]; // use the default method, HMAC-SHA1
	
    [request setHTTPMethod:@"POST"];	
	
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
	
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(requestTokenTicket:didFinishWithData:)
                  didFailSelector:@selector(requestTokenTicket:didFailWithError:)];
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
	if (ticket.didSucceed) {
		NSString *responseBody = [[NSString alloc] initWithData:data
													   encoding:NSUTF8StringEncoding];

		requestToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
		
		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?oauth_token=%@", kAuthorizeURL, [requestToken key]]];
		[[webView mainFrame] loadRequest:[NSURLRequest requestWithURL:url]];
	}
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error {
	NSLog(@"REQUEST TOKEN ERRAR: %@", error);
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame {	
	if ( [[webView mainFrameURL] rangeOfString:@"oauth_token"].location != NSNotFound ) {
		// Loaded the login dialog
		// Restyle the dialog
		[webView stringByEvaluatingJavaScriptFromString:@"\
		  document.getElementsByTagName('style')[0].innerHTML = '\
		    h2, #top-bar, .app-info, .permissions, .footer, #deny { display: none; }\
		    body { background-image: none; background-color: #EDEDED; }\
		    #bd { border-width: 0; }\
		    .auth { border-width: 0; margin: 0; padding: 0; width: 100%; }\
		    label { font-family: Lucida Grande; font-weight: normal !important; }\
			input { font-family: Lucida Grande; }\
		    #allow { float: right; margin-right: 40px; }\
		  '\
		 "];
		
		// Draw it
		[webView setHidden:NO];
		[statusTextField setHidden:YES];		
	}
	else if ( [[webView mainFrameURL] rangeOfString:kAuthorizeURL].location != NSNotFound ) {
		// Loaded the PIN
		// TODO: Handle login errors here
		NSString *pin = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('code')[0].innerHTML"];
		
		// Get the access token
		// Setup consumer and URL
		OAConsumer *consumer = [[OAConsumer alloc] initWithKey:kConsumerKey
														secret:kConsumerSecret];
		
		NSURL *url = [NSURL URLWithString:kAccessTokenURL];
		
		// Get access token
		OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
																	   consumer:consumer
																		  token:requestToken
																		  realm:nil   // our service provider doesn't specify a realm
															  signatureProvider:nil]; // use the default method, HMAC-SHA1

		[request setOAuthParameterName:@"oauth_verifier" withValue:pin];
		[request setHTTPMethod:@"POST"];
		
		OADataFetcher *fetcher = [[OADataFetcher alloc] init];
		
		[fetcher fetchDataWithRequest:request
							 delegate:self
					didFinishSelector:@selector(accessTokenTicket:didFinishWithData:)
					  didFailSelector:@selector(accessTokenTicket:didFailWithError:)];		
	}
	else {
		// Got some unknown page
		NSLog(@"SOURCE: %@", [[[[webView mainFrame] dataSource] representation] documentSource]);
	}
}

- (void)webView:(WebView *)sender didStartProvisionalLoadForFrame:(WebFrame *)frame {
	if ( [[webView mainFrameURL] rangeOfString:@"oauth_token"].location == NSNotFound ) {
		// Started loading something except the form, make sure webView is hidden now
		[webView setHidden:YES];
		[statusTextField setHidden:NO];		
		[statusTextField setStringValue:@"Logging in ..."];
	}
}

- (void)accessTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
	if (ticket.didSucceed) {
		NSString *responseBody = [[NSString alloc] initWithData:data
													   encoding:NSUTF8StringEncoding];
		
		OAToken *accessToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
		[statusTextField setStringValue:[NSString stringWithFormat:@"Token: %@", accessToken.key]];
	}
}

- (void)accessTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error {
	NSLog(@"ACCESS TOKEN ERRAR: %@", error);
}

@end
