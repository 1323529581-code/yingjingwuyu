//
//  AuthPlugin.m
//  樱境物语 - 激活码验证插件 (完美版)
//

#import <UIKit/UIKit.h>
#import <stdlib.h>

#pragma mark - 全局状态
static UIViewController *currentAuthVC = nil;

#pragma mark - 声明

@interface AuthPlugin : NSObject
@property (nonatomic, strong) NSTimer *pollTimer;
+ (instancetype)sharedInstance;
- (void)startAuthCheck;
@end

#pragma mark - UI 控制器实现

@interface AuthPluginViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *codeTextField;
@property (nonatomic, strong) UIButton    *activateButton;
@property (nonatomic, strong) UIButton    *quitButton;
@property (nonatomic, strong) UILabel     *statusLabel;

@property (nonatomic, strong) NSDictionary<NSString *, NSNumber *> *codeTable;
@property (nonatomic, strong) NSTimer *countdownTimer;

@end

@implementation AuthPluginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.055 green:0.063 blue:0.098 alpha:1.0];
    
    [self buildActivationCodeTable];
    [self setupUI];
    [self restoreActivationState];
}

- (void)dealloc {
    [_countdownTimer invalidate];
    _countdownTimer = nil;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - 内置50个激活码

- (void)buildActivationCodeTable {
    NSMutableDictionary *table = [NSMutableDictionary dictionary];
    
    // 试用卡 (10个, 8小时)
    NSArray *trialCodes = @[
        @"TRY-366NT-OM80T", @"TRY-7JBJS-SZONQ", @"TRY-84904-8GRY0", @"TRY-E85FV-K1XFS", @"TRY-F4PH4-B5FGP",
        @"TRY-F6SZU-400LO", @"TRY-FMSC4-SXUH4", @"TRY-MFN8B-60P55", @"TRY-OIEYC-VLBMO", @"TRY-Y0CLH-B8WWE"
    ];
    for (NSString *code in trialCodes) { table[code] = @(8 * 60 * 60); }
    
    // 天卡 (10个, 24小时)
    NSArray *dayCodes = @[
        @"DAY-1GVEE-4P914", @"DAY-2PKN3-EVCRD", @"DAY-D2AY4-2U2RG", @"DAY-GL0BU-WF412", @"DAY-I4C1L-5R5CL",
        @"DAY-IE4KW-FSNIU", @"DAY-JZ5A5-YPRMV", @"DAY-ONKCH-B116V", @"DAY-PJGZA-HG0FR", @"DAY-U42E1-8SMQB"
    ];
    for (NSString *code in dayCodes) { table[code] = @(24 * 60 * 60); }
    
    // 周卡 (10个, 7天)
    NSArray *weekCodes = @[
        @"WEK-0NDRN-SG0XL", @"WEK-2AWTP-2TDVB", @"WEK-9Q1FN-NIWWV", @"WEK-BRG7G-TIVAE", @"WEK-DRL4Q-8P0HG",
        @"WEK-G8OD8-PDEMF", @"WEK-JU8Y3-BC08L", @"WEK-P5BYO-0OQHR", @"WEK-WLL2Q-1B35J", @"WEK-Z49IL-220LY"
    ];
    for (NSString *code in weekCodes) { table[code] = @(7 * 24 * 60 * 60); }
    
    // 月卡 (10个, 30天)
    NSArray *monthCodes = @[
        @"MON-9PUVH-BJNCH", @"MON-H77NP-DDIWR", @"MON-LF6SK-FB3Z6", @"MON-LZLTK-R3YCH", @"MON-R0KAJ-7AFFI",
        @"MON-R5AE0-9VKQQ", @"MON-VGOZQ-EK7QV", @"MON-VQF5G-3XWG4", @"MON-W989E-OAQ2C", @"MON-ZER1C-TYEHB"
    ];
    for (NSString *code in monthCodes) { table[code] = @(30 * 24 * 60 * 60); }
    
    // 季卡 (10个, 90天)
    NSArray *quarterCodes = @[
        @"QTR-BFGHU-T0UNL", @"QTR-CNBVC-MO7E6", @"QTR-D06IQ-0525O", @"QTR-RC68M-DLU9F", @"QTR-S84HG-10VXY",
        @"QTR-THVMG-SKBY3", @"QTR-U0773-28XMZ", @"QTR-UHJ99-9XWTJ", @"QTR-V7PS8-PNTSG", @"QTR-VQGMS-5PF9K"
    ];
    for (NSString *code in quarterCodes) { table[code] = @(90 * 24 * 60 * 60); }
    
    self.codeTable = [table copy];
}

#pragma mark - UI 搭建

- (void)setupUI {
    UIColor *goldColor = [UIColor colorWithRed:0.93 green:0.78 blue:0.42 alpha:1.0];
    UIColor *darkBgColor = [UIColor colorWithRed:0.11 green:0.12 blue:0.17 alpha:1.0];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"樱境物语";
    titleLabel.textColor = goldColor;
    titleLabel.font = [UIFont boldSystemFontOfSize:34];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:titleLabel];

    UILabel *subTitleLabel = [[UILabel alloc] init];
    subTitleLabel.text = @"—— 激活码验证 ——";
    subTitleLabel.textColor = [UIColor colorWithWhite:0.62 alpha:1.0];
    subTitleLabel.font = [UIFont systemFontOfSize:14];
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    subTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:subTitleLabel];

    UITextField *textField = [[UITextField alloc] init];
    textField.backgroundColor = darkBgColor;
    textField.textColor = [UIColor whiteColor];
    textField.tintColor = goldColor;
    textField.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    textField.textAlignment = NSTextAlignmentCenter;
    textField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.returnKeyType = UIReturnKeyGo;
    textField.delegate = self;
    textField.layer.cornerRadius = 12.0;
    textField.layer.borderWidth = 1.0;
    textField.layer.borderColor = [UIColor colorWithWhite:0.28 alpha:1.0].CGColor;
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入激活码" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.45 alpha:1.0]}];
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:textField];
    self.codeTextField = textField;

    UIButton *activateBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [activateBtn setTitle:@"激  活" forState:UIControlStateNormal];
    [activateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    activateBtn.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    activateBtn.backgroundColor = goldColor;
    activateBtn.layer.cornerRadius = 12.0;
    activateBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [activateBtn addTarget:self action:@selector(activateButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:activateBtn];
    self.activateButton = activateBtn;

    UIButton *quitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [quitBtn setTitle:@"退出游戏" forState:UIControlStateNormal];
    [quitBtn setTitleColor:[UIColor colorWithWhite:0.85 alpha:1.0] forState:UIControlStateNormal];
    quitBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    quitBtn.backgroundColor = darkBgColor;
    quitBtn.layer.cornerRadius = 12.0;
    quitBtn.layer.borderWidth = 1.0;
    quitBtn.layer.borderColor = [UIColor colorWithWhite:0.28 alpha:1.0].CGColor;
    quitBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [quitBtn addTarget:self action:@selector(quitGame) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:quitBtn];
    self.quitButton = quitBtn;

    UILabel *statusLabel = [[UILabel alloc] init];
    statusLabel.textColor = [UIColor systemGreenColor];
    statusLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.numberOfLines = 0;
    statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:statusLabel];
    self.statusLabel = statusLabel;

    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"试用卡 8 小时 · 天卡 1 天 · 周卡 7 天\n月卡 30 天 · 季卡 90 天\n有效期自首次激活起计算";
    tipLabel.textColor = [UIColor colorWithWhite:0.42 alpha:1.0];
    tipLabel.font = [UIFont systemFontOfSize:12];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.numberOfLines = 0;
    tipLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:tipLabel];

    UILayoutGuide *safe = self.view.safeAreaLayoutGuide;
    [NSLayoutConstraint activateConstraints:@[
        [titleLabel.centerXAnchor constraintEqualToAnchor:safe.centerXAnchor],
        [titleLabel.topAnchor constraintEqualToAnchor:safe.topAnchor constant:70],
        [subTitleLabel.centerXAnchor constraintEqualToAnchor:safe.centerXAnchor],
        [subTitleLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:10],
        [textField.centerXAnchor constraintEqualToAnchor:safe.centerXAnchor],
        [textField.topAnchor constraintEqualToAnchor:subTitleLabel.bottomAnchor constant:50],
        [textField.leadingAnchor constraintEqualToAnchor:safe.leadingAnchor constant:36],
        [textField.trailingAnchor constraintEqualToAnchor:safe.trailingAnchor constant:-36],
        [textField.heightAnchor constraintEqualToConstant:54],
        [activateBtn.centerXAnchor constraintEqualToAnchor:safe.centerXAnchor],
        [activateBtn.topAnchor constraintEqualToAnchor:textField.bottomAnchor constant:26],
        [activateBtn.leadingAnchor constraintEqualToAnchor:textField.leadingAnchor],
        [activateBtn.trailingAnchor constraintEqualToAnchor:textField.trailingAnchor],
        [activateBtn.heightAnchor constraintEqualToConstant:52],
        [quitBtn.centerXAnchor constraintEqualToAnchor:safe.centerXAnchor],
        [quitBtn.topAnchor constraintEqualToAnchor:activateBtn.bottomAnchor constant:16],
        [quitBtn.leadingAnchor constraintEqualToAnchor:textField.leadingAnchor],
        [quitBtn.trailingAnchor constraintEqualToAnchor:textField.trailingAnchor],
        [quitBtn.heightAnchor constraintEqualToConstant:52],
        [statusLabel.centerXAnchor constraintEqualToAnchor:safe.centerXAnchor],
        [statusLabel.topAnchor constraintEqualToAnchor:quitBtn.bottomAnchor constant:26],
        [statusLabel.leadingAnchor constraintEqualToAnchor:safe.leadingAnchor constant:30],
        [statusLabel.trailingAnchor constraintEqualToAnchor:safe.trailingAnchor constant:-30],
        [tipLabel.centerXAnchor constraintEqualToAnchor:safe.centerXAnchor],
        [tipLabel.bottomAnchor constraintEqualToAnchor:safe.bottomAnchor constant:-24]
    ]];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

