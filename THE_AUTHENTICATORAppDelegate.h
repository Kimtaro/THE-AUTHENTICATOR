//
//  THE_AUTHENTICATORAppDelegate.h
//  THE AUTHENTICATOR
//
//  Created by Kim Ahlström on 2011-05-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <OAuthConsumer/OAuthConsumer.h>
#import <WebKit/WebKit.h>

@interface THE_AUTHENTICATORAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification;
- (void)requestTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data;
- (void)requestTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error;

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet WebView *webView;
@property (assign) IBOutlet NSTextField *preparingTextField;

@end
