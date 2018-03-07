

#import "UINavigationBar+BarTintColor.h"
#import "DKNightVersionManager.h"
#import "objc/runtime.h"

@interface UINavigationBar ()

@property (nonatomic, strong) UIColor *normalBarTintColor;

@end

@implementation UINavigationBar (BarTintColor)

+ (void)load {
    static dispatch_once_t onceToken;                                              
    dispatch_once(&onceToken, ^{                                                   
        Class class = [self class];                                                
        SEL originalSelector = @selector(setBarTintColor:);                                  
        SEL swizzledSelector = @selector(hook_setBarTintColor:);                                 
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

- (void)hook_setBarTintColor:(UIColor*)barTintColor {
    if ([DKNightVersionManager currentThemeVersion] == DKThemeVersionNormal) [self setNormalBarTintColor:barTintColor];
    [self hook_setBarTintColor:barTintColor];
}

- (UIColor *)nightBarTintColor {
    UIColor *nightColor = objc_getAssociatedObject(self, @selector(nightBarTintColor));
    if (nightColor) {
        return nightColor;
    } else if ([DKNightVersionManager useDefaultNightColor] && self.defaultNightBarTintColor) {
        return self.defaultNightBarTintColor;
    } else {
        UIColor *resultColor = self.normalBarTintColor ?: [UIColor clearColor];
        return resultColor;
    }
}

- (void)setNightBarTintColor:(UIColor *)nightBarTintColor {
    if ([DKNightVersionManager currentThemeVersion] == DKThemeVersionNight) [self setBarTintColor:nightBarTintColor];
    objc_setAssociatedObject(self, @selector(nightBarTintColor), nightBarTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)normalBarTintColor {
    return objc_getAssociatedObject(self, @selector(normalBarTintColor));
}

- (void)setNormalBarTintColor:(UIColor *)normalBarTintColor {
    objc_setAssociatedObject(self, @selector(normalBarTintColor), normalBarTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)defaultNightBarTintColor {
    return [self isMemberOfClass:[UINavigationBar class]] ? UIColorFromRGB(0x444444) : nil;
}

@end
