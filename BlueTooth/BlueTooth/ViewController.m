//
//  ViewController.m
//  BlueToochPrint
//
//  Created by yu on 2020/6/14.
//  Copyright © 2020 yu. All rights reserved.
//

#import "ViewController.h"
#import "BlueListViewController.h"
#import "JWBluetoothManage.h"

@interface ViewController ()

@property (strong, nonatomic) JWBluetoothManage *manage;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"连接蓝牙" style:UIBarButtonItemStylePlain target:self action:@selector(clientBlue)];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.center = self.view.center;
    btn.bounds = CGRectMake(0, 0, 200, 30);
    [btn setTitle:@"打印" forState:UIControlStateNormal];
    btn.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.manage = [JWBluetoothManage sharedInstance];
}
- (void)btnClick {
    if (self.manage.connectedPerpheral == nil) {
        NSLog(@"请先设置打印机");
        return;
    }
    if (self.manage.stage != JWScanStageCharacteristics) {
        NSLog(@"打印机正在准备中...");
        return;
    }
    JWPrinter *printer = [[JWPrinter alloc] init];
    [printer appendText:[NSString stringWithFormat:@"收货人：小李子"] alignment:HLTextAlignmentLeft];
    [printer appendText:[NSString stringWithFormat:@"手机号：123456789"] alignment:HLTextAlignmentLeft];
    [printer appendText:[NSString stringWithFormat:@"地址：北京市人民路28号"] alignment:HLTextAlignmentLeft];
    [printer appendSeperatorLine];
    [printer appendLeftText:@"商品名称" middleText:@"数量" rightText:@"单价" isTitle:true];
    [printer appendLeftText:@"钱包" middleText:@"100000" rightText:@"元" isTitle:false];
    
}
- (void)clientBlue {
    BlueListViewController *vc = [[BlueListViewController alloc]init];
    [self.navigationController pushViewController:vc animated:true];
}
@end
