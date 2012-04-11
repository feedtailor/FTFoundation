//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import "FTCFAutorelease.h"

void FTCFAutorelease(CFTypeRef object)
{
	[((id)object) autorelease];
}
