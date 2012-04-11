//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import "FTNSString+DataLength.h"

@implementation NSString (FTNSStringDataLength)

+(NSString*) ft_stringWithLength:(unsigned long long)length
{
	float _length;
	if (length < 1024) {
		return [NSString stringWithFormat:@"%llu B", length];
	} else {
		_length = length / 1024.0;
		if (_length < 1024) {
			return [NSString stringWithFormat:@"%.2f KB", _length];			
		} else {
			_length = _length / 1024.0;
			if (_length < 1024) {
				return [NSString stringWithFormat:@"%.2f MB", _length];			
			} else {
				_length = _length / 1024.0;
				if (_length < 1024) {
					return [NSString stringWithFormat:@"%.2f GB", _length];			
				} else {
					_length = _length / 1024.0;
					if (_length < 1024) {
						return [NSString stringWithFormat:@"%.2f TB", _length];			
					}
				}
			}
		}
	}
	return [NSString stringWithFormat:@"%llu B", length];
}

+(NSString*) ft_shortStringWithLength:(unsigned long long)length
{
	unsigned long long _length;
	if (length < 1024) {
		return [NSString stringWithFormat:@"%llu B", length];
	} else {
		_length = length / 1024.0;
		if (_length < 1024) {
			return [NSString stringWithFormat:@"%llu K", _length];			
		} else {
			_length = _length / 1024.0;
			if (_length < 1024) {
				return [NSString stringWithFormat:@"%llu M", _length];			
			} else {
				_length = _length / 1024.0;
				if (_length < 1024) {
					return [NSString stringWithFormat:@"%llu G", _length];			
				} else {
					_length = _length / 1024.0;
					if (_length < 1024) {
						return [NSString stringWithFormat:@"%llu T", _length];			
					}
				}
			}
		}
	}
	return [NSString stringWithFormat:@"%llu B", length];	
}

@end
