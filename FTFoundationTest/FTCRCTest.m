//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import "FTCRCTest.h"
#import "FTCRC.h"
#import "Common.h"

@implementation FTCRCTest

// All code under test must be linked into the Unit Test bundle
- (void)testEncode
{
	NSData* d = [TEST_TEXT dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
	UInt32 crc = [d ft_CRC];
	UInt32 correct = 391512288;
	STAssertTrue(crc == correct, @"%lu = %lu", crc, correct);
}

@end
