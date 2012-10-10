//
//  FTTypeCheckKeyPathTest.m
//  FTFoundation
//
//  Created by fujishige on 2012/08/02.
//  Copyright (c) 2012年 feedtailor inc. All rights reserved.
//

#import "FTTypeCheckKeyPathTest.h"
#import "FTNSDictionary+TypeCheckKeyPath.h"

@implementation FTTypeCheckKeyPathTest
{
	NSDictionary *_data;
}

- (void)setUp
{
	_data = @{
	@"string" : @"test",
	@"number" : @10,
	@"true" : [NSNumber numberWithBool:YES],
	@"false" : [NSNumber numberWithBool:NO],
	@"null" : [NSNull null],
	@"array" : @[@1, @2, @3],
	@"dictionary" : @{
		@"nest1" : @{
			@"nest2" : @{
				@"string" : @"test",
				@"number" : @10,
				@"true" : [NSNumber numberWithBool:YES],
				@"false" : [NSNumber numberWithBool:NO],
				@"null" : [NSNull null],
				@"array" : @[@1, @2, @3],
				},
			},
		}
	};
}

- (void)tearDown
{
	_data = nil;
}

#pragma mark -

- (void)testLF
{
	STAssertNotNil([_data ft_objectForKeyPath:@"string"], nil);
	STAssertNotNil([_data ft_objectForKeyPath:@"number"], nil);
	STAssertNotNil([_data ft_objectForKeyPath:@"true"], nil);
	STAssertNotNil([_data ft_objectForKeyPath:@"false"], nil);
	STAssertNotNil([_data ft_objectForKeyPath:@"null"], nil);
	STAssertNotNil([_data ft_objectForKeyPath:@"array"], nil);
	STAssertNotNil([_data ft_objectForKeyPath:@"dictionary"], nil);
	STAssertNotNil([_data ft_objectForKeyPath:@"dictionary.nest1"], nil);
	STAssertNotNil([_data ft_objectForKeyPath:@"dictionary.nest1.nest2"], nil);
	STAssertNotNil([_data ft_objectForKeyPath:@"dictionary.nest1.nest2.string"], nil);
	STAssertNotNil([_data ft_objectForKeyPath:@"dictionary.nest1.nest2.number"], nil);
	STAssertNotNil([_data ft_objectForKeyPath:@"dictionary.nest1.nest2.true"], nil);
	STAssertNotNil([_data ft_objectForKeyPath:@"dictionary.nest1.nest2.false"], nil);
	STAssertNotNil([_data ft_objectForKeyPath:@"dictionary.nest1.nest2.null"], nil);
	STAssertNotNil([_data ft_objectForKeyPath:@"dictionary.nest1.nest2.array"], nil);

	STAssertNil([_data ft_objectForKeyPath:@"foo"], nil);
	STAssertNil([_data ft_objectForKeyPath:@"dictionary.foo"], nil);
	STAssertNil([_data ft_objectForKeyPath:@"dictionary.nest1.foo"], nil);

	STAssertNil([_data ft_objectForKeyPath:@"string.foo"], nil);
	STAssertNil([_data ft_objectForKeyPath:@"number.foo"], nil);
	STAssertNil([_data ft_objectForKeyPath:@"true.foo"], nil);

	STAssertNotNil([_data ft_stringForKeyPath:@"string"], nil);
	STAssertNotNil([_data ft_numberForKeyPath:@"number"], nil);
	STAssertNotNil([_data ft_boolForKeyPath:@"true"], nil);
	STAssertNotNil([_data ft_boolForKeyPath:@"false"], nil);
	STAssertNotNil([_data ft_nullForKeyPath:@"null"], nil);
	STAssertNotNil([_data ft_arrayForKeyPath:@"array"], nil);
	STAssertNotNil([_data ft_dictionaryForKeyPath:@"dictionary"], nil);
	STAssertNotNil([_data ft_dictionaryForKeyPath:@"dictionary.nest1"], nil);
	STAssertNotNil([_data ft_dictionaryForKeyPath:@"dictionary.nest1.nest2"], nil);
	STAssertNotNil([_data ft_stringForKeyPath:@"dictionary.nest1.nest2.string"], nil);
	STAssertNotNil([_data ft_numberForKeyPath:@"dictionary.nest1.nest2.number"], nil);
	STAssertNotNil([_data ft_boolForKeyPath:@"dictionary.nest1.nest2.true"], nil);
	STAssertNotNil([_data ft_boolForKeyPath:@"dictionary.nest1.nest2.false"], nil);
	STAssertNotNil([_data ft_nullForKeyPath:@"dictionary.nest1.nest2.null"], nil);
	STAssertNotNil([_data ft_arrayForKeyPath:@"dictionary.nest1.nest2.array"], nil);

	STAssertNil([_data ft_numberForKeyPath:@"string"], nil);
	STAssertNil([_data ft_stringForKeyPath:@"number"], nil);
	STAssertNil([_data ft_stringForKeyPath:@"true"], nil);
	STAssertNil([_data ft_stringForKeyPath:@"false"], nil);
	STAssertNil([_data ft_numberForKeyPath:@"null"], nil);
	STAssertNil([_data ft_numberForKeyPath:@"array"], nil);
	STAssertNil([_data ft_numberForKeyPath:@"dictionary"], nil);

	STAssertNil([_data ft_numberForKeyPath:@"dictionary.nest1.nest2.string"], nil);
	STAssertNil([_data ft_stringForKeyPath:@"dictionary.nest1.nest2.number"], nil);
	STAssertNil([_data ft_stringForKeyPath:@"dictionary.nest1.nest2.true"], nil);
	STAssertNil([_data ft_stringForKeyPath:@"dictionary.nest1.nest2.false"], nil);
	STAssertNil([_data ft_numberForKeyPath:@"dictionary.nest1.nest2.null"], nil);
	STAssertNil([_data ft_numberForKeyPath:@"dictionary.nest1.nest2.array"], nil);

	STAssertNil([_data ft_boolForKeyPath:@"number"], nil);

	STAssertNil([_data ft_stringForKeyPath:@"string" lengthRange:NSMakeRange(0, 3)], nil);
	STAssertNil([_data ft_stringForKeyPath:@"string" lengthRange:NSMakeRange(0, 4)], nil);
	STAssertNotNil([_data ft_stringForKeyPath:@"string" lengthRange:NSMakeRange(0, 5)], nil);
	STAssertNotNil([_data ft_stringForKeyPath:@"string" lengthRange:NSMakeRange(2, 10)], nil);
	STAssertNil([_data ft_stringForKeyPath:@"string" lengthRange:NSMakeRange(10, 4)], nil);

	STAssertNil([_data ft_arrayForKeyPath:@"array" countRange:NSMakeRange(0, 2)], nil);
	STAssertNil([_data ft_arrayForKeyPath:@"array" countRange:NSMakeRange(0, 3)], nil);
	STAssertNotNil([_data ft_arrayForKeyPath:@"array" countRange:NSMakeRange(0, 4)], nil);
	STAssertNotNil([_data ft_arrayForKeyPath:@"array" countRange:NSMakeRange(1, 4)], nil);
	STAssertNil([_data ft_arrayForKeyPath:@"array" countRange:NSMakeRange(10, 4)], nil);

	STAssertNotNil([_data ft_numberForKeyPath:@"number" minimum:@-1 maximum:nil], nil);
	STAssertNotNil([_data ft_numberForKeyPath:@"number" minimum:@5 maximum:nil], nil);
	STAssertNotNil([_data ft_numberForKeyPath:@"number" minimum:@9 maximum:nil], nil);
	STAssertNotNil([_data ft_numberForKeyPath:@"number" minimum:@10 maximum:nil], nil);
	STAssertNil([_data ft_numberForKeyPath:@"number" minimum:@11 maximum:nil], nil);

	STAssertNil([_data ft_numberForKeyPath:@"number" minimum:nil maximum:@-1], nil);
	STAssertNil([_data ft_numberForKeyPath:@"number" minimum:nil maximum:@5], nil);
	STAssertNil([_data ft_numberForKeyPath:@"number" minimum:nil maximum:@9], nil);
	STAssertNotNil([_data ft_numberForKeyPath:@"number" minimum:nil maximum:@10], nil);
	STAssertNotNil([_data ft_numberForKeyPath:@"number" minimum:nil maximum:@11], nil);

	STAssertNil([_data ft_numberForKeyPath:@"number" minimum:@0 maximum:@5], nil);
	STAssertNil([_data ft_numberForKeyPath:@"number" minimum:@5 maximum:@9], nil);
	STAssertNotNil([_data ft_numberForKeyPath:@"number" minimum:@-1 maximum:@11], nil);
	STAssertNotNil([_data ft_numberForKeyPath:@"number" minimum:@5 maximum:@15], nil);
}

@end
