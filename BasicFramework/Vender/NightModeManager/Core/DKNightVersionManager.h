

#import <UIKit/UIKit.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


typedef enum : NSUInteger {
    DKThemeVersionNormal,
    DKThemeVersionNight,
} DKThemeVersion;

extern NSString *const DKNightVersionNightFallingNotification;
extern NSString *const DKNightVersionDawnComingNotification;

extern CGFloat const DKNightVersionAnimationDuration;

@interface DKNightVersionManager : NSObject

/**
 *  Current ThemeVersion, default is DKThemeVersionNormal.
 *
 *  @return Current theme version, default is DKThemeVersionNormal. Readonly
 */
+ (DKThemeVersion)currentThemeVersion;

/**
 *  Night falling. When nightFalling is called, post DKNightVersionNightFallingNotification. You  can setup customize with observing the notification.
 */
+ (void)nightFalling;

/**
 *  Dawn coming. When dawnComing is called, post DKNightVersionDawnComingNotification. You  can setup customize with observing the notification.
 */
+ (void)dawnComing;

+ (void)changeColor:(id)object;

/**
 *  Use default night color or not, default is YES, set it use setUseDefaultNightColor: method
 *
 *  @return Use default night color or not, default is YES
 */
+ (BOOL)useDefaultNightColor;

/**
 *  Set whether or not use default night color
 *
 *  @param use Bool value to set whether to use default color
 */
+ (void)setUseDefaultNightColor:(BOOL)use;

@end

@interface DKNightVersionManager (RespondClasses)

/**
 *  Add Class to respond classes set to make class can change
 *  color when switch theme
 *
 *  @param klass Klass which are supposed to change color
 */
+ (void)addClassToSet:(Class)klass;

/**
 *  Remove Class from respond classes set to make class cannot change
 *  color when switch theme
 *
 *  @param klass Klass which are not supposed to change color
 */
+ (void)removeClassFromSet:(Class)klass;

/**
 *  All klasses will change color when switch themes
 *
 *  @return A bunch of string for class which will change color when switch theme
 */
+ (NSSet *)respondClasseses;

@end
