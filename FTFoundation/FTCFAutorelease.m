//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import "FTCFAutorelease.h"

CFTypeRef FTCFAutorelease(CFTypeRef object)
{
	return (CFTypeRef)[((id)object) autorelease];
}
