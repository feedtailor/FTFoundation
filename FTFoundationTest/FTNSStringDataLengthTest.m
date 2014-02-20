//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import "FTNSStringDataLengthTest.h"
#import "FTNSString+DataLength.h"

@implementation FTNSStringDataLengthTest

-(void) __test:(UInt64)length correct:(NSString*)correct
{
	NSString* str = [NSString ft_stringWithLength:length];
	XCTAssertTrue([str isEqualToString:correct], @"%@ = %@", str, correct);
}

-(void) __testShort:(UInt64)length correct:(NSString*)correct
{
	NSString* str = [NSString ft_shortStringWithLength:length];
	XCTAssertTrue([str isEqualToString:correct], @"%@ = %@", str, correct);
}

- (void)test
{
	[self __test:1024 correct:@"1.00 KB"];
	[self __testShort:1024 correct:@"1 K"];
	
	[self __test:34312324 correct:@"32.72 MB"];
	[self __testShort:34312324 correct:@"32 M"];
}

@end
