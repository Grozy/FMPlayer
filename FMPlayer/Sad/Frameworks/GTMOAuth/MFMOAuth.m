//
//  MFMOAuth.m
//  Moe FM
//
//  Created by Greg Wang on 12-8-15.
//
//

#import "MFMOAuth.h"
#import "GTMOAuthSignIn.h"
#import "GTMOAuthAuthentication.h"
#import "GTMOAuthViewControllerTouch.h"

NSString * MFMOAuthStatusChangedNotification = @"MFMOAuthStatusChangedNotification";

NSString * const kConsumerKey = @"05de60db933221b8b260d43f85a78b2b053d4afa3";
NSString * const kConsumerSecret = @"1e56bda1863c23bdb1843022199028a9";
NSString * const kServiceName = @"Moe FM";
NSString * const kAppServiceName = @"Moe FM: Moe FM";

NSString * const kSavedConsumerKey = @"SavedConsumerKey";

@interface MFMOAuth ()

@property (strong, nonatomic) GTMOAuthAuthentication *authentication;

@end

@implementation MFMOAuth

@synthesize authentication = _authentication;

- (GTMOAuthAuthentication *)authentication
{
	if (_authentication == nil) {
		_authentication = [[GTMOAuthAuthentication alloc] initWithSignatureMethod:kGTMOAuthSignatureMethodHMAC_SHA1 consumerKey:kConsumerKey privateKey:kConsumerSecret];
		_authentication.serviceProvider = kServiceName;
	}
	return _authentication;
}

- (BOOL)canAuthorize
{
	return [self.authentication canAuthorize];
}

#pragma mark - life cycle

+ (MFMOAuth *)sharedOAuth
{
	static MFMOAuth *oauth = nil;
	if (oauth == nil) {
		oauth = [[MFMOAuth alloc] init];
	}
	return oauth;
}

- (MFMOAuth *)init
{
	self = [super init];
	if (self != nil) {
		NSString *prevConsumerKey = [[NSUserDefaults standardUserDefaults] stringForKey:kSavedConsumerKey];
		if (prevConsumerKey == nil || ![prevConsumerKey isEqualToString:kConsumerKey]) {
			NSLog(@"Failed to match ComsumerKey, sign out. ");
			[self signOut];
		} else {
			[self updateFromKeychain];
		}
		[[NSUserDefaults standardUserDefaults] setValue:kConsumerKey forKey:kSavedConsumerKey];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	return self;
}

- (void)updateFromKeychain
{
	BOOL couldAuthorize = self.canAuthorize;
	[GTMOAuthViewControllerTouch authorizeFromKeychainForName:kAppServiceName
											   authentication:self.authentication];
	if (couldAuthorize != self.canAuthorize) {
		[[NSNotificationCenter defaultCenter] postNotificationName:MFMOAuthStatusChangedNotification object:self];
	}
}

- (void)signInWithNavigationController:(UIViewController *)controller
{
	NSURL *requestURL = [NSURL URLWithString:@"http://api.moefou.org/oauth/request_token"];
	NSURL *accessURL = [NSURL URLWithString:@"http://api.moefou.org/oauth/access_token"];
	NSURL *authorizeURL = [NSURL URLWithString:@"http://api.moefou.org/oauth/authorize"];
	NSString *scope = @"http://api.moefou.org";
	
	if (self.canAuthorize) {
		return;
	}
	
	[self.authentication setCallback:@"moefm://oauth/success"];
	
	GTMOAuthViewControllerTouch *viewController;
	viewController = [[GTMOAuthViewControllerTouch alloc] initWithScope:scope
															   language:nil
														requestTokenURL:requestURL
													  authorizeTokenURL:authorizeURL
														 accessTokenURL:accessURL
														 authentication:self.authentication
														 appServiceName:kAppServiceName
															   delegate:self
													   finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [controller presentViewController:navigationController animated:YES completion:nil];
	return;
}

- (void)signOut
{
	[GTMOAuthViewControllerTouch removeParamsFromKeychainForName:kAppServiceName];
	[self updateFromKeychain];
}

- (void)viewController:(GTMOAuthViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuthAuthentication *)auth
                 error:(NSError *)error {
	if (error != nil) {
		// Authentication failed
		NSLog(@"OAuth failed with error: %@", error.localizedDescription);
	} else {
		// Authentication succeeded
		[[NSNotificationCenter defaultCenter] postNotificationName:MFMOAuthStatusChangedNotification object:self];
	}
}

- (BOOL)authorizeRequest:(NSMutableURLRequest *)urlRequest
{
	if (self.canAuthorize) {
		[self.authentication authorizeRequest:urlRequest];
		return YES;
	}
	return NO;
}

@end
