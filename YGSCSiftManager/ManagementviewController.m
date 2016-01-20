//
//  ManagementviewController.m
//  YGSCSiftManager
//
//  Created by MASAHIDE HAKUYA on 2015/10/15.
//  Copyright © 2015年 MASAHIDE HAKUYA. All rights reserved.
//

#import "ManagementviewController.h"
#import "YGSCDayCell.h"
#import "ViewController.h"
#import "GroopTableCell.h"
#import "PickerViewController.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
@interface ManagementviewController ()
{
    CGSize cellSize;
    IBOutlet UILabel *MonthLabel;
    NSUInteger flags;
    NSDateComponents *comps;
    NSDateComponents *components;
    NSDate *date;
    NSDateFormatter *format;
    NSCalendar *cal;
    NSInteger weekday;
    NSInteger b;
    NSInteger weekcount;
    NSInteger nowweek;
    NSInteger NowDay;
    NSMutableArray* employeeDataArray;
    NSDate *Selectdate;
    NSInteger Year;
    NSInteger Month;
    NSMutableArray * titleArray;
    NSString *yobi;
    NSDate *today;
    //NSMutableArray* datas;
    NSCalendar *gregorian;
    NSInteger *tapcellNum;
    NSString *filepath;
    AppDelegate *appDelegate;
    NSString *documentsDirectory;
    NSString *fileName;
    NSIndexPath *path;
    NSIndexPath *selectedindexPath;
}
@property (weak, nonatomic) IBOutlet UICollectionView* montheCalendarView;
@property (nonatomic, strong) NSDate *selectedDate;
@property(readonly) NSTimeInterval timeIntervalSince1970;
@property (strong, nonatomic) id<UITableViewDelegate> delegate;
@property (strong, nonatomic) PickerViewController *pickerViewController;
@property (strong, nonatomic) GroopTableCell *tabelcell;
@property (strong, nonatomic) NSMutableArray *datas;




@end

@implementation ManagementviewController
@synthesize tableView1;
@synthesize collectionview1;

- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate = [[UIApplication sharedApplication] delegate];
    // Do any additional setup after loading the view, typically from a nib.
    titleArray = [NSMutableArray array];
    cellSize = CGSizeMake(70, 60);
    today = [NSDate date];// this month
    gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    components = [gregorian components:
                  (NSCalendarUnitDay |  NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday) fromDate:today];
    comps = [[NSDateComponents alloc] init];
    NowDay = components.day;
    Year = components.year;   // 現在の年を取得
    Month = components.month;  // 現在の月を取得
    //nowweek = components.weekdayOrdinal;
    cal = [NSCalendar currentCalendar];
    comps.month =Month;
    comps.year = Year;
    comps.day = 1;
    NSLog(@"day%ld",(long)comps.day);
    NSDate* onDaydate = [cal dateFromComponents:comps];
    NSLog(@"onday%@",onDaydate);
    comps = [cal components:NSWeekdayCalendarUnit fromDate:onDaydate];
    NSLog(@"day%ld",(long)comps.day);
    weekday = comps.weekday-1;
    MonthLabel.text=[NSString stringWithFormat:@"%ld年%ld月", (long)Year, Month];
    UINib *nib = [UINib nibWithNibName:@"GroopShiftTableview" bundle:nil];
    //UINib *nib = [UINib nibWithNibName:@"CustomCell" bundle:nil];
    [self.tableView1 registerNib:nib forCellReuseIdentifier:@"SiftCell"];
    //__weak ManagementviewController *weakSelf = self;
    [tableView1 setDataSource:self];
    [tableView1 setDelegate:self];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self
                       action:@selector(onRefresh:)
             forControlEvents:UIControlEventValueChanged];
    [self.tableView1 addSubview:refreshControl];

    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [path objectAtIndex:0];
    fileName = [NSString stringWithFormat:@"Emp%ld%d.plist",(long)Month,1];
    filepath = [documentsDirectory stringByAppendingPathComponent:fileName];
    if([[NSFileManager defaultManager] fileExistsAtPath:filepath] == NO){
        //ファイルが存在しなければファイルを作成する
        [[NSFileManager defaultManager] createFileAtPath:filepath contents:nil attributes:nil];
    }else{
        self.datas = [NSMutableArray arrayWithContentsOfFile:filepath];
    }
    self.navititle.title = [NSString stringWithFormat:@"%ld年%ld月", (long)Year, Month];
    selectedindexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(rowButtonAction:)];
    longPressRecognizer.allowableMovement = 15;
    longPressRecognizer.minimumPressDuration = 0.6f;
    [self.tableView1 addGestureRecognizer: longPressRecognizer];
    self.navigationItem.title = @"グループシフト";
   }

