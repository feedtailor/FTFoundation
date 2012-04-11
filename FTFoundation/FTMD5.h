//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTMD5 : NSObject
{
	void* context;
	unsigned char* buf;
}

-(void) addData:(NSData*)data;
-(void) addBytes:(const void*)buf length:(NSUInteger)length;
-(NSString*) md5HashString;
-(NSData*) md5HashData;

@end

@interface NSString (FTNSStringMD5)

-(NSString*) ft_md5HashString;
-(NSData*) ft_md5HashData;

@end

@interface NSData (FTNSDataMD5)

-(NSString*) ft_md5HashString;
-(NSData*) ft_md5HashData;

@end
