//
//  MySiftViewController.h
//  YGSCSiftManager
//
//  Created by MASAHIDE HAKUYA on 2015/10/22.
//  Copyright © 2015年 MASAHIDE HAKUYA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MySiftViewController : UIViewController
<UITableViewDelegate,UITableViewDataSource>
{
    
}
@property (weak ,nonatomic) IBOutlet UITableView * myshiftTableview;
@property (weak, nonatomic) IBOutlet UINavigationItem *navititle;
@property (weak, nonatomic) NSMutableDictionary *myShiftDic;


@end
