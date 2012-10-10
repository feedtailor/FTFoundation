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


#if __IPHONE_OS_VERSION_MAX_ALLOWED < 60000

#if __has_feature(objc_subscripting)
@interface NSArray (_FT_XCODE44_)
- (id)objectAtIndexedSubscript:(NSUInteger)idx;
@end

@interface NSMutableArray (_FT_XCODE44_)
- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx;
@end

@interface NSDictionary (_FT_XCODE44_)
- (id)objectForKeyedSubscript:(id)key;
@end

@interface NSMutableDictionary (_FT_XCODE44_)
- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key;
@end
#endif

#if __has_feature(objc_bool)
#undef YES
#undef NO
#define YES __objc_yes
#define NO  __objc_no
#endif

#endif

#endif