- (void)dismissKeyboard { [self.view endEditing:YES]; }

#pragma mark - 激活核心逻辑

- (void)activateButtonTapped {
    [self.view endEditing:YES];
    NSString *input = self.codeTextField.text ?: @"";
    input = [input stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    input = [input uppercaseString];

    if (input.length == 0) { [self activationFailed]; return; }

    NSNumber *durationNum = self.codeTable[input];
    if (durationNum == nil) { [self activationFailed]; return; } 

    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval expireAt = now + durationNum.doubleValue;

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:input forKey:@"YS_ActivationCode"];
    [ud setDouble:now forKey:@"YS_ActivationTime"];
    [ud setDouble:expireAt forKey:@"YS_ExpireTime"];
    [ud synchronize];

    self.activateButton.enabled = NO;
    self.codeTextField.enabled = NO;
    [self startCountdown];
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *expireString = [fmt stringFromDate:[NSDate dateWithTimeIntervalSince1970:expireAt]];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"激活成功" message:[NSString stringWithFormat:@"恭喜，激活成功！\n\n到期时间：%@", expireString] preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"开始游戏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 安全退出验证界面
        [self dismissViewControllerAnimated:YES completion:^{
            currentAuthVC = nil;
        }];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)activationFailed {
    self.statusLabel.textColor = [UIColor systemRedColor];
    self.statusLabel.text = @"激活码无效，游戏即将退出…";
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        exit(0);
    });
}

