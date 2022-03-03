//
//  KFAudioConfig.h
//  AVDemo1
//
//  Created by BingYan on 2022/3/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KFAudioConfig : NSObject

+ (instancetype)defaultConfig;

/// 声道数 默认2
@property (nonatomic, assign) NSInteger channels;

/// 采样率 默认 44100
@property (nonatomic, assign) NSInteger sampleRate;

/// 量化位深 默认16
@property (nonatomic, assign) NSInteger bitDepth;

@end

NS_ASSUME_NONNULL_END
