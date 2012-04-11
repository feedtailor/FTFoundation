//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import "FTNSData+Crypto.h"

@implementation NSData (FTNSDataCrypto)

- (NSData*)ft_encryptedDataWithInitializationVector:(NSData *)iv key:(NSData *)key
{
	if(iv && [iv length] != FTNSDataCryptoBlockSize) {
		return nil;
	}
	
	if([key length] != FTNSDataCryptoKeySize) {
		return nil;
	}
	
	size_t bufferLen = [self length] + FTNSDataCryptoBlockSize;
	void *buffer = malloc(bufferLen);
	size_t outLen = 0;
	
	CCCryptorStatus status = CCCrypt(kCCEncrypt,
									 kCCAlgorithmAES128,
									 kCCOptionPKCS7Padding,
									 [key bytes],
									 [key length],
									 [iv bytes],
									 [self bytes],
									 [self length],
									 buffer,
									 bufferLen,
									 &outLen);
	
	if(status == kCCSuccess) {
		return [NSData dataWithBytesNoCopy:buffer length:outLen];
	}
	
	free(buffer);
	return nil;
}

- (NSData*)ft_decryptedDataWithInitializationVector:(NSData *)iv key:(NSData *)key
{
	if(iv && [iv length] != FTNSDataCryptoBlockSize) {
		return nil;
	}
	
	if([key length] != FTNSDataCryptoKeySize) {
		return nil;
	}
	
	size_t bufferLen = [self length] + FTNSDataCryptoBlockSize;
	void *buffer = malloc(bufferLen);
	size_t outLen = 0;
	
	CCCryptorStatus status = CCCrypt(kCCDecrypt,
									 kCCAlgorithmAES128,
									 kCCOptionPKCS7Padding,
									 [key bytes],
									 [key length],
									 [iv bytes],
									 [self bytes],
									 [self length],
									 buffer,
									 bufferLen,
									 &outLen);
	
	if(status == kCCSuccess) {
		return [NSData dataWithBytesNoCopy:buffer length:outLen];
	}
	
	free(buffer);
	return nil;
}

@end