- (void)quitGame {
    [self.view endEditing:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        exit(0);
    });
}

- (void)restoreActivationState {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *savedCode = [ud stringForKey:@"YS_ActivationCode"];
    NSTimeInterval expireAt = [ud doubleForKey:@"YS_ExpireTime"];
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];

    if (savedCode.length == 0) return;

    self.codeTextField.text = savedCode;
    if (expireAt > now) {
        self.codeTextField.enabled = NO;
        self.activateButton.enabled = NO;
        [self startCountdown];
    } else {
        self.statusLabel.textColor = [UIColor systemRedColor];
        self.statusLabel.text = @"激活码已过期，请重新输入激活码";
    }
}

- (void)startCountdown {
    [self.countdownTimer invalidate];
    self.countdownTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(tickCountdown) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.countdownTimer forMode:NSRunLoopCommonModes];
    [self tickCountdown];
}

- (void)tickCountdown {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSTimeInterval expireAt = [ud doubleForKey:@"YS_ExpireTime"];
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval remain = expireAt - now;

    if (remain <= 0) {
        [self.countdownTimer invalidate];
        self.countdownTimer = nil;
        self.statusLabel.textColor = [UIColor systemRedColor];
        self.statusLabel.text = @"激活已过期，请重新输入激活码";
        self.codeTextField.enabled = YES;
        self.activateButton.enabled = YES;
        return;
    }

    self.statusLabel.textColor = [UIColor systemGreenColor];
    NSInteger total = (NSInteger)remain;
    NSInteger day = total / 86400;
    NSInteger hour = (total % 86400) / 3600;
    NSInteger min = (total % 3600) / 60;
    NSInteger sec = total % 60;
    
    if (day > 0) {
        self.statusLabel.text = [NSString stringWithFormat:@"剩余时长：%ld天 %02ld:%02ld:%02ld", (long)day, (long)hour, (long)min, (long)sec];
    } else {
        self.statusLabel.text = [NSString stringWithFormat:@"剩余时长：%02ld:%02ld:%02ld", (long)hour, (long)min, (long)sec];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self activateButtonTapped];
    return YES;
}

