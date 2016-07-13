//
//  EQOIDAuthorizationUICoordinator.m
//  Hermes
//
//  Created by Marc Haisenko on 11/07/16.
//  Copyright © 2016 equinux AG. All rights reserved.
//

#import "EQOIDAuthorizationUICoordinator.h"

#if !__has_feature(objc_arc)
#error Need ARC!
#endif


@interface EQOIDAuthorizationUICoordinator () <WKNavigationDelegate>
@property (copy) EQOIDPresentationCallback presentation;
@property (copy) EQOIDDismissalCallback dismissal;
@property (strong) NSURL * redirectURL;
@property (strong) WKWebView * webView;
@property (weak) id<OIDAuthorizationFlowSession> session;
@end

@implementation EQOIDAuthorizationUICoordinator

- (instancetype)initWithProcessPool:(WKProcessPool *)processPool
						redirectURL:(NSURL *)redirectURL
					   presentation:(EQOIDPresentationCallback)presentation
						  dismissal:(EQOIDDismissalCallback)dismissal
{
	self = [super init];
	if (!self) return nil;

	self.redirectURL = redirectURL;
	self.presentation = presentation;
	self.dismissal = dismissal;

	WKWebViewConfiguration * config = [[WKWebViewConfiguration alloc] init];
	config.processPool = processPool;

	self.webView = [[WKWebView alloc] initWithFrame:NSMakeRect(0, 0, 100, 100) configuration:config];
	self.webView.navigationDelegate = self;

	return self;
}

- (BOOL)presentAuthorizationWithURL:(NSURL *)URL session:(id<OIDAuthorizationFlowSession>)session
{
	if (self.session) {
		// Authorization UI is still being presented.
		// Do we need to fail with an error or is it enough to simply return NO?
		return NO;
	}
	if (!self.presentation) {
		// Cannot present, callback is missing.
		// Do we need to fail with an error or is it enough to simply return NO?
		return NO;
	}

	self.session = session;

	self.presentation(self.webView, session);
	[self.webView loadRequest:[NSURLRequest requestWithURL:URL]];

	return YES;
}

- (void)dismissAuthorizationAnimated:(BOOL)animated completion:(void (^)(void))completion
{
	self.session = nil;
	if (self.dismissal) {
		self.dismissal(self.webView, completion);
	}
}

#define MY_EQUAL(left, right) (left == right || [left isEqual:right])

- (void)webView:(WKWebView *)webView
	decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
	decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
	NSURL *URL = navigationAction.request.URL;
	BOOL isURLMatching =
		MY_EQUAL(URL.scheme, self.redirectURL.scheme)
		&& MY_EQUAL(URL.host, self.redirectURL.host)
		&& MY_EQUAL(URL.port, self.redirectURL.port)
		&& MY_EQUAL(URL.path, self.redirectURL.path)
		;

	if (isURLMatching) {
		decisionHandler(WKNavigationActionPolicyCancel);
		[self.session resumeAuthorizationFlowWithURL:URL];
	} else {
		decisionHandler(WKNavigationActionPolicyAllow);
	}
}

@end
