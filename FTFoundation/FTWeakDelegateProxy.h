//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * asign参照仕様のdelegateをweak参照仕様の様に扱うproxyオブジェクト

 * 概念図

 [対象オブジェクト]-(delegate:assign)-[FTWeakDelegateProxy]-(delegate:weak)-[real delegate]

 * real delegate が消滅した場合、FTWeakDelegateProxyはdelegateメソッドを無視する

 * FTWeakDelegateProxyがreal delegateに転送するメソッドは、
 - (void)addForwardableSelector:(SEL)selector; で明示的に指定する必要がある。

 * FTWeakDelegateProxyを誰が保持するか

 対象となるオブジェクトにassosiative referenceとして保持させるのが簡単。
 [対象オブジェクト]-(assosiative reference)-[FTWeakDelegateProxy]
 
 + weakDelegateProxyWithDelegate:objectToAttach:
 - attachToObject:

 では、objectToAttach引数のオブジェクトにselfをassosiative referenceで関連づける。

 * 使用例

 UIWebView *wv = [[UIWebView alloc] initWithFrame:frame];
 FTWeakDelegateProxy *delegateProxy = [FTWeakDelegateProxy weakDelegateProxyWithDelegate:self
																	      objectToAttach:wv];
 [delegateProxy addForwardableSelector:@selector(webViewDidStartLoad:)];
 wv.delegate = (id <UIWebViewDelegate>)delegateProxy;

 */

@interface FTWeakDelegateProxy : NSObject

@property (nonatomic, weak, readonly) id delegate;

+ (id)weakDelegateProxyWithDelegate:(id)realDelegate
					 objectToAttach:(id)objectToAttach;

- (id)initWithDelegate:(id)realDelegate;
- (void)addForwardableSelector:(SEL)selector;

- (void)attachToObject:(id)object;

@end
