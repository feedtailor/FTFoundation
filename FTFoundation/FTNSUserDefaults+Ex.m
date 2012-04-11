//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import "FTNSUserDefaults+Ex.h"

@implementation NSUserDefaults (FTNSUserDefaultsEx)

-(void) ft_setupDefaultsWithPlist:(NSString*)filename
{
	if (!filename) {
		filename = @"defaults.plist";
	}
	[self registerDefaults:[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:filename ofType:nil]]];
	[self synchronize];
}

-(void) ft_removeAllObjects
{
	NSArray* allKeys = [[self dictionaryRepresentation] allKeys];
	for (NSString* key in allKeys) {
		[self removeObjectForKey:key];
	}
}

@end
