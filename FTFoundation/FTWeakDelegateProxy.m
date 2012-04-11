//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import "FTWeakDelegateProxy.h"
#import <objc/runtime.h>

@implementation FTWeakDelegateProxy
{
	NSMutableDictionary *_methodSignatureMap;
	__weak id _delegate;
}

@synthesize delegate = _delegate;

- (id)initWithDelegate:(id)realDelegate
{
	if(!realDelegate) {
		return nil;
	}

    self = [super init];
    if(self) {
		_delegate = realDelegate;
		_methodSignatureMap = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)addForwardableSelector:(SEL)selector
{
	NSMethodSignature *methodSignature = [_delegate methodSignatureForSelector:selector];
	NSValue *selectorValue = [NSValue value:&selector withObjCType:@encode(SEL)];
	[_methodSignatureMap setObject:methodSignature forKey:selectorValue];
}

- (void)dealloc
{
}

- (BOOL)respondsToSelector:(SEL)selector
{
	NSValue *selectorValue = [NSValue value:&selector withObjCType:@encode(SEL)];
	if([_methodSignatureMap objectForKey:selectorValue]) {
		return YES;
	}
	
	return [super respondsToSelector:selector];
}

- (void)forwardInvocation:(NSInvocation*)invocation
{
    if([_delegate respondsToSelector:[invocation selector]]) {
        [invocation invokeWithTarget:_delegate];
		return;
    }
	
	SEL selector = [invocation selector];
	NSValue *selectorValue = [NSValue value:&selector withObjCType:@encode(SEL)];
	if([_methodSignatureMap objectForKey:selectorValue]) {
		return;
	}
	
	[super forwardInvocation:invocation];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
	if(_delegate) {
		return [_delegate methodSignatureForSelector:selector];
	}
	
	NSValue *selectorValue = [NSValue value:&selector withObjCType:@encode(SEL)];
	NSMethodSignature *methodSignature = [_methodSignatureMap objectForKey:selectorValue];
	if(methodSignature) {
		return methodSignature;
	}
	
	return [super methodSignatureForSelector:selector];;
}

#pragma mark - 

- (void)attachToObject:(id)objectToAttach
{
	static char delegateProxyKey;
	objc_setAssociatedObject(objectToAttach, &delegateProxyKey, self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (id)weakDelegateProxyWithDelegate:(id)realDelegate
					 objectToAttach:(id)objectToAttach
{
	FTWeakDelegateProxy *proxy = [[FTWeakDelegateProxy alloc] initWithDelegate:realDelegate];
	if(proxy) {
		[proxy attachToObject:objectToAttach];
	}
	return proxy;
}

@end
