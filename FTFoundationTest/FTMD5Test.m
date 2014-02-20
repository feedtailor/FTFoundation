//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import "FTMD5Test.h"
#import "FTMD5.h"
#import "Common.h"

@implementation FTMD5Test

// All code under test must be linked into the Unit Test bundle
- (void)testEncode
{
	NSData* d = [TEST_TEXT dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
	NSString* encoded = [d ft_md5HashString];
	NSString* correct = @"abf3118241a86cb15adc153f8cb3d85b";
	XCTAssertTrue([encoded isEqualToString:correct], @"%@ = %@", encoded, correct);
	
	encoded = [TEST_TEXT ft_md5HashString];
	XCTAssertTrue([encoded isEqualToString:correct], @"%@ = %@", encoded, correct);
}

-(void) testEncode2
{
	FTMD5* md5 = [[FTMD5 alloc] init];
	NSData* d = [TEST_TEXT dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
	[md5 addData:d];
	NSString* encoded = [md5 md5HashString];
	NSString* correct = @"abf3118241a86cb15adc153f8cb3d85b";
	XCTAssertTrue([encoded isEqualToString:correct], @"%@ = %@", encoded, correct);
}

@end
