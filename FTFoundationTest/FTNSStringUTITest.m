//
//  FTNSStringUTITest.m
//  FTFoundation
//
//  Created by itok on 2014/07/23.
//  Copyright (c) 2014年 feedtailor inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FTNSString+UTI.h"

@interface FTNSStringUTITest : XCTestCase

@end

@implementation FTNSStringUTITest

-(void) testUTI
{
    NSString* filename = @"test.png";
    
    XCTAssertTrue([[NSString ft_UTIForFilename:filename] isEqualToString:@"public.png"], @"");
}

-(void) testMIME
{
    NSString* filename = @"test.png";
    
    XCTAssertTrue([[NSString ft_mimeTypeForFilename:filename] isEqualToString:@"image/png"], @"");
}

@end
