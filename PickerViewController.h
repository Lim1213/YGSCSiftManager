//
//  PickerViewController.h
//  YGSCSiftManager
//
//  Created by MASAHIDE HAKUYA on 2015/11/25.
//  Copyright © 2015年 MASAHIDE HAKUYA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PickerViewControllerDelegate;

@interface PickerViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>{
    int Okflg;
    NSString *startTime;
    NSString *endTime;
}

@property (weak, nonatomic) IBOutlet UIDatePicker *picker;
// 空の領域にある透明なボタン
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *OkButton;
@property (weak ,nonatomic) IBOutlet UILabel *Nexttext;

// 処理のデリゲート先の参照
@property (weak, nonatomic) id<PickerViewControllerDelegate> delegate;

// PickerViewを閉じる処理を行うメソッド。closeButtonが押下されたときに呼び出される
- (IBAction)closePickerView:(id)sender;

@end

@protocol PickerViewControllerDelegate <NSObject>
// 選択された文字列を適用するためのデリゲートメソッド
-(void)applySelectedString:(NSString *)str;
// 当該PickerViewを閉じるためのデリゲートメソッド
-(void)closePickerView:(PickerViewController *)controller;
-(void)OkPickerView:(PickerViewController *)controller;
@end