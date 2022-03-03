//
//  KFAudioCature.h
//  AVDemo1
//
//  Created by BingYan on 2022/3/3.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>

NS_ASSUME_NONNULL_BEGIN

@class KFAudioConfig;

@interface KFAudioCature : NSObject

- (instancetype)initWithConfig:(KFAudioConfig *)config;

/// 开始
- (void)startRunning;

/// 结束
- (void)stopRunning;

@property (nonatomic, strong, readonly) KFAudioConfig *config;

/// 数据采集回调
@property (nonatomic, copy) void (^sampleBufferOutputBlock)(CMSampleBufferRef sample);

/// 错误回调
@property (nonatomic, copy) void (^errBlock)(NSError *error);

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
