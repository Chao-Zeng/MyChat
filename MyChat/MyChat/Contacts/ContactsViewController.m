//
//  ContactsViewController.m
//  MyChat
//
//  Created by Charles on 15/5/28.
//  Copyright (c) 2015年 Charles. All rights reserved.
//

#import "ContactsViewController.h"

@interface ContactsViewController ()
-(id)init;
@end

@implementation ContactsViewController

-(id)init
{
    if(self = [super init])
    {
        self.title = @"Contacts";
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Contacts" image:nil selectedImage:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor yellowColor];
    
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

@end