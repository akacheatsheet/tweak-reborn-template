#import <UIKit/UIKit.h>
#include <alert.h>
#include <aslr.h>
#include <log.h>
#include <string>
#include <substrate.h>

// ファイルにスコアを書き込む関数
__attribute__((noinline)) void log_score(int score) {
    writeLogToFile("/tmp/log.txt",
                   "reset score: " + std::to_string(score));
}

// 0x100008884の元の機能を持つ関数
void (*orig_reset_score)(int);

// 0x100008884の関数をhookした関数
void reset_score(int score) {
    // リセット時のスコアをログに書き込む
    log_score(score);

    // 9999でリセットする
    orig_reset_score(9999);
}

static void didFinishLaunching(CFNotificationCenterRef center, void *observer,
                               CFStringRef name, const void *object,
                               CFDictionaryRef userInfo) {
    // アプリのASLRを取得する
    static const uintptr_t slide = get_address(nullptr, 0x0);

    // ログにアプリのASLRを書き込む
    writeLogToFile("/tmp/log.txt", "slide: " + uintptrToHex(slide));

    // 0x100008884の関数をhookする、いわゆる関数フック
    MSHookFunction((void *)(0x100008884 + slide), (void *)reset_score,
                   (void **)&orig_reset_score);

    // 0x100008B68の値を0x00A10F91に書き換える、いわゆるOffset Patch
    uint32_t newValue = __builtin_bswap32(0x00A10F91);
    MSHookMemory((void *)(0x100008B68 + slide), &newValue, sizeof(newValue));

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                     // 3秒後に実行する処理
                     alert(@"Hello", @"World");
                   });
}

// アプリ起動時に実行される関数
__attribute__((constructor)) static void initializer() {
    CFNotificationCenterAddObserver(
        CFNotificationCenterGetLocalCenter(), NULL, &didFinishLaunching,
        (CFStringRef)UIApplicationDidFinishLaunchingNotification, NULL,
        CFNotificationSuspensionBehaviorDeliverImmediately);
}

// %hook ClassName

// - (void)messageName:(int)argument {
//  %log;
//  %orig;
// }

// %end