//
//  idInfo.m
//  BankCard
//
//  Created by XAYQ-FanXL on 16/7/8.
//  Copyright © 2016年 AN. All rights reserved.
//

#import "idInfo.h"

@implementation IDInfo

- (BOOL)isEqual:(IDInfo *)idInfo {
    if (idInfo == nil) {
        return NO;
    }
    if (_type == 1) {
        if ((_type == idInfo.type) &&
            [_code isEqualToString:idInfo.code] &&
            [_name isEqualToString:idInfo.name] &&
            [_gender isEqualToString:idInfo.gender] &&
            [_gender isEqualToString:idInfo.gender] &&
            [_address isEqualToString:idInfo.address]) {
            return YES;
        }
    } else if (_type == 2) {
        if ([_issue isEqualToString:idInfo.issue] &&
            [_valid isEqualToString:idInfo.valid]) {
            return YES;
        }
    }
    return NO;
}

- (NSString *)toString {
    return [NSString stringWithFormat:@"身份证号:%@\n姓名:%@\n性别:%@\n民族:%@\n地址:%@\n签发机关:%@\n有效期:%@",
            _code, _name, _gender, _nation, _address, _issue, _valid];
}

- (BOOL)isOK {
    if (_code !=nil && _name!=nil && _gender!=nil && _nation!=nil && _address!=nil) {
        if (_code.length>0 && _name.length >0 && _gender.length>0 && _nation.length>0 && _address.length>0) {
            return YES;
        }
    }
    else if (_issue !=nil && _valid!=nil) {
        if (_issue.length>0 && _valid.length >0) {
            return YES;
        }
    }
    return NO;
}


@end
