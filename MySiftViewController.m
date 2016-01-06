//
//  MySiftViewController.m
//  YGSCSiftManager
//
//  Created by MASAHIDE HAKUYA on 2015/10/22.
//  Copyright © 2015年 MASAHIDE HAKUYA. All rights reserved.
//

#import "MySiftViewController.h"
#import "MyTableCell.h"

@interface MySiftViewController(){
    NSInteger *month;
    NSInteger *last;
    NSInteger *year;
    NSInteger weekday;
    NSMutableArray * titleArray;
    NSString *yobi;
    NSString *fileName;
    NSIndexPath *path;
    NSString *filepath;
    NSString *documentsDirectory;
    NSMutableArray* myDataArray;
    NSDate *Selectdate;
    NSCalendar *cal;
    NSDateComponents *components;
    NSMutableDictionary *shiftdic;
    NSMutableArray *myshiftArray;
    NSString *myId;
    NSDateComponents *comps;
}
@property NSMutableArray *mydatas;


@end
@implementation MySiftViewController
@synthesize myshiftTableview;

- (void)viewDidLoad {
    [super viewDidLoad];
    myId = @"114514";
    UINib *nib = [UINib nibWithNibName:@"MyShiftTableview" bundle:nil];
    myshiftArray = [NSMutableArray array];
    [self.myshiftTableview registerNib:nib forCellReuseIdentifier:@"MyShiftCell"];
    //__weak ManagementviewController *weakSelf = self;
    [myshiftTableview setDataSource:self];
    [myshiftTableview setDelegate:self];
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    components = [gregorian components:
                                    (NSCalendarUnitDay |  NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday) fromDate:today];
    year = components.year;
    month = components.month;
    
    cal = [NSCalendar currentCalendar];
    Selectdate = [cal dateFromComponents:components];
    NSRange range = [cal rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:Selectdate];
    last =  range.length;
    self.navititle.title = [NSString stringWithFormat:@"%ld年%ld月", (long)year, (long)month];
    titleArray = [NSMutableArray array];
    [self shiftLoad];
    comps = [[NSDateComponents alloc] init];
    comps.day = 1;
    NSDate* onDaydate = [cal dateFromComponents:comps];
    comps = [cal components:NSWeekdayCalendarUnit fromDate:onDaydate];
    weekday = comps.weekday;
    //nowweek = components.weekdayOrdinal;
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self
                       action:@selector(onRefresh:)
             forControlEvents:UIControlEventValueChanged];
    [self.myshiftTableview addSubview:refreshControl];
    self.navigationItem.title = @"マイシフト";
        }


- (void)onRefresh:(UIRefreshControl *)refreshControl
{
    [refreshControl beginRefreshing];
    // ここの間に更新のロジックを書く
    [myshiftArray removeAllObjects];
    [self shiftLoad];
    [self.myshiftTableview reloadData];
    [refreshControl endRefreshing];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return last;
}
- (void)loadEmpShift{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [path objectAtIndex:0];
    fileName = [NSString stringWithFormat:@"Emp%ld%d.plist",(long)month,1];
    filepath = [documentsDirectory stringByAppendingPathComponent:fileName];
    self.mydatas = [NSMutableArray arrayWithContentsOfFile:filepath];
    NSMutableArray *idarray =[self.mydatas valueForKeyPath:@"id"];
    NSLog(@"%@",idarray);
    NSInteger matchIndex = [idarray indexOfObject:myId];
    if(self.mydatas != nil){
   shiftdic = [self.mydatas objectAtIndex:matchIndex];
    }

}

-(void)shiftLoad{
    for(int i=1; i<=last; i++){
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [path objectAtIndex:0];
    fileName = [NSString stringWithFormat:@"Emp%ld%d.plist",(long)month,i];
    filepath = [documentsDirectory stringByAppendingPathComponent:fileName];
    self.mydatas = [NSMutableArray arrayWithContentsOfFile:filepath];
    NSArray *idarray =[self.mydatas valueForKeyPath:@"id"];
    NSInteger matchIndex = [idarray indexOfObject:myId];
    shiftdic = [self.mydatas objectAtIndex:matchIndex];
    NSLog(@"%@",shiftdic);
        if(self.mydatas != nil){
    [myshiftArray addObject:shiftdic];
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // カスタムセルを取得
    MyTableCell *cell = [myshiftTableview dequeueReusableCellWithIdentifier:@"MyShiftCell" forIndexPath:indexPath];
    if(self.mydatas != nil){
    self.myShiftDic = [myshiftArray objectAtIndex:indexPath.row];
    }
    cell.dayLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
    if([self.myShiftDic objectForKey:@"StartTime"] != nil ){
        cell.myTimeLabel1.text= [self.myShiftDic objectForKey:@"StartTime"];
        cell.myTimeLabel2.text= [self.myShiftDic objectForKey:@"EndTime"];
    }else{
        cell.myTimeLabel1.text= @"NODATA";
        cell.myTimeLabel2.text= @"NODATA";
    }
    if([cell.myTimeLabel1.text  isEqual: @""] &&[cell.myTimeLabel2.text  isEqual:@""])  {
        cell.myKigouLabel.text =@"休み";
    }else{
        cell.myKigouLabel.text =@"~";
    }
    //cell.yobiLabel.text=@"";
    switch (weekday) {
        case 0:
            yobi = @"(日)";
            //cell.yobiLabel.text = yobi;
            break;
        case 1:
            yobi = @"(月)";
            //cell.yobiLabel.text = yobi;
            break;
        case 2:
            yobi = @"(火)";
            //cell.yobiLabel.text = yobi;
            break;
        case 3:
            yobi = @"(水)";
            //cell.yobiLabel.text = yobi;
            break;
        case 4:
            yobi = @"(木)";
            //cell.yobiLabel.text = yobi;
            break;
        case 5:
            yobi = @"(金)";
            //cell.yobiLabel.text = yobi;
            break;
        case 6:
            yobi = @"(土)";
            //cell.yobiLabel.text = yobi;
            break;
    }
    //if([titleArray[indexPath.row]==nil]){
    [titleArray addObject:yobi];
    //}
    cell.yobiLabel.text = titleArray[indexPath.row];
    weekday++;
    if(weekday > 6){
        weekday = 0;
    }
    if([cell.yobiLabel.text  isEqual: @"(土)"]){
        cell.yobiLabel.textColor = [UIColor blueColor];
        cell.dayLabel.textColor = [UIColor blueColor];
    }else if([cell.yobiLabel.text isEqual:@"(日)"]){
        cell.yobiLabel.textColor = [UIColor redColor];
        cell.dayLabel.textColor = [UIColor redColor];
    }else{
        cell.yobiLabel.textColor = [UIColor blackColor];
        cell.dayLabel.textColor = [UIColor blackColor];
    }

    
    
    return cell;
}

@end
