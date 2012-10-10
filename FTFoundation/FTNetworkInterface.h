//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

// IPv4
const NSString *FTNetworkInterfaceIPAddressKey;
const NSString *FTNetworkInterfaceSubnetMaskKey;
const NSString *FTNetworkInterfaceBroadcastAddressKey;
// IPv6
const NSString *FTNetworkInterfaceIPv6AddressKey;
const NSString *FTNetworkInterfaceIPv6SubnetMaskKey;
// ether
const NSString *FTNetworkInterfaceMACAddressKey;

@interface FTNetworkInterface : NSObject

+ (NSArray*)allInterfaceNames;
+ (NSDictionary*)allInterfaces;
+ (NSDictionary*)primaryInterface;
+ (NSDictionary*)interfaceForName:(NSString*)name;
+ (void)update;

@end
