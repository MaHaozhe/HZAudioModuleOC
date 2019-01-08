//
//  ViewController.m
//  HZAudioModuleOC
//
//  Created by MaHaoZhe on 2019/1/3.
//  Copyright © 2019 HachiTech. All rights reserved.
//

#import "HomeViewController.h"
#import "HZAudioManager.h"
#import "HomeTV.h"
#import "HZMusicPlayVC.h"//播放音乐VC

@interface HomeViewController ()

@property (nonatomic, strong) HomeTV *tableview;

@end

@implementation HomeViewController

#pragma mark
#pragma mark - 1.View生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"音频组件";
    
    [self addSubviews];
}


- (void)addSubviews{
    _tableview = [[HomeTV alloc] init];
    [self.view addSubview:_tableview];
    
    WS(weakSelf);
    _tableview.cellSelectCallback = ^(NSIndexPath * _Nonnull indexPath) {
        switch (indexPath.row) {
            case 0:
            {
                [[HZAudioManager sharedHZAudioManager] playSoundEffect:@"produceSound.wav" playType:HZSoundEffectDefaultCallbackType complete:^(SystemSoundID soundID) {
                    NSLog(@"播放结束");
                }];
            }
                break;
            case 1:
            {
                HZMusicPlayVC *playVC = [[HZMusicPlayVC alloc] init];
                [weakSelf.navigationController pushViewController:playVC animated:YES];
            }
                break;
                
                
            default:
                break;
        }
    };
    
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
}


#pragma mark
#pragma mark - 2.View代理、数据源方法


#pragma mark 自定义代理


#pragma mark
#pragma mark - 3.用户交互


#pragma mark
#pragma mark - 4.数据处理/Http

#pragma mark
#pragma mark - 5.其它


@end
