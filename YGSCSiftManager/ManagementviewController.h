//
//  ManagementviewController.h
//  YGSCSiftManager
//
//  Created by MASAHIDE HAKUYA on 2015/10/15.
//  Copyright © 2015年 MASAHIDE HAKUYA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickerViewController.h"
@interface ManagementviewController : UIViewController

<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource,PickerViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView1;
@property (weak, nonatomic) NSMutableDictionary *employeeDic;
@property (weak, nonatomic) IBOutlet UINavigationItem *navititle;
@property (weak, nonatomic) IBOutlet UICollectionView * collectionview1;
@end
