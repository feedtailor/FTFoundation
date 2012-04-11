//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import "FTNSString+Encode.h"

#define FTNSSTRING_ESCAPED_RFC3986	@"!*'();:@&=+$,/?#[]%"

@implementation NSString (FTNSStringEncode)

-(NSString*) ft_stringByURLEncode
{
	return [self ft_stringByURLEncodeWithEscapeCharacters:FTNSSTRING_ESCAPED_RFC3986];
}

-(NSString*) ft_stringByURLEncodeWithEscapeCharacters:(NSString*)toBeEscaped
{
	CFStringRef encoded = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)self, nil, (__bridge CFStringRef)toBeEscaped, kCFStringEncodingUTF8);
	NSString* ret = CFBridgingRelease(encoded);
	return ret;
}

-(NSString*) ft_stringByURLDecode
{
	return [self ft_stringByURLDecodeWithEscapeCharacters:@""];
}

-(NSString*) ft_stringByURLDecodeWithEscapeCharacters:(NSString*)toBeEscaped
{
	CFStringRef decoded = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (__bridge CFStringRef)self, (__bridge CFStringRef)toBeEscaped, kCFStringEncodingUTF8);
	NSString* ret = CFBridgingRelease(decoded);
	return ret;
}

@end
