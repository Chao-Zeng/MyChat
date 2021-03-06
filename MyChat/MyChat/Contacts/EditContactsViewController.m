//
//  EditContactsViewController.m
//  MyChat
//
//  Created by Charles on 15/6/17.
//  Copyright (c) 2015年 Charles. All rights reserved.
//

//C header
#import <ctype.h>
#import "pinyin.h"

#import "EditContactsViewController.h"
#import "AppDelegate.h"


@interface EditContactsViewController ()

@property PersonInfo *personInfo;

@property UILabel *nameLabel;
@property UITextField *nameTextField;
@property UILabel *weiXinNumberLabel;
@property UITextField *weiXinNumberTextField;
@property UILabel *addressLabel;
@property UITextField *addressTextField;
@property UILabel *signatureLabel;
@property UITextField *signatureTextField;
@property UILabel *headPortraitLabel;
@property UIImageView *headPortraitImageView;
@property UILabel *genderLabel;
@property UISegmentedControl *genderSegmentedControl;
@property UIButton *addNewContactsButton;

- (void)initView;
- (void)layoutView;
- (void)updateContacts;
- (void)selectHeadPortrait;

@end

@implementation EditContactsViewController

- (id)initWithPersonInfo:(PersonInfo*)personInfo
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.personInfo = personInfo;
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"EditContacts";
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

- (void)updateContacts{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"PersonInfo"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", self.personInfo.name];
    [fetchRequest setPredicate:predicate];
    NSError *error;
    NSArray *resultArray = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error || [resultArray count] != 1) {
        NSLog(@"fetch contacts %@ info from database error:%@!", self.personInfo.name, error);
        return;
    }
    
    PersonInfo *personInfo = [resultArray objectAtIndex:0];
    personInfo.name = self.nameTextField.text;
    
    int initial = [personInfo.name characterAtIndex:0];
    if (0 == isChinese(initial)) {
        personInfo.initialOfName = [[NSString stringWithFormat:@"%c", pinyinFirstLetter(initial)] uppercaseString];
    } else {
        personInfo.initialOfName = [[NSString stringWithFormat:@"%c", initial] uppercaseString];
    }
    
    personInfo.weiXinNumber = self.weiXinNumberTextField.text;
    personInfo.address = self.addressTextField.text;
    
    //save head portrait image to file
    if (self.headPortraitImageView.image == nil) {
        personInfo.headPortrait = nil;
    } else {
        NSString  *headPortraitPath = [NSHomeDirectory() stringByAppendingPathComponent:
                                       [NSString stringWithFormat:@"Documents/%@.jpg", personInfo.name]];
        BOOL success = [UIImageJPEGRepresentation(self.headPortraitImageView.image, 1.0) writeToFile:headPortraitPath atomically:YES];
        
        if (!success) {
            NSLog(@"write image %@.jpg to file %@ failed!", personInfo.name, headPortraitPath);
            personInfo.headPortrait = nil;
        } else {
            personInfo.headPortrait = headPortraitPath;
        }
    }
    
    personInfo.signature = self.signatureTextField.text;
    
    if (UISegmentedControlNoSegment == self.genderSegmentedControl.selectedSegmentIndex) {
        self.genderSegmentedControl.selectedSegmentIndex = 0;
    }
    personInfo.gender = [self.genderSegmentedControl titleForSegmentAtIndex:
                         [self.genderSegmentedControl selectedSegmentIndex]];
    
    
    BOOL isSaveSuccess=[managedObjectContext save:&error];
    if (!isSaveSuccess) {
        NSLog(@"update contacts error:%@",error);
    }else{
        NSLog(@"update contacts successful!");
    }
    
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectHeadPortrait{
    UIAlertController *selectHeadPortraitController = [UIAlertController
                                                       alertControllerWithTitle:@"选择头像"
                                                       message:@"select head portrait"
                                                       preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    
    [selectHeadPortraitController addAction:cancelAction];
    
    UIAlertAction *selectFromPotoLibrarys = [UIAlertAction actionWithTitle:@"相册"
                                                                     style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction *action) {
                                                                       UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                                                                       imagePickerController.delegate = self;
                                                                       imagePickerController.allowsEditing = YES;
                                                                       imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                                       [self presentViewController:imagePickerController animated:YES completion:nil];
                                                                   }];
    
    [selectHeadPortraitController addAction:selectFromPotoLibrarys];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertAction *selectFromCamer = [UIAlertAction actionWithTitle:@"照相机"
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction *action) {
                                                                    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                                                                    imagePickerController.delegate = self;
                                                                    imagePickerController.allowsEditing = YES;
                                                                    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                                    [self presentViewController:imagePickerController animated:YES completion:nil];
                                                                }];
        
        [selectHeadPortraitController addAction:selectFromCamer];
    }
    
    [self presentViewController:selectHeadPortraitController animated:YES completion:nil];
}

