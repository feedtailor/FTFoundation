//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import "FTKeychain.h"
#import <Security/Security.h>

@implementation FTKeychain

+ (NSError *)OSStatusErrorWithOSStatus:(OSStatus)status
{
	return [NSError errorWithDomain:NSOSStatusErrorDomain code:errSecItemNotFound userInfo:nil];
}

+ (NSString*)passwordForService:(NSString*)service account:(NSString*)account error:(NSError **)error
{
	if(!service || !account) {
		return nil;
	}

	NSMutableDictionary *query = [NSMutableDictionary dictionary];

	[query setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
	[query setObject:service forKey:(__bridge id)kSecAttrService];
	[query setObject:account forKey:(__bridge id)kSecAttrAccount];

	[query setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
	
	NSString *password = nil;
	CFDataRef passwordDataRef = NULL;

	OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&passwordDataRef);

	if(status == errSecSuccess) {
		password = [[NSString alloc] initWithData:(__bridge NSData *)passwordDataRef encoding:NSUTF8StringEncoding];
	} else if(status == errSecItemNotFound) {
		// password = nil;
	} else {
		if(error) {
			*error = [self OSStatusErrorWithOSStatus:status];
		}
	}

	if(passwordDataRef) {
		CFRelease(passwordDataRef);
	}

	return password;
}

+ (BOOL)setPassword:(NSString*)password
		 forService:(NSString*)service
			account:(NSString*)account
  secAttrAccessible:(CFTypeRef)secAttrAccessible	// kSecAttrAccessible の取りうる値 or NULL
			  error:(NSError **)error
{
	BOOL result = NO;

	NSMutableDictionary* query = [NSMutableDictionary dictionary];
	NSData* passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
	
	[query setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
	[query setObject:service forKey:(__bridge id)kSecAttrService];
	[query setObject:account forKey:(__bridge id)kSecAttrAccount];
	
	OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, NULL);

	switch(status) {
		case errSecSuccess:
		{
			NSMutableDictionary* attributes = [NSMutableDictionary dictionary];
			[attributes setObject:passwordData forKey:(__bridge id)kSecValueData];
			if(secAttrAccessible) {
				[attributes setObject:(__bridge id)secAttrAccessible forKey:(__bridge id)kSecAttrAccessible];
			}
			
			status = SecItemUpdate((__bridge CFDictionaryRef)query, (__bridge CFDictionaryRef)attributes);
			if(status == errSecSuccess) {
				result = YES;
			} else {
				if(error) {
					*error = [self OSStatusErrorWithOSStatus:status];
				}
			}
		}
			break;

		case errSecItemNotFound:
		{
			NSMutableDictionary* attributes = [NSMutableDictionary dictionary];
			[attributes setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
			[attributes setObject:service forKey:(__bridge id)kSecAttrService];
			[attributes setObject:account forKey:(__bridge id)kSecAttrAccount];
			[attributes setObject:passwordData forKey:(__bridge id)kSecValueData];
			if(secAttrAccessible) {
				[attributes setObject:(__bridge id)secAttrAccessible forKey:(__bridge id)kSecAttrAccessible];
			}
			
			status = SecItemAdd((__bridge CFDictionaryRef)attributes, NULL);
			if(status == errSecSuccess) {
				result = YES;
			} else {
				if(error) {
					*error = [self OSStatusErrorWithOSStatus:status];
				}
			}
		}
			break;

		default:
		{
			if(error) {
				*error = [self OSStatusErrorWithOSStatus:status];
			}
		}
			break;
	}
	
	return result;
}

+ (BOOL)setPassword:(NSString*)password forService:(NSString*)service account:(NSString*)account error:(NSError **)error
{
	return [self setPassword:password forService:service account:account secAttrAccessible:NULL error:error];
}

+ (BOOL)removePasswordForService:(NSString*)service account:(NSString*)account error:(NSError **)error
{
	BOOL result = NO;

	NSMutableDictionary* query = [NSMutableDictionary dictionary];

	[query setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];

	if(service) {
		[query setObject:service forKey:(__bridge id)kSecAttrService];
	}

	if(account) {
		[query setObject:account forKey:(__bridge id)kSecAttrAccount];
	}
	
	OSStatus status = SecItemDelete((__bridge  CFDictionaryRef)query);
	
	if(status == errSecSuccess) {
		result = YES;
	} else {
		if(error) {
			*error = [self OSStatusErrorWithOSStatus:status];
		}
	}
	
	return result;
}

+ (NSArray *)allItemAttributesForService:(NSString*)service includesData:(BOOL)includesData error:(NSError **)error
{
	NSMutableDictionary *query = [NSMutableDictionary dictionary];

	[query setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
	if(service) {
		[query setObject:service forKey:(__bridge id)kSecAttrService];
	}

	[query setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnAttributes];
	[query setObject:(__bridge id)kSecMatchLimitAll forKey:(__bridge id)kSecMatchLimit];

	if(includesData) {
		[query setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
	}
	
	CFArrayRef result = NULL;
	OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&result);

	if(status == errSecSuccess) {
		return CFBridgingRelease(result);
	} else {
		if(error) {
			*error = [self OSStatusErrorWithOSStatus:status];
		}
	}

	return nil;
}

@end
