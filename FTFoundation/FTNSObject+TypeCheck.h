//
//  Copyright (c) 2012 feedtailor inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (FTNSObjectTypeCheck)

- (BOOL)ft_isNSDictionary;
- (BOOL)ft_isNSArray;
- (BOOL)ft_isNSString;
- (BOOL)ft_isNSNumber;
- (BOOL)ft_isNSNumberBool;
- (BOOL)ft_isNSDate;
- (BOOL)ft_isNSNull;

@end
