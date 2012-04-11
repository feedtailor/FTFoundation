//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

// AES-128
// CBC
// PKCS7 padding
// key len : kCCKeySizeAES256

#define FTNSDataCryptoKeySize (kCCKeySizeAES256)
#define FTNSDataCryptoBlockSize (kCCBlockSizeAES128)

@interface NSData (FTNSDataCrypto)

// no IV is provided, an IV of all zeroes will be used.
- (NSData *)ft_encryptedDataWithInitializationVector:(NSData *)iv key:(NSData *)key;
- (NSData *)ft_decryptedDataWithInitializationVector:(NSData *)iv key:(NSData *)key;

@end
