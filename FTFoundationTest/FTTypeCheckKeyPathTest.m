//
//  FTTypeCheckKeyPathTest.m
//  FTFoundation
//
//  Created by fujishige on 2012/08/02.
//  Copyright (c) 2012年 feedtailor inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FTNSDictionary+TypeCheckKeyPath.h"

@interface FTTypeCheckKeyPathTest : XCTestCase
@end

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
	XCTAssertNotNil([_data ft_objectForKeyPath:@"string"]);
	XCTAssertNotNil([_data ft_objectForKeyPath:@"number"]);
	XCTAssertNotNil([_data ft_objectForKeyPath:@"true"]);
	XCTAssertNotNil([_data ft_objectForKeyPath:@"false"]);
	XCTAssertNotNil([_data ft_objectForKeyPath:@"null"]);
	XCTAssertNotNil([_data ft_objectForKeyPath:@"array"]);
	XCTAssertNotNil([_data ft_objectForKeyPath:@"dictionary"]);
	XCTAssertNotNil([_data ft_objectForKeyPath:@"dictionary.nest1"]);
	XCTAssertNotNil([_data ft_objectForKeyPath:@"dictionary.nest1.nest2"]);
	XCTAssertNotNil([_data ft_objectForKeyPath:@"dictionary.nest1.nest2.string"]);
	XCTAssertNotNil([_data ft_objectForKeyPath:@"dictionary.nest1.nest2.number"]);
	XCTAssertNotNil([_data ft_objectForKeyPath:@"dictionary.nest1.nest2.true"]);
	XCTAssertNotNil([_data ft_objectForKeyPath:@"dictionary.nest1.nest2.false"]);
	XCTAssertNotNil([_data ft_objectForKeyPath:@"dictionary.nest1.nest2.null"]);
	XCTAssertNotNil([_data ft_objectForKeyPath:@"dictionary.nest1.nest2.array"]);

	XCTAssertNil([_data ft_objectForKeyPath:@"foo"]);
	XCTAssertNil([_data ft_objectForKeyPath:@"dictionary.foo"]);
	XCTAssertNil([_data ft_objectForKeyPath:@"dictionary.nest1.foo"]);

	XCTAssertNil([_data ft_objectForKeyPath:@"string.foo"]);
	XCTAssertNil([_data ft_objectForKeyPath:@"number.foo"]);
	XCTAssertNil([_data ft_objectForKeyPath:@"true.foo"]);

	XCTAssertNotNil([_data ft_stringForKeyPath:@"string"]);
	XCTAssertNotNil([_data ft_numberForKeyPath:@"number"]);
	XCTAssertNotNil([_data ft_boolForKeyPath:@"true"]);
	XCTAssertNotNil([_data ft_boolForKeyPath:@"false"]);
	XCTAssertNotNil([_data ft_nullForKeyPath:@"null"]);
	XCTAssertNotNil([_data ft_arrayForKeyPath:@"array"]);
	XCTAssertNotNil([_data ft_dictionaryForKeyPath:@"dictionary"]);
	XCTAssertNotNil([_data ft_dictionaryForKeyPath:@"dictionary.nest1"]);
	XCTAssertNotNil([_data ft_dictionaryForKeyPath:@"dictionary.nest1.nest2"]);
	XCTAssertNotNil([_data ft_stringForKeyPath:@"dictionary.nest1.nest2.string"]);
	XCTAssertNotNil([_data ft_numberForKeyPath:@"dictionary.nest1.nest2.number"]);
	XCTAssertNotNil([_data ft_boolForKeyPath:@"dictionary.nest1.nest2.true"]);
	XCTAssertNotNil([_data ft_boolForKeyPath:@"dictionary.nest1.nest2.false"]);
	XCTAssertNotNil([_data ft_nullForKeyPath:@"dictionary.nest1.nest2.null"]);
	XCTAssertNotNil([_data ft_arrayForKeyPath:@"dictionary.nest1.nest2.array"]);

	XCTAssertNil([_data ft_numberForKeyPath:@"string"]);
	XCTAssertNil([_data ft_stringForKeyPath:@"number"]);
	XCTAssertNil([_data ft_stringForKeyPath:@"true"]);
	XCTAssertNil([_data ft_stringForKeyPath:@"false"]);
	XCTAssertNil([_data ft_numberForKeyPath:@"null"]);
	XCTAssertNil([_data ft_numberForKeyPath:@"array"]);
	XCTAssertNil([_data ft_numberForKeyPath:@"dictionary"]);

	XCTAssertNil([_data ft_numberForKeyPath:@"dictionary.nest1.nest2.string"]);
	XCTAssertNil([_data ft_stringForKeyPath:@"dictionary.nest1.nest2.number"]);
	XCTAssertNil([_data ft_stringForKeyPath:@"dictionary.nest1.nest2.true"]);
	XCTAssertNil([_data ft_stringForKeyPath:@"dictionary.nest1.nest2.false"]);
	XCTAssertNil([_data ft_numberForKeyPath:@"dictionary.nest1.nest2.null"]);
	XCTAssertNil([_data ft_numberForKeyPath:@"dictionary.nest1.nest2.array"]);

	XCTAssertNil([_data ft_boolForKeyPath:@"number"]);

	XCTAssertNil([_data ft_stringForKeyPath:@"string" lengthRange:NSMakeRange(0, 3)]);
	XCTAssertNil([_data ft_stringForKeyPath:@"string" lengthRange:NSMakeRange(0, 4)]);
	XCTAssertNotNil([_data ft_stringForKeyPath:@"string" lengthRange:NSMakeRange(0, 5)]);
	XCTAssertNotNil([_data ft_stringForKeyPath:@"string" lengthRange:NSMakeRange(2, 10)]);
	XCTAssertNil([_data ft_stringForKeyPath:@"string" lengthRange:NSMakeRange(10, 4)]);

	XCTAssertNil([_data ft_arrayForKeyPath:@"array" countRange:NSMakeRange(0, 2)]);
	XCTAssertNil([_data ft_arrayForKeyPath:@"array" countRange:NSMakeRange(0, 3)]);
	XCTAssertNotNil([_data ft_arrayForKeyPath:@"array" countRange:NSMakeRange(0, 4)]);
	XCTAssertNotNil([_data ft_arrayForKeyPath:@"array" countRange:NSMakeRange(1, 4)]);
	XCTAssertNil([_data ft_arrayForKeyPath:@"array" countRange:NSMakeRange(10, 4)]);

	XCTAssertNotNil([_data ft_numberForKeyPath:@"number" minimum:@-1 maximum:nil]);
	XCTAssertNotNil([_data ft_numberForKeyPath:@"number" minimum:@5 maximum:nil]);
	XCTAssertNotNil([_data ft_numberForKeyPath:@"number" minimum:@9 maximum:nil]);
	XCTAssertNotNil([_data ft_numberForKeyPath:@"number" minimum:@10 maximum:nil]);
	XCTAssertNil([_data ft_numberForKeyPath:@"number" minimum:@11 maximum:nil]);

	XCTAssertNil([_data ft_numberForKeyPath:@"number" minimum:nil maximum:@-1]);
	XCTAssertNil([_data ft_numberForKeyPath:@"number" minimum:nil maximum:@5]);
	XCTAssertNil([_data ft_numberForKeyPath:@"number" minimum:nil maximum:@9]);
	XCTAssertNotNil([_data ft_numberForKeyPath:@"number" minimum:nil maximum:@10]);
	XCTAssertNotNil([_data ft_numberForKeyPath:@"number" minimum:nil maximum:@11]);

	XCTAssertNil([_data ft_numberForKeyPath:@"number" minimum:@0 maximum:@5]);
	XCTAssertNil([_data ft_numberForKeyPath:@"number" minimum:@5 maximum:@9]);
	XCTAssertNotNil([_data ft_numberForKeyPath:@"number" minimum:@-1 maximum:@11]);
	XCTAssertNotNil([_data ft_numberForKeyPath:@"number" minimum:@5 maximum:@15]);
}

@end
