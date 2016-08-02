/*
  ViewLayer.m

  Created by coder4869 on 8/2/16.
  Copyright © 2016 coder4869. All rights reserved.
*/

#import "ViewLayer.h"

@implementation SubView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        printf("View init finish\n");
    }
    return self;
}

+ (Class)layerClass
{
    printf("Create View Layer\n");
    return [SubLayer class];
}
- (void)setFrame:(CGRect)frame
{
    printf("Set View Frame\n");
    [super setFrame:frame];
}
- (void)setCenter:(CGPoint)center
{
    printf("Set View Center\n");
    [super setCenter:center];
}
- (void)setBounds:(CGRect)bounds
{
    printf("Set View Bounds\n");
    [super setBounds:bounds];
}


-(void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    printf("View drawRect\n");
}

@end



@implementation SubLayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        printf("Layer init\n");
    }
    return self;
}

+ (Class)layerClass
{
    printf("Create Layer Class\n");
    return [SubLayer class];
}

- (void)setFrame:(CGRect)frame
{
    printf("Set Layer Frame\n");
    [super setFrame:frame];
}
- (void)setPosition:(CGPoint)position
{
    printf("Set Layer Position\n");
    NSLog(@"position=%@",NSStringFromCGPoint(position));
    [super setPosition:position];
}
- (void)setBounds:(CGRect)bounds
{
    printf("Set Layer Bounds\n");
    [super setBounds:bounds];
}

-(void)display {
    [super display];
    printf("Layer display\n");
}

@end
