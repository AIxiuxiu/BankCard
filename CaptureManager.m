//
//  CaptureManager.m
//  BankCard
//
//  Created by XAYQ-FanXL on 16/7/8.
//  Copyright © 2016年 AN. All rights reserved.
//

#import "CaptureManager.h"
#import "UIImage+Extend.h"
#import "RectManager.h"

@implementation CaptureManager

- (void)startSession {
    if (![self.captureSession isRunning]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.captureSession startRunning];
        });
    }
}

- (void)stopSession {
    if ([self.captureSession isRunning]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.captureSession stopRunning];
        });
    }
}

- (BOOL)setupSession {
    
    self.captureSession.sessionPreset = self.sessionPreset;
    
    self.verify = YES;
    
    if (![self addVideoInput:AVCaptureDevicePositionBack]) {
        return NO;
    }
    if (![self addVideoOutput]) {
        return NO;
    }

    [self addConnection];
    
    [self configureDevice];
    
    [self.captureSession commitConfiguration];
    
    return YES;
}

- (BOOL)addVideoInput:(AVCaptureDevicePosition)devicePosition {
    AVCaptureDevice *videoDevice=nil;
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    if (devicePosition == AVCaptureDevicePositionBack) {
        for (AVCaptureDevice *device in devices) {
            if ([device position] == AVCaptureDevicePositionBack) {
                if ([device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
                    NSError *error = nil;
                    if ([device lockForConfiguration:&error]) {
                        device.focusMode = AVCaptureFocusModeContinuousAutoFocus;
                        [device unlockForConfiguration];
                    }
                }
                videoDevice = device;
            }
        }
    }
    else if (devicePosition == AVCaptureDevicePositionFront) {
        for (AVCaptureDevice *device in devices){
            if ([device position] == AVCaptureDevicePositionFront) {
                if ([device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
                    NSError *error = nil;
                    if ([device lockForConfiguration:&error]) {
                        device.focusMode = AVCaptureFocusModeContinuousAutoFocus;
                        [device unlockForConfiguration];
                    }
                }
                videoDevice = device;
            }
        }
    }
    
    if (videoDevice)
    {
        NSError *error;
        
        AVCaptureDeviceInput *videoIn = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
        
        if (!error) {
            if ([[self captureSession] canAddInput:videoIn]) {
                [[self captureSession] addInput:videoIn];
                return YES;
            }
            else {
                NSLog(@"不能添加输入设备");
                return NO;
            }
        }
        else {
            NSLog(@"创建输入设备失败");
            return NO;
        }
    }
    else {
        NSLog(@"不能添加输入设备");
        return NO;
    }
    return NO;
}



- (BOOL)addVideoOutput
{
    // Create a VideoDataOutput and add it to the session
    self.videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    
    // Specify the pixel format
    self.videoDataOutput.videoSettings = [NSDictionary dictionaryWithObject:_outPutSetting forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    
    self.videoDataOutput.alwaysDiscardsLateVideoFrames = YES;
    
    // Configure your output.
    dispatch_queue_t queue = dispatch_queue_create("myQueue", NULL);
    
    [self.videoDataOutput setSampleBufferDelegate:self queue:queue];
    
    if ([self.captureSession canAddOutput:self.videoDataOutput]) {
        [self.captureSession addOutput:self.videoDataOutput];
        return YES;
    } else {
        NSLog(@"不能添加输出设备");
        return NO;
    }
    return NO;
}

- (void)addConnection {
    AVCaptureConnection *videoConnection;
    for (AVCaptureConnection *connection in[self.videoDataOutput connections]) {
        for (AVCaptureInputPort *port in[connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                videoConnection = connection;
            }
        }
    }
    if ([videoConnection isVideoStabilizationSupported]) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
            videoConnection.enablesVideoStabilizationWhenAvailable = YES;
        }
        else {
            videoConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
        }
    }
}

- (void)configureDevice {
    AVCaptureDevice *device = [self activeCamera];
    // Use Smooth focus
    if( YES == [device lockForConfiguration:NULL] )
    {
        if([device respondsToSelector:@selector(setSmoothAutoFocusEnabled:)] && [device isSmoothAutoFocusSupported] )
        {
            [device setSmoothAutoFocusEnabled:YES];
        }
        AVCaptureFocusMode currentMode = [device focusMode];
        if( currentMode == AVCaptureFocusModeLocked )
        {
            currentMode = AVCaptureFocusModeAutoFocus;
        }
        if( [device isFocusModeSupported:currentMode] )
        {
            [device setFocusMode:currentMode];
        }
        [device unlockForConfiguration];
    }
}

- (AVCaptureSession *)captureSession {
    if (!_captureSession) {
        _captureSession = [[AVCaptureSession alloc] init];
        [self.captureSession beginConfiguration];
    }
    return _captureSession;
}

- (AVCaptureVideoPreviewLayer *)previewLayer {
    if (!_previewLayer) {
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self. captureSession];
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    return _previewLayer;
}

- (NSString *)sessionPreset {
    if (!_sessionPreset) {
        _sessionPreset = AVCaptureSessionPreset1280x720;
    }
    return _sessionPreset;
}

- (NSNumber *)outPutSetting {
    if (!_outPutSetting) {
        //kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange
        //kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
        //kCVPixelFormatType_32BGRA
        _outPutSetting = [NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange];
    }
    return _outPutSetting;
}

- (AVCaptureDevice *)activeCamera {
    return self.activeVideoInput.device;
}


#pragma mark - AVCaptureFileOutputRecordingDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
   
    if ([_outPutSetting isEqualToNumber:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange]] ||
        [_outPutSetting isEqualToNumber:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange]]) {
         CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        if ([captureOutput isEqual:self.videoDataOutput]) {
            [self idCardRecognit:imageBuffer];
        }
    }
    else {
        NSLog(@"输出格式不支持");
    }
}

