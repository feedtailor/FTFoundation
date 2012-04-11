//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTCRC : NSObject
{
	UInt32 CRC;
}

@property (nonatomic) UInt32 CRC;

-(void) updateWithData:(NSData*)data;
-(void) clear;

@end

@interface NSData (FTNSDataCRC)

-(UInt32) ft_CRC;

@end
