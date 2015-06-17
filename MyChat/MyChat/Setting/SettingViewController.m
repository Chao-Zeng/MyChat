//
//  SettingViewController.m
//  MyChat
//
//  Created by Charles on 15/5/28.
//  Copyright (c) 2015年 Charles. All rights reserved.
//

#import "SettingViewController.h"
#import "PersonalInfoViewController.h"

@interface SettingViewController ()

@property UITableView *settingTableView;
@property NSArray *tableViewSections;

- (id)init;

@end

@implementation SettingViewController

@synthesize settingTableView = _settingTableView;
@synthesize tableViewSections = _tableViewSections;

- (id)init
{
    if(self = [super init])
    {
        self.tableViewSections = [NSArray arrayWithObjects:nil];
        self.title = @"Setting";
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Setting" image:nil selectedImage:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    self.settingTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.settingTableView.dataSource = self;
    self.settingTableView.delegate = self;
    //self.settingTableView.sectionHeaderHeight = 5.0;
    [self.view addSubview:self.settingTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//=============UITableViewDataSource protocol=================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(1 == section){
        return 3;
    }
        
    return 1;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellReuseIdentifier = @"cellReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellReuseIdentifier];
    }
    
    cell.textLabel.text = @"我";
    cell.detailTextLabel.text = @"微信号：";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

//==============UITableViewDelegate protocol==================
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5.0;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    PersonalInfoViewController *personalInfoViewController = [[PersonalInfoViewController alloc] initWithStyle:UITableViewStylePlain];
    
    [self.navigationController pushViewController:personalInfoViewController animated:TRUE];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PersonalInfoViewController *personalInfoViewController = [[PersonalInfoViewController alloc] initWithStyle:UITableViewStylePlain];
    
    [self.navigationController pushViewController:personalInfoViewController animated:TRUE];
}

@end
