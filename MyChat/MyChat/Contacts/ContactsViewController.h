//
//  ContactsViewController.h
//  MyChat
//
//  Created by Charles on 15/5/28.
//  Copyright (c) 2015年 Charles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

//Protocol NSFetchedResultsSectionInfo
@interface ContactsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,  NSFetchedResultsControllerDelegate>

@end
