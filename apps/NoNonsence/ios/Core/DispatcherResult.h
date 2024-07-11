//
//  DispatcherResult.h
//  NoNonsence
//
//  Created by 叶永平 on 2024/7/9.
//

#ifndef DispatcherResult_h
#define DispatcherResult_h

#ifdef __cplusplus
extern "C" {
#endif

typedef struct {
    unsigned char *data; // 指向结果数据的指针
    int length;          // 结果数据的长度
    int errorCode;       // 错误码
    const char *errorMessage; // 错误信息
} DispatcherResult;

//DispatcherResult CallDispatcherAction(const char* name, const unsigned char* params, int length);

#ifdef __cplusplus
}
#endif


#endif /* DispatcherResult_h */
