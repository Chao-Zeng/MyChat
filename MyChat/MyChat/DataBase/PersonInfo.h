//
//  PersonInfo.h
//  MyChat
//
//  Created by Charles on 15/6/4.
//  Copyright (c) 2015年 Charles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PersonInfo : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * weiXinNumber;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * signature;
@property (nonatomic, retain) NSString * headPortrait;
@property (nonatomic, retain) NSString * gender;

@end
