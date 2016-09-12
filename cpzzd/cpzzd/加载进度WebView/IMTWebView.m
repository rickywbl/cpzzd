//
//  IMTWebView.m
//  webkittest
//
//  Created by Petr Dvorak on 11/23/11.
//  Copyright (c) 2011 Inmite. All rights reserved.
//

#import "IMTWebView.h"

@interface UIWebView ()
-(id)webView:(id)view identifierForInitialRequest:(id)initialRequest fromDataSource:(id)dataSource;
-(void)webView:(id)view resource:(id)resource didFinishLoadingFromDataSource:(id)dataSource;
-(void)webView:(id)view resource:(id)resource didFailLoadingWithError:(id)error fromDataSource:(id)dataSource;
-(NSURLRequest *)webView:(id )sender resource:(id)identifier willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse fromDataSource:(id)dataSource;
@end

@implementation IMTWebView

@synthesize progressDelegate;
@synthesize resourceCount;
@synthesize resourceCompletedCount;

-(id)webView:(id)view identifierForInitialRequest:(id)initialRequest fromDataSource:(id)dataSource
{
    [super webView:view identifierForInitialRequest:initialRequest fromDataSource:dataSource];
    return [NSNumber numberWithInt:resourceCount++];
}

-(NSURLRequest *)webView:(id )sender resource:(id)identifier willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse fromDataSource:(id)dataSource{
    NSURLRequest *r = nil;

    if (self.progressDelegate && [self.progressDelegate respondsToSelector:@selector(webView:willSendRequest:)]) {
        
        r = [self.progressDelegate webView:self willSendRequest:request];
        
    }else{
        r = request;
    }
    return r;
    
}

- (void)webView:(id)view resource:(id)resource didFailLoadingWithError:(id)error fromDataSource:(id)dataSource {
    [super webView:view resource:resource didFailLoadingWithError:error fromDataSource:dataSource];
    resourceCompletedCount++;
    if ([self.progressDelegate respondsToSelector:@selector(webView:didReceiveResourceNumber:totalResources:)]) {
        [self.progressDelegate webView:self didReceiveResourceNumber:resourceCompletedCount totalResources:resourceCount];
    }
}

-(void)webView:(id)view resource:(id)resource didFinishLoadingFromDataSource:(id)dataSource
{
    [super webView:view resource:resource didFinishLoadingFromDataSource:dataSource];
    resourceCompletedCount++;
    if ([self.progressDelegate respondsToSelector:@selector(webView:didReceiveResourceNumber:totalResources:)]) {
        [self.progressDelegate webView:self didReceiveResourceNumber:resourceCompletedCount totalResources:resourceCount];
    }
}


@end
