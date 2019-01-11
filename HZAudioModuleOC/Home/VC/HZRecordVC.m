//
//  HZRecordVC.m
//  HZAudioModuleOC
//
//  Created by MaHaoZhe on 2019/1/10.
//  Copyright © 2019 HachiTech. All rights reserved.
//

#import "HZRecordVC.h"
#import "HZRecordObj.h"

@interface HZRecordVC ()<UITextFieldDelegate>

@property (nonatomic, strong) UIProgressView *powerView;//声波

@property (nonatomic, strong) UITextField *timeTF;//指定时间

@property (nonatomic, strong) UITextField *durationTF;//录音时长

@property (nonatomic, strong) UITextField *recordNameTF;//录制的标题

@property (nonatomic, strong) HZRecordObj *recordObj;//录音管理类

@end

@implementation HZRecordVC

#pragma mark
#pragma mark - 1.View生命周期


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"录音";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self loadsubViews];
}


- (void)loadsubViews{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *recordBtn = [self loadCustomBtnWithTitle:@"录制" action:@selector(recordClick:)];
    UIButton *puaseBtn = [self loadCustomBtnWithTitle:@"暂停" action:@selector(puaseClick:)];
    UIButton *stopBtn = [self loadCustomBtnWithTitle:@"停止" action:@selector(stopClick:)];
    UIButton *timeRecordBtn = [self loadCustomBtnWithTitle:@"指定时间录制" action:@selector(timeRecordClick:)];
    UIButton *durationRecordBtn = [self loadCustomBtnWithTitle:@"指定时间录制" action:@selector(durationRecordClick:)];
    UIButton *doubleRecordBtn = [self loadCustomBtnWithTitle:@"双限制录制" action:@selector(doubleRecordClick:)];
    
    [self.view addSubview:recordBtn];
    [self.view addSubview:puaseBtn];
    [self.view addSubview:stopBtn];
    [self.view addSubview:timeRecordBtn];
    [self.view addSubview:durationRecordBtn];
    [self.view addSubview:doubleRecordBtn];
    [self.view addSubview:self.powerView];
    [self.view addSubview:self.recordNameTF];
    [self.view addSubview:self.timeTF];
    [self.view addSubview:self.durationTF];
    
    [self.recordNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(20);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.equalTo(@(44));
    }];
    
    [self.timeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.recordNameTF.mas_bottom).offset(15);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.equalTo(@(44));
    }];
    
    [self.durationTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeTF.mas_bottom).offset(15);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.equalTo(@(44));
    }];
    
    [self.powerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.durationTF.mas_bottom).offset(30);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.equalTo(@(2));
    }];
    
    [@[recordBtn,puaseBtn,stopBtn] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:20 leadSpacing:15 tailSpacing:15];
    [@[recordBtn,puaseBtn,stopBtn] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-40);
        make.height.equalTo(@(40));
    }];
    
    [@[timeRecordBtn,durationRecordBtn,doubleRecordBtn] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:20 leadSpacing:15 tailSpacing:15];
    [@[timeRecordBtn,durationRecordBtn,doubleRecordBtn] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(recordBtn.mas_top).offset(-15);
        make.height.equalTo(@(40));
    }];
}


