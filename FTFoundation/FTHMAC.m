//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import "FTHMAC.h"

@implementation NSString (FTNSStringHMAC)

static NSUInteger __ft_digestLength(CCHmacAlgorithm algorithm) {
	switch (algorithm) {
		case kCCHmacAlgSHA1 :
			return CC_SHA1_DIGEST_LENGTH;
		case kCCHmacAlgMD5 :
			return CC_MD5_DIGEST_LENGTH;
		case kCCHmacAlgSHA256 :
			return CC_SHA256_DIGEST_LENGTH;
		case kCCHmacAlgSHA384 :
			return CC_SHA384_DIGEST_LENGTH;
		case kCCHmacAlgSHA512 :
			return CC_SHA512_DIGEST_LENGTH;
		case kCCHmacAlgSHA224 :
			return CC_SHA224_DIGEST_LENGTH;
		default:
			break;
	}
	return 0;
}

static BOOL __ft_hmac(CCHmacAlgorithm algorithm, const char* key, const char* data, char** digest, NSUInteger* digestLength)
{
	NSUInteger len = __ft_digestLength(algorithm);
	if (len == 0) {
		return NO;
	}
	char* buf = malloc(len);
	CCHmac(algorithm, key, strlen(key), data, strlen(data), buf);
	*digest = buf;
	*digestLength = len;
	return YES;
}

-(NSString*) ft_hmacDigestStringWithKey:(NSString*)key algorithm:(CCHmacAlgorithm)algorithm
{
	char* digest;
	NSUInteger digestLen;
	if (__ft_hmac(algorithm, [key UTF8String], [self UTF8String], &digest, &digestLen)) {
		NSMutableString* ret = [NSMutableString string];
		for (int i = 0; i < digestLen; i++) {
			[ret appendFormat:@"%02x", ((unsigned char *)digest)[i]];
		}
		free(digest);
		return ret;
	}
	return nil;
}

-(NSData*) ft_hmacDigestDataWithKey:(NSString*)key algorithm:(CCHmacAlgorithm)algorithm
{
	char* digest;
	NSUInteger digestLen;
	if (__ft_hmac(algorithm, [key UTF8String], [self UTF8String], &digest, &digestLen)) {
		NSData* ret = [NSData dataWithBytes:digest length:digestLen];
		free(digest);
		return ret;
	}
	return nil;	
}

@end
