//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 usage

 NSBlockOperation *op = [NSBlockOperation ft_blockOperationWithBlock:^(NSBlockOperation *selfOp) {
     // ...
     if([selfOp isCancelled]) {
         // ...
     // ...
     }
 }];

 */

@interface NSBlockOperation (FTNSBlockOperationSelfReference)

+ (id)ft_blockOperationWithBlock:(void (^)(NSBlockOperation *))block;
- (void)ft_addExecutionBlock:(void (^)(NSBlockOperation *))block;

@end