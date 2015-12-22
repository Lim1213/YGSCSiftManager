//
//  AppDelegate.h
//  YGSCSiftManager
//
//  Created by MASAHIDE HAKUYA on 2015/10/15.
//  Copyright © 2015年 MASAHIDE HAKUYA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSString *StartTime;
    NSString *EndTime;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) NSString* StartTime;
@property (nonatomic) NSString* EndTime;


@end

