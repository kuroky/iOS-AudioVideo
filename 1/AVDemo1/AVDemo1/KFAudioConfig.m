//
//  KFAudioConfig.m
//  AVDemo1
//
//  Created by BingYan on 2022/3/3.
//

#import "KFAudioConfig.h"

@implementation KFAudioConfig

+ (instancetype)defaultConfig {
    KFAudioConfig *config = [KFAudioConfig new];
    config.channels = 2;
    config.sampleRate = 44100;
    config.bitDepth = 16;
    return config;
}

@end
