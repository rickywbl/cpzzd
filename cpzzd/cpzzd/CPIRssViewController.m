//
//  CPIRssViewController.m
//  cpzzd
//
//  Created by 王保霖 on 16/8/31.
//  Copyright © 2016年 Ricky. All rights reserved.
//

#import "CPIRssViewController.h"
#import "CPRootViewController.h"
#import "CPMenuViewController.h"
#import "CPSearchViewController.h"
#import "CPIRSSTableViewCell.h"
#import "CPIRSSModel.h"
#import "CPIRSSWebDetailViewController.h"

static NSString * Identifier = @"Identifier";

@interface CPIRssViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView * tableView;
@property (strong, nonatomic) RLMResults * Articles;
@property (nonatomic, strong) RLMNotificationToken *notification;
@property (assign, nonatomic) int currentPage;
@property (assign, nonatomic) BOOL isPush;

@end

@implementation CPIRssViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    
    [self  setupNotifi];
    
    [self setupNavbar];
    
    [self setUpTableView];
    
    [self.tableView.mj_header beginRefreshing];

    
}

-(void)setupNotifi{

    self.Articles = [[CPIRSSModel allObjects] sortedResultsUsingProperty:@"ReleaseDate" ascending:NO];
    
    __weak typeof(self) weakSelf = self;
    
    
    self.notification = [self.Articles addNotificationBlock:^(RLMResults * _Nullable results, RLMCollectionChange * _Nullable change, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"Failed to open Realm on background worker: %@", error);
            return;
        }
        
        UITableView *tv = weakSelf.tableView;
        
        
        if (!change) {
            
            [tv.mj_header endRefreshing];
            
            [tv.mj_footer endRefreshing];
            
            return;
        }
        
        
        [tv beginUpdates];
        
        [tv deleteRowsAtIndexPaths:[change deletionsInSection:0] withRowAnimation:UITableViewRowAnimationNone];
        
        [tv insertRowsAtIndexPaths:[change insertionsInSection:0] withRowAnimation:UITableViewRowAnimationNone];
        
        [tv reloadRowsAtIndexPaths:[change modificationsInSection:0] withRowAnimation:UITableViewRowAnimationNone];
        [tv endUpdates];
        
        
        
        [tv.mj_header endRefreshing];
            
        [tv.mj_footer endRefreshing];
        
        
    }];
    
    
}

#pragma mark ---  UI

-(void)setupNavbar{
    
    self.navigationItem.title = @"操盘早知道";
    
    UIButton * menu = [UIButton buttonWithType:UIButtonTypeCustom];
    
    
    [menu addTarget:self action:@selector(menushow:) forControlEvents:UIControlEventTouchUpInside];
    
    [menu setImage:CPImage(@"nav_menu") forState:UIControlStateNormal];
    
    menu.frame = CGRectMake(0, 0, 44, 44);
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:menu];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    UIButton * search = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [search setImage:CPImage(@"nav_search") forState:UIControlStateNormal];
    
    search.frame = CGRectMake(0, 0, 30, 44);
    
    UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc]initWithCustomView:search];
    
    [[search rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        CPSearchViewController *search = [[CPSearchViewController alloc]init];
        
        [search setHidesBottomBarWhenPushed:YES];
        
        [self.navigationController pushViewController:search animated:YES];
    }];
    
    
    
    UIButton * fresh = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [fresh setImage:CPImage(@"nav_refresh") forState:UIControlStateNormal];
    
    @weakify(self);
    
    [[fresh rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        
        [self.tableView.mj_header beginRefreshing];
        
    }];
    
    fresh.frame = CGRectMake(0, 0, 30, 44);
    
    UIBarButtonItem *rightItem2 = [[UIBarButtonItem alloc]initWithCustomView:fresh];
    
    self.navigationItem.rightBarButtonItems = @[rightItem2,rightItem1];
    
    
}

-(void)menushow:(UIButton *)Button{

 
    CPNavigationController * nav = (CPNavigationController * )[UIApplication sharedApplication].keyWindow.rootViewController;
    
    CPRootViewController *root = (CPRootViewController *)nav.visibleViewController;
    
    [root.menu MenuShow];
}

-(void)setUpTableView{

    

    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.showsHorizontalScrollIndicator = NO;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CPIRSSTableViewCell" bundle:nil] forCellReuseIdentifier:Identifier];
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        
        self.currentPage = 1;
        
        self.isPush = YES;
        
        [self setupData];
        
    }];
    
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        
        self.currentPage ++;
        
        self.isPush = NO;
        
         [self setupData];
    }];
    
    [self.view addSubview:self.tableView];
    
    
    UIImageView *headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CPScreen_Width, CPScreen_Width * 0.267)];
    
    headerImage.image = [UIImage imageNamed:@"HomeBanner"];
    
    self.tableView.tableHeaderView = headerImage;
    
}

-(void)setupData{

    NSString *path = CPNetRequest_Header(@"article/List");
    NSMutableDictionary *parameters1 = [[NSMutableDictionary alloc]init];
    [parameters1 setObject:[CPConfig sharedInstance].token forKey:@"token"];
    [parameters1 setObject:[NSString stringWithFormat:@"%d",self.currentPage] forKey:@"index"];
    
    [[CPNetManage sharedInstance] GETRequestWithPath:path parameters:parameters1 completion:^(CPMessageResponse *messageResponse, NSError *err) {
        
        if(err){
        
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            
            return ;
        }
        
        
        if(self.isPush == YES){
            
            if(self.Articles.count > 0){
            
                [[RLMRealm defaultRealm] transactionWithBlock:^{
                    
                    [[RLMRealm defaultRealm] deleteObjects:self.Articles];
                }];
            }
        

        }
        
        NSArray * articels = messageResponse.context[@"articles"];
        
        for (NSDictionary * dic in articels) {
            
            CPIRSSModel * model = [CPIRSSModel yy_modelWithDictionary:dic];
            
            [[RLMRealm defaultRealm] transactionWithBlock:^{
                
                [[RLMRealm defaultRealm] addOrUpdateObject:model];
            }];
            
            
        }
        
    }];

}


#pragma mark --- TableViewDataDelegate && TableViewDelegate


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    CPIRSSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
    
    CPIRSSModel *model = self.Articles[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.model = model;
    
    
    return  cell;
    

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    tableView.mj_footer.hidden = !self.Articles.count;
    
    return self.Articles.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    CPIRSSWebDetailViewController *web = [[CPIRSSWebDetailViewController alloc]init];
    
    web.model =  self.Articles[indexPath.row];
    
    [web setHidesBottomBarWhenPushed:YES];
    
    [self.navigationController pushViewController:web animated:YES];
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    CPIRSSModel *model = self.Articles[indexPath.row];
    
    CGFloat hight = [CPTools CalculateCellHightWithString:model.Title Size:CGSizeMake(CPScreen_Width - 24, 50) Fontsize:17];
    
    return [model.cellHight floatValue] + hight;
}

@end