- (void)idCardRecognit:(CVImageBufferRef)imageBuffer {
    @synchronized(self) {
        CVBufferRetain(imageBuffer);
        IDInfo *idInfo = nil;
        // Lock the image buffer
        if (CVPixelBufferLockBaseAddress(imageBuffer, 0) == kCVReturnSuccess) {
            size_t width= CVPixelBufferGetWidth(imageBuffer);
            size_t height = CVPixelBufferGetHeight(imageBuffer);
            
            CVPlanarPixelBufferInfo_YCbCrBiPlanar *planar = CVPixelBufferGetBaseAddress(imageBuffer);
            size_t offset = NSSwapBigIntToHost(planar->componentInfoY.offset);
            size_t rowBytes = NSSwapBigIntToHost(planar->componentInfoY.rowBytes);
            unsigned char* baseAddress = (unsigned char *)CVPixelBufferGetBaseAddress(imageBuffer);
            unsigned char* pixelAddress = baseAddress + offset;

            static unsigned char *buffer = NULL;
            if (buffer == NULL) {
                buffer = (unsigned char*)malloc(sizeof(unsigned char) * width * height);
            }
            
            memcpy(buffer, pixelAddress, sizeof(unsigned char) * width * height);
            
            unsigned char pResult[1024];
            int ret = EXCARDS_RecoIDCardData(buffer, (int)width, (int)height, (int)rowBytes, (int)8, (char*)pResult, sizeof(pResult));
            if (ret <= 0) {
                 NSLog(@"ret=[%d]", ret);
            }
            else {
                NSLog(@"ret=[%d]", ret);
                char ctype;
                char content[256];
                int xlen;
                int i = 0;
                
                idInfo = [[IDInfo alloc] init];
                ctype = pResult[i++];
                idInfo.type = ctype;
                while(i < ret){
                    ctype = pResult[i++];
                    for(xlen = 0; i < ret; ++i){
                        if(pResult[i] == ' ') { ++i; break; }
                        content[xlen++] = pResult[i];
                    }
                    content[xlen] = 0;
                    if(xlen) {
                        NSStringEncoding gbkEncoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                        if(ctype == 0x21)
                            idInfo.code = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
                        else if(ctype == 0x22)
                            idInfo.name = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
                        else if(ctype == 0x23)
                            idInfo.gender = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
                        else if(ctype == 0x24)
                            idInfo.nation = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
                        else if(ctype == 0x25)
                            idInfo.address = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
                        else if(ctype == 0x26)
                            idInfo.issue = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
                        else if(ctype == 0x27)
                            idInfo.valid = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
                    }
                }
                
                static IDInfo *lastIdInfo = nil;
                if (self.verify) {
                    if (lastIdInfo == nil) {
                        lastIdInfo = idInfo;
                        idInfo = nil;
                    }
                    else{
                        if (![lastIdInfo isEqual:idInfo]){
                            lastIdInfo = idInfo;
                            idInfo = nil;
                        }
                    }
                }
                if ([lastIdInfo isOK]) {
                    NSLog(@"%@", [lastIdInfo toString]);
                } else {
                    idInfo = nil;
                }
            }
            if (idInfo != nil) {
                CGSize size = CGSizeMake(width, height);
                CGRect effectRect = [RectManager getEffectImageRect:size];
                CGRect rect = [RectManager getGuideFrame:effectRect];
                UIImage *image = [UIImage getImageStream:imageBuffer];
                __block UIImage *subImg = [UIImage getSubImage:rect inImage:image];
                dispatch_async(dispatch_get_main_queue(), ^{
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                    if([self.delegate respondsToSelector:@selector(idCardRecognited:image:)]) {
                        [self.delegate idCardRecognited:idInfo image:subImg];
                    }
                });
            }
            CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
        }
    
       CVBufferRelease(imageBuffer);
    }
}

@end
