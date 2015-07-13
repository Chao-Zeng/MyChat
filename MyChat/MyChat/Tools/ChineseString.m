//
//  ChineseString.m
//  MyChat
//
//  Created by Charles on 15/7/13.
//  Copyright (c) 2015年 Charles. All rights reserved.
//

#import "ChineseString.h"

@implementation ChineseString

+ (NSString*)pinyinAcronym:(NSString*)hanziString{
    NSString *pinyinAcronym = [[NSString alloc] init];
    pinyinAcronym = @"";
    
    if (hanziString == nil || [hanziString isEqualToString:@""]) {
        return pinyinAcronym;
    } else {
        for(int i = 0; i < hanziString.length; ++i){
            NSString *singlePinyinLetter=[[NSString stringWithFormat:@"%c",
                                           pinyinFirstLetter([hanziString characterAtIndex:i])] uppercaseString];
            
            [pinyinAcronym stringByAppendingString:singlePinyinLetter];
        }
    }
    
    return pinyinAcronym;
}

@end
