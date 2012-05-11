//
//  Copyright (c) 2012年 feedtailor Inc. All rights reserved.
//

#import "NSFileManager+Utilities.h"

@implementation NSFileManager (NSFileManagerUtilities)

+ (unsigned long long)ft_diskFreeSpace
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *cachesDirectory = [paths objectAtIndex:0];
	NSDictionary *info = [[NSFileManager defaultManager] attributesOfFileSystemForPath:cachesDirectory error:NULL];
	NSNumber *freeSpaceNumber = [info objectForKey:NSFileSystemFreeSize];
	
	unsigned long long freeSpace = [freeSpaceNumber unsignedLongLongValue];
	return freeSpace;
}

@end