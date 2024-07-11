//
//  NativeMadPipe.m
//  NoNonsence
//
//  Created by 叶永平 on 2024/7/10.
//

#import "NativeMadPipe.h"
#import <React/RCTUIManager.h>
#import "NativeMadPipeJSI.h"

@interface NativeMadPipe () <RCTBridgeModule, RCTTurboModule>
@end

@implementation NativeMadPipe

@synthesize bridge = _bridge;
@synthesize moduleRegistry = _moduleRegistry;

RCT_EXPORT_MODULE()

- (dispatch_queue_t)methodQueue {
  return _bridge.uiManager.methodQueue;
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule: (const facebook::react::ObjCTurboModule::InitParams &)params
{
  return std::make_shared<facebook::react::NativeMadCorePipeJSI>(params);
}

@end
