#import "EfBuglyPlugin.h"
#if __has_include(<ef_bugly/ef_bugly-Swift.h>)
#import <ef_bugly/ef_bugly-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "ef_bugly-Swift.h"
#endif

@implementation EfBuglyPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftEfBuglyPlugin registerWithRegistrar:registrar];
}
@end