- (void)viewWillAppear:(BOOL)animated
{
    self.datas = [NSMutableArray arrayWithContentsOfFile:filepath];
    [self.tableView1 reloadData];
    [super viewWillAppear:animated];
    
    
}
- (void)viewDidLayoutSubviews{
    //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:NowDay inSection:0];
    //[_montheCalendarView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
}

     
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)pushNext
{
    if(Month != 12){
        Month = Month+1;
    }else{
        Year = Year+1;
        Month =1;
    }
    NSLog(@"%ld",(long)Month);
    fileName = [NSString stringWithFormat:@"Emp%ld%d.plist",(long)Month,1];
    filepath = [documentsDirectory stringByAppendingPathComponent:fileName];
    self.datas = [NSMutableArray arrayWithContentsOfFile:filepath];
    [self.tableView1 reloadData];
    selectedindexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.collectionview1 reloadData];
    self.navititle.title=[NSString stringWithFormat:@"%ld年%ld月", (long)Year, Month];
}

-(IBAction)pushPrev
{
    if (Month !=1) {
        Month = Month-1;
    }else{
        Year = Year-1;
        Month = 12;
    }
    fileName = [NSString stringWithFormat:@"Emp%ld%d.plist",(long)Month,1];
    filepath = [documentsDirectory stringByAppendingPathComponent:fileName];
    self.datas = [NSMutableArray arrayWithContentsOfFile:filepath];
    [self.tableView1 reloadData];
    selectedindexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.collectionview1 reloadData];
    NSLog(@"%ld",(long)Month);
    self.navititle.title=[NSString stringWithFormat:@"%ld年%ld月", (long)Year, Month];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    cal = [NSCalendar currentCalendar];
    Selectdate = [cal dateFromComponents:components];
    NSRange range = [cal rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:Selectdate];
    NSInteger last =  range.length;
    return last;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.datas count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // カスタムセルを取得
    GroopTableCell *cell = [tableView1 dequeueReusableCellWithIdentifier:@"SiftCell" forIndexPath:indexPath];
    self.employeeDic = [self.datas objectAtIndex:indexPath.row];
    // カスタムセルのラベルに値を設定
    NSString *NameString = [self.employeeDic objectForKey:@"Name"];
    NSLog(@"%zd",indexPath.row);
    [cell.NameButton setTitle:NameString forState:UIControlStateNormal];
    cell.TimeLabel1.text= [self.employeeDic objectForKey:@"StartTime"];
    cell.TimeLabel2.text= [self.employeeDic objectForKey:@"EndTime"];
    if([cell.TimeLabel1.text  isEqual: @""] &&[cell.TimeLabel2.text  isEqual:@""])  {
        cell.KigouLabel.text =@"休み";
    }else{
        cell.KigouLabel.text =@"~";
    }
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"%@",);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // cellがタップされた際の処理
    self.pickerViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"PickerViewController"];
    self.pickerViewController.delegate = self;
    CGRect screen = [[UIScreen mainScreen] bounds];
    self.pickerViewController.view.frame = CGRectMake(0.0, 1.0, screen.size.width, screen.size.height);
    //self.pickerViewController.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0];
    self.pickerViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:self.pickerViewController
                               animated:YES
                     completion:nil];
    tapcellNum = indexPath.row;
}


// PickerViewController上にある透明ボタンがタップされたときに呼び出されるPickerViewControllerDelegateプロトコルのデリゲートメソッド
- (void)closePickerView:(PickerViewController *)controller

