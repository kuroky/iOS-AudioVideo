//
//  ViewController.m
//  AVDemo1
//
//  Created by BingYan on 2022/3/3.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "KFAudioCature.h"
#import "KFAudioConfig.h"

@interface ViewController ()

@property (nonatomic, strong) KFAudioConfig *audioConfig;
@property (nonatomic, strong) KFAudioCature *audioCapture;
@property (nonatomic, strong) NSFileHandle *fileHandle;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(120, 200, 120, 40);
    [btn setTitle:@"start" forState:UIControlStateNormal];
    btn.backgroundColor = UIColor.lightGrayColor;
    [btn addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(120, 300, 120, 40);
    [btn setTitle:@"stop" forState:UIControlStateNormal];
    btn.backgroundColor = UIColor.lightGrayColor;
    [btn addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
    
    _audioCapture = [[KFAudioCature alloc] initWithConfig:self.audioConfig];
    
    __weak typeof(self) weakSelf = self;
    _audioCapture.errBlock = ^(NSError * _Nonnull error) {
        NSLog(@"error: %@", error);
    };
    
    _audioCapture.sampleBufferOutputBlock = ^(CMSampleBufferRef  _Nonnull sample) {
        if (sample) {
            // 1 获取CMBlockBuffer
            CMBlockBufferRef blockBuffer = CMSampleBufferGetDataBuffer(sample);
            size_t lengthAtOffsetOutout, totalLengthOutput;
            char *dataPointer;
            
            // 2 从CMBlockBuffer 中获取 PCM 并存储到文件
            CMBlockBufferGetDataPointer(blockBuffer, 0, &lengthAtOffsetOutout, &totalLengthOutput, &dataPointer);
            [weakSelf.fileHandle writeData:[NSData dataWithBytes:dataPointer length:totalLengthOutput]];
        }
    };
    
    [self setupAudioSession];
    
}

- (void)start {
    [self.audioCapture startRunning];
}

- (void)stop {
    [self.audioCapture stopRunning];
}

- (void)setupAudioSession {
    NSError *error = nil;
    
    // 1 音频会话实例
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    // 2 设置
    [session setCategory:AVAudioSessionCategoryPlayAndRecord
             withOptions:AVAudioSessionCategoryOptionMixWithOthers | AVAudioSessionCategoryOptionDefaultToSpeaker
                   error:&error];
    
    if (error) {
        NSLog(@"AVAudioSession setCategory error.");
        error = nil;
        return;
    }
    
    // 设置模式
    [session setMode:AVAudioSessionModeVideoRecording error:&error];
    if (error) {
        NSLog(@"AVAudioSession setMode error.");
        error = nil;
        return;
    }
    
    // 4、激活会话。
    [session setActive:YES error:&error];
    if (error) {
        NSLog(@"AVAudioSession setActive error.");
        error = nil;
        return;
    }
}

- (KFAudioConfig *)audioConfig {
    if (!_audioConfig) {
        _audioConfig = [KFAudioConfig defaultConfig];
    }
    
    return _audioConfig;
}

- (NSFileHandle *)fileHandle {
    if (!_fileHandle) {
        NSString *audioPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"test.pcm"];
        NSLog(@"PCM file path: %@", audioPath);
        [[NSFileManager defaultManager] removeItemAtPath:audioPath error:nil];
        [[NSFileManager defaultManager] createFileAtPath:audioPath contents:nil attributes:nil];
        _fileHandle = [NSFileHandle fileHandleForWritingAtPath:audioPath];
    }
    return _fileHandle;
}

@end
