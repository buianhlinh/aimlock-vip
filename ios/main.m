#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, WKNavigationDelegate, WKUIDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) WKWebView *webView;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 1. Khởi tạo cửa sổ khớp 100% kích thước màn hình thiết bị (xóa bỏ hoàn toàn viền đen)
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    self.window = [[UIWindow alloc] initWithFrame:screenBounds];
    UIColor *bgColor = [UIColor colorWithRed:5.0/255.0 green:8.0/255.0 blue:17.0/255.0 alpha:1.0];
    self.window.backgroundColor = bgColor;
    
    UIViewController *rootVC = [[UIViewController alloc] init];
    rootVC.view.backgroundColor = bgColor;
    
    // 2. Cấu hình WebKit tối ưu cho game & âm thanh
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.allowsInlineMediaPlayback = YES;
    if (@available(iOS 10.0, *)) {
        config.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeNone;
    }
    
    // 3. Khởi tạo WKWebView Full màn hình edge-to-edge
    self.webView = [[WKWebView alloc] initWithFrame:screenBounds configuration:config];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.webView.backgroundColor = bgColor;
    self.webView.opaque = NO;
    self.webView.scrollView.bounces = NO;
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    // 4. Tải giao diện Nhẹ Tâm Pro V5
    NSURL *targetURL = [NSURL URLWithString:@"https://buianhlinh.github.io/aimlock-vip/?v=5"];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL 
                                             cachePolicy:NSURLRequestReloadIgnoringLocalCacheData 
                                         timeoutInterval:20.0];
    [self.webView loadRequest:request];
    
    rootVC.view = self.webView;
    self.window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark - WKNavigationDelegate: MỞ GAME FREE FIRE & CÁC APP KHÁC

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *url = navigationAction.request.URL;
    NSString *scheme = [[url scheme] lowercaseString];
    
    // Nếu là URL scheme mở ứng dụng ngoài (freefire, freefiremax, zalo, itms, tel, v.v...)
    if (scheme && ![scheme isEqualToString:@"http"] && ![scheme isEqualToString:@"https"] && ![scheme isEqualToString:@"file"] && ![scheme isEqualToString:@"about"]) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:url];
        }
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark - WKUIDelegate: HỖ TRỢ HỘP THOẠI ALERT, CONFIRM, PROMPT NATIVE

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"NHẸ TÂM PRO V5" 
                                                                   message:message 
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Đóng" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        completionHandler();
    }]];
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Xác nhận" 
                                                                   message:message 
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Hủy" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler(NO);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Đồng ý" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        completionHandler(YES);
    }]];
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

@end

int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
