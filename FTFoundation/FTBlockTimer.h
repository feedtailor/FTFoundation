//
//  Copyright (c) 2014 feedtailor inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTBlockTimer : NSObject

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval repeats:(BOOL)repeats timerFireBlock:(void (^)(NSTimer *))timerFireBlock;
+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)timeInterval repeats:(BOOL)repeats timerFireBlock:(void (^)(NSTimer *))timerFireBlock;

@end
