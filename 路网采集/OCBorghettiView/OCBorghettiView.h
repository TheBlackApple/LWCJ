#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class OCBorghettiView;

#pragma mark -
#pragma mark OCBorghettiViewDelegate

@protocol OCBorghettiViewDelegate <NSObject>

@optional

- (void)accordion:(OCBorghettiView *)accordion
 didSelectSection:(UIView *)view
        withTitle:(NSString *)title;

@end

#pragma mark -
#pragma mark OCBorghettiView Class

@interface OCBorghettiView : UIView

- (void)addSectionWithTitle:(NSString *)sectionTitle andView:(id)sectionView andImage:(NSString *)imgStr andName:(NSString *)nameStr andStake:(NSString *)stakeStr andHuman:(NSString *)humanStr andDate:(NSString *)dateStr andStakeEnd:(NSString *)stakeEndStr andContent:(NSString *)contentStr;

@property (nonatomic, assign) NSInteger accordionSectionHeight;
@property (nonatomic, strong) UIFont *accordionSectionFont;
@property (nonatomic, strong) UIColor *accordionSectionTitleColor;
@property (nonatomic, strong) UIColor *accordionSectionColor;
@property (nonatomic, strong) UIColor *accordionSectionBorderColor;
@property (nonatomic, assign) id <OCBorghettiViewDelegate> delegate;

@end