//
//  PersonInfo.h
//  
//
//  Created by Charles on 15/7/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PersonInfo : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * headPortrait;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * signature;
@property (nonatomic, retain) NSString * weiXinNumber;
@property (nonatomic, retain) NSString * initialOfName;

@end
