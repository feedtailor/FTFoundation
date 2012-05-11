//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

typedef enum 
{
	ParseStateColumnStart		= 1,
	ParseStateInNormalColumn	= 2,
	ParseStateInQuotedColumn	= 3,

} ParseState;

#import "FTCSVParser.h"

@implementation FTCSVParser
{
	NSString *_csvString;
}

static const unichar COMMA = ',';
static const unichar QUOTE = '\"';

- (id)initWithCSVString:(NSString *)csvString
{
	self = [super init];
	if(self) {
		_csvString = csvString;
	}
	return self;
}

- (NSString *)stringByTrimmingTrailingCharactersInSet:(NSCharacterSet *)set withString:(NSString *)string
{
	NSUInteger index = NSNotFound;

	for(int i = [string length] - 1; 0 <= i; i--) {
		if(![set characterIsMember:[string characterAtIndex:i]]) {
			index = i+1;
			break;
		}
	}

	if(index != NSNotFound) {
		return [string substringToIndex:index];
	}

	return @"";
}

- (NSArray *)csvColumnsWithLine:(NSString *)line
{
	NSMutableArray *columns = [NSMutableArray array];

	int length = [line length];
	
	ParseState state = ParseStateColumnStart;
	NSMutableString *columnBuffer = [NSMutableString string];

	for(int i = 0; i < length; i++) {
		unichar c = [line characterAtIndex:i];
	
		switch(state) {
			case ParseStateColumnStart:
			{
				if(c == QUOTE) {
					state = ParseStateInQuotedColumn;
				} else if(c == COMMA) {
					[columns addObject:columnBuffer];
					columnBuffer = [NSMutableString string];
				} else {
					state = ParseStateInNormalColumn;
					[columnBuffer appendString:[NSString stringWithCharacters:&c length:1]];
				}
			}
				break;

			case ParseStateInNormalColumn:
			{
				if(c == QUOTE) {
					// QUOTE始まりで無いカラム中にQUOTEが出て来たら行全体無効
					return nil;
				} else if(c == COMMA) {
					state = ParseStateColumnStart;
					[columns addObject:columnBuffer];
					columnBuffer = [NSMutableString string];
				} else {
					[columnBuffer appendString:[NSString stringWithCharacters:&c length:1]];
				}
			}
				break;

			case ParseStateInQuotedColumn:
			{
				if(c == QUOTE) {
					if(i < length - 1) {
						i++;
						unichar c2 = [line characterAtIndex:i];
						if(c2 == QUOTE) {
							[columnBuffer appendString:[NSString stringWithCharacters:&c2 length:1]];
						} else {
							state = ParseStateColumnStart;
							[columns addObject:columnBuffer];
							columnBuffer = [NSMutableString string];
						}
					} else {
						// last charctor is QUOTE
						state = ParseStateColumnStart;
						[columns addObject:columnBuffer];
						columnBuffer = nil;
					}
				} else {
					[columnBuffer appendString:[NSString stringWithCharacters:&c length:1]];
				}
			}
				break;
				
			default:
				NSAssert(NO, @"");
				break;
		}
	}

	if(columnBuffer) {
		[columns addObject:columnBuffer];
	}

	return columns;
}

- (NSArray *)rowsWithSkipInvalidRow:(BOOL)skipInvalidRow
{
	int numberOfLines, index;
	int stringLength = [_csvString length];
	NSMutableArray *lines = [NSMutableArray array];

	for(index = 0, numberOfLines = 0; index < stringLength; numberOfLines++) {
		NSRange lineRange = [_csvString lineRangeForRange:NSMakeRange(index, 0)];
		NSString *line = [_csvString substringWithRange:lineRange];

		line = [self stringByTrimmingTrailingCharactersInSet:[NSCharacterSet newlineCharacterSet] withString:line];
		if([line length]) {
			NSArray *columns = [self csvColumnsWithLine:line];
			if(columns) {
				[lines addObject:columns];
			} else {
				if(!skipInvalidRow) {
					[lines addObject:(__bridge id)kCFNull];
				}
			}
		} else {
			[lines addObject:[NSArray array]];
		}

		index = NSMaxRange(lineRange);
	}

	return lines;
}

- (NSArray *)rows
{
	return [self rowsWithSkipInvalidRow:YES];
}

@end
