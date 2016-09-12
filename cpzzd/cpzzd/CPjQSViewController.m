//
//  CPjQSViewController.m
//  cpzzd
//
//  Created by 王保霖 on 16/8/31.
//  Copyright © 2016年 Ricky. All rights reserved.
//

#import "CPjQSViewController.h"
#import "CPRootViewController.h"
#import "CPMenuViewController.h"
#import "CPSearchViewController.h"
#import "CPJQSTableViewCell.h"
#import "CPJQSModel.h"
#import "CPJQSDetailViewController.h"

static NSString *Identifier = @"JQS";

@interface CPjQSViewController ()<UITableViewDelegate,UITableViewDataSource>{

    UILabel *dataText;
}

@property (strong, nonatomic) UITableView * tableView;
@property (strong, nonatomic) RLMResults * Articles;
@property (nonatomic, strong) RLMNotificationToken *notification;
@property (assign, nonatomic) int currentPage;
@property (assign, nonatomic) BOOL isPush;


@end

@implementation CPjQSViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    [self setupNavbar];
    
    [self setupTableView];
    
    
    [self setupNotifi];
    
    [self.tableView.mj_header beginRefreshing];
    
}


-(void)setupNotifi{
    
    self.Articles = [[CPJQSModel allObjects] sortedResultsUsingProperty:@"CreateTime" ascending:NO];
    
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
        
        
        [tv reloadData];
        
        
        [tv.mj_header endRefreshing];
        
        [tv.mj_footer endRefreshing];
        
        
    }];
    
    
}

-(void)loadData{
    
    NSMutableDictionary *parameters1 = [[NSMutableDictionary alloc]init];
    [parameters1 setObject:[CPConfig sharedInstance].token forKey:@"token"];
    [parameters1 setObject:[NSString stringWithFormat:@"%d",self.currentPage] forKey:@"index"];

    [[CPNetManage sharedInstance] GETRequestWithPath:CPNetRequest_Header(@"/video/List") parameters:parameters1 completion:^(CPMessageResponse *messageResponse, NSError *err) {
        
        

        if(self.isPush == YES){
            
            if(self.Articles.count > 0){
                
                [[RLMRealm defaultRealm] transactionWithBlock:^{
                    
                    [[RLMRealm defaultRealm] deleteObjects:self.Articles];
                }];
            }
            
            
        }
        
        NSArray * articels = messageResponse.context[@"videos"];
        
        
        for (NSDictionary * dic in articels) {
            
            CPJQSModel * model = [CPJQSModel yy_modelWithDictionary:dic];
            
            [[RLMRealm defaultRealm] transactionWithBlock:^{
                
                [[RLMRealm defaultRealm] addOrUpdateObject:model];
            }];
            
            
        }

    }];

}

#pragma mark ---  UI

-(void)setupTableView{

    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       
        self.currentPage = 1;
        
        self.isPush = YES;
        
        [self loadData];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        self.currentPage ++ ;
        
        self.isPush = NO;
        
        [self loadData];
    }];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CPJQSTableViewCell" bundle:nil] forCellReuseIdentifier:Identifier];
    
    [self.view addSubview:self.tableView];
    
    
    UIView *header =[[UIView alloc]initWithFrame:CGRectMake(0, 0, CPScreen_Width, 40)];
    
    UILabel *lab1 =[[UILabel alloc]initWithFrame:CGRectMake(12, 0, 100, 40)];
    
    lab1.text = @"复盘视频";
    
    lab1.textColor = CPColor(@"666666");
    
    lab1.font = [UIFont systemFontOfSize:16];
    
    [header addSubview:lab1];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 39, CPScreen_Width, 1)];
    
    line.backgroundColor = CPColor(@"ebebeb");
    
    [header addSubview:line];
    
    
    dataText = [[UILabel alloc]initWithFrame:CGRectMake(CPScreen_Width - 200 - 12, 0, 200, 40)];
    
    dataText.textAlignment = NSTextAlignmentRight;
    
    NSDate *date =[NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    NSInteger currentYear=[[formatter stringFromDate:date] integerValue];
    [formatter setDateFormat:@"MM"];
    NSInteger currentMonth=[[formatter stringFromDate:date]integerValue];
    [formatter setDateFormat:@"dd"];
    NSInteger currentDay=[[formatter stringFromDate:date] integerValue];
    
    dataText.text = [NSString stringWithFormat:@"%ld年%ld月%ld日",currentYear,currentMonth,currentDay];
    dataText.textColor = CPColor(@"666666");
    dataText.font = [UIFont systemFontOfSize:16];
    
    [header addSubview:dataText];

    self.tableView.tableHeaderView = header;
    

}

-(void)setupNavbar{
    
    self.navigationItem.title = @"复盘";
    
    UIButton * menu = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [menu setImage:CPImage(@"nav_menu") forState:UIControlStateNormal];
    
    menu.frame = CGRectMake(0, 0, 44, 44);
    
    [menu addTarget:self action:@selector(menushow:) forControlEvents:UIControlEventTouchUpInside];

    
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
    
    fresh.frame = CGRectMake(0, 0, 30, 44);
    
    
    [[fresh rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
       
        [self.tableView.mj_header beginRefreshing];
    }];
    
    UIBarButtonItem *rightItem2 = [[UIBarButtonItem alloc]initWithCustomView:fresh];
    
    self.navigationItem.rightBarButtonItems = @[rightItem2,rightItem1];

    
}

-(void)menushow:(UIButton *)Button{
    
    
    CPNavigationController * nav = (CPNavigationController * )[UIApplication sharedApplication].keyWindow.rootViewController;
    
    CPRootViewController *root = (CPRootViewController *)nav.visibleViewController;
    
    [root.menu MenuShow];
}

#pragma mark --- TableViewDelegate && TableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    CPJQSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
    
    CPJQSModel *model = self.Articles[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.JQSTitle.text = model.Title;
        
    cell.JQSTeacher.text = model.Teacher;
    
    cell.JQSTime.text = [model.CreateTime substringWithRange:NSMakeRange(11, 5)];
    
   cell.JQSSource.text = model.Source;
    
    [cell.JQSImage sd_setImageWithURL:[NSURL URLWithString:model.ImgUrl] placeholderImage:[UIImage imageNamed:@"backGroundImage"]];
    
    return  cell;
    

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.Articles.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    CPJQSModel *model = self.Articles[indexPath.row];
    
    CGFloat hight = [CPTools CalculateCellHightWithString:model.Title Size:CGSizeMake(CPScreen_Width *0.67, 100) Fontsize:17];
    
    return CPScreen_Width * 0.67 + hight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CPJQSDetailViewController *web = [[CPJQSDetailViewController alloc]init];
    
    web.model =  self.Articles[indexPath.row];
    
    [web setHidesBottomBarWhenPushed:YES];
    
    [self.navigationController pushViewController:web animated:YES];
    
    
}




@end
