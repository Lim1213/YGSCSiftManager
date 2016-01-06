//
//  EmproyeeEntry.m
//  YGSCSiftManager
//
//  Created by MASAHIDE HAKUYA on 2015/12/08.
//  Copyright © 2015年 MASAHIDE HAKUYA. All rights reserved.
//

#import "EmproyeeEntry.h"
#import "SVProgressHUD.h"

@implementation EmproyeeEntry{
    IBOutlet UITextField *nametf;
    IBOutlet UITextField *idtf;
    NSInteger *Month;
    NSInteger *last;
}
-(void)viewDidLoad{
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:
                  (NSCalendarUnitDay |  NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday) fromDate:today];
    Month = components.month;

    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *Selectdate = [cal dateFromComponents:components];
    NSRange range = [cal rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:Selectdate];
    last =  range.length;
    NSLog(@"%d",last);
    UIBarButtonItem* backButton =[[UIBarButtonItem alloc] initWithTitle:@"戻る" style:UIBarButtonItemStylePlain target:self action:@selector(backNavigation)];
    self.navigationItem.leftBarButtonItem = backButton;
    [backButton setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
    
   
}
- (void)viewDidLayoutSubviews{
    
}

- (void)backNavigation{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)EntryButton:(id)sender{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [path objectAtIndex:0];
    NSString *filepath = [documentsDirectory stringByAppendingPathComponent:@"persons.plist"];
    
    NSMutableArray* datas;
    
    for(int i = 1; i<=last;i++){
        if(i>=2){
        datas = [[NSMutableArray alloc]init];
        }
        NSString *fileName = [NSString stringWithFormat:@"Emp%ld%d.plist",(long)Month,i];
        filepath = [documentsDirectory stringByAppendingPathComponent:fileName];
        if([[NSFileManager defaultManager] fileExistsAtPath:filepath] == NO){
            //ファイルが存在しなければファイルを作成する
            //[[NSFileManager defaultManager] createFileAtPath:filepath contents:nil attributes:nil];
                }else{
                    datas = [NSMutableArray arrayWithContentsOfFile:filepath];
                }
        //ファイルが壊れていた時の復旧処理
        if(datas == nil){
            datas = [[NSMutableArray alloc]init];
        }
    
        NSMutableDictionary* list = [[NSMutableDictionary alloc]init];
        [list setObject:idtf.text forKey:@"id"];
        [list setObject:nametf.text forKey:@"Name"];
        [list setObject:@"" forKey:@"StartTime"];
        [list setObject:@"" forKey:@"EndTime"];
        if([idtf.text  isEqual:@""]){
            [SVProgressHUD showErrorWithStatus:@"IDを入力してください"maskType:SVProgressHUDMaskTypeGradient];
        }else if([nametf.text  isEqual: @""]){
            [SVProgressHUD showErrorWithStatus:@"名前を入力してください"maskType:SVProgressHUDMaskTypeGradient];
        }else{
            //データを入れる
            [datas addObject:list];
            
            //ファイルを書き込み
            BOOL a =[datas writeToFile:filepath atomically:YES];
    //[datas writeToFile:filepath atomically:YES];
            [SVProgressHUD showSuccessWithStatus:@"登録が完了しました。"maskType:SVProgressHUDMaskTypeGradient];
        }
    }

    idtf.text=@"";
    nametf.text=@"";

}

@end
