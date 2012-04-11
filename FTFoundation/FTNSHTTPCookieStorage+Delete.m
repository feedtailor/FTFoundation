//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import "FTNSHTTPCookieStorage+Delete.h"

@implementation NSHTTPCookieStorage (FTNSHTTPCookieStorageDelete)

-(void) ft_deleteCookiesForDomains:(NSArray*)domains
{
	for (NSHTTPCookie* cookie in self.cookies) {
		NSString* _domain = [cookie domain];
		for (NSString* domain in domains) {
			if ([_domain rangeOfString:domain options:NSCaseInsensitiveSearch].location != NSNotFound) {
				[self deleteCookie:cookie];
				break;
			}
		}
	}
}
@end
