//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTCharacterEncodingTool : NSObject
{
	NSLocale* locale;
}
@property (nonatomic, retain) NSLocale* locale;


+(NSString*) IANANameWithEncoding:(NSStringEncoding)encoding;

-(NSStringEncoding) detectEncodingWithData:(NSData*)data;
-(NSStringEncoding) detectEncodingWithBytes:(void*)bytes length:(size_t)length;

@end
