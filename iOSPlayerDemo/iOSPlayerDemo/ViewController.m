//
//  ViewController.m
//  iOSPlayerDemo
//
//  Created by garenwang on 2023/11/8.
//

#import "ViewController.h"
#import "AVPlayerDemoController.h"
#import "TXPlayerDemoController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"视频播放器demo";
}

- (IBAction)avPlayer:(UIButton *)sender {
    AVPlayerDemoController * avPlayer = [AVPlayerDemoController new];
    avPlayer.isPrivate = sender.tag;
    avPlayer.title = sender.tag == 1 ? @"私有加密" : @"标准加密";
    [self.navigationController pushViewController:avPlayer animated:YES];
}
- (IBAction)txPlayer:(UIButton *)sender {
    TXPlayerDemoController * avPlayer = [TXPlayerDemoController new];
    avPlayer.isPrivate = sender.tag;
    avPlayer.title = sender.tag == 1 ? @"私有加密" : @"标准加密";
    [self.navigationController pushViewController:avPlayer animated:YES];
}


@end
