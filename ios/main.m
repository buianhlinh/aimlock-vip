#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor colorWithRed:5.0/255.0 green:8.0/255.0 blue:17.0/255.0 alpha:1.0];
    
    UIViewController *rootVC = [[UIViewController alloc] init];
    rootVC.view.backgroundColor = self.window.backgroundColor;
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.allowsInlineMediaPlayback = YES;
    if (@available(iOS 10.0, *)) {
        config.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeNone;
    }
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:rootVC.view.bounds configuration:config];
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    webView.backgroundColor = self.window.backgroundColor;
    webView.opaque = NO;
    webView.scrollView.bounces = NO;
    if (@available(iOS 11.0, *)) {
        webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    NSURL *targetURL = [NSURL URLWithString:@"https://buianhlinh.github.io/aimlock-vip/?v=5"];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL 
                                             cachePolicy:NSURLRequestReloadIgnoringLocalCacheData 
                                         timeoutInterval:20.0];
    [webView loadRequest:request];
    
    rootVC.view = webView;
    self.window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];
    return YES;
}

@end

int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
