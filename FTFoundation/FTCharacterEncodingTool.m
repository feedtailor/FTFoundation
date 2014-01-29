//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import "FTCharacterEncodingTool.h"

typedef NSString*(^_FTCharacterEncodingTool)(NSStringEncoding encoding);

@implementation FTCharacterEncodingTool

@synthesize locale;

static CFStringEncoding s_encodingTbl[] = {
    kCFStringEncodingShiftJIS, // Japanese (Shift JIS)
    kCFStringEncodingEUC_JP, // Japanese (EUC)
	
    kCFStringEncodingUTF8, // Unicode (UTF-8)
	
    kCFStringEncodingDOSJapanese, // Japanese (Windows, DOS)
    kCFStringEncodingShiftJIS_X0213_00, // Japanese (Shift JIS X0213)
    kCFStringEncodingMacJapanese, // Japanese (Mac OS)
    kCFStringEncodingISO_2022_JP, // Japanese (ISO 2022-JP)
	
    kCFStringEncodingUnicode, // Unicode (UTF-16), kCFStringEncodingUTF16(in 10.4)
	
    kCFStringEncodingMacRoman, // Western (Mac OS Roman)
    kCFStringEncodingWindowsLatin1, // Western (Windows Latin 1)
	
    kCFStringEncodingMacChineseTrad, // Traditional Chinese (Mac OS)
    kCFStringEncodingMacChineseSimp, // Simplified Chinese (Mac OS)
    kCFStringEncodingEUC_TW,  // Traditional Chinese (EUC)
    kCFStringEncodingEUC_CN,  // Simplified Chinese (EUC)
    kCFStringEncodingDOSChineseTrad,  // Traditional Chinese (Windows, DOS)
    kCFStringEncodingDOSChineseSimplif,  // Simplified Chinese (Windows, DOS)
	
    kCFStringEncodingMacKorean, // Korean (Mac OS)
    kCFStringEncodingEUC_KR,  // Korean (EUC)
    kCFStringEncodingDOSKorean,  // Korean (Windows, DOS)
	
    kCFStringEncodingMacArabic, // Arabic (Mac OS)
    kCFStringEncodingMacHebrew, // Hebrew (Mac OS)
    kCFStringEncodingMacGreek, // Greek (Mac OS)
    kCFStringEncodingISOLatinGreek, // Greek (ISO 8859-7)
    kCFStringEncodingMacCyrillic, // Cyrillic (Mac OS)
    kCFStringEncodingISOLatinCyrillic, // Cyrillic (ISO 8859-5)
    kCFStringEncodingMacCentralEurRoman, // Central European (Mac OS)
    kCFStringEncodingMacTurkish, // Turkish (Mac OS)
    kCFStringEncodingMacIcelandic, // Icelandic (Mac OS)
	
    kCFStringEncodingISOLatin1, // Western (ISO Latin 1)
    kCFStringEncodingISOLatin2, // Central European (ISO Latin 2)
    kCFStringEncodingISOLatin3, // Western (ISO Latin 3)
    kCFStringEncodingISOLatin4, // Central European (ISO Latin 4)
    kCFStringEncodingISOLatin5, // Turkish (ISO Latin 5)
    kCFStringEncodingDOSLatinUS, // Latin-US (DOS)
    kCFStringEncodingWindowsLatin2, // Central European (Windows Latin 2)
    kCFStringEncodingNextStepLatin, // Western (NextStep)
    kCFStringEncodingNonLossyASCII, // Non-lossy ASCII

    kCFStringEncodingUTF16BE, // kCFStringEncodingUTF16BE
    kCFStringEncodingUTF16LE, // kCFStringEncodingUTF16LE
    kCFStringEncodingUTF32, // kCFStringEncodingUTF32
    kCFStringEncodingUTF32BE, // kCFStringEncodingUTF32BE
    kCFStringEncodingUTF32LE, // kCFStringEncodingUTF32LE
	
	kCFStringEncodingInvalidId,
};

static CFStringEncoding s_encodingTbl_ja[] = {
	kCFStringEncodingShiftJIS, // Japanese (Shift JIS)
    kCFStringEncodingEUC_JP, // Japanese (EUC)
    kCFStringEncodingDOSJapanese, // Japanese (Windows, DOS)
    kCFStringEncodingShiftJIS_X0213_00, // Japanese (Shift JIS X0213)
    kCFStringEncodingMacJapanese, // Japanese (Mac OS)
    kCFStringEncodingISO_2022_JP, // Japanese (ISO 2022-JP

	kCFStringEncodingInvalidId,
};

static CFStringEncoding s_encodingTbl_ko[] = {
    kCFStringEncodingMacKorean, // Korean (Mac OS)
    kCFStringEncodingEUC_KR,  // Korean (EUC)
    kCFStringEncodingDOSKorean,  // Korean (Windows, DOS)

	kCFStringEncodingInvalidId,
};

