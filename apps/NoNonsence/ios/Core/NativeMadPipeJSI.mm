//
//  NativeMadPipe.cpp
//  NoNonsence
//
//  Created by 叶永平 on 2024/7/10.
//

#include "NativeMadPipeJSI.h"
#include "DispatcherResult.h"
#include "TypedArray.h"

extern "C" {
DispatcherResult CallDispatcherAction(const char* name,
                                      const unsigned char* params,
                                      int length);
}

namespace facebook {
namespace react {

static facebook::jsi::Value __hostFunction_NativeMadCorePipe_pipe(facebook::jsi::Runtime& rt,
                                                                  TurboModule &turboModule,
                                                                  const facebook::jsi::Value* args,
                                                                  size_t count)
{
  if (count < 1 || !args[0].isString()) {
    throw jsi::JSError(rt, "The first argument must be a string representing the action name");
  }
  
  // Get the action name
  std::string actionName = args[0].asString(rt).utf8(rt);
  
  // Get the parameters
  const unsigned char* params = nullptr;
  int length = 0;
  
  if (count > 1 && args[1].isObject()) {
    auto arrayBuffer = args[1].asObject(rt).getArrayBuffer(rt);
    length = static_cast<int>(arrayBuffer.size(rt));
    params = arrayBuffer.data(rt);
  }
  
  // Call the Dispatcher function
  DispatcherResult result = CallDispatcherAction(actionName.c_str(), params, length);
  
  // Check the result
  if (result.errorCode == 1) {
    return jsi::Value::null();
  } else if (result.errorCode == 0) {
    std::vector<uint8_t> dataVector(result.data, result.data + result.length);
    auto typedArray = TypedArray<TypedArrayKind::Uint8Array>(rt, result.length);
    typedArray.update(rt, dataVector);
    return typedArray;
  } else {
    throw jsi::JSError(rt, result.errorMessage);
  }
}

NativeMadCorePipeJSI::NativeMadCorePipeJSI(const ObjCTurboModule::InitParams &params)
: ObjCTurboModule(params) {
  methodMap_["pipe"] = MethodMetadata {2, __hostFunction_NativeMadCorePipe_pipe};
}
} // namespace react
} // namespace facebook