//========UIImagePickerControllerDelegate=============
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    self.headPortraitImageView.image = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//==========init and layout views=====================
- (void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.nameLabel.text = @"名字：";
    self.nameLabel.textAlignment = NSTextAlignmentJustified;
    [self.view addSubview:self.nameLabel];
    
    self.nameTextField = [[UITextField alloc] init];
    self.nameTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.nameTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.nameTextField.backgroundColor = [UIColor colorWithRed:211.0f/255.0f green:211.0f/255.0f blue:211.0f/255.0f alpha:1.0];
    self.nameTextField.text = self.personInfo.name;
    [self.view addSubview:self.nameTextField];
    
    self.weiXinNumberLabel = [[UILabel alloc] init];
    self.weiXinNumberLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.weiXinNumberLabel.text = @"微信号：";
    self.weiXinNumberLabel.textAlignment = NSTextAlignmentJustified;
    [self.view addSubview:self.weiXinNumberLabel];
    
    self.weiXinNumberTextField = [[UITextField alloc] init];
    self.weiXinNumberTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.weiXinNumberTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.weiXinNumberTextField.backgroundColor = [UIColor colorWithRed:211.0f/255.0f green:211.0f/255.0f blue:211.0f/255.0f alpha:1.0];
    self.weiXinNumberTextField.text = self.personInfo.weiXinNumber;
    [self.view addSubview:self.weiXinNumberTextField];
    
    self.addressLabel = [[UILabel alloc] init];
    self.addressLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.addressLabel.text = @"地址";
    self.addressLabel.textAlignment = NSTextAlignmentJustified;
    [self.view addSubview:self.addressLabel];
    
    self.addressTextField = [[UITextField alloc] init];
    self.addressTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.addressTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.addressTextField.backgroundColor = [UIColor colorWithRed:211.0f/255.0f green:211.0f/255.0f blue:211.0f/255.0f alpha:1.0];
    self.addressTextField.text = self.personInfo.address;
    [self.view addSubview:self.addressTextField];
    
    self.signatureLabel = [[UILabel alloc] init];
    self.signatureLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.signatureLabel.text = @"签名";
    self.signatureLabel.textAlignment = NSTextAlignmentJustified;
    [self.view addSubview:self.signatureLabel];
    
    self.signatureTextField = [[UITextField alloc] init];
    self.signatureTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.signatureTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.signatureTextField.backgroundColor = [UIColor colorWithRed:211.0f/255.0f green:211.0f/255.0f blue:211.0f/255.0f alpha:1.0];
    self.signatureTextField.text = self.personInfo.signature;
    [self.view addSubview:self.signatureTextField];
    
    self.headPortraitLabel = [[UILabel alloc] init];
    self.headPortraitLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.headPortraitLabel.text = @"头像";
    self.headPortraitLabel.textAlignment = NSTextAlignmentJustified;
    [self.view addSubview:self.headPortraitLabel];
    
    self.headPortraitImageView = [[UIImageView alloc] init];
    self.headPortraitImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.headPortraitImageView.backgroundColor = [UIColor redColor];
    self.headPortraitImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *selectHeadPortraitClick =[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                             action:@selector(selectHeadPortrait)];
    [self.headPortraitImageView addGestureRecognizer:selectHeadPortraitClick];
    self.headPortraitImageView.image = [UIImage imageWithContentsOfFile:self.personInfo.headPortrait];
    [self.view addSubview:self.headPortraitImageView];
    
    self.genderLabel = [[UILabel alloc] init];
    self.genderLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.genderLabel.text = @"性别";
    self.genderLabel.textAlignment = NSTextAlignmentJustified;
    [self.view addSubview:self.genderLabel];
    
    NSMutableArray *genderArray = [NSMutableArray arrayWithObjects:@"男", @"女", nil];
    self.genderSegmentedControl = [[UISegmentedControl alloc] initWithItems:genderArray];
    self.genderSegmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.genderSegmentedControl.selectedSegmentIndex = [genderArray indexOfObject:self.personInfo.gender];
    [self.view addSubview:self.genderSegmentedControl];
    
    self.addNewContactsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.addNewContactsButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.addNewContactsButton setTitle:@"更新联系人" forState:UIControlStateNormal];
    [self.addNewContactsButton addTarget:self action:@selector(updateContacts) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addNewContactsButton];
    
    [self layoutView];
}

