//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import "FTNSBlockOperation+SelfReference.h"

@implementation NSBlockOperation (FTNSBlockOperationSelfReference)

- (void)ft_addExecutionBlock:(void (^)(NSBlockOperation *))block
{
	__weak NSBlockOperation *weakOp = self;
	
	[self addExecutionBlock:^{
		NSBlockOperation *op = weakOp;
		if(op) {
			block(op);
		}
	}];
}

+ (id)ft_blockOperationWithBlock:(void (^)(NSBlockOperation *))block
{
	NSBlockOperation *op = [[NSBlockOperation alloc] init];
	[op ft_addExecutionBlock:block];
	return op;
}

@end