@end


#pragma mark - AuthPlugin 入口类

@implementation AuthPlugin

+ (instancetype)sharedInstance {
    static AuthPlugin *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AuthPlugin alloc] init];
    });
    return instance;
}

// 获取当前最顶层的 ViewController
- (UIViewController *)getTopViewController {
    UIWindow *keyWindow = nil;
    if (@available(iOS 13.0, *)) {
        for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if ([scene isKindOfClass:[UIWindowScene class]] && scene.activationState == UISceneActivationStateForegroundActive) {
                UIWindowScene *windowScene = (UIWindowScene *)scene;
                for (UIWindow *window in windowScene.windows) {
                    if (window.isKeyWindow) {
                        keyWindow = window;
                        break;
                    }
                }
            }
        }
    }
    if (!keyWindow) keyWindow = [UIApplication sharedApplication].keyWindow;
    if (!keyWindow) keyWindow = [UIApplication sharedApplication].windows.firstObject;
    
    UIViewController *topVC = keyWindow.rootViewController;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

- (void)startAuthCheck {
    if (self.pollTimer) return; // 防止重复创建
    
    // 启动定时器，每 0.2 秒检测一次游戏主界面是否已经加载
    self.pollTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(pollForUI) userInfo:nil repeats:YES];
}

- (void)pollForUI {
    // 如果已经弹出了验证界面，直接停掉定时器
    if (currentAuthVC) {
        [self.pollTimer invalidate];
        self.pollTimer = nil;
        return;
    }
    
    UIViewController *topVC = [self getTopViewController];
    
    // 如果还没拿到游戏的根视图（引擎还在加载），继续等
    if (!topVC) return;
    
    // 如果当前顶层的已经是我们的验证界面（防御性判断）
    if ([topVC isKindOfClass:[AuthPluginViewController class]]) {
        [self.pollTimer invalidate];
        self.pollTimer = nil;
        return;
    }
    
    // 找到了游戏的界面，立刻停止轮询并盖上验证界面
    [self.pollTimer invalidate];
    self.pollTimer = nil;
    
    AuthPluginViewController *vc = [[AuthPluginViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    currentAuthVC = vc;
    
    [topVC presentViewController:vc animated:NO completion:nil];
}

@end

#pragma mark - 插件自动启动拦截

__attribute__((constructor))
static void auto_init_auth_plugin() {
    // 极早期在主线程延迟 0.1 秒，确保沙盒数据可读
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 1. 第一时间读取有效期
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSTimeInterval expireAt = [ud doubleForKey:@"YS_ExpireTime"];
        NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
        
        // ==========================================
        // 核心逻辑：如果在有效期内，直接静默返回！
        // 不创建任何界面，不启动任何定时器，绝对不干扰游戏！
        // ==========================================
        if (expireAt > now) {
            NSLog(@"[AuthPlugin] 验证通过，有效期内静默放行。");
            return; 
        }
        
        // 2. 未激活或过期，启动无感轮询，等待游戏主界面加载后立刻拦截
        NSLog(@"[AuthPlugin] 未激活或已过期，开始轮询等待游戏界面准备弹窗...");
        [[AuthPlugin sharedInstance] startAuthCheck];
    });
}
