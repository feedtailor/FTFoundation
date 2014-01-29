//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import "FTNSData+GZip.h"

#import <zlib.h>

static char gz_magic[2] = { '\x1f', '\x8b'};
#define ASCII_FLAG   0x01 /* bit 0 set: file probably ascii text */
#define HEAD_CRC     0x02 /* bit 1 set: header CRC present */
#define EXTRA_FIELD  0x04 /* bit 2 set: extra field present */
#define ORIG_NAME    0x08 /* bit 3 set: original file name present */
#define COMMENT      0x10 /* bit 4 set: file comment present */
#define RESERVED     0xE0 /* bits 5..7: reserved */

static inline int __ft_check(const char *buf, int len)
{
	if(buf[0] != gz_magic[0] || buf[1] != gz_magic[1]) {
		return -1;
	}
	int i = 2;
	int method = buf[i++];
	int flags  = buf[i++];
	if (method != Z_DEFLATED || (flags & RESERVED) != 0) {
		return -1;
	}
	i+=6;
	
	if (flags & EXTRA_FIELD) { /* skip the extra field */
		int len = 0;
		len  =  (uInt)buf[i++];
		len += ((uInt)buf[i++])<<8;
		/* len is garbage if EOF but the loop below will quit anyway */
		i+=len;
	}
	if (flags & ORIG_NAME) { /* skip the original file name */
		while (buf[i++] !=0) ;
	}
	if (flags & COMMENT) {   /* skip the .gz file comment */
		while (buf[i++] != 0) ;
	}
	if (flags & HEAD_CRC) {  /* skip the header crc */
		i+=2;
	}
	return i;
} 

@implementation NSData (FTNSDataGZip)

-(NSData*) ft_inflatedData
{
	const char* inBuf = [self bytes];
	NSParameterAssert([self length] <= INT_MAX);
	int inLen = (int)[self length];
	
	int ret =  __ft_check(inBuf, inLen);
	if (ret >= 0) {
		inBuf += ret;
		inLen -= ret;
	} else {
		NSLog(@"fail to check gzipped data");
		return nil;
	}
	
	NSMutableData* outData = [NSMutableData data];
	z_stream z;
	z.zalloc = Z_NULL;
	z.zfree = Z_NULL;
	z.opaque = Z_NULL;
	
	if (inflateInit2(&z, -MAX_WBITS) != Z_OK) {
		NSLog(@"fail to inflateInit");
		return nil;
	}
	
	unsigned char* outbuf = (unsigned char*)calloc(1, inLen);
	
	z.avail_in = inLen;
	z.next_in = (unsigned char*)inBuf;
	z.next_out = outbuf;
	z.avail_out = inLen;
	
	while (1) {
		
		ret = inflate(&z, Z_NO_FLUSH);
		
		if (ret == Z_STREAM_END) {
			break;
		}
		if (ret != Z_OK) {
			NSLog(@"%s", z.msg);
			return nil;
		}
		if (z.avail_out == 0) {
			[outData appendBytes:outbuf length:inLen];
			z.next_out = outbuf;
			z.avail_out = inLen;
		}
	}
	
	if (inLen != z.avail_out) {
		[outData appendBytes:outbuf length:inLen - z.avail_out];
	}
	
	inflateEnd(&z);
	free(outbuf);
	
	return outData;	
}

@end
