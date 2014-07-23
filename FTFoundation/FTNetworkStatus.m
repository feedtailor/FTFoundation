//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import "FTNetworkStatus.h"

#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>
#import <CoreFoundation/CoreFoundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

@implementation FTNetworkStatus

+(int) networkStatus
{
	int ret = kFTNetworkStatus_Unavailable;
	
	struct sockaddr_in address;
	bzero(&address, sizeof(address));
	address.sin_len = sizeof(address);
	address.sin_family = AF_INET;
	SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&address);
	if (reachability) {
		SCNetworkReachabilityFlags flags;
		if (SCNetworkReachabilityGetFlags(reachability, &flags)) {
			if ((flags & kSCNetworkReachabilityFlagsReachable) == 0) {
				ret = kFTNetworkStatus_Unavailable;
			} else {
				if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0) {
					ret = kFTNetworkStatus_WiFi;
				}
				if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
					 (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0)) {
					// ... and the connection is on-demand (or on-traffic) if the
					//     calling application is using the CFSocketStream or higher APIs
					
					if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0) {
						// ... and no [user] intervention is needed
						ret = kFTNetworkStatus_WiFi;
					}
				}
				
#if TARGET_OS_IPHONE
				if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN) {
					// ... but WWAN connections are OK if the calling application
					//     is using the CFNetwork (CFSocketStream?) APIs.
					ret = kFTNetworkStatus_WWAN;
				}
#endif
			}
		}
		
		CFRelease(reachability);
	}
	return ret;	
}

+(int) networkStatusMask
{
	int ret = kFTNetworkStatusMask_Unavailable;
	
	struct sockaddr_in address;
	bzero(&address, sizeof(address));
	address.sin_len = sizeof(address);
	address.sin_family = AF_INET;
	SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&address);
	if (reachability) {
		SCNetworkReachabilityFlags flags;
		if (SCNetworkReachabilityGetFlags(reachability, &flags)) {
			if ((flags & kSCNetworkReachabilityFlagsReachable) == 0) {
			} else {
				if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0) {
					ret |= kFTNetworkStatusMask_WiFi;
				}
				if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
					 (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0)) {
					// ... and the connection is on-demand (or on-traffic) if the
					//     calling application is using the CFSocketStream or higher APIs
					
					if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0) {
						// ... and no [user] intervention is needed
						ret |= kFTNetworkStatusMask_WiFi;
					}
				}
				
#if TARGET_OS_IPHONE
				if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN) {
					// ... but WWAN connections are OK if the calling application
					//     is using the CFNetwork (CFSocketStream?) APIs.
					ret |= kFTNetworkStatusMask_WWAN;
				}
#endif
			}
		}
		
		CFRelease(reachability);
	}
	return ret;	
	
}

@end
