//
//  CPSearchViewController.m
//  cpzzd
//
//  Created by 王保霖 on 16/9/1.
//  Copyright © 2016年 Ricky. All rights reserved.
//

#import "CPSearchViewController.h"
#import "CPSearchPlaceHolder.h"
#import "CPIRSSModel.h"
#import "CPIRSSTableViewCell.h"
#import "CPIRSSWebDetailViewController.h"


static NSString * Identifier = @"Identifier";



@interface CPSearchViewController ()<CYLTableViewPlaceHolderDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property (assign, nonatomic) int currentPage;
@property (strong, nonatomic) NSMutableArray * Articles;
@property (strong, nonatomic)  UITextField * searchTf;


@end

@implementation CPSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNav];
    
    
    [self  setupTableView];

}

-(NSMutableArray *)Articles{
    
    if(_Articles == nil){
        
        _Articles = [[NSMutableArray alloc]init];
    }
    
    return _Articles;
}

-(void)setupData{
    
    NSString *path = CPNetRequest_Header(@"article/List");
    NSMutableDictionary *parameters1 = [[NSMutableDictionary alloc]init];
    [parameters1 setObject:[CPConfig sharedInstance].token forKey:@"token"];
    [parameters1 setObject:[NSString stringWithFormat:@"%d",self.currentPage] forKey:@"index"];
    [parameters1 setObject:[NSString stringWithFormat:@"%@", self.searchTf.text] forKey:@"title"];
    
    [[CPNetManage sharedInstance] GETRequestWithPath:path parameters:parameters1 completion:^(CPMessageResponse *messageResponse, NSError *err) {
        
        if(err){
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            
            return ;
        }
        
        
        NSArray * articels = messageResponse.context[@"articles"];
        
        for (NSDictionary * dic in articels) {
            
            CPIRSSModel * model = [CPIRSSModel yy_modelWithDictionary:dic];
            
            [self.Articles addObject:model];
            
            
        }
        
        [self.tableView cyl_reloadData];
        
    }];
    
}

-(void)setUpNav{
    
    UIButton * back = [UIButton buttonWithType:UIButtonTypeCustom];

    [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    [back setImage:CPImage(@"product_back") forState:UIControlStateNormal];
    
    back.frame = CGRectMake(0, 0,30, 44);
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:back];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.searchTf = [[UITextField alloc]initWithFrame:CGRectMake(0, 0,100, 20)];
    
     self.searchTf.placeholder = @"请输入股票代码、关键字等";
    
     self.searchTf.textColor = [UIColor whiteColor];
    
     self.searchTf.returnKeyType = UIReturnKeySearch;
    
    [ self.searchTf setValue:CPColor(@"666666") forKeyPath:@"_placeholderLabel.textColor"];
    [ self.searchTf setValue:[UIFont systemFontOfSize:16.5] forKeyPath:@"_placeholderLabel.font"];
    
    UIImageView * searchView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,30, 20)];
    
    [searchView setImage:[UIImage imageNamed:@"nav_search"]];
    
    searchView.contentMode = UIViewContentModeCenter;
    
     self.searchTf.leftView = searchView;
    
     self.searchTf.leftViewMode = UITextFieldViewModeAlways;
    
    self.searchTf.delegate = self;
    
    self.navigationItem.titleView =  self.searchTf;
    
    
    
}




-(void)setupTableView{

    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CPIRSSTableViewCell" bundle:nil] forCellReuseIdentifier:Identifier];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
       
        self.currentPage ++;
        
        [self setupData];
    }];
    
    [self.view addSubview:self.tableView];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    [self.tableView cyl_reloadData];

}


-(void)back:(UIButton *)button{
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];

}



#pragma mark --- CYLTableViewPlaceHolderDelegate


- (UIView *)makePlaceHolderView{
    

    CPSearchPlaceHolder *place = [[[NSBundle mainBundle] loadNibNamed:@"CPSearchPlaceHolder" owner:self options:nil] lastObject];

    
    return place;

}

#pragma mark --- UITableViewDelegate,UITableViewDataSource


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


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    self.currentPage = 1;

    [self.Articles removeAllObjects];

    [self setupData];
    
    [textField resignFirstResponder];
    
    return YES;

}



@end
