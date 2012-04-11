//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#ifndef FTFoundation_FTMacros_h
#define FTFoundation_FTMacros_h

#import <Foundation/Foundation.h>

#define FT_IS_DICTIONARY(__dic__)	((__dic__) && [(__dic__) isKindOfClass:[NSDictionary class]])
#define FT_IS_ARRAY(__arr__)		((__arr__) && [(__arr__) isKindOfClass:[NSArray class]])
#define FT_IS_STRING(__str__)		((__str__) && [(__str__) isKindOfClass:[NSString class]])
#define FT_IS_NUMBER(__num__)		((__num__) && [(__num__) isKindOfClass:[NSNumber class]])
#define FT_IS_DATE(__date__)		((__date__) && [(__date__) isKindOfClass:[NSDate class]])
#define FT_CHECK_NULL(__obj__)		((!(__obj__) || [(__obj__) isKindOfClass:[NSNull class]]) ? nil : (__obj__))

#define FT_LOCALIZED(__str__)					NSLocalizedString((__str__), @"")
#define FT_LOCALIZED_TABLE(__str__, __table__)	NSLocalizedStringFromTable((__str__), (__table__), @"")

#endif