static CFStringEncoding s_encodingTbl_zh[] = {
	kCFStringEncodingMacChineseTrad, // Traditional Chinese (Mac OS)
    kCFStringEncodingMacChineseSimp, // Simplified Chinese (Mac OS)
    kCFStringEncodingEUC_TW,  // Traditional Chinese (EUC)
    kCFStringEncodingEUC_CN,  // Simplified Chinese (EUC)
    kCFStringEncodingDOSChineseTrad,  // Traditional Chinese (Windows, DOS)
    kCFStringEncodingDOSChineseSimplif,  // Simplified Chinese (Windows, DOS)

	kCFStringEncodingInvalidId,
};

static CFStringEncoding s_encodingTbl_el[] = {
    kCFStringEncodingMacGreek, // Greek (Mac OS)
    kCFStringEncodingISOLatinGreek, // Greek (ISO 8859-7)

	kCFStringEncodingInvalidId,
};

static CFStringEncoding s_encodingTbl_ar[] = {
    kCFStringEncodingMacArabic, // Arabic (Mac OS)

	kCFStringEncodingInvalidId,
};

static CFStringEncoding s_encodingTbl_he[] = {
    kCFStringEncodingMacHebrew, // Hebrew (Mac OS)

	kCFStringEncodingInvalidId,
};

static CFStringEncoding s_encodingTbl_tr[] = {
    kCFStringEncodingMacTurkish, // Turkish (Mac OS)
    kCFStringEncodingISOLatin5, // Turkish (ISO Latin 5)

	kCFStringEncodingInvalidId,
};

static CFStringEncoding s_encodingTbl_is[] = {
    kCFStringEncodingMacIcelandic, // Icelandic (Mac OS)

	kCFStringEncodingInvalidId,
};

+(NSString*) IANANameWithEncoding:(NSStringEncoding)encoding
{
	NSString* ret = (__bridge NSString*)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(encoding));
	return ret;
}

-(void) dealloc
{
	self.locale = nil;
}

static CFStringEncoding* __encodingsTableWithLaunguageCode(NSString* langCode)
{
	langCode = [langCode lowercaseString];
	if ([langCode isEqualToString:@"ja"]) {
		return s_encodingTbl_ja;
	} else if ([langCode isEqualToString:@"zh"]) {
		return s_encodingTbl_zh;
	} else if ([langCode isEqualToString:@"ko"]) {
		return s_encodingTbl_ko;
	} else if ([langCode isEqualToString:@"el"]) {
		return s_encodingTbl_el;
	} else if ([langCode isEqualToString:@"ar"]) {
		return s_encodingTbl_ar;
	} else if ([langCode isEqualToString:@"he"]) {
		return s_encodingTbl_he;
	} else if ([langCode isEqualToString:@"tr"]) {
		return s_encodingTbl_tr;
	} else if ([langCode isEqualToString:@"is"]) {
		return s_encodingTbl_is;
	}
	return nil;
}

-(NSStringEncoding) __detectEncodingWithBlock:(NSString*(^)(NSStringEncoding))block;
{
	if (!self.locale) {
		self.locale = [NSLocale currentLocale];
	}
		
	CFStringEncoding* tbl = __encodingsTableWithLaunguageCode([self.locale objectForKey:NSLocaleLanguageCode]);
	if (tbl) {
		for (int i = 0; ; i++) {
			CFStringEncoding cfEnc = tbl[i];
			if (cfEnc == kCFStringEncodingInvalidId) {
				break;
			}
			if (!CFStringIsEncodingAvailable(cfEnc)) {
				continue;
			}
			NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(cfEnc);
			NSString* str = block(encoding);
			if (str) {
				return encoding;
			}
		}		
	}
	
	for (int i = 0; ; i++) {
		CFStringEncoding cfEnc = s_encodingTbl[i];
		if (cfEnc == kCFStringEncodingInvalidId) {
			break;
		}
		if (!CFStringIsEncodingAvailable(cfEnc)) {
			continue;
		}
		NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(cfEnc);
		NSString* str = block(encoding);
		if (str) {
			return encoding;
		}
	}
	return NSUTF8StringEncoding;
}

-(NSStringEncoding) detectEncodingWithData:(NSData*)data
{
	if (memchr([data bytes], 0x1b, [data length]) != NULL) {
		NSString* str = [[NSString alloc] initWithData:data encoding:NSISO2022JPStringEncoding];
		if (str) {
			return NSISO2022JPStringEncoding;
		}
	}

	return [self __detectEncodingWithBlock:^NSString*(NSStringEncoding encoding) {
		return [[NSString alloc] initWithData:data encoding:encoding];
	}];
}

-(NSStringEncoding) detectEncodingWithBytes:(void*)bytes length:(size_t)length
{
	if (memchr(bytes, 0x1b, length) != NULL) {
		NSString* str = [[NSString alloc] initWithBytes:bytes length:length encoding:NSISO2022JPStringEncoding];
		if (str) {
			return NSISO2022JPStringEncoding;
		}
	}

	return [self __detectEncodingWithBlock:^NSString*(NSStringEncoding encoding) {
		return [[NSString alloc] initWithBytes:bytes length:length encoding:encoding];
	}];
}


@end
