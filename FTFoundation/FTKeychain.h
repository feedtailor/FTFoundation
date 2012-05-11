//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTKeychain : NSObject

+ (NSString*)passwordForService:(NSString*)service account:(NSString*)account error:(NSError **)error;

+ (BOOL)setPassword:(NSString*)password
		 forService:(NSString*)service
			account:(NSString*)account
  secAttrAccessible:(CFTypeRef)secAttrAccessible	// kSecAttrAccessible の取りうる値 or NULL
			  error:(NSError **)error;

+ (BOOL)setPassword:(NSString*)password forService:(NSString*)service account:(NSString*)account error:(NSError **)error;

+ (BOOL)removePasswordForService:(NSString*)service	// optional
						 account:(NSString*)account	// optional
						   error:(NSError **)error;

+ (NSArray *)allItemAttributesForService:(NSString*)service	// optional
							includesData:(BOOL)includesData
								   error:(NSError **)error;

@end