{
    [controller dismissViewControllerAnimated:YES completion:^{
       // 閉じ終わった処理
        self.employeeDic = [self.datas objectAtIndex:tapcellNum];
        if(appDelegate.StartTime != nil || appDelegate.EndTime != nil){
        [self.employeeDic setObject:appDelegate.StartTime forKey:@"StartTime"];
        [self.employeeDic setObject:appDelegate.EndTime forKey:@"EndTime"];
        NSLog(@"%@",appDelegate.StartTime);
        [self.datas writeToFile:filepath atomically:YES];
        [self.tableView1 reloadData];
        }
            }];
   }

// 単位のPickerViewを閉じるアニメーションが終了したときに呼び出されるメソッド
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    // PickerViewをサブビューから削除
    UIView *pickerView = (__bridge UIView *)context;
    [pickerView removeFromSuperview];
}

/**
 *  Controls what gets displayed in each cell
 *  Edit this function for customized calendar logic
 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YGSCDayCell* cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"YGSCDayCell" forIndexPath:indexPath];
    NSString* dayStr = [NSString stringWithFormat:@"%zd",indexPath.row + 1];
    cell.dayLabel.text = dayStr;
    cell.yobiLabel.text=@"";
    //components.day = 1;
    //weekday = [components weekday];
    switch (weekday) {
        case 0:
            yobi = @"(日)";
            cell.yobiLabel.text = yobi;
            break;
        case 1:
            yobi = @"(月)";
            cell.yobiLabel.text = yobi;
            break;
        case 2:
            yobi = @"(火)";
            cell.yobiLabel.text = yobi;
            break;
        case 3:
            yobi = @"(水)";
            cell.yobiLabel.text = yobi;
            break;
        case 4:
            yobi = @"(木)";
            cell.yobiLabel.text = yobi;
            break;
        case 5:
            yobi = @"(金)";
            cell.yobiLabel.text = yobi;
            break;
        case 6:
            yobi = @"(土)";
            cell.yobiLabel.text = yobi;
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
    }
    UIView *selectedView = [UIView new];
    selectedView.backgroundColor = [UIColor colorWithRed:8/255.0 green:166/255.0 blue:1/255.0 alpha:1.0];
    cell.selectedBackgroundView = selectedView;
    if (indexPath.row == selectedindexPath.row) {
        cell.yobiLabel.textColor = [UIColor whiteColor];
        cell.dayLabel.textColor = [UIColor whiteColor];
        //[self.collectionview1 reloadData];
    }else{
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
        //[self.collectionview1 reloadData];
    }
    selectedindexPath = [NSIndexPath indexPathForRow:path.item inSection:0];
    [collectionView selectItemAtIndexPath:selectedindexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //collectionviewがタップされた時の処理
    NSArray *paths = [collectionView indexPathsForSelectedItems];
    path = [paths objectAtIndex: 0];
    selectedindexPath = [NSIndexPath indexPathForRow:path.item inSection:0];
    fileName = [NSString stringWithFormat:@"Emp%ld%ld.plist",(long)Month,path.item+1];
    filepath = [documentsDirectory stringByAppendingPathComponent:fileName];
    if([[NSFileManager defaultManager] fileExistsAtPath:filepath] == NO){
        //ファイルが存在しなければファイルを作成する
    //[[NSFileManager defaultManager] createFileAtPath:filepath contents:nil attributes:nil];
    }else{
        self.datas = [NSMutableArray arrayWithContentsOfFile:filepath];
    }
    //ファイルが壊れていた時の復旧処理
    if(self.datas == nil){
        self.datas = [[NSMutableArray alloc]init];
    }
    //ファイルを書き込み
    [self.datas writeToFile:filepath atomically:YES];
    [self.tableView1 reloadData];
    //NSLog(@"%@",fileName);
    //NSLog(@"Selected. Item number = %ld", (long)path.item+1);
    [self.collectionview1 reloadData];
}
/*
- (void)refleshControlSetting
{
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self
                       action:@selector(onRefresh:)
             forControlEvents:UIControlEventValueChanged];
    [self.tableView1 addSubview:refreshControl];
}
 */

