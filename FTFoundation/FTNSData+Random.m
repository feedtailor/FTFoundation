//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import "FTNSData+Random.h"
#import <Security/Security.h>

@implementation NSData (FTNSDataRandom)

+ (NSData *)ft_randomDataWithLength:(NSUInteger)length
{
	NSMutableData *buffer = [NSMutableData dataWithLength:length];
	int status = SecRandomCopyBytes(kSecRandomDefault, length, [buffer mutableBytes]);
	if(status == 0) {
		return buffer;
	}
	
	return nil;
}

@end
