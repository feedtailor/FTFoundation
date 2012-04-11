//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

//
//  CSV Parser implementation copied from the following blog post.
//
//  http://cocoawithlove.com/2009/11/writing-parser-using-nsscanner-csv.html
//
//  ***
//
//  Created by Matt Gallagher on 2009/11/30.
//  Copyright 2009 Matt Gallagher. All rights reserved.
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#import "FTCSVParser.h"

@interface FTCSVParser (PrivateMethods)
- (NSString *)readLineFromFile;
- (NSArray *)parseFile;
- (NSMutableArray *)parseHeader;
- (NSDictionary *)parseRecord;
- (NSString *)parseName;
- (NSString *)parseField;
- (NSString *)parseEscaped;
- (NSString *)parseNonEscaped;
- (NSString *)parseDoubleQuote;
- (NSString *)parseSeparator;
- (NSString *)parseLineSeparator;
- (NSString *)parseTwoDoubleQuotes;
- (NSString *)parseTextData;
@end

@implementation FTCSVParser

// Private constructor

- (id)init:(NSString *)aSeparatorString
 hasHeader:(BOOL)header
fieldNames:(NSArray *)names
{
	self = [super init];
	
	if (self) {
		separator = aSeparatorString;
		
		NSAssert([separator length] > 0 &&
				 [separator rangeOfString:@"\""].location == NSNotFound &&
				 [separator rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound,
				 @"CSV separator string must not be empty and must not contain the double quote character or newline characters.");
		
		NSMutableCharacterSet *endTextMutableCharacterSet =
		[[NSCharacterSet newlineCharacterSet] mutableCopy];
		[endTextMutableCharacterSet addCharactersInString:@"\""];
		[endTextMutableCharacterSet addCharactersInString:[separator substringToIndex:1]];
		endTextCharacterSet = endTextMutableCharacterSet;
		
		if ([separator length] == 1) {
			separatorIsSingleChar = YES;
		}
		
		if(names) {
			fieldNames = [names mutableCopy];
		}
		else if(header) {            
			fieldNames = [self parseHeader];
			if (!fieldNames || ![self parseLineSeparator]) {
				return nil;
			}
		}
		else {
			fieldNames = [[NSMutableArray alloc] init];
		}
		
	}
	
	return self;    
}

// Public constructors

- (id)initWithString:(NSString *)str
		   separator:(NSString *)aSeparatorString
		   hasHeader:(BOOL)header
		  fieldNames:(NSArray *)names
{
	self = [self init:aSeparatorString hasHeader:header fieldNames:names];
	if (self) {
		scanner = [[NSScanner alloc] initWithString:str];
		[scanner setCharactersToBeSkipped:nil];
	}
	
    return self;
}

- (id)initWithFile:(NSString *)filename
         separator:(NSString *)aSeparatorString
         hasHeader:(BOOL)header
        fieldNames:(NSArray *)names
{
	self = [self init:aSeparatorString hasHeader:header fieldNames:names];
	if (self) {
	    file = fopen([filename cStringUsingEncoding:NSASCIIStringEncoding], "r");
	
		NSString *line = [self readLineFromFile];
		if(!line)
			line = @"";
		
		scanner = [[NSScanner alloc] initWithString:line];
		[scanner setCharactersToBeSkipped:nil];
	}
	
    return self;
}

//
// dealloc
//
// Releases instance memory.
//
- (void)dealloc
{
    if(file)
        fclose(file);
}


//
// rows
//
// Performs a parsing of the data, returning the entire result.
//
// returns the array of all parsed row records
//
- (NSArray *)rows
{
    return [self parseFile];	
}

//
// nextRow
//
// Returns the next row of data
//
- (NSDictionary *)nextRow
{
    NSDictionary *record = [self parseRecord];
    [self parseLineSeparator];
    return record;
}

//
// readLineFromFile
//
- (NSString *)readLineFromFile
{
    char buffer[4096];
	
    if(!file || feof(file))
        return nil;
    
    NSMutableString *result = [NSMutableString stringWithCapacity:256];
	
    // Read all the data up to the line ending
    int charsRead;
    do
    {
        if(fscanf(file, "%4095[^\r\n]%n", buffer, &charsRead) == 1)
            [result appendFormat:@"%s", buffer];
        else
            break;
    } while(charsRead == 4095);
	
    // Chop off the line endings
    fscanf(file, "%*[\r\n]");
    
    return result;
}

//
// parseFile
//
// Attempts to parse a file from the current scan location.
//
// returns the parsed results if successful
//
- (NSArray *)parseFile
{	
	NSMutableArray *records = [NSMutableArray array];
	
	NSDictionary *record = [self parseRecord];
	if (!record)
	{
		return nil;
	}
	
	while (record)
	{
		@autoreleasepool {
			[records addObject:record];
			
			if (![self parseLineSeparator])
			{
				break;
			}
			
			record = [self parseRecord];			
		}
	}
	
	return records;
}

//
// parseHeader
//
// Attempts to parse a header row from the current scan location.
//
// returns the array of parsed field names or nil on parse failure.
//
- (NSMutableArray *)parseHeader
{
	NSString *name = [self parseName];
	if (!name)
	{
		return nil;
	}
	
	NSMutableArray *names = [NSMutableArray array];
	while (name)
	{
		[names addObject:name];
		
		if (![self parseSeparator])
		{
			break;
		}
		
		name = [self parseName];
	}
	return names;
}

//
// parseRecord
//
// Attempts to parse a record from the current scan location. The record
// dictionary will use the fieldNames as keys, or FIELD_X for each column
// X-1 if no fieldName exists for a given column.
//
// returns the parsed record as a dictionary, or nil on failure. 
//
- (NSDictionary *)parseRecord
{
	//
	// Special case: return nil if the line is blank. Without this special case,
	// it would parse as a single blank field.
	//
	if ([self parseLineSeparator] || [scanner isAtEnd])
	{
		return nil;
	}
	
	NSString *field = [self parseField];
	if (!field)
	{
		return nil;
	}
	
	NSInteger fieldNamesCount = [fieldNames count];
	NSInteger fieldCount = 0;
	
	NSMutableDictionary *record =
	[NSMutableDictionary dictionaryWithCapacity:[fieldNames count]];
	while (field)
	{
		NSString *fieldName;
		if (fieldNamesCount > fieldCount)
		{
			fieldName = [fieldNames objectAtIndex:fieldCount];
		}
		else
		{
			fieldName = [NSString stringWithFormat:@"FIELD_%ld", fieldCount + 1];
			[fieldNames addObject:fieldName];
			fieldNamesCount++;
		}
		
		[record setObject:field forKey:fieldName];
		fieldCount++;
		
		if (![self parseSeparator])
		{
			break;
		}
		
		field = [self parseField];
	}
	
	return record;
}

//
// parseName
//
// Attempts to parse a name from the current scan location.
//
// returns the name or nil.
//
- (NSString *)parseName
{
	return [self parseField];
}

//
// parseField
//
// Attempts to parse a field from the current scan location.
//
// returns the field or nil
//
- (NSString *)parseField
{
	NSString *escapedString = [self parseEscaped];
	if (escapedString)
	{
		return escapedString;
	}
	
	NSString *nonEscapedString = [self parseNonEscaped];
	if (nonEscapedString)
	{
		return nonEscapedString;
	}
	
	//
	// Special case: if the current location is immediately
	// followed by a separator, then the field is a valid, empty string.
	//
	NSInteger currentLocation = [scanner scanLocation];
	if ([self parseSeparator] || [self parseLineSeparator] || [scanner isAtEnd])
	{
		[scanner setScanLocation:currentLocation];
		return @"";
	}
	
	return nil;
}

//
// parseEscaped
//
// Attempts to parse an escaped field value from the current scan location.
//
// returns the field value or nil.
//
- (NSString *)parseEscaped
{
	if (![self parseDoubleQuote])
	{
		return nil;
	}
	
	NSString *accumulatedData = [NSString string];
	while (YES)
	{
		NSString *fragment = [self parseTextData];
		if (!fragment)
		{
			fragment = [self parseSeparator];
			if (!fragment)
			{
				fragment = [self parseLineSeparator];
				if (!fragment)
				{
					if ([self parseTwoDoubleQuotes])
					{
						fragment = @"\"";
					}
					else
					{
						break;
					}
				}
			}
		}
		
		accumulatedData = [accumulatedData stringByAppendingString:fragment];
	}
	
	if (![self parseDoubleQuote])
	{
		return nil;
	}
	
	return accumulatedData;
}

//
// parseNonEscaped
//
// Attempts to parse a non-escaped field value from the current scan location.
//
// returns the field value or nil.
//
- (NSString *)parseNonEscaped
{
	return [self parseTextData];
}

//
// parseTwoDoubleQuotes
//
// Attempts to parse two double quotes from the current scan location.
//
// returns a string containing two double quotes or nil.
//
- (NSString *)parseTwoDoubleQuotes
{
	if ([scanner scanString:@"\"\"" intoString:NULL])
	{
		return @"\"\"";
	}
	return nil;
}

//
// parseDoubleQuote
//
// Attempts to parse a double quote from the current scan location.
//
// returns @"\"" or nil.
//
- (NSString *)parseDoubleQuote
{
	if ([scanner scanString:@"\"" intoString:NULL])
	{
		return @"\"";
	}
	return nil;
}

//
// parseSeparator
//
// Attempts to parse the separator string from the current scan location.
//
// returns the separator string or nil.
//
- (NSString *)parseSeparator
{
	if ([scanner scanString:separator intoString:NULL])
	{
		return separator;
	}
	return nil;
}

//
// parseLineSeparator
//
// Attempts to parse newline characters from the current scan location.
//
// returns a string containing one or more newline characters or nil.
//
- (NSString *)parseLineSeparator
{
    if(file) {
        
        // If we are reading from a file, we basically simulate the
        // parsing of newlines because this is where we stream more
        // data in. This is necessary because Objective-C doesn't
        // properly support streaming data from disk.
        //
        // Make sure this line is ended and then read the next line
        // into memory. This complexity is necessary to support
        // streaming data from the disk to avoid loading the whole
        // file into memory.
        
        if([scanner isAtEnd]) {
            NSString *line;
            NSString *ret = @"\n";
			
            // Continue reading lines from the file until we hit a
            // non-blank line. Keep track of the blank lines we
            // accumulate (only contains newlines).
            while((line = [self readLineFromFile])) {
                if(![line isEqualToString:@"\n"]) {
                    break;
                }
                else {
                    ret = [ret stringByAppendingString:line];
                }
            }
			
            // We won't have a line if we hit the end of file before
            // finding the next non-blank line. If we have a line,
            // create a new scanner for this line and return the
            // accumulated newlines (to properly support multi-line
            // quoted data)
            if(line) {
                scanner = [[NSScanner alloc] initWithString:line];
                [scanner setCharactersToBeSkipped:nil];
                return ret;
            }
            else {
                return nil;
            }
        }
        else {
            return nil;
        }
    }
    else {
		NSString *matchedNewlines = nil;
		[scanner
		 scanCharactersFromSet:[NSCharacterSet newlineCharacterSet]
		 intoString:&matchedNewlines];
		return matchedNewlines;
    }
}

//
// parseTextData
//
// Attempts to parse text data from the current scan location.
//
// returns a non-zero length string or nil.
//
- (NSString *)parseTextData
{
	NSString *accumulatedData = [NSString string];
	while (YES)
	{
		NSString *fragment;
		if ([scanner scanUpToCharactersFromSet:endTextCharacterSet intoString:&fragment])
		{
			accumulatedData = [accumulatedData stringByAppendingString:fragment];
		}
		
		//
		// If the separator is just a single character (common case) then
		// we know we've reached the end of parseable text
		//
		if (separatorIsSingleChar)
		{
			break;
		}
		
		//
		// Otherwise, we need to consider the case where the first character
		// of the separator is matched but we don't have the full separator.
		//
		NSUInteger location = [scanner scanLocation];
		NSString *firstCharOfSeparator;
		if ([scanner scanString:[separator substringToIndex:1] intoString:&firstCharOfSeparator])
		{
			if ([scanner scanString:[separator substringFromIndex:1] intoString:NULL])
			{
				[scanner setScanLocation:location];
				break;
			}
			
			//
			// We have the first char of the separator but not the whole
			// separator, so just append the char and continue
			//
			accumulatedData = [accumulatedData stringByAppendingString:firstCharOfSeparator];
			continue;
		}
		else
		{
			break;
		}
	}
	
	if ([accumulatedData length] > 0)
	{
		return accumulatedData;
	}
	
	return nil;
}

@end
