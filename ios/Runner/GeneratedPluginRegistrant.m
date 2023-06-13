//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<ssh2/SshPlugin.h>)
#import <ssh2/SshPlugin.h>
#else
@import ssh2;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [SshPlugin registerWithRegistrar:[registry registrarForPlugin:@"SshPlugin"]];
}

@end
