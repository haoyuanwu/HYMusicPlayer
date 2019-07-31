//
//  ListViewModel.h
//  Music
//
//  Created by 吴昊原 on 2018/6/1.
//  Copyright © 2018年 吴昊原. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListViewModel : NSObject

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *image;
@property (nonatomic,strong) NSMutableArray *array;

@end
