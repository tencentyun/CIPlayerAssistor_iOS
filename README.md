### 简介
CIPlayerAssistor 为数据万象提供给客户希望使用第三方播放器或自研播放器开发播放万象自研私有加密m3u8资源文件，常用于有自定义播放器功能需求的用户。

### 相关资源
CIPlayerAssistor iOS SDK 以及 Demo 项目，请参见 [CIPlayerAssistor_iOS]()

### 集成指引
#### 环境要求
配置支持 HTTP 请求，需要在项目的 info.plist 文件中添加 `App Transport Security Settings->Allow Arbitrary Loads` 设置为 YES。

#### 手动集成 CIPlayerAssistor SDK

1. 前往github下载 CIPlayerAssistor 插件，将CIPlayerAssistor/CIPlayerAssistor.framework拖入项目中。
2. 导入头文件
```
#import <CIPlayerAssistor/CIPlayerAssistor.h>
```

### 示例代码
以系统 AVPlayer 播放器为例，展示如何使用 CIPlayerAssistor SDK 播放私有加密m3u8。
```
// 创建媒体信息对象，
// object:媒体文件全路径，如：output/test.m3u8
// bucket:媒体文件所在桶名，格式 桶名-appId
// fileUrl:媒体文件链接，如：https://bucket-1250000000.cos.myqcloud.com/output/test.m3u8。
//         若为私有读，需携带签名信息。
CIMediaInfo * media = [[CIMediaInfo alloc]initWithObject:@"output/test.m3u8"
                                                  bucket:@"bucket-1250000000"
                                                 fileUrl:@"https://bucket-1250000000.cos.myqcloud.com/output/test.m3u8"];

// 创建媒体配置对象
// MediaInfo:上面创建媒体信息对象。
// m3u8Type:m3u8加密类型
//    CIM3u8TypeStandard：标准加密。
//    CIM3u8TypePrivate：私有加密。
CIMediaConfig * config = [[CIMediaConfig alloc]initWithMediaInfo:media
                                             m3u8Type:CIM3u8TypePrivate];

// 使用CIPlayerAssistor 请求token并构建用于播放的m3u8文件链接。
[[CIPlayerAssistor singleAssistor] buildPlayerUrlWithConfig:self.config getTokenBlock:^(CIMediaConfig * _Nullable config, CIPlayerAssistorGetTokenCallBack  _Nonnull callBack) {
    // 此处用config 在业务服务构建token并使用callBack回调给SDK; 具体可以参考下方服务端配置实例
    NSString * token = @"";//从业务后台请求token信息。
    callBack(token);    
} buildUrlcallBack:^(NSString * _Nullable url, NSError * _Nullable error) {
    // 构建播放链接回调，若构建失败则返回视频源链接。
    // url：用于播放的视频文件链接，可直接用播放器进行加载
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:url]];
    self.myPlayer = [AVPlayer playerWithPlayerItem:item];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.myPlayer];
    self.playerLayer.frame = CGRectMake(0, 100, self.view.bounds.size.width, 300);
    [self.view.layer addSublayer:self.playerLayer];
    [self.myPlayer play];
}];
```
