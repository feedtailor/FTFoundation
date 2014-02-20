//
//  Copyright (c) 2014 feedtailor inc. All rights reserved.
//

#import "FTBlockTimer.h"

@implementation FTBlockTimer
{
    void (^_timerFireBlock)(NSTimer *);
}

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval repeats:(BOOL)repeats timerFireBlock:(void (^)(NSTimer *))timerFireBlock;
{
    FTBlockTimer *target = [[FTBlockTimer alloc] initWithTimerFireBlock:timerFireBlock];
    return [NSTimer scheduledTimerWithTimeInterval:timeInterval target:target selector:@selector(timerFireMethod:) userInfo:nil repeats:repeats];
}

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)timeInterval repeats:(BOOL)repeats timerFireBlock:(void (^)(NSTimer *))timerFireBlock;
{
    FTBlockTimer *target = [[FTBlockTimer alloc] initWithTimerFireBlock:timerFireBlock];
    return [NSTimer timerWithTimeInterval:timeInterval target:target selector:@selector(timerFireMethod:) userInfo:nil repeats:repeats];
}

#pragma mark -

- (instancetype)initWithTimerFireBlock:(void (^)(NSTimer *))block
{
    self = [super init];
    if (self) {
        if (!block) {
            block = ^(NSTimer *timer){};
        }
        _timerFireBlock = [block copy];
    }
    return self;
}

- (void)timerFireMethod:(NSTimer *)timer
{
    _timerFireBlock(timer);
}

- (void)dealloc
{
}

@end
