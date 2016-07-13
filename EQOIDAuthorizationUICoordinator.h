//
//  EQOIDAuthorizationUICoordinator.h
//  Hermes
//
//  Created by Marc Haisenko on 11/07/16.
//  Copyright © 2016 equinux AG. All rights reserved.
//

#import <AppKit/AppKit.h>
#import <WebKit/WebKit.h>

#import "OIDAuthorizationService.h"
#import "OIDAuthorizationUICoordinator.h"


NS_ASSUME_NONNULL_BEGIN

/** Callback: present the given authorization view.

 @param viewToPresent The login view to present.

 @param session Authorization session. Use this to cancel the session externally (for example, when
    presenting the UI in a popover and the popover is closed before the login process has finished).
 */
typedef void (^EQOIDPresentationCallback) (NSView * viewToPresent, id<OIDAuthorizationFlowSession> session);

/** Callback: dismiss the given authorization view.

 @param viewToDismiss The login view to dismiss.

 @param completion A block that needs to be executed once the dismissal has finished.
 */
typedef void (^EQOIDDismissalCallback) (NSView * viewToDismiss, void (^completion)());


/** Simple generic UI coordinator presenting a WKWebView.
 */
@interface EQOIDAuthorizationUICoordinator : NSObject<OIDAuthorizationUICoordinator>

/** Designated initializer.

 @param processPool Shared process pool for the internal web view. Required to share the cookies
    with other web view instances.

 @param redirectURL The URL to which the login flow should redirect to. Required to detect the
    end of the flow without requiring to register a custom URL scheme.

 @param presentation Block that presents the web view for login.

 @param dismissal Block that dismisses the presented view.
 */
- (instancetype)initWithProcessPool:(WKProcessPool *)processPool
                        redirectURL:(NSURL *)redirectURL
                       presentation:(EQOIDPresentationCallback)presentation
                          dismissal:(EQOIDDismissalCallback)dismissal;

@end

NS_ASSUME_NONNULL_END