//
//  PickerViewController.m
//  YGSCSiftManager
//
//  Created by MASAHIDE HAKUYA on 2015/11/25.
//  Copyright © 2015年 MASAHIDE HAKUYA. All rights reserved.
//

#import "PickerViewController.h"
#import "ManagementviewController.h"
#import "GroopTableCell.h"
#import "AppDelegate.h"
@interface PickerViewController (){
    NSDateFormatter *df;
    AppDelegate* appDelegate;

}
@property (strong, nonatomic) ManagementviewController *Mng;
@property (strong, nonatomic) GroopTableCell *tabelcell;
@end

@implementation PickerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = [[UIApplication sharedApplication] delegate];

    
    // PickerViewのデリゲート先とデータソースをこのクラスに設定
    //self.picker.delegate = self;
    Okflg =0;
    //self.picker.dataSource = self;
    [self.picker setBackgroundColor:[UIColor colorWithRed:0.800 green:1.0 blue:0.800 alpha:1.0]];
}

// PickerViewで要素が選択されたときに呼び出されるメソッド
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    // デリゲート先の処理を呼び出し、選択された文字列を親Viewに表示させる
    [self.delegate applySelectedString:[NSString stringWithFormat:@"%ld", (long)row]];
}

// PickerViewの列数を指定するメソッド
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView {
    return 1;
}

// PickerViewに表示する行数を指定するメソッド
-(NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 10;
}

// PickerViewの各行に表示する文字列を指定するメソッド
-(NSString*)pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [NSString stringWithFormat:@"%ld", (long)row];
}
- (IBAction)DateChanged:(id)sender{
    
    //ラベルに表示する日付・時刻のフォーマットを指定
    df = [[NSDateFormatter alloc]init];
    df.dateFormat = @"HH:mm";
    //ラベルに指定したフォーマットで表示

    }


// 空の領域にある透明なボタンがタップされたときに呼び出されるメソッド
- (IBAction)closePickerView:(id)sender {
    // PickerViewを閉じるための処理を呼び出す
    
    [self.delegate closePickerView:self];
}
- (IBAction)OkPickerView:(id)sender{
    if(Okflg == 0){
        self.Nexttext.text = @"シフト終了時刻を設定してください";
        appDelegate.StartTime = [df stringFromDate:self.picker.date];
        NSLog(@"St%@",startTime);
        Okflg = 1;
    }else{
        [self.delegate closePickerView:self];
        appDelegate.EndTime = [df stringFromDate:self.picker.date];
        NSLog(@"Ed%@",endTime);
        Okflg = 0;
    }
    
}

@end