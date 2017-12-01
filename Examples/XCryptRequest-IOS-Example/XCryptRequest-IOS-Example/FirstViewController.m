//
//  FirstViewController.m
//  XCryptRequest-IOS-Example
//
//  Created by wjg on 16/11/2017.
//  Copyright © 2017 wujungao. All rights reserved.
//

#import "FirstViewController.h"

#import "TableViewCell.h"

@interface FirstViewController ()<XCryptManagerProtocol,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *stopBtn;

- (IBAction)startAction:(UIButton *)sender;
- (IBAction)stopAction:(UIButton *)sender;

#pragma mark -
//datas
@property(nonatomic,strong)NSMutableArray *datas;

@property(nonatomic,assign)float progressValue;

@property(nonatomic,strong)id callbackParam;

@property(nonatomic,strong)NSRecursiveLock *opLock;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configDatas];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
-(void)configDatas{
    
    [self.datas addObject:@"/Users/wjg/Downloads/finished_upload_20171103.zip"];
    [self.datas addObject:@"/Users/wjg/Documents/enzp.zip"];
}

-(void)initConfigProgressValue{
    
    self.progressValue=0.0;
}

#pragma mark - Tb Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.datas.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row>self.datas.count || indexPath.row<0){
        
        return nil;
    }
    
    NSString *dd=[self.datas objectAtIndex:indexPath.row];
    
    TableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"tbCell"];
    if(!cell){
    
        cell=[[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tbCell"];
    }
    
    if([dd isEqualToString:(NSString *)self.callbackParam]){
    
        cell.progressView.progress=self.progressValue;
    }
    
    return cell;
}

#pragma mark - Btn Action
- (IBAction)startAction:(UIButton *)sender {
    
    NSDictionary *param=@{@"CCOperation":@(0),
                          @"SourceFilePath":@"/Users/wjg/Downloads/finished_upload_20171103.zip",
                          @"IV":@"1234567890987654",
                          @"Key":@"qazwsxedcrfvtgbyhnujmiklopqazwsx"
                          };
    
    NSDictionary *paramb=@{@"CCOperation":@(1),
                           @"SourceFilePath":@"/Users/wjg/Documents/enzp.zip",
                           @"IV":@"1234567890987654",
                           @"Key":@"qazwsxedcrfvtgbyhnujmiklopqazwsx"
                           };
    
    [[XCryptManager sharedManager] sendAESCBCXCryptRequest:self requestParam:param callbackParam:@"/Users/wjg/Downloads/finished_upload_20171103.zip"];
    
    [[XCryptManager sharedManager] sendAESCBCXCryptRequest:self requestParam:paramb callbackParam:@"/Users/wjg/Documents/enzp.zip"];
}

- (IBAction)stopAction:(UIButton *)sender {
    
    [[XCryptManager sharedManager] cancelXCryptRequest:self requestTag:@"/Users/wjg/Downloads/finished_upload_20171103.zip"];
    //
    [[XCryptManager sharedManager] cancelXCryptRequest:self requestTag:@"/Users/wjg/Documents/enzp.zip"];
}

#pragma mark - XCryptManager Protocol
-(void)finishedXCrypt:(NSString *)sourceFilePath
          desFilePath:(NSString *)desFilePath
        callbackParam:(id)callbackParam{
    
    NSLog(@"finishedXCrypt\n");
}

-(void)failedXCrypt:(NSString *)sourceFilePath
        desFilePath:(NSString *)desFilePath
      callbackParam:(id)callbackParam
   failedStatusCode:(NSInteger)statusCode
          failedMsg:(NSString *)failedMsg{
    
    NSLog(@"failedXCrypt,statusCode:%d\n",statusCode);
}

-(void)xcryptProgressValue:(float)progressValue
            sourceFilePath:(NSString *)sourceFilePath
               desFilePath:(NSString *)desFilePath
             callbackParam:(id)callbackParam{
    
    NSLog(@"xcryptProgressValue:%f\n",progressValue);
    self.progressValue=progressValue;
    self.callbackParam=callbackParam;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.tableView reloadData];
    });
}

-(void)canceledXCrypt:(NSString *)sourceFilePath
          desFilePath:(NSString *)desFilePath
        callbackParam:(id)callbackParam{
    
    NSLog(@"canceledXCrypt\n");
}

#pragma mark - Property
-(NSMutableArray *)datas{
    
    if(!_datas){
        
        _datas=[[NSMutableArray alloc] initWithCapacity:1];
    }
    
    return _datas;
}

@end
