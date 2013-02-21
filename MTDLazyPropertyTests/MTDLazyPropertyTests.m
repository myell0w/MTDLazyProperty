//
//  MTDLazyPropertyTests.m
//  MTDLazyPropertyTests
//
//  Created by Matthias Tretter on 21.02.13.
//  Copyright (c) 2013 @myell0w. All rights reserved.
//

#import "MTDLazyPropertyTests.h"
#import "NSObject+MTDLazyProperty.h"
#import "MTDTestClass.h"

@implementation MTDLazyPropertyTests {
    NSUInteger _blockCallingCount;
}

- (void)setUp {
    [super setUp];

    _blockCallingCount = 0;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [MTDTestClass mtd_implementProperty:@"name" withBlock:^id(id _self) {
            _blockCallingCount++;
            return NSStringFromClass([_self class]);
        }];
    });
}

- (void)testExample {
    MTDTestClass *test = [MTDTestClass new];
    NSString *name = test.name;

    for (NSUInteger i=0;i<20;i++) {
        // just access property to check if implementation block is called only once
        (void)test.name;
    }

    STAssertEqualObjects(name, @"MTDTestClass", nil);
    STAssertTrue(_blockCallingCount == 1, nil);
}

@end
