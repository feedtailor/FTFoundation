//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTSHA1 : NSObject
{
	void* context;
	unsigned char* buf;
}

-(void) addData:(NSData*)data;
-(void) addBytes:(const void*)buf length:(NSUInteger)length;
-(NSString*) sha1HashString;
-(NSData*) sha1HashData;

@end

@interface NSString (FTNSStringSHA1)

-(NSString*) ft_sha1HashString;
-(NSData*) ft_sha1HashData;

@end

@interface NSData (FTNSDataSHA1)

-(NSString*) ft_sha1HashString;
-(NSData*) ft_sha1HashData;

@end
