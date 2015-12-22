//
//  GroopTableCell.h
//  YGSCSiftManager
//
//  Created by MASAHIDE HAKUYA on 2015/10/28.
//  Copyright © 2015年 MASAHIDE HAKUYA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroopTableCell : UITableViewCell;
@property (weak, nonatomic) IBOutlet UIButton * NameButton;
@property (weak, nonatomic) IBOutlet UILabel * TimeLabel1;
@property (weak, nonatomic) IBOutlet UILabel * TimeLabel2;
@property (weak, nonatomic) IBOutlet UILabel * KigouLabel;
+ (CGFloat)rowHeight;

@end
