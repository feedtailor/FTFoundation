//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import "FTNSStringKeyValueTest.h"
#import "FTNSString+KeyValue.h"

@implementation FTNSStringKeyValueTest

-(void) __test:(NSString*)original delimiter:(NSString*)delimiter correct:(NSDictionary*)correct
{
	NSDictionary* dic = [original ft_keyValueDictionaryWithDelimiter:delimiter];
	XCTAssertTrue([dic isEqualToDictionary:correct], @"%@ =\n%@", [dic description], [correct description]);
}

-(void) testKeyValue
{
	[self __test:@"a=b&c=d" delimiter:nil correct:[NSDictionary dictionaryWithObjectsAndKeys:@"b", @"a", @"d", @"c", nil]];
}

-(void) testKeyValueB
{
	[self __test:@"a=b,c=d" delimiter:@"," correct:[NSDictionary dictionaryWithObjectsAndKeys:@"b", @"a", @"d", @"c", nil]];
}

@end
