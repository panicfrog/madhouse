//
//  SimpleNativeModule.m
//  RNTurboDemo
//
//  Created by 叶永平 on 2024/6/28.
//

#import "SimpleNativeModule.h"


@implementation SimpleNativeModule

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(sampleMethod:(RCTPromiseResolveBlock)resolve
                    rejecter:(RCTPromiseRejectBlock)reject) {
  resolve(@(kStartTimestamp));
}

@end
