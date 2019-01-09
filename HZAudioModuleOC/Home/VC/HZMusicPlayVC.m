//
//  HZMusicPlayVC.m
//  HZAudioModuleOC
//
//  Created by MaHaoZhe on 2019/1/4.
//  Copyright © 2019 HachiTech. All rights reserved.
//

#import "HZMusicPlayVC.h"
#import "HZAudioPlaybackObj.h"

@interface HZMusicPlayVC ()

@property (nonatomic, strong) UILabel *musicNameLab;//歌曲名称
@property (nonatomic, strong) UIButton *playOrPauseBtn;//播放/暂停按钮
@property (nonatomic, strong) UIButton *beforeOneBtn;//上一首按钮
@property (nonatomic, strong) UIButton *nextOneBtn;//下一首按钮
@property (nonatomic, strong) UIProgressView *progressView;//播放进度
@property (nonatomic, strong) UISlider *progressSlider;//更改音频播放进度的滑块
@property (nonatomic, strong) UILabel *currentTimeLab;//当前进度
@property (nonatomic, strong) UILabel *totalTimeLab;//音频总时间
@property (nonatomic, strong) HZAudioPlaybackObj *playBackObj;//音频播放管理

@end

@implementation HZMusicPlayVC

#pragma mark
#pragma mark - 1.View生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"播放音乐";
    
    [self addSubviews];
    
    NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"The Argonauts.mp3" ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:urlStr];
    
    WS(weakSelf);
    _playBackObj = [[HZAudioPlaybackObj alloc] initAudioPlayer:url updateProgress:^(CGFloat progress, NSString * _Nonnull progressStr, NSString * _Nonnull totalTimeStr) {
        weakSelf.progressView.progress = progress;
        weakSelf.currentTimeLab.text = progressStr;
        weakSelf.totalTimeLab.text = totalTimeStr;
        weakSelf.progressSlider.value = progress*100;
    } DeviceStatusChangedCallback:^(HZAudioDeviceChangeStatusType type) {
        if (type == HZAudioDeviceChangeStatusPlay) {
            weakSelf.playOrPauseBtn.selected = NO;
        }else if (type == HZAudioDeviceChangeStatusPause){
            weakSelf.playOrPauseBtn.selected = YES;
        }
    }];
    [_playBackObj playAudio];
    
}


- (void)addSubviews{
    [self.view addSubview:self.musicNameLab];
    [self.view addSubview:self.playOrPauseBtn];
    [self.view addSubview:self.beforeOneBtn];
    [self.view addSubview:self.nextOneBtn];
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.currentTimeLab];
    [self.view addSubview:self.totalTimeLab];
    [self.view addSubview:self.progressSlider];
    
    [_musicNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(@(50));
    }];
    
    [@[_beforeOneBtn,_playOrPauseBtn,_nextOneBtn] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:(kDeviceWidth-60)/3.f leadSpacing:15 tailSpacing:15];
    [@[_beforeOneBtn,_playOrPauseBtn,_nextOneBtn] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-80);
        make.height.equalTo(@(44));
    }];
    
    [_currentTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.bottom.equalTo(self.beforeOneBtn.mas_top).offset(-15);
        make.height.equalTo(@(15));
        make.width.equalTo(@(35));
    }];
    
    [_totalTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.bottom.equalTo(self.beforeOneBtn.mas_top).offset(-15);
        make.height.equalTo(@(15));
        make.height.equalTo(@(35));
    }];
    
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.currentTimeLab.mas_right).offset(12);
        make.right.equalTo(self.totalTimeLab.mas_left).offset(-12);
        make.centerY.equalTo(self.currentTimeLab.mas_centerY);
        make.height.equalTo(@(2.5));
    }];
    
    [_progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.progressView.mas_centerY).offset(-0.75);
        make.left.equalTo(self.progressView.mas_left);
        make.right.equalTo(self.progressView.mas_right);
        make.height.equalTo(@(20));
    }];
}


#pragma mark
#pragma mark - 2.View代理、数据源方法


#pragma mark 自定义代理


#pragma mark
#pragma mark - 3.用户交互
- (void)clickPlayOrPauseEvent:(UIButton *)sender{
    if (sender.isSelected == YES) {//播放
        sender.selected = NO;
        [_playBackObj pauseAudio];
    }else{//暂停
        sender.selected = YES;
        [_playBackObj playAudio];
    }
}


