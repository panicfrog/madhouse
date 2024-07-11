//
//  TurboMadCore.m
//  NoNonsence
//
//  Created by 叶永平 on 2024/7/8.
//

#import "NativeMadCore.h"
#import <React/RCTUIManager.h>
#import "NativeMadCoreSpec/NativeMadCoreSpec.h"

extern double kStartTimestamp;
@interface NativeMadCore () <NativeMadCoreSpec>
@end


@implementation NativeMadCore

@synthesize bridge = _bridge;
@synthesize moduleRegistry = _moduleRegistry;

RCT_EXPORT_MODULE()

- (dispatch_queue_t)methodQueue {
  return _bridge.uiManager.methodQueue;
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule: (const facebook::react::ObjCTurboModule::InitParams &)params
{
  return std::make_shared<facebook::react::NativeMadCoreSpecJSI>(params);
}

- (NSNumber *)appStartAt { 
  return @(kStartTimestamp);
}

@end
