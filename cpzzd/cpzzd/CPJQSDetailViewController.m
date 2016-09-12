//
//  CPJQSDetailViewController.m
//  cpzzd
//
//  Created by 王保霖 on 16/9/7.
//  Copyright © 2016年 Ricky. All rights reserved.
//

#import "CPJQSDetailViewController.h"
#import "VideoPlayView.h"
#import "FullViewController.h"
#import "CPJQSModel.h"
#import "CPCommentTableViewCell.h"
#import "CPJQSDetailHeaderView.h"
#import "CPJQSCommentModel.h"
#import "NewCommentView.h"
#import "AppDelegate.h"

static NSString * Identifier = @"cell";

@interface CPJQSDetailViewController ()<VideoPlayViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@property (nonatomic, weak) VideoPlayView *playView;


@property (nonatomic, strong) FullViewController *fullView;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)int currentPage;
@property(nonatomic,strong)NSMutableArray *comments;

@property(nonatomic,strong)CPJQSDetailHeaderView *tableViewHeader;

@property (strong, nonatomic) UIView * ToolView;
@property(nonatomic,strong)NewCommentView *commentView;



@end

@implementation CPJQSDetailViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.view.backgroundColor = CPColor(@"dedede");
    
    [self setUpNav];
    
    
    self.currentPage = 1;
    
    [self setupVideoPlayView];
    
    [self setupTableView];
    
    
    [self.tableView.mj_header beginRefreshing];

}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

}


-(NewCommentView *)commentView{
    
    if(_commentView == nil){
        
        _commentView =[[[NSBundle mainBundle]loadNibNamed:@"NewCommentView" owner:self options:nil] lastObject];
        
        _commentView.frame = CGRectMake(0,CPScreen_Height,CPScreen_Width,160);
        
        _commentView.ContentTextView.delegate = self;
        
        [self.commentView.Cancle addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
        [self.commentView.Send addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:self.commentView];
    }
    
    return _commentView;
}


-(void)sendAction{

    NSString *encoded = [self.commentView.ContentTextView.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSString *path = CPNetRequest_Header(Comment_Request([CPConfig sharedInstance].token,self.model.Id,encoded));
    
    
    
    [[CPNetManage sharedInstance] PostRequestWithPath:path parameters:nil completion:^(CPMessageResponse *messageResponse, NSError *err) {
       
        
        [self cancleAction];
    }];
    
}


-(void)MakeDown{
    
    [UIView animateWithDuration:0.1 animations:^{
        
        self.commentView.frame =CGRectMake(0, CPScreen_Height, CPScreen_Width,0);
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self.commentView.ContentTextView becomeFirstResponder];
        self.commentView.ContentTextView.text = @"";
    }];
}

- (void)keyboardWillShow:(NSNotification*)notification{
    
    CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:1 animations:^{
        
        self.commentView.frame =CGRectMake(0, CPScreen_Height-keyboardRect.size.height-160, CPScreen_Width, 160);
        self.view.alpha = 1;
        
    } completion:^(BOOL finished) {
        
    }];
    
}

-(UIView *)ToolView{
    
    if(_ToolView == nil){
        
        _ToolView = [[UIView alloc]initWithFrame:CGRectMake(0,CPScreen_Height - 44, CPScreen_Width, 44)];
        
        _ToolView.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:_ToolView];
        
    }
    
    return _ToolView;
}

-(NSMutableArray *)comments{
    
    if(_comments == nil){
        
        _comments = [[NSMutableArray alloc]init];;
    }
    
    return _comments;
}

