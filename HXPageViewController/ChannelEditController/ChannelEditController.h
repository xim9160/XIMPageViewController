//
//  ChannelEditController.h
//  V1_Circle
//
//  Created by 刘瑞龙 on 15/11/2.
//  Copyright © 2015年 com.Dmeng. All rights reserved.
//

#import "ChannelUnitModel.h"

#import <UIKit/UIKit.h>

@interface ChannelEditController : UIViewController


/// 初始化方法, 当前 页面显示蓝色标记
/// @param topDataArr 显示在列表中的 频道
/// @param bottomDataSource 暂未显示的频道
/// @param initialIndex 蓝色标记的频道
- (id)initWithTopDataSource:(NSArray<ChannelUnitModel *> *)topDataArr andBottomDataSource:(NSArray<ChannelUnitModel *> *)bottomDataSource andInitialIndex:(NSInteger)initialIndex;


/// 初始化方法,
/// @param topDataArr 显示在列表中的 频道
/// @param bottomDataSource 暂未显示的频道
- (id)initWithTopDataSource:(NSArray<ChannelUnitModel *> *)topDataArr andBottomDataSource:(NSArray<ChannelUnitModel *> *)bottomDataSource;

/**
 * @b 编辑后, 删除初始选中项排序的回调
 */
@property (nonatomic, copy) void(^removeInitialIndexBlock)(NSMutableArray<ChannelUnitModel *> *topArr, NSMutableArray<ChannelUnitModel *> *bottomArr);

/**
 * @b 选中某一个频道回调
 */
@property (nonatomic, copy) void(^chooseIndexBlock)(NSInteger index, NSMutableArray<ChannelUnitModel *> *topArr, NSMutableArray<ChannelUnitModel *> *bottomArr);

@property (nonatomic, copy) void(^disAppearBlock)(NSMutableArray<ChannelUnitModel *> *topArr, NSMutableArray<ChannelUnitModel *> *bottomArr);

@end