- (void)sliderValueChange:(UISlider *)sender{
    [self.playBackObj setCurrentTime:sender.value/100.0*self.playBackObj.totalTime];
}


#pragma mark
#pragma mark - 4.数据处理/Http

#pragma mark
#pragma mark - 5.其它
- (UILabel *)musicNameLab{
    if (!_musicNameLab) {
        _musicNameLab = [[UILabel alloc] init];
        _musicNameLab.text = @"The Argonauts";
        _musicNameLab.textColor = [UIColor whiteColor];
        _musicNameLab.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _musicNameLab.textAlignment = NSTextAlignmentCenter;
        _musicNameLab.font = [UIFont systemFontOfSize:15];
    }
    return _musicNameLab;
}


- (UIButton *)playOrPauseBtn{
    if (!_playOrPauseBtn) {
        _playOrPauseBtn = [[UIButton alloc] init];
        [_playOrPauseBtn setTitle:@"播放" forState:UIControlStateNormal];
        [_playOrPauseBtn setTitle:@"暂停" forState:UIControlStateSelected];
        [_playOrPauseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_playOrPauseBtn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        _playOrPauseBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_playOrPauseBtn setBackgroundColor:[UIColor redColor]];
        _playOrPauseBtn.layer.cornerRadius = 4;
        _playOrPauseBtn.selected = YES;
        [_playOrPauseBtn addTarget:self action:@selector(clickPlayOrPauseEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playOrPauseBtn;
}


- (UIButton *)beforeOneBtn{
    if (!_beforeOneBtn) {
        _beforeOneBtn = [[UIButton alloc] init];
        [_beforeOneBtn setTitle:@"上一首" forState:UIControlStateNormal];
        [_beforeOneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _beforeOneBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_beforeOneBtn setBackgroundColor:[UIColor yellowColor]];
        _beforeOneBtn.layer.cornerRadius = 4;
    }
    return _beforeOneBtn;
}


- (UIButton *)nextOneBtn{
    if (!_nextOneBtn) {
        _nextOneBtn = [[UIButton alloc] init];
        [_nextOneBtn setTitle:@"下一首" forState:UIControlStateNormal];
        [_nextOneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _nextOneBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_nextOneBtn setBackgroundColor:[UIColor blueColor]];
        _nextOneBtn.layer.cornerRadius = 4;
    }
    return _nextOneBtn;
}


- (UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] init];
        _progressView.progressTintColor = [UIColor blackColor];
        _progressView.trackTintColor = [UIColor darkGrayColor];
        _progressView.layer.cornerRadius = 1.25;
        _progressView.layer.masksToBounds = YES;
    }
    return _progressView;
}


- (UILabel *)currentTimeLab{
    if (!_currentTimeLab) {
        _currentTimeLab = [[UILabel alloc] init];
        _currentTimeLab.textAlignment = NSTextAlignmentLeft;
        _currentTimeLab.textColor = [UIColor blackColor];
        _currentTimeLab.font = [UIFont systemFontOfSize:12];
        _currentTimeLab.text = @"00:00";
    }
    return _currentTimeLab;
}


- (UILabel *)totalTimeLab{
    if (!_totalTimeLab) {
        _totalTimeLab = [[UILabel alloc] init];
        _totalTimeLab.textAlignment = NSTextAlignmentRight;
        _totalTimeLab.textColor = [UIColor blackColor];
        _totalTimeLab.font = [UIFont systemFontOfSize:12];
        _totalTimeLab.text = @"00:00";
    }
    return _totalTimeLab;
}


- (UISlider *)progressSlider{
    if(!_progressSlider){
        _progressSlider = [[UISlider alloc] init];
        _progressSlider.minimumTrackTintColor = [UIColor redColor];
        _progressSlider.maximumTrackTintColor = [UIColor clearColor];
        _progressSlider.maximumValue = 100;
        _progressSlider.minimumValue = 0;
        _progressSlider.value = 0;
        [_progressSlider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _progressSlider;
}


- (void)dealloc{
    if (_playBackObj) {
        [_playBackObj stopAudio];
        [_playBackObj releaseObj];
        _playBackObj = nil;
    }
}

@end