- (void)layoutView{
    NSDictionary *viewsDictionary =@{@"nameLabel":self.nameLabel,
                                     @"nameTextField":self.nameTextField,
                                     @"weiXinNumberLabel":self.weiXinNumberLabel,
                                     @"weiXinNumberTextField":self.weiXinNumberTextField,
                                     @"genderLabel":self.genderLabel,
                                     @"genderSegmentedControl":self.genderSegmentedControl,
                                     @"addressLabel":self.addressLabel,
                                     @"addressTextField":self.addressTextField,
                                     @"headPortraitLabel":self.headPortraitLabel,
                                     @"headPortraitImageView":self.headPortraitImageView,
                                     @"signatureLabel":self.signatureLabel,
                                     @"signatureTextField":self.signatureTextField,
                                     @"addNewContactsButton":self.addNewContactsButton
                                     };
    
    //NSDictionaryOfVariableBindings(self.nameLabel, self.nameTextField, self.weiXinNumberLabel,
    //                               self.weiXinNumberTextField);
    
    NSDictionary *metricsDictionary = @{@"LeftSpace":@10, @"RightSpace":@10, @"TopSpace":@100, @"BottomSpace":@100,
                                        @"VSpace":@20, @"HSpace":@10,
                                        @"LabelWidth":@50, @"LabelHeight":@50, @"TextFieldWidth":@200,
                                        @"TextFieldHeight":@50, @"ImageWidth":@50, @"ImageHeight":@50};
    
    //nameLabel
    NSString *hLayoutstring = @"H:|-LeftSpace-[nameLabel(>=LabelWidth)]";
    NSArray *hLayoutArray = [NSLayoutConstraint constraintsWithVisualFormat:hLayoutstring options:0
                                                                    metrics:metricsDictionary views:viewsDictionary];
    NSString *vLayoutString = @"V:|-TopSpace-[nameLabel]";
    NSArray *vLayoutArray = [NSLayoutConstraint constraintsWithVisualFormat:vLayoutString options:0
                                                                    metrics:metricsDictionary views:viewsDictionary];
    [self.view addConstraints:vLayoutArray];
    [self.view addConstraints:hLayoutArray];
    
    //nameTextField
    hLayoutstring = @"H:[nameLabel]-HSpace-[nameTextField(>=TextFieldWidth)]-HSpace-|";
    hLayoutArray = [NSLayoutConstraint constraintsWithVisualFormat:hLayoutstring options:0
                                                           metrics:metricsDictionary views:viewsDictionary];
    vLayoutString = @"V:|-TopSpace-[nameTextField]";
    vLayoutArray = [NSLayoutConstraint constraintsWithVisualFormat:vLayoutString options:0
                                                           metrics:metricsDictionary views:viewsDictionary];
    [self.view addConstraints:vLayoutArray];
    [self.view addConstraints:hLayoutArray];
    
    //weiXinNumberLabel
    hLayoutstring = @"H:|-LeftSpace-[weiXinNumberLabel(>=LabelWidth)]";
    hLayoutArray = [NSLayoutConstraint constraintsWithVisualFormat:hLayoutstring options:0
                                                           metrics:metricsDictionary views:viewsDictionary];
    vLayoutString = @"V:[nameTextField]-VSpace-[weiXinNumberLabel]";
    vLayoutArray = [NSLayoutConstraint constraintsWithVisualFormat:vLayoutString options:0
                                                           metrics:metricsDictionary views:viewsDictionary];
    [self.view addConstraints:vLayoutArray];
    [self.view addConstraints:hLayoutArray];
    
    //weiXinNumberTextField
    hLayoutstring = @"H:[weiXinNumberLabel]-HSpace-[weiXinNumberTextField(>=TextFieldWidth)]-HSpace-|";
    hLayoutArray = [NSLayoutConstraint constraintsWithVisualFormat:hLayoutstring options:0
                                                           metrics:metricsDictionary views:viewsDictionary];
    vLayoutString = @"V:[nameTextField]-VSpace-[weiXinNumberTextField]";
    vLayoutArray = [NSLayoutConstraint constraintsWithVisualFormat:vLayoutString options:0
                                                           metrics:metricsDictionary views:viewsDictionary];
    [self.view addConstraints:vLayoutArray];
    [self.view addConstraints:hLayoutArray];
    
    //genderLabel
    hLayoutstring = @"H:|-LeftSpace-[genderLabel(>=LabelWidth)]";
    hLayoutArray = [NSLayoutConstraint constraintsWithVisualFormat:hLayoutstring options:0
                                                           metrics:metricsDictionary views:viewsDictionary];
    vLayoutString = @"V:[weiXinNumberTextField]-VSpace-[genderLabel]";
    vLayoutArray = [NSLayoutConstraint constraintsWithVisualFormat:vLayoutString options:0
                                                           metrics:metricsDictionary views:viewsDictionary];
    [self.view addConstraints:vLayoutArray];
    [self.view addConstraints:hLayoutArray];
    
    //genderSegmentedControl
    hLayoutstring = @"H:[genderLabel]-HSpace-[genderSegmentedControl]";
    hLayoutArray = [NSLayoutConstraint constraintsWithVisualFormat:hLayoutstring options:0
                                                           metrics:metricsDictionary views:viewsDictionary];
    
    vLayoutString = @"V:[weiXinNumberTextField]-VSpace-[genderSegmentedControl]";
    vLayoutArray = [NSLayoutConstraint constraintsWithVisualFormat:vLayoutString options:0
                                                           metrics:metricsDictionary views:viewsDictionary];
    
    [self.view addConstraints:hLayoutArray];
    [self.view addConstraints:vLayoutArray];
    
    //addressLabel
    hLayoutstring = @"H:|-LeftSpace-[addressLabel(>=LabelWidth)]";
    hLayoutArray = [NSLayoutConstraint constraintsWithVisualFormat:hLayoutstring options:0
                                                           metrics:metricsDictionary views:viewsDictionary];
    vLayoutString = @"V:[genderSegmentedControl]-VSpace-[addressLabel]";
    vLayoutArray = [NSLayoutConstraint constraintsWithVisualFormat:vLayoutString options:0
                                                           metrics:metricsDictionary views:viewsDictionary];
    [self.view addConstraints:vLayoutArray];
    [self.view addConstraints:hLayoutArray];
    
    //addressTextField
    hLayoutstring = @"H:[addressLabel]-HSpace-[addressTextField(>=TextFieldWidth)]-HSpace-|";
    hLayoutArray = [NSLayoutConstraint constraintsWithVisualFormat:hLayoutstring options:0
                                                           metrics:metricsDictionary views:viewsDictionary];
    vLayoutString = @"V:[genderSegmentedControl]-VSpace-[addressTextField]";
    vLayoutArray = [NSLayoutConstraint constraintsWithVisualFormat:vLayoutString options:0
                                                           metrics:metricsDictionary views:viewsDictionary];
    [self.view addConstraints:vLayoutArray];
    [self.view addConstraints:hLayoutArray];
    
    //headPortraitLabel
    hLayoutstring = @"H:|-LeftSpace-[headPortraitLabel(>=LabelWidth)]";
    hLayoutArray = [NSLayoutConstraint constraintsWithVisualFormat:hLayoutstring options:0
                                                           metrics:metricsDictionary views:viewsDictionary];
    vLayoutString = @"V:[addressTextField]-VSpace-[headPortraitLabel]";
    vLayoutArray = [NSLayoutConstraint constraintsWithVisualFormat:vLayoutString options:0
                                                           metrics:metricsDictionary views:viewsDictionary];
    [self.view addConstraints:vLayoutArray];
    [self.view addConstraints:hLayoutArray];
    
    //headPortraitImageView
    hLayoutstring = @"H:[headPortraitLabel]-HSpace-[headPortraitImageView(==ImageWidth)]";
    hLayoutArray = [NSLayoutConstraint constraintsWithVisualFormat:hLayoutstring options:0
                                                           metrics:metricsDictionary views:viewsDictionary];
    vLayoutString = @"V:[addressTextField]-VSpace-[headPortraitImageView(==ImageHeight)]";
    vLayoutArray = [NSLayoutConstraint constraintsWithVisualFormat:vLayoutString options:0
                                                           metrics:metricsDictionary views:viewsDictionary];
    [self.view addConstraints:vLayoutArray];
    [self.view addConstraints:hLayoutArray];
    
    //signatureLabel
    hLayoutstring = @"H:|-LeftSpace-[signatureLabel(>=LabelWidth)]";
    hLayoutArray = [NSLayoutConstraint constraintsWithVisualFormat:hLayoutstring options:0
                                                           metrics:metricsDictionary views:viewsDictionary];
    vLayoutString = @"V:[headPortraitImageView]-VSpace-[signatureLabel]";
    vLayoutArray = [NSLayoutConstraint constraintsWithVisualFormat:vLayoutString options:0
                                                           metrics:metricsDictionary views:viewsDictionary];
    [self.view addConstraints:vLayoutArray];
    [self.view addConstraints:hLayoutArray];
    
    //signatureTextField
    hLayoutstring = @"H:[signatureLabel]-HSpace-[signatureTextField(>=TextFieldWidth)]-HSpace-|";
    hLayoutArray = [NSLayoutConstraint constraintsWithVisualFormat:hLayoutstring options:0
                                                           metrics:metricsDictionary views:viewsDictionary];
    vLayoutString = @"V:[headPortraitImageView]-VSpace-[signatureTextField(==TextFieldHeight)]";
    vLayoutArray = [NSLayoutConstraint constraintsWithVisualFormat:vLayoutString options:0
                                                           metrics:metricsDictionary views:viewsDictionary];
    [self.view addConstraints:vLayoutArray];
    [self.view addConstraints:hLayoutArray];
    
    //addNewContactsButton
    hLayoutstring = @"H:|-[addNewContactsButton]-|";
    hLayoutArray = [NSLayoutConstraint constraintsWithVisualFormat:hLayoutstring options:0
                                                           metrics:metricsDictionary views:viewsDictionary];
    
    vLayoutString = @"V:[signatureTextField]-VSpace-[addNewContactsButton]";
    vLayoutArray = [NSLayoutConstraint constraintsWithVisualFormat:vLayoutString options:0
                                                           metrics:metricsDictionary views:viewsDictionary];
    
    [self.view addConstraints:vLayoutArray];
    [self.view addConstraints:hLayoutArray];
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
