//
//  NativeMadPipe.hpp
//  NoNonsence
//
//  Created by 叶永平 on 2024/7/10.
//

#ifndef NativeMadPipeJSI_h
#define NativeMadPipeJSI_h

#ifndef __cplusplus
#error This file must be compiled as Obj-C++. If you are importing it, you must change your file extension to .mm.
#endif
#import <Foundation/Foundation.h>
#import <RCTRequired/RCTRequired.h>
#import <RCTTypeSafety/RCTConvertHelpers.h>
#import <RCTTypeSafety/RCTTypedModuleConstants.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTCxxConvert.h>
#import <React/RCTManagedPointer.h>
#import <ReactCommon/RCTTurboModule.h>
#import <optional>
#import <vector>

namespace facebook {
  namespace react {
    /**
     * ObjC++ class for module 'NativeMadCore'
     */
    class JSI_EXPORT NativeMadCorePipeJSI : public ObjCTurboModule {
    public:
      NativeMadCorePipeJSI(const ObjCTurboModule::InitParams &params);
    };
  } // namespace react
} // namespace facebook



#endif /* NativeMadPipeJSI_h */
