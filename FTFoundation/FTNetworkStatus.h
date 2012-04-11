//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
	kFTNetworkStatus_Unavailable = 0,
	kFTNetworkStatus_WiFi,
	kFTNetworkStatus_WWAN,
};

enum {
	kFTNetworkStatusMask_Unavailable = 0,
	kFTNetworkStatusMask_WiFi = 1 << (kFTNetworkStatus_WiFi - 1),
	kFTNetworkStatusMask_WWAN = 1 << (kFTNetworkStatus_WWAN - 1),
};

@interface FTNetworkStatus : NSObject {

}

+(int) networkStatus;
+(int) networkStatusMask;

@end
