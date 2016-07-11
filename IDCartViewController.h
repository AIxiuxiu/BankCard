//
//  IDCartViewController.h
//  BankCard
//
//  Created by XAYQ-FanXL on 16/7/11.
//  Copyright © 2016年 AN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDInfo.h"

typedef void (^ResultBlock)(IDInfo* idInfo, UIImage *image);

@interface IDCartViewController : UIViewController

- (void)achieveResult:(ResultBlock)block;

@end
