//
//  EditContactsViewController.h
//  MyChat
//
//  Created by Charles on 15/6/17.
//  Copyright (c) 2015年 Charles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonInfo.h"

@interface EditContactsViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

- (id)initWithPersonInfo:(PersonInfo*)personInfo;
@end
