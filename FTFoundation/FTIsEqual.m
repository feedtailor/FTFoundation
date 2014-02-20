//
//  Copyright (c) 2014 feedtailor inc. All rights reserved.
//

#import "FTIsEqual.h"

BOOL FTIsEqualObjects(id <NSObject> a, id <NSObject> b)
{
    if (a) {
        if (b) {
            return [a isEqual:b];
        }
    } else {
        if (!b) {
            return YES;
        }
    }
    
    return NO;
}

Boolean FTCFEqual(CFTypeRef a, CFTypeRef b)
{
    return FTIsEqualObjects((__bridge id <NSObject>)a, (__bridge id <NSObject>)b);
}
