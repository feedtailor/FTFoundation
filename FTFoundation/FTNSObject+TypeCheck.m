//
//  Copyright (c) 2012 feedtailor inc. All rights reserved.
//

#import "FTNSObject+TypeCheck.h"

@implementation NSObject (FTNSObjectTypeCheck)

- (BOOL)ft_isNSDictionary
{
	return [self isKindOfClass:[NSDictionary class]];
}

- (BOOL)ft_isNSArray
{
	return [self isKindOfClass:[NSArray class]];
}

- (BOOL)ft_isNSString
{
	return [self isKindOfClass:[NSString class]];
}

- (BOOL)ft_isNSNumber
{
	return [self isKindOfClass:[NSNumber class]];
}

- (BOOL)ft_isNSNumberBool
{
	if(self == (id)kCFBooleanFalse || self == (id)kCFBooleanTrue) {
		return YES;
	}

	return NO;
}

- (BOOL)ft_isNSDate
{
	return [self isKindOfClass:[NSDate class]];
}

- (BOOL)ft_isNSNull
{
	return [self isKindOfClass:[NSNull class]];
}

@end
