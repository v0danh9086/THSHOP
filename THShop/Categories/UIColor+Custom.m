//
//  UIColor+Custom.h
//  ShootStudio
//
//  Created by Tom Fewster on 30/09/2011.
//  Copyright (c) 2011 Tom Fewster. All rights reserved.
//

#import "UIColor+Custom.h"

@implementation UIColor (Custom)

+ (UIColor *)blueTextColor {
	return [UIColor colorWithRed:0.243 green:0.306 blue:0.435 alpha:1.0];
}

+ (UIColor *)appBobyTextColor
{
    return [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.5 alpha:1];
}

+ (UIColor *)appBackgroundGreyColor
{
    return [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.5 alpha:1];
}

+ (UIColor *)titleColor
{
    return [UIColor colorWithRed:98/255.0 green:127/255.0 blue:154/255.5 alpha:1];
}

+ (UIColor *)headerMenuColor{
    return [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.5 alpha:1];
}

@end
