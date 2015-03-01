//
//  ShutdownMyMac_MacOSXTests.m
//  ShutdownMyMac-MacOSXTests
//
//  Created by Jesús on 1/3/15.
//  Copyright (c) 2015 Jesús. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>

@interface ShutdownMyMac_MacOSXTests : XCTestCase

@end

@implementation ShutdownMyMac_MacOSXTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
