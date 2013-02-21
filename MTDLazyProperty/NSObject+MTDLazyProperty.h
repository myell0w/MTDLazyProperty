//
//  NSObject+MTDLazyProperty.h
//  MTDLazyProperty
//
//  Created by Matthias Tretter on 21.02.13.
//  Copyright (c) 2013 @myell0w. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef id(^mtd_property_block)(id _self);


@interface NSObject (MTDLazyProperty)

+ (void)mtd_implementProperty:(NSString *)property withBlock:(mtd_property_block)block;

@end
