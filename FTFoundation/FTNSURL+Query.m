//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import "FTNSURL+Query.h"

@implementation NSURL (FTNSURLQuery)

-(NSDictionary*) ft_queryDictionary
{
	NSMutableDictionary* dic = [NSMutableDictionary dictionary];;
	NSArray* queries = [[self query] componentsSeparatedByString:@"&"];
	for (NSString* q in queries) {
		NSArray* comp = [q componentsSeparatedByString:@"="];
		if ([comp count] == 2) {
			[dic setObject:[[comp objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:[comp objectAtIndex:0]];
		}
	}
	return dic;
}

@end
