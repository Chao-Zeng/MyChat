//
//  AddContactsViewController.m
//  MyChat
//
//  Created by Charles on 15/6/11.
//  Copyright (c) 2015年 Charles. All rights reserved.
//

#import "AddContactsViewController.h"

@interface AddContactsViewController ()

@property UITextField *name;
@property UITextField *weiXinNumber;
@property UITextField *address;
@property UITextField *signature;
@property UITextField *headPortrait;
@property UISegmentedControl *gender;

- (void)initView;

@end

@implementation AddContactsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"AddContacts";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGPoint initialPoint = {10, 100};
    CGFloat gap = 5;
    
    CGRect nameLabelRect;
    nameLabelRect.origin = initialPoint;
    nameLabelRect.size = CGSizeMake(50, 20);
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:nameLabelRect];
    nameLabel.text = @"名字";
    [self.view addSubview:nameLabel];
    
    CGRect nameTextFieldRect;
    nameTextFieldRect.origin.x = nameLabelRect.origin.x + nameLabelRect.size.width + gap;
    nameTextFieldRect.origin.y = nameLabelRect.origin.y;
    nameTextFieldRect.size = CGSizeMake(100, 20);
    self.name = [[UITextField alloc] initWithFrame:nameTextFieldRect];
    self.name.borderStyle = UITextBorderStyleRoundedRect;
    self.name.placeholder = @"请输入名字";
    [self.view addSubview:self.name];
    
    CGRect weiXinNumberLabelRect;
    weiXinNumberLabelRect.origin.x = nameLabelRect.origin.x;
    weiXinNumberLabelRect.origin.y = nameLabelRect.origin.y + nameLabelRect.size.height + gap;
    weiXinNumberLabelRect.size = CGSizeMake(100, 20);
    UILabel *weiXinNumberLabel = [[UILabel alloc] initWithFrame:weiXinNumberLabelRect];
    weiXinNumberLabel.text = @"微信号";
    [self.view addSubview:weiXinNumberLabel];
    
    CGRect weiXinNumberTextFieldRect;
    weiXinNumberTextFieldRect.origin.x = weiXinNumberLabelRect.origin.x + weiXinNumberLabelRect.size.width + gap;
    weiXinNumberTextFieldRect.origin.y = weiXinNumberLabelRect.origin.y;
    weiXinNumberTextFieldRect.size = CGSizeMake(100, 20);
    self.weiXinNumber = [[UITextField alloc] initWithFrame:weiXinNumberTextFieldRect];
    self.weiXinNumber.borderStyle = UITextBorderStyleRoundedRect;
    self.weiXinNumber.placeholder = @"请输入微信号";
    [self.view addSubview:self.weiXinNumber];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
