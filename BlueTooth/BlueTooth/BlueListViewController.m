//
//  BlueListViewController.m
//  BlueToochPrint
//
//  Created by yu on 2020/6/14.
//  Copyright © 2020 yu. All rights reserved.
//

#import "BlueListViewController.h"
#import "JWBluetoothManage.h"

@interface BlueListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataSource; //设备列表
@property (nonatomic, strong) NSMutableArray *rssisArray; //信号强度 可选择性使用
@property (strong, nonatomic) JWBluetoothManage *manage;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation BlueListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.title = @"蓝牙选择";
    self.dataSource = @[].mutableCopy;
    self.rssisArray = @[].mutableCopy;
    self.manage = [JWBluetoothManage sharedInstance];
    [self.manage beginScanPerpheralSuccess:^(NSArray<CBPeripheral *> *peripherals, NSArray<NSNumber *> *rssis) {
        self.dataSource = [NSMutableArray arrayWithArray:peripherals];
        self.rssisArray = [NSMutableArray arrayWithArray:rssis];
        [self.tableView reloadData];
    } failure:^(CBManagerState status) {
        NSLog(@"状态是%@",status);
    }];
    self.manage.disConnectBlock = ^(CBPeripheral *perpheral, NSError *error) {
        NSLog(@"设备已经断开连接！");
    };
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 71;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    CBPeripheral *peripherral = [self.dataSource objectAtIndex:indexPath.row];
    if (peripherral.state == CBPeripheralStateConnected) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"名称:%@",peripherral.name];
    NSNumber * rssis = self.rssisArray[indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"强度:%@",rssis];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CBPeripheral *peripheral = [self.dataSource objectAtIndex:indexPath.row];
    
    [self.manage connectPeripheral:peripheral completion:^(CBPeripheral *perpheral, NSError *error) {
        if (!error) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSLog(@"连接成功");
                [self.navigationController popViewControllerAnimated:true];
            });

        }else{
            
        }
    }];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
