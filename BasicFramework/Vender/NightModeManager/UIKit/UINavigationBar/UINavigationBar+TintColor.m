


#import "UINavigationBar+TintColor.h"
#import "DKNightVersionManager.h"
#import "objc/runtime.h"

@interface UINavigationBar ()

@property (nonatomic, strong) UIColor *normalTintColor;

@end

@implementation UINavigationBar (TintColor)

+ (void)load {
    static dispatch_once_t onceToken;                                              
    dispatch_once(&onceToken, ^{                                                   
        Class class = [self class];                                                
        SEL originalSelector = @selector(setTintColor:);                                  
        SEL swizzledSelector = @selector(hook_setTintColor:);                                 
        Method originalMethod = class_getInstanceMethod(class, originalSelector);  
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);  
        BOOL didAddMethod =                                                        
        class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));                   
        if (didAddMethod){
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));           
        } else {                                                                   
            method_exchangeImplementations(originalMethod, swizzledMethod);        
        }
    });
    [DKNightVersionManager addClassToSet:self.class];
}

- (void)hook_setTintColor:(UIColor*)tintColor {
    if ([DKNightVersionManager currentThemeVersion] == DKThemeVersionNormal) [self setNormalTintColor:tintColor];
    [self hook_setTintColor:tintColor];
}

- (UIColor *)nightTintColor {
    UIColor *nightColor = objc_getAssociatedObject(self, @selector(nightTintColor));
    if (nightColor) {
        return nightColor;
    } else if ([DKNightVersionManager useDefaultNightColor] && self.defaultNightTintColor) {
        return self.defaultNightTintColor;
    } else {
        UIColor *resultColor = self.normalTintColor ?: [UIColor whiteColor];
        return resultColor;
    }
}

- (void)setNightTintColor:(UIColor *)nightTintColor {
    if ([DKNightVersionManager currentThemeVersion] == DKThemeVersionNight) [self setTintColor:nightTintColor];
    objc_setAssociatedObject(self, @selector(nightTintColor), nightTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)normalTintColor {
    return objc_getAssociatedObject(self, @selector(normalTintColor));
}

- (void)setNormalTintColor:(UIColor *)normalTintColor {
    objc_setAssociatedObject(self, @selector(normalTintColor), normalTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)defaultNightTintColor {
    return [self isMemberOfClass:[UINavigationBar class]] ? UIColorFromRGB(0xffffff) : nil;
}

@end
