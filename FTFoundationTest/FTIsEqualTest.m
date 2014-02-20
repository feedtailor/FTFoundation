//
//  Copyright (c) 2014 feedtailor inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FTIsEqual.h"

@interface FTIsEqualTest : XCTestCase
@end

@implementation FTIsEqualTest

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testEqualObjects
{
    id a = @"abc";
    id b = @"abc";
    
    XCTAssertTrue(FTIsEqualObjects(a, b));
}

- (void)testNotEqualObjects
{
    id a = @"abc";
    id b = @"xyz";
    
    XCTAssertFalse(FTIsEqualObjects(a, b));
}

- (void)testDifferentClassObjects
{
    id a = @(123);
    id b = @"xyz";
    
    XCTAssertFalse(FTIsEqualObjects(a, b));
}

- (void)testNilAndObject
{
    id a = nil;
    id b = @"abc";
    
    XCTAssertFalse(FTIsEqualObjects(a, b));
}

- (void)testObjectAndNil
{
    id a = @"abc";
    id b = nil;
    
    XCTAssertFalse(FTIsEqualObjects(a, b));
}

- (void)testNilAndNil
{
    id a = nil;
    id b = nil;
    
    XCTAssertTrue(FTIsEqualObjects(a, b));
}

@end
