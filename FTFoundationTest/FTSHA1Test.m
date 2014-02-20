//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FTSHA1.h"
#import "Common.h"

@interface FTSHA1Test : XCTestCase
@end

@implementation FTSHA1Test

// All code under test must be linked into the Unit Test bundle
- (void)testEncode
{
	NSData* d = [TEST_TEXT dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
	NSString* encoded = [d ft_sha1HashString];
	NSString* correct = @"b198a2818170188d5700dc0d20d7fbf042ddc78a";
	XCTAssertTrue([encoded isEqualToString:correct], @"%@ = %@", encoded, correct);
	
	encoded = [TEST_TEXT ft_sha1HashString];
	XCTAssertTrue([encoded isEqualToString:correct], @"%@ = %@", encoded, correct);
}

-(void) testEncode2
{
	FTSHA1* sha1 = [[FTSHA1 alloc] init];
	NSData* d = [TEST_TEXT dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
	[sha1 addData:d];
	NSString* encoded = [sha1 sha1HashString];
	NSString* correct = @"b198a2818170188d5700dc0d20d7fbf042ddc78a";
	XCTAssertTrue([encoded isEqualToString:correct], @"%@ = %@", encoded, correct);
}

@end
