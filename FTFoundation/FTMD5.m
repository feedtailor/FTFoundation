//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import "FTMD5.h"
#import <CommonCrypto/CommonDigest.h>

static NSString* ft_md5HashString(unsigned char* inBuf, unsigned int inLen)
{
	unsigned char md[CC_MD5_DIGEST_LENGTH];
	CC_MD5(inBuf, inLen, md);
	
	NSMutableString* ret = [NSMutableString string];
	for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
		[ret appendFormat:@"%02x", md[i]];
	}
	return [NSString stringWithString:ret];
}

static NSData* ft_md5HashData(unsigned char* inBuf, unsigned int inLen)
{
	unsigned char md[CC_MD5_DIGEST_LENGTH];
	CC_MD5(inBuf, inLen, md);
	
	return [NSData dataWithBytes:md length:CC_MD5_DIGEST_LENGTH];	
}

@implementation FTMD5

-(id) init
{
	self = [super init];
	if (self) {
		buf = nil;
		context = malloc(sizeof(CC_MD5_CTX));
		CC_MD5_Init((CC_MD5_CTX*)context);
	}
	return self;
}

-(void) dealloc
{
	if (context) {
		free(context);
	}
	if (buf) {
		free(buf);
	}
}

-(void) addData:(NSData*)data
{
	[self addBytes:[data bytes] length:[data length]];
}

-(void) addBytes:(const void*)bytes length:(NSUInteger)length
{
	CC_MD5_Update((CC_MD5_CTX*)context, bytes, length);
}

-(void) __createBufferIfNeeded
{
	if (!buf) {
		buf = malloc(CC_MD5_DIGEST_LENGTH);
		CC_MD5_Final(buf, (CC_MD5_CTX*)context);	
	}
}

-(NSString*) md5HashString
{
	[self __createBufferIfNeeded];

	NSMutableString* ret = [NSMutableString string];
	for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
		[ret appendFormat:@"%02x", buf[i]];
	}
	return [NSString stringWithString:ret];	
}

-(NSData*) md5HashData
{
	[self __createBufferIfNeeded];

	return [NSData dataWithBytes:buf length:CC_MD5_DIGEST_LENGTH];	
}	

@end

@implementation NSString (FTNSStringMD5)

-(NSString*) ft_md5HashString
{
	return [[self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO] ft_md5HashString];
}

-(NSData*) ft_md5HashData
{
	return [[self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO] ft_md5HashData];
}

@end

@implementation NSData (FTNSDataMD5)

-(NSString*) ft_md5HashString
{
	return ft_md5HashString((unsigned char*)[self bytes], [self length]);
}

-(NSData*) ft_md5HashData
{
	return ft_md5HashData((unsigned char*)[self bytes], [self length]);
}

@end
