//
//  ChineseString.h
//  MyChat
//
//  Created by Charles on 15/7/13.
//  Copyright (c) 2015年 Charles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "pinyin.h"

@interface ChineseString : NSObject

+ (NSString*)pinyinAcronym:(NSString*)hanziString;

@end
