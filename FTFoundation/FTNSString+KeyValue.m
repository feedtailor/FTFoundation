//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import "FTNSString+KeyValue.h"

@implementation NSString (FTNSStringsKeyValue)

-(NSDictionary*) ft_keyValueDictionary
{
	return [self ft_keyValueDictionaryWithDelimiter:nil];
}

-(NSDictionary*) ft_keyValueDictionaryWithDelimiter:(NSString*)delimiter
{
	if (!delimiter) {
		delimiter = @"&";
	}
	
	NSArray* comps = [self componentsSeparatedByString:delimiter];
	NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
	for (NSString* comp in comps) {
		NSArray* subComps = [comp componentsSeparatedByString:@"="];
		if ([subComps count] == 2) {
			[dic setObject:[subComps objectAtIndex:1] forKey:[subComps objectAtIndex:0]];
		}
	}
	
	if ([dic count] > 0) {
		return dic;
	}
	return nil;
}

@end
