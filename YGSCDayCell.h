//
//  YGSCDayCell.h
//  YGSCSiftManager
//
//  Created by MASAHIDE HAKUYA on 2015/10/15.
//  Copyright © 2015年 MASAHIDE HAKUYA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YGSCDayCell : UICollectionViewCell
@property(weak, nonatomic) IBOutlet UILabel* dayLabel;
@property(strong, nonatomic) NSDate* day;
@property(assign, nonatomic) UIColor* background;
@property (weak,nonatomic) IBOutlet UILabel* yobiLabel;

@end
