//
//  CategoriesTest.m
//  WordPress
//
//  Created by Tonny Xu on 3/2/13.
//  Copyright (c) 2013 WordPress. All rights reserved.
//

#import "CategoriesTest.h"

#import "NSData+Base64.h"
#import "NSMutableDictionary+Helpers.h"
#import "NSString+Helpers.h"
#import "NSString+XMLExtensions.h"
#import "NSString+Util.h"
#import "NSString+SBJSON.h"

@implementation CategoriesTest

- (void)testNSData_Base64{
  NSString *testString = @"abcdef_123456\n";
  NSString *expectedBase64String = @"YWJjZGVmXzEyMzQ1Ngo=";
  
  NSData *testDataFromTestString = [testString dataUsingEncoding:NSASCIIStringEncoding];
  NSString *encodedString = [testDataFromTestString base64EncodedString];
  STAssertEqualObjects(expectedBase64String, encodedString, @"encode: %@, expected: %@", encodedString, expectedBase64String);
}

- (void)testNSMutableDictionary_Helper{
  
}

- (void)testNSString_Helpers{
  
}

- (void)testNSString_XMLExtensions{
  
}

- (void)testNSString_Util{
  
}

- (void)testNSString_SBJSON{
  
}

@end
