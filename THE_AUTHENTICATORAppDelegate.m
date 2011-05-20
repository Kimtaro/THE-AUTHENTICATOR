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
@synthesize preparingTextField;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Setup consumer and URL
	OAConsumer *consumer = [[OAConsumer alloc] initWithKey:kConsumerKey
                                                    secret:kConsumerSecret];
	
    NSURL *url = [NSURL URLWithString:kRequestTokenURL];
	
	// Setup webView
	[webView setFrameLoadDelegate:self];
	
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

		OAToken *requestToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
		
		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?oauth_token=%@", kAuthorizeURL, [requestToken key]]];
		[[webView mainFrame] loadRequest:[NSURLRequest requestWithURL:url]];
	}
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error {
	NSLog(@"ERRAR: %@", error);
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame {
	// Restyle
	[webView stringByEvaluatingJavaScriptFromString:@"\
	  document.getElementsByTagName('style')[0].innerHTML = '\
		h2, #top-bar, .app-info, .permissions, .footer { display:none; }\
		body { background-image: none; background-color: #EDEDED; }\
		#bd { border-width: 0; }\
	    .auth { border-width: 0; margin: 0; padding: 0; width: 100%; }\
	  '\
	"];
	
	// Draw it
	[webView setHidden:NO];
	[preparingTextField setHidden:YES];

}

@end
