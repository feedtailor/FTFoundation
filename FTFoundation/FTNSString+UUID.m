//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import "FTNSString+UUID.h"

@implementation NSString (FTNSStringUUID)

+(NSString*) ft_UUIDString
{
	CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
	CFStringRef str = CFUUIDCreateString(kCFAllocatorDefault, uuid);
	CFRelease(uuid);
	NSString* ret = CFBridgingRelease(str);
	return ret;
}

@end
