//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import "FTNetworkInterface.h"
#import <ifaddrs.h>
#import <sys/socket.h>
#import <arpa/inet.h>
#import <net/ethernet.h>
#import <net/if_dl.h>



static FTNetworkInterface *FTNetworkInterfaceSharedInstance = nil;

const NSString *FTNetworkInterfaceName = @"name";
const NSString *FTNetworkInterfaceIPAddressKey = @"IPAddress";
const NSString *FTNetworkInterfaceSubnetMaskKey = @"subnetMask";
const NSString *FTNetworkInterfaceBroadcastAddressKey = @"broadcastAddress";
const NSString *FTNetworkInterfaceIPv6AddressKey = @"IPv6Address";
const NSString *FTNetworkInterfaceIPv6SubnetMaskKey = @"IPv6SubnetMask";
const NSString *FTNetworkInterfaceMACAddressKey = @"MACAddress";

@interface FTNetworkInterface ()

@property (nonatomic,strong) NSMutableDictionary *interfaces;

+ (id)sharedInstance;

@end

@implementation FTNetworkInterface

@synthesize interfaces = _interfaces;

+ (NSArray*)allInterfaceNames {
	return [[[self sharedInstance] allInterfaces] allKeys];
}

+ (NSDictionary*)allInterfaces {
	return [[self sharedInstance] allInterfaces];
}

+ (NSDictionary*)primaryInterface {
	NSArray *interfaceNames = [NSArray arrayWithObjects:@"en0",@"en1",@"en2",@"pdp_ip0",@"pdp_ip1",@"pdp_ip2",@"pdp_ip3",nil];
	for (NSString *name in interfaceNames) {
		NSDictionary *interface = [[self class] interfaceForName:name];
		if(interface) {
			return interface;
		}
	}
	return nil;
}

+ (NSDictionary*)interfaceForName:(NSString*)name {
	return [[[self sharedInstance] allInterfaces] objectForKey:name];
}

+ (void)update {
	[[self sharedInstance] update];
}


#pragma mark -

+ (id)sharedInstance {
	if (!FTNetworkInterfaceSharedInstance) {
		FTNetworkInterfaceSharedInstance = [[FTNetworkInterface alloc] init];
	}
	return FTNetworkInterfaceSharedInstance;
}

- (NSMutableDictionary*)allInterfaces {
	if (!self.interfaces) {
		[self update];
	}
	return self.interfaces;
}

- (void)update {
	
	self.interfaces = [NSMutableDictionary dictionary];
	
	struct ifaddrs *ifa;
	struct ifaddrs *ifaList;
	NSString *str;
	
	if (getifaddrs(&ifaList) != 0) {
		return;
	} 
	
	for (ifa = ifaList; ifa != NULL; ifa = ifa->ifa_next) {
		
		NSString *name = [NSString stringWithCString:ifa->ifa_name encoding:NSASCIIStringEncoding];
		NSMutableDictionary *d = [self.interfaces objectForKey:name];
		if (!d) {
			d = [NSMutableDictionary dictionary];
			[self.interfaces setObject:d forKey:name];
		}
		[d setObject:name forKey:FTNetworkInterfaceName];
		
		switch (ifa->ifa_addr->sa_family) {
			case AF_INET:
				str = [self inet_ntoptos:AF_INET v:&((struct sockaddr_in*)ifa->ifa_addr)->sin_addr];
				[d setObject:str forKey:FTNetworkInterfaceIPAddressKey];
				
				str = [self inet_ntoptos:AF_INET v:&((struct sockaddr_in*)ifa->ifa_netmask)->sin_addr];
				[d setObject:str forKey:FTNetworkInterfaceSubnetMaskKey];
				
				str = [self inet_ntoptos:AF_INET v:&((struct sockaddr_in*)ifa->ifa_dstaddr)->sin_addr];
				[d setObject:str forKey:FTNetworkInterfaceBroadcastAddressKey];
				break;
			case AF_INET6:
				str = [self inet_ntoptos:AF_INET6 v:&((struct sockaddr_in6 *)ifa->ifa_addr)->sin6_addr];
				[d setObject:str forKey:FTNetworkInterfaceIPv6AddressKey];
				
				str = [self inet_ntoptos:AF_INET6 v:&((struct sockaddr_in6 *)ifa->ifa_netmask)->sin6_addr];
				[d setObject:str forKey:FTNetworkInterfaceIPv6SubnetMaskKey];
				break;
			case AF_LINK:
			{
				struct sockaddr_dl *sdl = (struct sockaddr_dl *)(ifa->ifa_addr);
				str = [self ether_ntoatos:(const struct ether_addr *)LLADDR(sdl)];
				[d setObject:str forKey:FTNetworkInterfaceMACAddressKey];
			}
				break;
			default:
				break;
		}
	}
	
}

- (NSString*)inet_ntoptos:(int)n v:(const void*)v {
	char tmp[256];
	memset(tmp, 0, sizeof(tmp));
	inet_ntop(n,v,
			  tmp,sizeof(tmp));
	return [NSString stringWithCString:tmp encoding:NSASCIIStringEncoding];
}
- (NSString*)ether_ntoatos:(const struct ether_addr *)addr {
	int a,b,c,d,e,f;
	char tmp[256];
	memset(tmp, 0, sizeof(tmp));
	strcpy(tmp,ether_ntoa(addr));
	sscanf(tmp, "%x:%x:%x:%x:%x:%x",&a,&b,&c,&d,&e,&f);
	sprintf(tmp, "%02X:%02X:%02X:%02X:%02X:%02X",a,b,c,d,e,f);
	return [NSString stringWithCString:tmp encoding:NSASCIIStringEncoding];
}

@end
