//
//  CPAcountViewController.m
//  cpzzd
//
//  Created by 王保霖 on 16/9/1.
//  Copyright © 2016年 Ricky. All rights reserved.
//

#import "CPAcountViewController.h"
#import "CPAcountTableViewCell.h"
#import "CPAcountHeaderView.h"
#import "CPAcountTFTableViewCell.h"
#import "CPAcountTableViewFooter.h"

static NSString * Identifier = @"cell";

@interface CPAcountViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic)UITableView *tableView;

@property(strong,nonatomic)NSMutableArray *results;

@property(strong,nonatomic)UIImageView *ArrowImage;

@property(strong,nonatomic)CPAcountTableViewFooter *tableFooter;

@property(strong,nonatomic)CPAcountHeaderView *headerView;

@property(strong,nonatomic)UIButton *finish;

@property(assign,nonatomic)BOOL isOpen;

//

@end

@implementation CPAcountViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = CPMainBGCOLOR;
    
    [self setUpNav];
    
    [self setupTableView];

}
-(CPAcountTableViewFooter *)tableFooter{
    
    if(_tableFooter == nil){
        
        _tableFooter = [[[NSBundle mainBundle] loadNibNamed:@"CPAcountTableViewFooter" owner:nil options:nil]lastObject];
        
    }
    
    return _tableFooter;
}


-(NSMutableArray *)results{
    
    if(_results == nil){
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"AcountManage" ofType:@"plist"];
        
        _results = [NSMutableArray arrayWithContentsOfFile:path];
    }
    
    return _results;
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:NO];

	}


-(void)setUpNav{
    
    
    self.title = @"账户管理";
    
    UIButton * back = [UIButton buttonWithType:UIButtonTypeCustom];
    
    
    [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    [back setImage:CPImage(@"product_back") forState:UIControlStateNormal];
    
    back.frame = CGRectMake(0, 0,30, 44);
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:back];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    
    self.finish = [UIButton buttonWithType:UIButtonTypeCustom];
    
    
    
    [self.finish setTitle:@"完成" forState:UIControlStateNormal];
    
    self.finish.titleLabel.font = [UIFont systemFontOfSize:15];

    self.finish.frame = CGRectMake(0, 0, 44, 44);
    
    UIBarButtonItem *rightItem2 = [[UIBarButtonItem alloc]initWithCustomView: self.finish];
    
    [[self.finish rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        NSString *path = CPNetRequest_Header(ChangePassword_Request([CPConfig sharedInstance].token, self.tableFooter.oldPassword.text, self.tableFooter.newpassword.text));
       
        [[CPNetManage sharedInstance] PostRequestWithPath:path parameters:nil completion:^(CPMessageResponse *messageResponse, NSError *err) {
           
            [SVProgressHUD showInfoWithStatus:messageResponse.Message];
            
            [UIView animateWithDuration:0.5 animations:^{
                    
                    self.view.frame = CGRectMake(0,0,CPScreen_Width, CPScreen_Height);
                    
            } completion:^(BOOL finished) {
                    
                    [self.view endEditing:YES];
                    
            }];

            

            
        }];
    }];
    
    self.navigationItem.rightBarButtonItem = rightItem2;
    
}

-(void)back:(UIButton *)button{
    
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)setupTableView{
    
    self.isOpen = NO;

    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    self.tableView.delegate = self;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.headerView =[[[NSBundle mainBundle]loadNibNamed:@"CPAcountHeaderView" owner:nil options:nil]lastObject];
    
     self.headerView.frame = CGRectMake(0, 0, self.view.width, self.view.width * 0.34);
    
    self.tableView.tableHeaderView =  self.headerView;
    
    
    self.tableView.dataSource = self;
    
    
    [self.view addSubview:self.tableView];

}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

      NSDictionary *resultdic = self.results[indexPath.section][indexPath.row];

    if(indexPath.section == 0){
    
        CPAcountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
        
        if(cell == nil){
        
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CPAcountTableViewCell" owner:nil options:nil]lastObject];
            

            cell.CPTitle.text = resultdic[@"Title"];
            
            cell.AcountImage.image = [UIImage imageNamed:resultdic[@"Image"]];
            
            cell.CPSubTitle.text = indexPath.row == 0?[CPConfig sharedInstance].userName:[CPConfig sharedInstance].expiration;

            
        }
        
        return cell;
    
    }else{
    
    
        CPAcountTFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
        
        if(cell == nil){
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CPAcountTFTableViewCell" owner:nil options:nil]lastObject];
        }
        
        return cell;
        
    }

    

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray * rows = self.results[section];
    
    return rows.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    return 44;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.results.count;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if(section == 1 ){
    
        
        UIView * sectionHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 43)];
        
        sectionHeader.backgroundColor = [UIColor whiteColor];
        
        UIImageView *imageView =[[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"Account_密码修改"];
        [sectionHeader addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerY.equalTo(sectionHeader);
            make.left.equalTo(sectionHeader.mas_left).offset(12);
        }];
        
        UILabel * title = [[UILabel alloc]init];
        
        title.text = @"密码修改";
        
        title.textColor = CPColor(@"333333");
        
        title.font = [UIFont systemFontOfSize:15.2];
        
        [sectionHeader addSubview:title];
        
        
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(imageView.mas_right).offset(10);
            make.centerY.equalTo(sectionHeader);
            
            
        }];
        
        self.ArrowImage = [[UIImageView alloc]init];
        
        self.isOpen = NO;
        
        self.ArrowImage.image = [UIImage imageNamed:@"Account_arrow2"];
        
        [sectionHeader addSubview: self.ArrowImage];
        
        [self.ArrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.right.equalTo(sectionHeader.mas_right).offset(-12);
            make.centerY.equalTo(sectionHeader);

        }];
        
        
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changePassword)];
        
        sectionHeader.userInteractionEnabled = YES;
        
        [sectionHeader addGestureRecognizer:tap];
        
        return sectionHeader;
        
    
    }
    
    return nil;

}

-(void)changePassword{
    
     self.isOpen = !self.isOpen;
    
    if(self.isOpen){
    
        self.ArrowImage.image = [UIImage imageNamed:@"Account_arrow1"];
        
        self.tableView.tableFooterView = self.tableFooter;

        self.tableFooter.oldPassword.text = @"";
        
        self.tableFooter.newpassword.text = @"";
        
        self.tableFooter.replyPassword.text = @"";
        
        [self.tableFooter.oldPassword becomeFirstResponder];
        
        [UIView animateWithDuration:0.5 animations:^{
            
            
            self.view.frame = CGRectMake(0,-150,CPScreen_Width, CPScreen_Height);
        }];

        
        
    }else{
    
        self.ArrowImage.image = [UIImage imageNamed:@"Account_arrow2"];
        
        self.tableView.tableFooterView = [[UIView alloc]init];
        
        
        [UIView animateWithDuration:0.5 animations:^{
    
            self.view.frame = CGRectMake(0,0,CPScreen_Width, CPScreen_Height);
            
        } completion:^(BOOL finished) {
            
            [self.view endEditing:YES];
            
        }];

        
    }

}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if(section == 1){
    
        return 44;
    }
    
    return 20;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if(section == 0){
    
        return 20;
    }

    return 1;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];
    [self.tableFooter endEditing:YES];
}

@end
