//
//  IdentityCatrViewController.m
//  BankCard
//
//  Created by XAYQ-FanXL on 16/7/11.
//  Copyright © 2016年 AN. All rights reserved.
//

#import "IdentityCatrViewController.h"
#import "IDCartViewController.h"

@interface IdentityCatrViewController ()

@property (nonatomic, strong) UILabel *nameLabel;       //姓名
@property (nonatomic, strong) UILabel *genderLabel;     //性别
@property (nonatomic, strong) UILabel *nationLabel;     //民族
@property (nonatomic, strong) UILabel *addressLabel;    //地址
@property (nonatomic, strong) UILabel *codeLabel;       //身份证号
@property (nonatomic, strong) UILabel *issueLabel;      //签发机关
@property (nonatomic, strong) UILabel *validLabel;      //有效期

@property (nonatomic, strong) UIImageView *cardImageView;

@end

@implementation IdentityCatrViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.genderLabel];
    [self.view addSubview:self.nationLabel];
    [self.view addSubview:self.addressLabel];
    [self.view addSubview:self.codeLabel];
    [self.view addSubview:self.issueLabel];
    [self.view addSubview:self.validLabel];
    
    [self.view addSubview:self.cardImageView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((self.view.bounds.size.width - 100)/2, 500, 100, 54);
    button.backgroundColor = [UIColor grayColor];
    [button setTitle:@"开始" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(startScanCard) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)startScanCard {
    IDCartViewController *idCardVC = [[IDCartViewController alloc] init];
    [idCardVC achieveResult:^(IDInfo *idInfo, UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (idInfo.type == 1) {
                self.nameLabel.text    = [NSString stringWithFormat:@"姓名:%@",
                                          idInfo.name];
                self.genderLabel.text  = [NSString stringWithFormat:@"性别:%@",
                                          idInfo.gender];
                self.nationLabel.text  = [NSString stringWithFormat:@"民族:%@",
                                          idInfo.nation];
                self.addressLabel.text = [NSString stringWithFormat:@"地址:%@",
                                          idInfo.address];
                self.codeLabel.text    = [NSString stringWithFormat:@"身份证号:%@",
                                          idInfo.code];
            } else if (idInfo.type == 2){
                self.issueLabel.text   = [NSString stringWithFormat:@"签发机关:%@",
                                          idInfo.issue];
                self.validLabel.text   = [NSString stringWithFormat:@"有效期:%@",
                                          idInfo.valid];
            }
            
            self.cardImageView.image = image;
        });
    }];
    
    [self.navigationController pushViewController:idCardVC animated:YES];
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, 300, 20)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textColor = [UIColor lightGrayColor];
    }
    return _nameLabel;
}

- (UILabel *)genderLabel {
    if (!_genderLabel) {
        _genderLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 300, 20)];
        _genderLabel.backgroundColor = [UIColor clearColor];
        _genderLabel.font = [UIFont systemFontOfSize:15];
        _genderLabel.textColor = [UIColor lightGrayColor];
    }
    return _genderLabel;
}

- (UILabel *)nationLabel {
    if (!_nationLabel) {
        _nationLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 130, 300, 20)];
        _nationLabel.backgroundColor = [UIColor clearColor];
        _nationLabel.font = [UIFont systemFontOfSize:15];
        _nationLabel.textColor = [UIColor lightGrayColor];
    }
    return _nationLabel;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 160, 300, 20)];
        _addressLabel.backgroundColor = [UIColor clearColor];
        _addressLabel.font = [UIFont systemFontOfSize:15];
        _addressLabel.textColor = [UIColor lightGrayColor];
    }
    return _addressLabel;
}

- (UILabel *)codeLabel {
    if (!_codeLabel) {
        _codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 190, 300, 20)];
        _codeLabel.backgroundColor = [UIColor clearColor];
        _codeLabel.font = [UIFont systemFontOfSize:15];
        _codeLabel.textColor = [UIColor lightGrayColor];
    }
    return _codeLabel;
}

- (UILabel *)issueLabel {
    if (!_issueLabel) {
        _issueLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 220, 300, 20)];
        _issueLabel.backgroundColor = [UIColor clearColor];
        _issueLabel.font = [UIFont systemFontOfSize:15];
        _issueLabel.textColor = [UIColor lightGrayColor];
    }
    return _issueLabel;
}

- (UILabel *)validLabel {
    if (!_validLabel) {
        _validLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 250, 300, 20)];
        _validLabel.backgroundColor = [UIColor clearColor];
        _validLabel.font = [UIFont systemFontOfSize:15];
        _validLabel.textColor = [UIColor lightGrayColor];
    }
    return _validLabel;
}

- (UIImageView *)cardImageView {
    if (!_cardImageView) {
        float cardw = self.view.bounds.size.width * 70 / 100;
        if(self.view.bounds.size.width < cardw)
            cardw = self.view.bounds.size.width;
        
        float cardh = (float)(cardw / 0.63084f);
        
        float left = (self.view.bounds.size.width -cardw)/2;
//        float top = (self.view.bounds.size.height -cardh)/2;
        CGRect rect = CGRectMake(left, 200, cardw, cardh);
        _cardImageView = [[UIImageView alloc] initWithFrame:rect];
        _cardImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _cardImageView;
}

@end
