//
//  CaptureManager.h
//  BankCard
//
//  Created by XAYQ-FanXL on 16/7/8.
//  Copyright © 2016年 AN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "IDInfo.h"
#import "excards.h"

@protocol CaptureDelegate<NSObject>

@optional

- (void)idCardRecognited:(IDInfo*)idInfo image:(UIImage *)image;

@end

@interface CaptureManager : NSObject<AVCaptureVideoDataOutputSampleBufferDelegate>

@property (weak, nonatomic) id<CaptureDelegate>             delegate;

//AVCaptureSession对象来执行输入设备和输出设备之间的数据传递
@property (nonatomic, strong) AVCaptureSession          *captureSession;
//AVCaptureDeviceInput对象是输入流
@property (nonatomic, strong) AVCaptureDeviceInput      *activeVideoInput;
//出流对象
@property (nonatomic, strong) AVCaptureVideoDataOutput  *videoDataOutput;
//创建预览层
@property (strong,nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
//图片质量
@property (nonatomic, copy  ) NSString                  *sessionPreset;
//输出格式
@property (strong,nonatomic ) NSNumber                  *outPutSetting;

@property (nonatomic, assign) BOOL                      verify;

- (BOOL)setupSession;
- (void)startSession;
- (void)stopSession;

@end
