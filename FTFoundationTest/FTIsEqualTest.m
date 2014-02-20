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

#pragma mark - CF

- (void)testCFEqualObjects
{
    CFTypeRef a = CFSTR("abc");
    CFTypeRef b = CFSTR("abc");
    
    XCTAssertTrue(FTCFEqual(a, b));
}

- (void)testCFNotEqualObjects
{
    CFTypeRef a = CFSTR("abc");
    CFTypeRef b = CFSTR("xyz");
    
    XCTAssertFalse(FTCFEqual(a, b));
}

- (void)testCFDifferentClassObjects
{
    CFTypeRef a = CFDateCreate(kCFAllocatorDefault, CFAbsoluteTimeGetCurrent());
    CFTypeRef b = CFSTR("xyz");

    XCTAssertFalse(FTCFEqual(a, b));

    CFRelease(a);
}

- (void)testCFNilAndObject
{
    CFTypeRef a = NULL;
    CFTypeRef b = CFSTR("abc");
    
    XCTAssertFalse(FTCFEqual(a, b));
}

- (void)testCFObjectAndNil
{
    CFTypeRef a = CFSTR("abc");
    CFTypeRef b = NULL;
    
    XCTAssertFalse(FTCFEqual(a, b));
}

- (void)testCFNilAndNil
{
    CFTypeRef a = NULL;
    CFTypeRef b = NULL;
    
    XCTAssertTrue(FTCFEqual(a, b));
}

@end
