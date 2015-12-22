//
//  MyTableCell.h
//  YGSCSiftManager
//
//  Created by MASAHIDE HAKUYA on 2015/12/21.
//  Copyright © 2015年 MASAHIDE HAKUYA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTableCell : UITableViewCell;
@property (weak, nonatomic) IBOutlet UILabel * dayLabel;
@property (weak, nonatomic) IBOutlet UILabel * myTimeLabel1;
@property (weak, nonatomic) IBOutlet UILabel * myTimeLabel2;
@property (weak, nonatomic) IBOutlet UILabel * myKigouLabel;
@property (weak, nonatomic) IBOutlet UILabel *yobiLabel;
+ (CGFloat)rowHeight;

@end
