//
//  SettingViewController.m
//  MyChat
//
//  Created by Charles on 15/5/28.
//  Copyright (c) 2015年 Charles. All rights reserved.
//

#import "SettingViewController.h"

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
    self.settingTableView.sectionHeaderHeight = 5.0;
    [self.view addSubview:self.settingTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//UITableViewDataSource protocol
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(1 == section){
        return 3;
    }
        
    return 1;

}


// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

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

@end
