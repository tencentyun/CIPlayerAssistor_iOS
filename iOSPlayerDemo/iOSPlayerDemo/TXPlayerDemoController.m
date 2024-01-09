//
//  TXPlayerDemoController.m
//  iOSPlayerDemo
//
//  Created by garenwang on 2023/11/8.
//

#import "TXPlayerDemoController.h"
#import "TXLiteAVSDK_Player/TXLiteAVSDK.h"
#import <CIPlayerAssistor/CIPlayerAssistor.h>
#import "InputConfig.h"
#import "TokenBuilder.h"
@interface TXPlayerDemoController ()
@property (nonatomic, strong)TXVodPlayer * txVodPlayer;
@property (nonatomic, strong)CIMediaConfig * config;
@property (nonatomic, strong)UIView * contentView;
@end

@implementation TXPlayerDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    NSString * const licenceURL = @"licenceURL";
    NSString * const licenceKey = @"licenceKey";
    
    [TXLiveBase setLicenceURL:licenceURL key:licenceKey];
    NSLog(@"SDK Version = %@", [TXLiveBase getSDKVersionStr]);

    
    [self setupPlayer];
}

-(void)setupPlayer{
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 300)];
    [self.view addSubview:self.contentView];
  
    self.txVodPlayer = [[TXVodPlayer alloc] init];
    [self.txVodPlayer setupVideoWidget:self.contentView insertIndex:0];

    
    self.config = [[CIMediaConfig alloc]initWithFileUrl:InputConfig.fileUrl
                                                 m3u8Type:self.isPrivate];
    
    [[CIPlayerAssistor singleAssistor] buildPlayerUrlWithConfig:self.config getTokenBlock:^(CIMediaConfig * _Nullable config, CIPlayerAssistorGetTokenCallBack  _Nonnull callBack) {
        NSString * token = [[[TokenBuilder alloc]initWithType:self.isPrivate withPublicKey:config.publicKey] buildToken];
        callBack(token);
    } buildUrlcallBack:^(NSString * _Nullable url, NSError * _Nullable error) {
        [_txVodPlayer startVodPlay:url];
    }];
}
@end

