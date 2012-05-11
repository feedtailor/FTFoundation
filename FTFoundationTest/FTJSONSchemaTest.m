//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import "FTJSONSchemaTest.h"
#import "FTJSONSchemaValidator.h"

// todo : test cateを増やす

@implementation FTJSONSchemaTest

- (void)setUp
{
}

- (void)tearDown
{
}

#pragma mark -

- (BOOL)validateDataPath:(NSString *)dataPath schemaPath:(NSString *)schemaPath
{
	NSData *schemaData = [NSData dataWithContentsOfFile:schemaPath];
	NSData *JSONData = [NSData dataWithContentsOfFile:dataPath];
	
	FTJSONSchemaValidator *validator = [[FTJSONSchemaValidator alloc] initWithSchemaData:schemaData];
	NSError *error = nil;
	BOOL result = [validator isValidJSONData:JSONData error:&error];
	NSLog(@"%@", error);

	return result;
}

- (void)testValid1
{
	NSString *schemaPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"test1_schema" ofType:@"json"];
	NSString *dataPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"test1_valid_1" ofType:@"json"];

	BOOL isValidJSONData = [self validateDataPath:dataPath schemaPath:schemaPath];

	STAssertTrue(isValidJSONData, @"isValidJSONData == %d", isValidJSONData);
}

- (void)testInvalid1
{
	NSString *schemaPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"test1_schema" ofType:@"json"];
	NSString *dataPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"test1_invalid_1" ofType:@"json"];
	
	BOOL isValidJSONData = [self validateDataPath:dataPath schemaPath:schemaPath];

	STAssertFalse(isValidJSONData, @"isValidJSONData == %d", isValidJSONData);
}

- (void)testValid2
{
	NSString *schemaPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"test2_schema" ofType:@"json"];
	NSString *dataPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"test2_valid_1" ofType:@"json"];
	
	BOOL isValidJSONData = [self validateDataPath:dataPath schemaPath:schemaPath];
	
	STAssertTrue(isValidJSONData, @"isValidJSONData == %d", isValidJSONData);
}

- (void)testInvalid2
{
	NSString *schemaPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"test2_schema" ofType:@"json"];
	NSString *dataPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"test2_invalid_1" ofType:@"json"];
	
	BOOL isValidJSONData = [self validateDataPath:dataPath schemaPath:schemaPath];
	
	STAssertFalse(isValidJSONData, @"isValidJSONData == %d", isValidJSONData);
}

@end
