//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import "FTNSObject+Tag.h"
#import <objc/runtime.h>

static char sFTTagKey;

@implementation NSObject (FTNSObjectTag)

- (NSInteger)ft_tag
{
	NSNumber *tag = objc_getAssociatedObject(self, &sFTTagKey);
	if(!tag) {
		return 0;
	}
	
	return [tag integerValue];
}

- (void)setFt_tag:(NSInteger)ft_tag
{
	if(ft_tag == 0) {
		objc_setAssociatedObject(self, &sFTTagKey, nil, OBJC_ASSOCIATION_ASSIGN);
	} else {
		objc_setAssociatedObject(self, &sFTTagKey, [NSNumber numberWithInteger:ft_tag], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
}

@end
