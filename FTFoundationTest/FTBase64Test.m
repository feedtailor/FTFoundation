//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FTBase64.h"
#import "Common.h"

@interface FTBase64Test : XCTestCase
@end

@implementation FTBase64Test

// All code under test must be linked into the Unit Test bundle
- (void)testEncode
{
	NSData* d = [TEST_TEXT dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
	NSString* encoded = [d ft_base64EncodedString];
	NSString* correct = @"5pel5pys5Zu95rCR44Gv44CB5q2j5b2T44Gr6YG45oyZ44GV44KM44Gf5Zu95Lya44Gr44GK44GR44KL5Luj6KGo6ICF44KS6YCa44GY44Gm6KGM5YuV44GX44CB44KP44KM44KJ44Go44KP44KM44KJ44Gu5a2Q5a2r44Gu44Gf44KB44Gr44CB6Ku45Zu95rCR44Go44Gu5Y2U5ZKM44Gr44KI44KL5oiQ5p6c44Go44CB44KP44GM5Zu95YWo5Zyf44Gr44KP44Gf44Gk44Gm6Ieq55Sx44Gu44KC44Gf44KJ44GZ5oG15rKi44KS56K65L+d44GX44CB5pS/5bqc44Gu6KGM54K644Gr44KI44Gk44Gm5YaN44Gz5oim5LqJ44Gu5oOo56aN44GM6LW344KL44GT44Go44Gu44Gq44GE44KE44GG44Gr44GZ44KL44GT44Go44KS5rG65oSP44GX44CB44GT44GT44Gr5Li75qip44GM5Zu95rCR44Gr5a2Y44GZ44KL44GT44Go44KS5a6j6KiA44GX44CB44GT44Gu5oay5rOV44KS56K65a6a44GZ44KL44CC";
	XCTAssertTrue([encoded isEqualToString:correct], @"%@ = %@", encoded, correct);
}

@end