-(void)GetComments{

    NSMutableDictionary *parameters1 = [[NSMutableDictionary alloc]init];
    [parameters1 setObject:[CPConfig sharedInstance].token forKey:@"token"];
    [parameters1 setObject:[NSString stringWithFormat:@"%@",self.model.Id] forKey:@"recId"];
    [parameters1 setObject:[NSString stringWithFormat:@"%d",self.currentPage] forKey:@"index"];
    
    

    [[CPNetManage sharedInstance] GETRequestWithPath:CPNetRequest_Header(@"/comment/List") parameters:parameters1 completion:^(CPMessageResponse *messageResponse, NSError *err) {
       
        NSArray *arr = messageResponse.context[@"comments"];
        
        for (NSDictionary *dic in arr) {
    
            CPJQSCommentModel *model = [CPJQSCommentModel yy_modelWithDictionary:dic];
            
            [self.comments addObject:model];
        }
        [self.tableView reloadData];
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
    
}


-(void)setUpNav{
    
    
    self.title = @"视频正文";
    
    UIButton * back = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    [back setImage:CPImage(@"product_back") forState:UIControlStateNormal];
    
    back.frame = CGRectMake(0, 0,30, 44);
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:back];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
}



-(void)setupTableView{

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+CPScreen_Width/16*9, CPScreen_Width, CPScreen_Height - CPScreen_Width/16*9) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.showsHorizontalScrollIndicator = NO;

    
    [self.tableView registerNib:[UINib nibWithNibName:@"CPCommentTableViewCell" bundle:nil] forCellReuseIdentifier:Identifier];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        

        self.currentPage = 1;
        
        [self.comments removeAllObjects];
        
        [self  GetComments];
    }];
    
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        self.currentPage ++;
        
        [self  GetComments];
    }];
    
    
    
    self.tableViewHeader = [[[NSBundle mainBundle] loadNibNamed:@"CPJQSDetailHeaderView" owner:nil options:nil] lastObject];
    
    CGFloat hight = [CPTools CalculateCellHightWithString:self.model.Intro Size:CGSizeMake(CPScreen_Width - 24, 1000) Fontsize:15];
    hight = hight + 80;

    self.tableViewHeader.frame = CGRectMake(0, 0,CPScreen_Width, hight);
    
    self.tableView.tableHeaderView = self.tableViewHeader;
    
    self.tableViewHeader.Title.text = self.model.Title;
    
    self.tableViewHeader.time.text = [self.model.CreateTime substringWithRange:NSMakeRange(11, 5)];
    self.tableViewHeader.content.attributedText = [CPTools AttributedStringWithString:self.model.Intro space:5 fontSize:15];
    
    self.tableViewHeader.year.text = [self.model.CreateTime substringWithRange:NSMakeRange(0, 10)];
    
    [self.view addSubview:self.tableView];
    
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CPScreen_Width, 1)];
    
    line.backgroundColor = CPColor(@"dfdfdf");
    
    [self.ToolView addSubview:line];
    
    
    UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [commentButton setTitle:@"我要评" forState:UIControlStateNormal];
    
    commentButton.frame = CGRectMake(CPScreen_Width - 150 - 12,0, 150, 44);
    
    [commentButton setImage:[UIImage imageNamed:@"Video_Etid"] forState:UIControlStateNormal];
    
    commentButton.titleEdgeInsets = UIEdgeInsetsMake(0,15, 0, 0);
    
    [commentButton setTitleColor:CPColor(@"666666") forState:UIControlStateNormal];
    
    [self.ToolView addSubview:commentButton];
    
    [[commentButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
          [self.commentView.ContentTextView becomeFirstResponder];
    }];
    

}

- (void)keyboardWillHide:(NSNotification*)notification{
    
    
    [UIView animateWithDuration:1 animations:^{
        
        self.commentView.frame =CGRectMake(0, CPScreen_Height, CPScreen_Width,0);
        
    } completion:^(BOOL finished) {
        
        
        [self.commentView.ContentTextView resignFirstResponder];
    }];
}



-(void)ResignTextfield{
    
    [self.commentView.ContentTextView resignFirstResponder];
}

-(void)BecomeTextfield{
    
    [self.commentView.ContentTextView becomeFirstResponder];
}

-(void)cancleAction{
    
    self.commentView.ContentTextView.text = @"";
    
    [self.commentView.ContentTextView resignFirstResponder];
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    CPCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
    
    CPJQSCommentModel *model = self.comments[indexPath.row];
    
    cell.userName.text = model.MName;
    cell.Time.text = model.SubTime;
    cell.Content.text = model.Content;
    
    return  cell;
    

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    self.tableView.mj_footer.hidden = !self.comments.count;

    return self.comments.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    return 80;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 10;
}

-(void)back:(UIButton *)button{
    
    [self.playView playDeloc];
    [self.navigationController popViewControllerAnimated:YES];
}

- (FullViewController *)fullView
{
    if (_fullView == nil) {
        
        _fullView = [[FullViewController alloc] init];
    }
    return _fullView;
}


- (void)setupVideoPlayView
{
    
    VideoPlayView *viewPlayView = [VideoPlayView videoPlayView];
    viewPlayView.frame = CGRectMake(0,64,CPScreen_Width, CPScreen_Width/16*9);
    [self.view addSubview:viewPlayView];
    viewPlayView.delegate = self;
    self.playView = viewPlayView;
    
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.model.VideoUrl]];
    [self.playView setPlayerItem:item];
    
}




-(void)videoplayViewSwitchOrientation:(BOOL)isFull
{
    
    if (isFull) {
        
        AppDelegate * appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
        appDelegate.allowRotation = 1;
        [self presentViewController:self.fullView animated:YES completion:^{
            self.playView.frame = self.fullView.view.bounds;
            [self.fullView.view addSubview:self.playView];
        }];
    } else {
        
        AppDelegate * appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
        appDelegate.allowRotation = 0;
        
        [self.fullView dismissViewControllerAnimated:YES completion:^{
            [self.view addSubview:self.playView];
            self.playView.frame = CGRectMake(0,64, self.view.bounds.size.width, self.view.bounds.size.width*9/16);
        }];
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.commentView.ContentTextView resignFirstResponder];
}

-(BOOL)shouldAutorotate{

    return YES;
    
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


@end