- (void)onRefresh:(UIRefreshControl *)refreshControl
{
    [refreshControl beginRefreshing];
    // ここの間に更新のロジックを書く
    self.datas = [NSMutableArray arrayWithContentsOfFile:filepath];
    [self.tableView1 reloadData];
    [refreshControl endRefreshing];
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // 削除するコードを挿入します
        // コントローラを生成
        self.employeeDic = [self.datas objectAtIndex:indexPath.row];
        NSString *alertMessage = [NSString stringWithFormat:@"%@さんのデータを削除します。\nよろしいですか？",[self.employeeDic objectForKey:@"Name"]];
        UIAlertController * ac =
        [UIAlertController alertControllerWithTitle:@"削除"
                                            message:alertMessage
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        // Cancel用のアクションを生成
        UIAlertAction * cancelAction =
        [UIAlertAction actionWithTitle:@"Cancel"
                                 style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction * action) {
                                   // ボタンタップ時の処理
                                   
                               }];
        NSString *deleatalertMessage = [NSString stringWithFormat:@"%@さんのデータを\n削除しました",[self.employeeDic objectForKey:@"Name"]];
        // OK用のアクションを生成
        UIAlertAction * okAction =
        [UIAlertAction actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   // ボタンタップ時の処理
                                   [self.datas removeObjectAtIndex:indexPath.row];
                                   [self.datas writeToFile:filepath atomically:YES];
                                   [self.tableView1 reloadData];
                                   [SVProgressHUD showSuccessWithStatus:deleatalertMessage　maskType:SVProgressHUDMaskTypeGradient];
                               }];
        
        // コントローラにアクションを追加
        [ac addAction:cancelAction];
        [ac addAction:okAction];
        
        // アラート表示処理
        [self presentViewController:ac animated:YES completion:nil];
    }
}

-(IBAction)rowButtonAction:(UILongPressGestureRecognizer *)gestureRecognizer {
    
    CGPoint p = [gestureRecognizer locationInView:tableView1];
    NSIndexPath *indexPath = [tableView1 indexPathForRowAtPoint:p];
    if (indexPath == nil){
        
        NSLog(@"long press on table view");
        
    }else if (((UILongPressGestureRecognizer *)gestureRecognizer).state == UIGestureRecognizerStateBegan){
        
        //セルが長押しされた場合の処理
        // コントローラを生成
        UIAlertController * ac =
        [UIAlertController alertControllerWithTitle:@"メニュー"
                                            message:nil
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        
        // Cancel用のアクションを生成
        UIAlertAction * cancelAction =
        [UIAlertAction actionWithTitle:@"閉じる"
                                 style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction * action) {
                                   // ボタンタップ時の処理
                                   NSLog(@"Cancel button tapped.");
                               }];
        
        // Destructive用のアクションを生成
        /*
        UIAlertAction * destructiveAction =
        [UIAlertAction actionWithTitle:@"Destructive"
                                 style:UIAlertActionStyleDestructive
                               handler:^(UIAlertAction * action) {
                                   // ボタンタップ時の処理
                                   NSLog(@"Destructive button tapped.");
                               }];
         */
        
        // OK用のアクションを生成
        UIAlertAction * okAction =
        [UIAlertAction actionWithTitle:@"社員情報編集"
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   // ボタンタップ時の処理
                                   NSLog(@"OK button tapped.");
                               }];
        
        // コントローラにアクションを追加
        [ac addAction:cancelAction];
        //[ac addAction:destructiveAction];
        [ac addAction:okAction];
        
        // アクションシート表示処理
        [self presentViewController:ac animated:YES completion:nil];
        
    }
    
}
/*
 * Scale the collection view size to fit the frame
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return (cellSize);
}

/*
 * Set all spaces between the cells to zero
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 2;
}

/*
 * If the width of the calendar cannot be divided by 7, add offset to each side to fit the calendar in
 */
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 5, 0, 5);
    return (inset);
    
}

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//}

@end
