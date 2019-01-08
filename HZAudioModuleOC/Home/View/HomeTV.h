//
//  HomeTV.h
//  HZAudioModuleOC
//
//  Created by MaHaoZhe on 2019/1/3.
//  Copyright © 2019 HachiTech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CellClickEventCallback)(NSIndexPath *indexPath);

@interface HomeTV : UITableView

@property (nonatomic, copy) CellClickEventCallback cellSelectCallback;

@end

NS_ASSUME_NONNULL_END
