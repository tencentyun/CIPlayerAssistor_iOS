### 简介
CIPlayerAssistor 为数据万象提供给客户希望使用第三方播放器或自研播放器开发播放万象自研私有加密m3u8资源文件，常用于有自定义播放器功能需求的用户。

### 相关资源
CIPlayerAssistor iOS SDK 以及 Demo 项目，请参见 [CIPlayerAssistor_iOS](https://github.com/tencentyun/CIPlayerAssistor_iOS)

### 集成指引
#### 环境要求
配置支持 HTTP 请求，需要在项目的 info.plist 文件中添加 `App Transport Security Settings->Allow Arbitrary Loads` 设置为 YES。

#### 使用 Pod 集成 CIPlayerAssistor SDK
1. podfile 文件中新增：
```
pod 'CIPlayerAssistor', :git => 'https://github.com/tencentyun/CIPlayerAssistor_iOS.git' :tag => '1.0.2'
```
执行`pod install`即可。

2. 导入头文件
```
#import <CIPlayerAssistor/CIPlayerAssistor.h>
```

### 示例代码

#### 使用 sdk 内生成的 RSA 密钥对
```
// 创建媒体配置对象
// fileUrl：文件链接
// m3u8Type:m3u8加密类型
//    CIM3u8TypeStandard：标准加密。
//    CIM3u8TypePrivate：私有加密。
CIMediaConfig * config = [[CIMediaConfig alloc]initWithFileUrl:@"http://test/test.m3u8"
                                             m3u8Type:CIM3u8TypePrivate];

[[CIPlayerAssistor singleAssistor] setDebug:NO];// 关闭日志打印
// CIMediaConfig 类在实例化时 自动生成了公钥 config.publicKey，可用于请求token;  
NSString * token; // 从业务服务请求hls token。
NSString * signature; // 若m3u8文件为私有读，则还需由业务服务返回用于鉴权的签名。

// 使用CIPlayerAssistor 请求token并构建用于播放的m3u8文件链接。
[[CIPlayerAssistor singleAssistor] buildPlayerUrlWithConfig:config withToken:token withSignature:signature buildUrlcallBack:^(NSString * _Nullable url, NSError * _Nullable error) {
    // 构建播放链接回调，若构建失败则返回视频源链接。
    // url：用于播放的视频文件链接，可直接用播放器进行加载
    // 以下代码可根据业务实际需求修改。
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:url]];
    AVPlayer *myPlayer = [AVPlayer playerWithPlayerItem:item];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:myPlayer];
    playerLayer.frame = CGRectMake(0, 100, self.view.bounds.size.width, 300);
    [self.view.layer addSublayer:playerLayer];
    [myPlayer play];
}];

```

#### 使用 自定义 RSA 密钥对

```
// 创建媒体配置对象
// fileUrl：文件链接
// privateKey:自定义rsa密钥
CIMediaConfig * config = [[CIMediaConfig alloc]initWithFileUrl:@"http://test/test.m3u8" privateKey:RsaPrivateKey];

NSString * token; // 从业务服务请求hls token。
NSString * signature; // 若m3u8文件为私有读，则还需由业务服务返回用于鉴权的签名。
[[CIPlayerAssistor singleAssistor] buildPlayerUrlWithConfig:config withToken:token withSignature:signature buildUrlcallBack:^(NSString * _Nullable url, NSError * _Nullable error) {
    // 构建播放链接回调，若构建失败则返回视频源链接。
    // url：用于播放的视频文件链接，可直接用播放器进行加载
    // 以下代码可根据业务实际需求修改。
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:url]];
    self.myPlayer = [AVPlayer playerWithPlayerItem:item];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.myPlayer];
    self.playerLayer.frame = CGRectMake(0, 100, self.view.bounds.size.width, 300);
    [self.view.layer addSublayer:self.playerLayer];
    [self.myPlayer play];
}];
```
