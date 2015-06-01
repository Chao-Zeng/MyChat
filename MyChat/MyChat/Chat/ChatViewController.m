//
//  ViewController.m
//  MyChat
//
//  Created by Charles on 15/5/28.
//  Copyright (c) 2015年 Charles. All rights reserved.
//

#import "ChatViewController.h"
#import "FunctionViewController.h"

@interface ChatViewController ()
@property UITableView *tableView;

- (id)init;
- (void)popFunctionView;
@end

@implementation ChatViewController

@synthesize tableView = _tableView;

-(id)init
{
    if(self = [super init])
    {
        self.title = @"Chat";
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Chat" image:nil selectedImage:nil];
    }
    return self;
}

- (void)loadView{
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //self.view.backgroundColor = [UIColor greenColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(popFunctionView)];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)popFunctionView{
    FunctionViewController* functionViewController = [[FunctionViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:functionViewController animated:YES];
}

//UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}


// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellReuseIdentifier = @"reuseCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
        cell.textLabel.text = @"chat";
        cell.textLabel.textColor = [UIColor redColor];
    }
    
    return cell;
}

@end
