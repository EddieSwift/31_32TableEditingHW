//
//  EGBStudent.h
//  31_32TableEditingHW
//
//  Created by Eduard Galchenko on 2/2/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EGBStudent : NSObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (assign, nonatomic) CGFloat averageGrade;

+ (EGBStudent* ) randomStudent;

@end

NS_ASSUME_NONNULL_END
