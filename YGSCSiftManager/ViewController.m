//
//  ViewController.m
//  YGSCSiftManager
//
//  Created by MASAHIDE HAKUYA on 2015/10/15.
//  Copyright © 2015年 MASAHIDE HAKUYA. All rights reserved.
//
#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubble;
@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubble;
@property (strong, nonatomic) JSQMessagesAvatarImage *incomingAvatar;
@property (strong, nonatomic) JSQMessagesAvatarImage *outgoingAvatar;

@end

@implementation ViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // ① 自分の senderId, senderDisplayName を設定
    self.senderId = @"user1";
    self.senderDisplayName = @"田所浩二";
    // ② MessageBubble (背景の吹き出し) を設定
    JSQMessagesBubbleImageFactory *bubbleFactory = [JSQMessagesBubbleImageFactory new];
    self.incomingBubble = [bubbleFactory  incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    self.outgoingBubble = [bubbleFactory  outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
    // ③ アバター画像を設定
    self.incomingAvatar = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"User2.gif"] diameter:64];
    self.outgoingAvatar = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"User1.gif"] diameter:64];
    // ④ メッセージデータの配列を初期化
    self.messages = [NSMutableArray array];
    self.navigationItem.title = @"お知らせ";
}

#pragma mark - JSQMessagesViewController

// ⑤ Sendボタンが押下されたときに呼ばれる
- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    // 効果音を再生する
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    // 新しいメッセージデータを追加する
    JSQMessage *message = [JSQMessage messageWithSenderId:senderId
                                              displayName:senderDisplayName
                                                     text:text];
    [self.messages addObject:message];
    // メッセージの送信処理を完了する (画面上にメッセージが表示される)
    [self finishSendingMessageAnimated:YES];
    // 擬似的に自動でメッセージを受信
    [self receiveAutoMessage];
}

#pragma mark - JSQMessagesCollectionViewDataSource

// ④ アイテムごとに参照するメッセージデータを返す
- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.messages objectAtIndex:indexPath.item];
}

// ② アイテムごとの MessageBubble (背景) を返す
- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    if ([message.senderId isEqualToString:self.senderId]) {
        return self.outgoingBubble;
    }
    return self.incomingBubble;
}

// ③ アイテムごとのアバター画像を返す
- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    if ([message.senderId isEqualToString:self.senderId]) {
        return self.outgoingAvatar;
    }
    return self.incomingAvatar;
}

#pragma mark - UICollectionViewDataSource

// ④ アイテムの総数を返す
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.messages.count;
}

#pragma mark - Auto Message

// ⑥ 返信メッセージを受信する (自動)
- (void)receiveAutoMessage
{
    // 1秒後にメッセージを受信する
    [NSTimer scheduledTimerWithTimeInterval:1
                                     target:self
                                   selector:@selector(didFinishMessageTimer:)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)didFinishMessageTimer:(NSTimer*)timer
{
    // 効果音を再生する
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    // 新しいメッセージデータを追加する
    JSQMessage *message = [JSQMessage messageWithSenderId:@"user2"
                                              displayName:@"葛城蓮"
                                                     text:@"了解です"];
    [self.messages addObject:message];
    // メッセージの受信処理を完了する (画面上にメッセージが表示される)
    [self finishReceivingMessageAnimated:YES];
}
/*
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (velocity.y > 0) {
        // 上下のバーを隠す
        [self hidesBarsWithScrollView:scrollView hidden:NO hiddenTop:YES hiddenBottom:YES];
    } else {
        // 上下のバーを表示する
        [self hidesBarsWithScrollView:scrollView hidden:YES hiddenTop:YES hiddenBottom:YES];
    }
}

- (void)hidesBarsWithScrollView:(UIScrollView *)scrollView hidden:(BOOL)hidden hiddenTop:(BOOL)hiddenTop hiddenBottom:(BOOL)hiddenBottom
{
    UITabBarController *tabBarController = self.tabBarController;
    UIEdgeInsets inset = scrollView.contentInset;
    
    //上下バーのframe
    CGRect tabBarRect = tabBarController.tabBar.frame;
    CGRect topBarRect = self.navigationController.navigationBar.frame;
    //各パーツの高さ
    CGFloat tabBerHeight = tabBarController.tabBar.frame.size.height;
    CGFloat naviBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat controllerHeight = tabBarController.view.frame.size.height;
    
    if (hidden) {
        if (hiddenTop) {
            topBarRect.origin.y = - (naviBarHeight + statusBarHeight);
            inset.top = 0;
        }
        if (hiddenBottom) {
            tabBarRect.origin.y = controllerHeight;
            inset.bottom = 0;
        }
    } else {
        topBarRect.origin.y = statusBarHeight;
        inset.top = naviBarHeight + statusBarHeight;
        tabBarRect.origin.y = controllerHeight - tabBerHeight;
        inset.bottom = tabBerHeight;
    }
    
    [UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:^{
        scrollView.contentInset = inset;
        scrollView.scrollIndicatorInsets = inset;
        tabBarController.tabBar.frame = tabBarRect;
        self.navigationController.navigationBar.frame = topBarRect;
    }];
}
 */

@end