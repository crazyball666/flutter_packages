//
//  BuglyUtil.m
//  bugly
//
//  Created by efun on 2021/2/25.
//

#import "BuglyUtil.h"
#import <Bugly/Bugly.h>

@implementation BuglyUtil

+ (void)startWithAppId:(NSString *)appId{
    [Bugly startWithAppId:appId];
    
    [Bugly reportError:[NSError errorWithDomain:@"test error" code:-1 userInfo:nil]];
    [Bugly reportException:[NSException exceptionWithName:@"exception" reason:@"asdasd" userInfo:nil]];
}




@end
