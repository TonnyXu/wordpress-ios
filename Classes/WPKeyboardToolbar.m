//
//  WPKeyboardToolbar.m
//  WordPress
//
//  Created by Jorge Bernal on 8/11/11.
//  Copyright 2011 WordPress. All rights reserved.
//

#import "WPKeyboardToolbar.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define CGColorFromRGB(rgbValue) UIColorFromRGB(rgbValue).CGColor
#define kStartColor UIColorFromRGB(0xb0b7c1)
#define kEndColor UIColorFromRGB(0x9199a4)
#define kStartColorIpad UIColorFromRGB(0xb7b6bf)
#define kEndColorIpad UIColorFromRGB(0x9d9ca7)

// Spacing between button groups
#define WPKT_BUTTON_SEPARATOR 6.0f
#define WPKT_BUTTON_HEIGHT_PORTRAIT 39.0f
#define WPKT_BUTTON_HEIGHT_LANDSCAPE 34.0f

@implementation WPKeyboardToolbar
@synthesize delegate;

- (void)dealloc
{
    [_gradient release];
    [mainView release];
    [extendedView release];
    [boldButton release];
    [italicsButton release];
    [linkButton release];
    [quoteButton release];
    [delButton release];
    [ulButton release];
    [olButton release];
    [liButton release];
    [codeButton release];
    [moreButton release];
    [doneButton release];
    [toggleButton release];
    [super dealloc];
}

- (CGRect)gradientFrame {
    CGRect rect = self.bounds;
    rect.origin.y += 2;
    rect.size.height -= 2;
    return rect;
}

- (void)drawTopBorder {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0f);
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    if (DeviceIsPad()) {
        CGContextSetStrokeColorWithColor(context, CGColorFromRGB(0x404040));
    } else {
        CGContextSetStrokeColorWithColor(context, CGColorFromRGB(0x52555b));        
    }
    CGContextMoveToPoint(context, self.bounds.origin.x, self.bounds.origin.y + 0.5f);
    CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.origin.y + 0.5f);
    CGContextStrokePath(context);
    if (DeviceIsPad()) {
        CGContextSetStrokeColorWithColor(context, CGColorFromRGB(0xd9d9d9));
    } else {
        CGContextSetStrokeColorWithColor(context, CGColorFromRGB(0xdbdfe4));
    }
    CGContextMoveToPoint(context, self.bounds.origin.x, self.bounds.origin.y + 1.5f);
    CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.origin.y + 1.5f);
    CGContextStrokePath(context);
    CGColorSpaceRelease(colorspace);
}

- (void)drawRect:(CGRect)rect {
    [self drawTopBorder];
}

- (void)buttonAction:(WPKeyboardToolbarButtonItem *)sender {
    WPFLogMethod();
    [[UIDevice currentDevice] playInputClick];
    if (self.delegate) {
        [self.delegate keyboardToolbarButtonItemPressed:sender];
    }
}

