//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//


#import <XCTest/XCTest.h>
#import "FTNSString+Encode.h"

@interface FTNSStringEncodeTest : XCTestCase
@end

@implementation FTNSStringEncodeTest

-(void) __test:(NSString*)original correct:(NSString*)correct
{
    NSString* encoded = [original ft_stringByURLEncode];
    NSString* decoded = [encoded ft_stringByURLDecode];
    
    XCTAssertTrue([encoded isEqualToString:correct], @"%@ = %@", encoded, correct);
    XCTAssertTrue([decoded isEqualToString:original], @"%@ = %@", decoded, original);
}

- (void)testEncode
{
    [self __test:@"http://www.google.co.jp/webhp?hl=ja" correct:@"http%3A%2F%2Fwww.google.co.jp%2Fwebhp%3Fhl%3Dja"];
}

- (void)testEncode2
{
    [self __test:@"吾輩は猫である" correct:@"%E5%90%BE%E8%BC%A9%E3%81%AF%E7%8C%AB%E3%81%A7%E3%81%82%E3%82%8B"];
}

- (void)testEncode3
{
    [self __test:@"!\"#$%&'()0=~|{}`*_?><" correct:@"%21%22%23%24%25%26%27%28%290%3D~%7C%7B%7D%60%2A_%3F%3E%3C"];
}

@end
