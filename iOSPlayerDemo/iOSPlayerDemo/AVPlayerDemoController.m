//
//  AVPlayerDemoController.m
//  iOSPlayerDemo
//
//  Created by garenwang on 2023/11/8.
//

#import "AVPlayerDemoController.h"
#import <AVFoundation/AVFoundation.h>
#import <CIPlayerAssistor/CIPlayerAssistor.h>
#import "InputConfig.h"
#import "TokenBuilder.h"
@interface AVPlayerDemoController ()
@property (strong, nonatomic)AVPlayer *myPlayer;//播放器
@property (strong, nonatomic)AVPlayerItem *item;//播放单元
@property (strong, nonatomic)AVPlayerLayer *playerLayer;//播放界面（layer）
@property (strong, nonatomic)AVURLAsset *urlAsset;
@property (nonatomic, strong)CIMediaConfig * config;
@end

@implementation AVPlayerDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self setupPlayer];
}

-(void)setupPlayer{
    CIOpenSSLRSA * sslRsa = [CIOpenSSL generateRsa];
    
    [[CIPlayerAssistor singleAssistor] setDebug:NO];
    self.config = [[CIMediaConfig alloc]initWithFileUrl:InputConfig.fileUrl privateKey:sslRsa.privateKey];
    
    [TokenBuilder getToken:sslRsa.publicKey fileURL:self.config.fileUrl protectContentKey:self.isPrivate callBack:^(NSString * _Nonnull token, NSString * _Nonnull signature) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[CIPlayerAssistor singleAssistorWithPort:69874] buildPlayerUrlWithConfig:self.config withToken:token withSignature:signature buildUrlcallBack:^(NSString * _Nullable url, NSError * _Nullable error) {
            
                AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:url]];
                self.myPlayer = [AVPlayer playerWithPlayerItem:item];
                self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.myPlayer];
                self.playerLayer.frame = CGRectMake(0, 100, self.view.bounds.size.width, 300);
                [self.view.layer addSublayer:self.playerLayer];
                [self.myPlayer play];
            }];
        });
    }];
}
@end