- (void)buildMainButtons {
    CGFloat x = 4.0f;
    if (boldButton == nil) {
        boldButton = [WPKeyboardToolbarButtonItem button];
        boldButton.frame = CGRectMake(x, 0, 28, WPKT_BUTTON_HEIGHT_PORTRAIT);
        x += boldButton.frame.size.width + 4;
        boldButton.actionTag = @"strong";
        boldButton.actionName = NSLocalizedString(@"bold", @"");
		[boldButton setImage:[UIImage imageNamed:@"toolbarBold"] forState:UIControlStateNormal];
		[boldButton setImage:[UIImage imageNamed:@"toolbarBoldHighlighted"] forState:UIControlStateHighlighted];
        [boldButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (italicsButton == nil) {
        italicsButton = [WPKeyboardToolbarButtonItem button];
        italicsButton.frame = CGRectMake(x, 0, 28, WPKT_BUTTON_HEIGHT_PORTRAIT);
        x += italicsButton.frame.size.width + 4;
        italicsButton.actionTag = @"em";
        italicsButton.actionName = NSLocalizedString(@"italic", @"");
		[italicsButton setImage:[UIImage imageNamed:@"toolbarItalic"] forState:UIControlStateNormal];
		[italicsButton setImage:[UIImage imageNamed:@"toolbarItalicHighlighted"] forState:UIControlStateHighlighted];
        [italicsButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (linkButton == nil) {
        linkButton = [WPKeyboardToolbarButtonItem button];
        linkButton.frame = CGRectMake(x, 0, 36, WPKT_BUTTON_HEIGHT_PORTRAIT);
        x += linkButton.frame.size.width + 4;
        linkButton.actionTag = @"link";
        linkButton.actionName = NSLocalizedString(@"link", @"");
		[linkButton setImage:[UIImage imageNamed:@"toolbarLink"] forState:UIControlStateNormal];
		[linkButton setImage:[UIImage imageNamed:@"toolbarLinkHighlighted"] forState:UIControlStateHighlighted];
        [linkButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (quoteButton == nil) {
        quoteButton = [WPKeyboardToolbarButtonItem button];
        quoteButton.frame = CGRectMake(x, 0, 52, WPKT_BUTTON_HEIGHT_PORTRAIT);
		x += quoteButton.frame.size.width + 4;
        quoteButton.actionTag = @"blockquote";
        quoteButton.actionName = NSLocalizedString(@"quote", @"");
		[quoteButton setImage:[UIImage imageNamed:@"toolbarBlockquote"] forState:UIControlStateNormal];
		[quoteButton setImage:[UIImage imageNamed:@"toolbarBlockquoteHighlighted"] forState:UIControlStateHighlighted];
        [quoteButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (delButton == nil) {
        delButton = [WPKeyboardToolbarButtonItem button];
        delButton.frame = CGRectMake(x, 0, 35, WPKT_BUTTON_HEIGHT_PORTRAIT);
        x += delButton.frame.size.width + 4;
        delButton.actionTag = @"del";
        delButton.actionName = NSLocalizedString(@"del", @"");
		[delButton setImage:[UIImage imageNamed:@"toolbarDel"] forState:UIControlStateNormal];
		[delButton setImage:[UIImage imageNamed:@"toolbarDelHighlighted"] forState:UIControlStateHighlighted];
        [delButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)buildExtendedButtons {
    CGFloat x = 4.0f;
    if (ulButton == nil) {
        ulButton = [WPKeyboardToolbarButtonItem button];
        ulButton.frame = CGRectMake(x, 0, 28, WPKT_BUTTON_HEIGHT_PORTRAIT);
        x += ulButton.frame.size.width + 4;
        ulButton.actionTag = @"ul";
        ulButton.actionName = NSLocalizedString(@"unordered list", @"");
		[ulButton setImage:[UIImage imageNamed:@"toolbarUl"] forState:UIControlStateNormal];
		[ulButton setImage:[UIImage imageNamed:@"toolbarUlHighlighted"] forState:UIControlStateHighlighted];
        [ulButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (olButton == nil) {
        olButton = [WPKeyboardToolbarButtonItem button];
        olButton.frame = CGRectMake(x, 0, 28, WPKT_BUTTON_HEIGHT_PORTRAIT);
        x += olButton.frame.size.width + 4;
        olButton.actionTag = @"ol";
        olButton.actionName = NSLocalizedString(@"ordered list", @"");
		[olButton setImage:[UIImage imageNamed:@"toolbarOl"] forState:UIControlStateNormal];
		[olButton setImage:[UIImage imageNamed:@"toolbarOlHighlighted"] forState:UIControlStateHighlighted];
        [olButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (liButton == nil) {
        liButton = [WPKeyboardToolbarButtonItem button];
        liButton.frame = CGRectMake(x, 0, 28, WPKT_BUTTON_HEIGHT_PORTRAIT);
        x += liButton.frame.size.width + 4;
        liButton.actionTag = @"li";
        liButton.actionName = NSLocalizedString(@"list item", @"");
		[liButton setImage:[UIImage imageNamed:@"toolbarLi"] forState:UIControlStateNormal];
		[liButton setImage:[UIImage imageNamed:@"toolbarLiHighlighted"] forState:UIControlStateHighlighted];
        [liButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (codeButton == nil) {
        codeButton = [WPKeyboardToolbarButtonItem button];
        codeButton.frame = CGRectMake(x, 0, 47, WPKT_BUTTON_HEIGHT_PORTRAIT);
        x += codeButton.frame.size.width + 4;
        codeButton.actionTag = @"code";
        codeButton.actionName = NSLocalizedString(@"code", @"");
		[codeButton setImage:[UIImage imageNamed:@"toolbarCode"] forState:UIControlStateNormal];
		[codeButton setImage:[UIImage imageNamed:@"toolbarCodeHighlighted"] forState:UIControlStateHighlighted];
        [codeButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (moreButton == nil) {
        moreButton = [WPKeyboardToolbarButtonItem button];
        moreButton.frame = CGRectMake(x, 0, 48, WPKT_BUTTON_HEIGHT_PORTRAIT);
        x += moreButton.frame.size.width + 4;
        moreButton.actionTag = @"more";
        moreButton.actionName = NSLocalizedString(@"more", @"");
		[moreButton setImage:[UIImage imageNamed:@"toolbarMore"] forState:UIControlStateNormal];
		[moreButton setImage:[UIImage imageNamed:@"toolbarMoreHighlighted"] forState:UIControlStateHighlighted];
        [moreButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)buildMainView {
    if (mainView == nil) {
        mainView = [[UIView alloc] init];
        [self buildMainButtons];
        CGFloat mainWidth = delButton.frame.origin.x + delButton.frame.size.width;
        mainView.frame = CGRectMake(0, 0, mainWidth, WPKT_BUTTON_HEIGHT_PORTRAIT);
        mainView.autoresizesSubviews = YES;

        [mainView addSubview:boldButton];
        [mainView addSubview:italicsButton];
        [mainView addSubview:linkButton];
        [mainView addSubview:quoteButton];
        [mainView addSubview:delButton];
    }
}

- (void)buildExtendedView {
    if (extendedView == nil) {
        extendedView = [[UIView alloc] init];
        [self buildExtendedButtons];
        CGFloat extendedWidth = moreButton.frame.origin.x + moreButton.frame.size.width;
        extendedView.frame = CGRectMake(0, 0, extendedWidth, WPKT_BUTTON_HEIGHT_PORTRAIT);
        [extendedView addSubview:ulButton];
        [extendedView addSubview:olButton];
        [extendedView addSubview:liButton];
        [extendedView addSubview:codeButton];
        [extendedView addSubview:moreButton];
    }
}

- (void)toggleExtendedView {
	WPFLogMethod();
	if (!toggleButton.selected == true) {
		[toggleButton setBackgroundImage:[UIImage imageNamed:@"toggleButtonExtended"] forState:UIControlStateNormal];
	}
	else {
		[toggleButton setBackgroundImage:[UIImage imageNamed:@"toggleButtonMain"] forState:UIControlStateNormal];
	}

    toggleButton.selected = !toggleButton.selected;
    [self setNeedsLayout];
}

- (void)buildToggleButton {
    if (toggleButton == nil) {
        toggleButton = [WPKeyboardToolbarButtonItem button];
        toggleButton.frame = CGRectMake(2, 2, 39, 39);
        toggleButton.adjustsImageWhenHighlighted = NO;
        [toggleButton addTarget:self action:@selector(toggleExtendedView) forControlEvents:UIControlEventTouchUpInside || UIControlEventTouchUpOutside];
		[toggleButton setBackgroundImage:[UIImage imageNamed:@"toggleButtonMain"] forState:UIControlStateNormal];
		//[toggleButton setBackgroundImage:[UIImage imageNamed:@"doneButton"] forState:UIControlStateHighlighted];
		[toggleButton setBackgroundImage:[UIImage imageNamed:@"toggleButtonExtended"] forState:UIControlStateSelected];
		[toggleButton setBackgroundImage:[UIImage imageNamed:@"toggleButtonMain"] forState:UIControlStateSelected || UIControlStateHighlighted];
		[toggleButton retain];
    }    
}

- (void)setupDoneButton {
    if (doneButton == nil) {
        doneButton = [WPKeyboardToolbarButtonItem button];
        doneButton.frame = CGRectMake(4, 2, 50, 39);
        [doneButton setTitle:@"Done" forState:UIControlStateNormal];
		doneButton.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
		doneButton.titleLabel.shadowColor = [UIColor darkGrayColor];
		doneButton.titleLabel.shadowOffset = CGSizeMake(0, -1.0);
		doneButton.titleLabel.textAlignment = UITextAlignmentCenter;
		//doneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		doneButton.contentEdgeInsets = UIEdgeInsetsMake(1, 1, 0, 0); // Needed to make the label align
        doneButton.actionTag = @"done";
        [doneButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
		[doneButton setBackgroundImage:[[UIImage imageNamed:@"doneButton"] stretchableImageWithLeftCapWidth:6.0f topCapHeight:0.0f] forState:UIControlStateNormal];
		[doneButton setBackgroundImage:[[UIImage imageNamed:@"doneButtonHighlighted"] stretchableImageWithLeftCapWidth:6.0f topCapHeight:0.0f] forState:UIControlStateHighlighted];
        [self addSubview:doneButton];
    }
}

- (void)setupView {
    self.backgroundColor = UIColorFromRGB(0xb0b7c1);
    _gradient = [CAGradientLayer layer];
    _gradient.frame = [self gradientFrame];
    if (DeviceIsPad()) {
        _gradient.colors = [NSArray arrayWithObjects:(id)kStartColorIpad.CGColor, (id)kEndColorIpad.CGColor, nil];
    } else {
        _gradient.colors = [NSArray arrayWithObjects:(id)kStartColor.CGColor, (id)kEndColor.CGColor, nil];
    }
    [self.layer insertSublayer:_gradient atIndex:0];
    [_gradient retain];
    
    [self buildMainView];
    [self buildExtendedView];
    [self buildToggleButton];
    [self setupDoneButton];
}

- (void)layoutSubviews {
    _gradient.frame = [self gradientFrame];
    
    CGRect doneFrame = doneButton.frame;
    doneFrame.origin.x = self.frame.size.width - doneFrame.size.width - 5;
    if (self.frame.size.height < WPKT_HEIGHT_IPHONE_PORTRAIT) {
        doneFrame.origin.y = -1;
		doneFrame.origin.x = self.frame.size.width - doneFrame.size.width - 3;
        doneFrame.size.height = WPKT_BUTTON_HEIGHT_LANDSCAPE + 2;
    } else {
        doneFrame.origin.y = 2;
		doneFrame.origin.x = self.frame.size.width - doneFrame.size.width - 5;
        doneFrame.size.height = WPKT_BUTTON_HEIGHT_PORTRAIT;
    }
    doneButton.frame = doneFrame;
    
    CGRect toggleFrame = toggleButton.frame;
    toggleFrame.size.height = WPKT_BUTTON_HEIGHT_PORTRAIT;
    toggleButton.frame = toggleFrame;
    
    if (self.frame.size.width <= 320.0f) {
        // iPhone portrait
        
        // Add toggle button
        if (toggleButton.superview == nil) {
            [self addSubview:toggleButton];
        }

        if (toggleButton.selected) {
            // Remove main view
            if (mainView.superview != nil) {
                [mainView removeFromSuperview];
            }
            
            // Show extended view
            CGRect frame = extendedView.frame;
            frame.origin.x = toggleButton.frame.origin.x + toggleButton.frame.size.width + 3;
            frame.origin.y = 2;
            frame.size.height = WPKT_BUTTON_HEIGHT_PORTRAIT;
            extendedView.frame = frame;
            if (extendedView.superview == nil) {
                [self addSubview:extendedView];
            }
        } else {
            // Remove extended view
            if (extendedView.superview != nil) {
                [extendedView removeFromSuperview];
            }
            
            // Show main view
            CGRect frame = mainView.frame;
            frame.origin.x = toggleButton.frame.origin.x + toggleButton.frame.size.width + 3;
            frame.origin.y = 2;
            frame.size.height = WPKT_BUTTON_HEIGHT_PORTRAIT;
            mainView.frame = frame;
            if (mainView.superview == nil) {
                [self addSubview:mainView];            
            }            
        }
    } else {
        // iPhone Landscape or iPad

        // Remove toggle button
        if (toggleButton.superview != nil) {
            [toggleButton removeFromSuperview];
        }
		
        // Show main view
        CGRect frame = mainView.frame;
        frame.origin.x = -1;
        if (self.frame.size.height < WPKT_HEIGHT_IPHONE_PORTRAIT) {
            frame.origin.y = -1;
            frame.size.height = WPKT_BUTTON_HEIGHT_LANDSCAPE;
        }
        mainView.frame = frame;
        if (mainView.superview == nil) {
            [self addSubview:mainView];
        }
        
        frame = extendedView.frame;
        frame.origin.x = mainView.frame.origin.x + mainView.frame.size.width;
        if (self.frame.size.height < WPKT_HEIGHT_IPHONE_PORTRAIT) {
            frame.origin.y = -1;
            frame.size.height = WPKT_BUTTON_HEIGHT_LANDSCAPE;
        }
        extendedView.frame = frame;
        if (extendedView.superview == nil) {
            [self addSubview:extendedView];
        }
    }
}

- (id)init {
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
    }
    return self;
}

#pragma mark - UIInputViewAudioFeedback

- (BOOL) enableInputClicksWhenVisible {
    return YES;
}

@end
