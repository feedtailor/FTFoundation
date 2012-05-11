//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import "FTCSVParserTest.h"
#import "FTCSVParser.h"

@implementation FTCSVParserTest

- (void)setUp
{
}

- (void)tearDown
{
}

#pragma mark -

- (NSArray *)rowsWithSkipInvalidRow:(BOOL)rowsWithSkipInvalidRow
{
	NSMutableArray *rows = [NSMutableArray array];

	[rows addObject:[NSArray arrayWithObjects:@"1", @"2", @"3", nil]];
	[rows addObject:[NSArray arrayWithObjects:@"4", @"5", @"6", nil]];
	[rows addObject:[NSArray arrayWithObjects:@"7", @"8", @"9", nil]];
	[rows addObject:[NSArray arrayWithObjects:@"10", @"11", nil]];
	[rows addObject:[NSArray arrayWithObjects:@"12", @"", nil]];
	[rows addObject:[NSArray arrayWithObjects:@"", @"", @"", nil]];
	[rows addObject:[NSArray arrayWithObjects:nil]];
	[rows addObject:[NSArray arrayWithObjects:@"x", @"y", @"z", nil]];

	if(!rowsWithSkipInvalidRow) {
		[rows addObject:[NSNull null]];
		[rows addObject:[NSNull null]];
	}

	[rows addObject:[NSArray arrayWithObjects:@"", @"2", @"3", nil]];
	[rows addObject:[NSArray arrayWithObjects:@"a", @"b", @"c", nil]];
	[rows addObject:[NSArray arrayWithObjects:@"A", @"B", @"C", nil]];
	[rows addObject:[NSArray arrayWithObjects:@"1", @"quote \"quoted\".", @"X", nil]];
	[rows addObject:[NSArray arrayWithObjects:@"a,b,c", @"b", @"c", nil]];

	return rows;
}

- (void)testLF
{
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *path = [bundle pathForResource:@"csv_LF" ofType:@"csv"];
	NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];

	FTCSVParser *parser = [[FTCSVParser alloc] initWithCSVString:string];
	NSArray *parsedRows = [parser rows];

	NSArray *rows = [self rowsWithSkipInvalidRow:YES];
	STAssertTrue([parsedRows isEqualToArray:rows],  @"%@ == %@", parsedRows, rows);
}

- (void)testCRLF
{
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *path = [bundle pathForResource:@"csv_CRLF" ofType:@"csv"];
	NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];

	FTCSVParser *parser = [[FTCSVParser alloc] initWithCSVString:string];
	NSArray *parsedRows = [parser rows];
	
	NSArray *rows = [self rowsWithSkipInvalidRow:YES];
	STAssertTrue([parsedRows isEqualToArray:rows],  @"%@ == %@", parsedRows, rows);
}

- (void)testCR
{
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *path = [bundle pathForResource:@"csv_CR" ofType:@"csv"];
	NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];

	FTCSVParser *parser = [[FTCSVParser alloc] initWithCSVString:string];
	NSArray *parsedRows = [parser rows];
	
	NSArray *rows = [self rowsWithSkipInvalidRow:YES];
	STAssertTrue([parsedRows isEqualToArray:rows],  @"%@ == %@", parsedRows, rows);
}

- (void)testLFIncludesIllegalLine
{
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *path = [bundle pathForResource:@"csv_LF" ofType:@"csv"];
	NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
	
	FTCSVParser *parser = [[FTCSVParser alloc] initWithCSVString:string];
	NSArray *parsedRows = [parser rowsWithSkipInvalidRow:NO];
	
	NSArray *rows = [self rowsWithSkipInvalidRow:NO];
	STAssertTrue([parsedRows isEqualToArray:rows],  @"%@ == %@", parsedRows, rows);
}

- (void)testCRLFIncludesIllegalLine
{
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *path = [bundle pathForResource:@"csv_CRLF" ofType:@"csv"];
	NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
	
	FTCSVParser *parser = [[FTCSVParser alloc] initWithCSVString:string];
	NSArray *parsedRows = [parser rowsWithSkipInvalidRow:NO];
	
	NSArray *rows = [self rowsWithSkipInvalidRow:NO];
	STAssertTrue([parsedRows isEqualToArray:rows],  @"%@ == %@", parsedRows, rows);
}

- (void)testCRIncludesIllegalLine
{
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *path = [bundle pathForResource:@"csv_CR" ofType:@"csv"];
	NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
	
	FTCSVParser *parser = [[FTCSVParser alloc] initWithCSVString:string];
	NSArray *parsedRows = [parser rowsWithSkipInvalidRow:NO];
	
	NSArray *rows = [self rowsWithSkipInvalidRow:NO];
	STAssertTrue([parsedRows isEqualToArray:rows],  @"%@ == %@", parsedRows, rows);
}

@end
