//
//  CPIRSSWebDetailViewController.m
//  cpzzd
//
//  Created by 王保霖 on 16/9/7.
//  Copyright © 2016年 Ricky. All rights reserved.
//

#import "CPIRSSWebDetailViewController.h"
#import "CPIRSSModel.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "IMTWebView.h"


@interface CPIRSSWebDetailViewController ()<UIWebViewDelegate,UIGestureRecognizerDelegate,IMTWebViewProgressDelegate>{

    UITapGestureRecognizer* singleTap;
    UIProgressView *progressView;
    UIActivityIndicatorView *indicatorView;;
}

@property (strong, nonatomic) IMTWebView * webView;

@end

@implementation CPIRSSWebDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNav];
    
    [self setupwebView];
    
    [self getDate];

}

-(void)viewWillAppear:(BOOL)animated{

    [self.navigationController.navigationBar setHidden:NO];
}

-(void)setUpNav{
    
    
    
    self.title = @"资讯正文";
    
    UIButton * back = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    [back setImage:CPImage(@"product_back") forState:UIControlStateNormal];
    
    back.frame = CGRectMake(0, 0,30, 44);
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:back];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
}


-(void)back:(UIButton *)button{
    
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)getDate{

    NSMutableDictionary *parameters1 = [[NSMutableDictionary alloc]init];
    [parameters1 setObject:[CPConfig sharedInstance].token forKey:@"token"];
    [parameters1 setObject:[NSString stringWithFormat:@"%@",self.model.Id] forKey:@"id"];
    
    
    [indicatorView startAnimating];

    
    [[CPNetManage sharedInstance] GETRequestWithPath:CPNetRequest_Header(@"article/Info") parameters:parameters1 completion:^(CPMessageResponse *messageResponse, NSError *err) {
        
        NSString *html = messageResponse.context[@"mobileartice"];
        
        [indicatorView stopAnimating];
        
        [self.webView loadHTMLString:html baseURL:nil];
        
    }];

}

-(void)setupwebView{

    
    progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    
    progressView.frame = CGRectMake(0.0f,0,CPScreen_Width, 3.0f);
    
    self.webView = [[IMTWebView alloc]initWithFrame:self.view.bounds];
    
    self.webView.delegate = self;
    
    self.webView.progressDelegate = self;
    
    self.webView.dataDetectorTypes = UIDataDetectorTypeAll;
    
    [self addTapOnWebView];

    
    [self.view addSubview:self.webView];
    
    [self.view insertSubview:progressView aboveSubview:self.webView];
    
    
    indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicatorView.frame = CGRectMake(0, 0, 30, 30);
    [self.view addSubview:indicatorView];
    indicatorView.center = self.view.center;
    [indicatorView startAnimating];
    [indicatorView setHidesWhenStopped:YES];

}


-(void)addTapOnWebView
{
    
    singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTap:)];
    [self.webView addGestureRecognizer:singleTap];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    
    CGPoint pt = [sender locationInView:self.webView];
    NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", pt.x, pt.y];

    NSString *urlToSave = [self.webView stringByEvaluatingJavaScriptFromString:imgURL];
    
    if([urlToSave hasPrefix:@"http"])
    {
        
        NSMutableArray *photos = [[NSMutableArray alloc]init];
        
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:urlToSave] ; // 图片路径
        [photos addObject:photo];
        
        
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
        browser.photos = photos; // 设置所有的图片
        [browser show];
    }
}

-(void)webView:(IMTWebView *)webView didReceiveResourceNumber:(int)resourceNumber totalResources:(int)totalResources{
    
    progressView.hidden = NO;
    
    [progressView setProgress:((float)resourceNumber) / ((float)totalResources) animated:YES];
    
    if (resourceNumber == totalResources) {
        
        webView.resourceCount = 0;
        
        webView.resourceCompletedCount = 0;
        
        progressView.hidden = YES;
        
        [indicatorView stopAnimating];
    }
    
}


-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [indicatorView stopAnimating];

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}



@end