- (UIButton *)loadCustomBtnWithTitle:(NSString *)title action:(SEL)action{
    UIButton *customBtn = [[UIButton alloc] init];
    [customBtn setTitle:title forState:UIControlStateNormal];
    [customBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    customBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    customBtn.layer.cornerRadius = 5;
    customBtn.layer.masksToBounds = YES;
    [customBtn setBackgroundColor:[UIColor redColor]];
    [customBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return customBtn;
}
#pragma mark
#pragma mark - 2.View代理、数据源方法


#pragma mark 自定义代理


#pragma mark
#pragma mark - 3.用户交互
- (void)recordClick:(UIButton *)sender{
    if (_recordNameTF.text.length <= 0) {
        return;
    }
    
    WS(weakSelf);
    //初始化
    _recordObj = [[HZRecordObj alloc] initWithRecordName:self.recordNameTF.text powerCallbask:^(CGFloat power) {
        weakSelf.powerView.progress = power;
    } completeCallback:^(CGFloat power) {
        weakSelf.powerView.progress = 0;
        [weakSelf releaseRecordObj];
    }];
    [_recordObj record];
};


- (void)timeRecordClick:(UIButton *)sender{
    if (_recordNameTF.text.length <= 0 || _timeTF.text.length <= 0) {
        return;
    }
    WS(weakSelf);
    //初始化
    _recordObj = [[HZRecordObj alloc] initWithRecordName:self.recordNameTF.text powerCallbask:^(CGFloat power) {
        weakSelf.powerView.progress = power;
    } completeCallback:^(CGFloat power) {
        weakSelf.powerView.progress = 0;
        [weakSelf releaseRecordObj];
    }];
    [_recordObj recordAtTime:self.timeTF.text.integerValue];
};


- (void)durationRecordClick:(UIButton *)sender{
    if (_recordNameTF.text.length <= 0 || _durationTF.text.length <= 0) {
        return;
    }
    
    WS(weakSelf);
    _recordObj = [[HZRecordObj alloc] initWithRecordName:self.recordNameTF.text powerCallbask:^(CGFloat power) {
        weakSelf.powerView.progress = power;
    } completeCallback:^(CGFloat power) {
        weakSelf.powerView.progress = 0;
        [weakSelf releaseRecordObj];
    }];
    [_recordObj recordDurationTime:self.durationTF.text.integerValue];
};


- (void)doubleRecordClick:(UIButton *)sender{
    if (_recordNameTF.text.length <= 0 || _timeTF.text.length <= 0 || _durationTF.text.length <= 0) {
        return;
    }
    
    WS(weakSelf);
    _recordObj = [[HZRecordObj alloc] initWithRecordName:self.recordNameTF.text powerCallbask:^(CGFloat power) {
        weakSelf.powerView.progress = power;
    } completeCallback:^(CGFloat power) {
        weakSelf.powerView.progress = 0;
        [weakSelf releaseRecordObj];
    }];
    [_recordObj recordAtTime:self.timeTF.text.integerValue DurationTime:self.durationTF.text.integerValue];
};


- (void)puaseClick:(UIButton *)sender{
    if (_recordObj.isRecording) {
        [_recordObj pauseRecord];
    }
    
};


- (void)stopClick:(UIButton *)sender{
    if (_recordObj.isRecording) {
        [_recordObj stopRecord];
    }
};


#pragma mark
#pragma mark - 4.数据处理/Http

#pragma mark
#pragma mark - 5.set get
- (UIProgressView *)powerView{
    if (!_powerView) {
        _powerView = [[UIProgressView alloc] init];
        _powerView.progressTintColor = [UIColor redColor];
        _powerView.trackTintColor = [UIColor grayColor];
    }
    return _powerView;
}


- (UITextField *)timeTF{
    if (!_timeTF) {
        _timeTF = [[UITextField alloc] init];
        _timeTF.placeholder = @"请输入开始录制的时间";
        _timeTF.font = [UIFont systemFontOfSize:14];
        _timeTF.textColor = [UIColor blackColor];
        _timeTF.keyboardType = UIKeyboardTypeDecimalPad;
        _timeTF.delegate = self;
        _timeTF.layer.borderWidth = 1;
        _timeTF.layer.borderColor = [UIColor redColor].CGColor;
        _timeTF.layer.cornerRadius = 5;
    }
    return _timeTF;
}


- (UITextField *)durationTF{
    if (!_durationTF) {
        _durationTF = [[UITextField alloc] init];
        _durationTF.placeholder = @"请输入录制时长";
        _durationTF.font = [UIFont systemFontOfSize:14];
        _durationTF.textColor = [UIColor blackColor];
        _durationTF.keyboardType = UIKeyboardTypeDecimalPad;
        _durationTF.delegate = self;
        _durationTF.layer.borderWidth = 1;
        _durationTF.layer.borderColor = [UIColor redColor].CGColor;
        _durationTF.layer.cornerRadius = 5;
    }
    return _durationTF;
}


- (UITextField *)recordNameTF{
    if (!_recordNameTF) {
        _recordNameTF = [[UITextField alloc] init];
        _recordNameTF.placeholder = @"请输入录制音频的标题";
        _recordNameTF.font = [UIFont systemFontOfSize:14];
        _recordNameTF.textColor = [UIColor blackColor];
        _recordNameTF.delegate = self;
        _recordNameTF.layer.borderWidth = 1;
        _recordNameTF.layer.borderColor = [UIColor redColor].CGColor;
        _recordNameTF.layer.cornerRadius = 5;
    }
    return _recordNameTF;
}


#pragma mark
#pragma mark - 6.其他

- (void)releaseRecordObj{
    _recordObj = nil;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
