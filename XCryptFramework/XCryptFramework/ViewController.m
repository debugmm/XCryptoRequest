//
//  ViewController.m
//  XCryptFramework
//
//  Created by wujungao on 15/11/2017.
//  Copyright © 2017 wjg. All rights reserved.
//

#import "ViewController.h"

#import "TbCellView.h"

#import "XCryptManager.h"

#import "XCryptManagerProtocol.h"

@interface ViewController()<NSTableViewDelegate,NSTableViewDataSource,XCryptManagerProtocol>

@property (weak) IBOutlet NSTableView *tableview;
@property (weak) IBOutlet NSButton *startBtn;
@property (weak) IBOutlet NSButton *stopBtn;


- (IBAction)startAction:(NSButton *)sender;
- (IBAction)stopAction:(NSButton *)sender;

//datas
@property(nonatomic,strong)NSMutableArray *datas;

@property(nonatomic,assign)float progressValue;

@property(nonatomic,strong)id callbackParam;

@property(nonatomic,strong)NSRecursiveLock *opLock;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    [self configDatas];
    _opLock=[[NSRecursiveLock alloc] init];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

#pragma mark - Test NSRecursiveLock
-(void)getImageName:(NSMutableArray *)imageNames{

    NSString *imageName;
    [self.opLock lock];
    
    
    [self.opLock unlock];
}

#pragma mark -
-(void)configDatas{

    [self.datas addObject:@"/Users/wjg/Downloads/finished_upload_20171103.zip"];
    [self.datas addObject:@"/Users/wjg/Documents/enzp.zip"];
}

-(void)initConfigProgressValue{

    self.progressValue=0.0;
}

#pragma mark - Tb data source
-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{

    return 2;
}

#pragma mark - Tb delegate
//-(NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row{
//
//    
//}

- (nullable NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row{

    if(row>self.datas.count){
    
        return nil;
    }
    
    NSString *dd=[self.datas objectAtIndex:row];
    
    TbCellView *cell=[tableView makeViewWithIdentifier:@"tbCellView" owner:self];

    if([dd isEqualToString:(NSString *)self.callbackParam]){
    
        cell.progressIndicator.doubleValue=self.progressValue;
    }
    
    cell.progressIndicator.minValue=0.0;
    cell.progressIndicator.maxValue=1.0;
    
    return cell;
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
        
        [self.tableview reloadData];
    });
}

-(void)canceledXCrypt:(NSString *)sourceFilePath
          desFilePath:(NSString *)desFilePath
        callbackParam:(id)callbackParam{

    NSLog(@"canceledXCrypt\n");
}

#pragma mark - Btn Action
- (IBAction)startAction:(NSButton *)sender {
    
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

- (IBAction)stopAction:(NSButton *)sender {
    
    [[XCryptManager sharedManager] cancelXCryptRequest:self requestTag:@"/Users/wjg/Downloads/finished_upload_20171103.zip"];
    //
    [[XCryptManager sharedManager] cancelXCryptRequest:self requestTag:@"/Users/wjg/Documents/enzp.zip"];
}

#pragma mark - Property
-(NSMutableArray *)datas{
    
    if(!_datas){
        
        _datas=[[NSMutableArray alloc] initWithCapacity:1];
    }
    
    return _datas;
}

@end
