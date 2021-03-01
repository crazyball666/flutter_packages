#import "BuglyPlugin.h"
#import "BuglyUtil.h"

static NSString *setupBugly = @"";

@implementation BuglyPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"bugly"
            binaryMessenger:[registrar messenger]];
  BuglyPlugin* instance = [[BuglyPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
    
    [BuglyUtil startWithAppId:@"8019bee04a"];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}
@end
