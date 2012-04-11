//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSHTTPCookieStorage (FTNSHTTPCookieStorageDelete)

-(void) ft_deleteCookiesForDomains:(NSArray*)domains;

@end
