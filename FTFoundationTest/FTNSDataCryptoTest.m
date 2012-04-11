//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import "FTNSDataCryptoTest.h"
#import "FTNSData+Crypto.h"
#import "FTNSData+Random.h"
#import "Common.h"

@implementation FTNSDataCryptoTest

// All code under test must be linked into the Unit Test bundle
- (void)testCrypto
{
	NSData* d = [TEST_TEXT dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
	NSData* key = [NSData ft_randomDataWithLength:FTNSDataCryptoKeySize];
	
	NSData* encrypted = [d ft_encryptedDataWithInitializationVector:nil key:key];
	NSData* decrypted = [encrypted ft_decryptedDataWithInitializationVector:nil key:key];
	
	NSString* str = [[NSString alloc] initWithData:decrypted encoding:NSUTF8StringEncoding];
	
	STAssertTrue([str isEqualToString:TEST_TEXT], @"%@ = %@", str, TEST_TEXT);
}

- (void)testCrypto2
{
	NSData* d = [TEST_TEXT dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
	NSData* key = [NSData ft_randomDataWithLength:FTNSDataCryptoKeySize];
	NSData* iv = [NSData ft_randomDataWithLength:FTNSDataCryptoBlockSize];
	
	NSData* encrypted = [d ft_encryptedDataWithInitializationVector:iv key:key];
	NSData* decrypted = [encrypted ft_decryptedDataWithInitializationVector:iv key:key];
	
	NSString* str = [[NSString alloc] initWithData:decrypted encoding:NSUTF8StringEncoding];
	
	STAssertTrue([str isEqualToString:TEST_TEXT], @"%@ = %@", str, TEST_TEXT);
}

@end
