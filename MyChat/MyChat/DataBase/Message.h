//
//  Message.h
//  MyChat
//
//  Created by Charles on 15/6/4.
//  Copyright (c) 2015年 Charles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Message : NSManagedObject

@property (nonatomic, retain) NSString * fromPerson;
@property (nonatomic, retain) NSString * toPerson;
@property (nonatomic, retain) NSNumber * time;

@end
