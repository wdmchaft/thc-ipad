//
//  THCTodoView.m
//  thc-ipad
//
//  Created by Vanger on 24.11.10.
//  Copyright 2010 Magic Ink. All rights reserved.
//

#import "THCUITodo.h"
#import "THCUIComponentsUtils.h"
#import "THCUILabel.h"

NSString * const kTypeTodo = @"todo";

@implementation THCUITodo

@synthesize checkbox;
@synthesize label;
@synthesize bottomLayer;

+ (THCUITodo *)createInView:(UIView *)aView withElement:(Element *)newElement {
	THCUITodo *todo = [[THCUITodo alloc] initWithFrame:CGRectMake(0, 0, kTextComponentWidth, 0)];
	[THCUIComponentsUtils setupLabel:todo.label];
	
	todo.element = newElement;
	
	[aView addSubview:todo];
	
	UIGestureRecognizer *convertToLabelGesture = [self newGestureForConvertingToLabel];
	[todo addGestureRecognizer:convertToLabelGesture];
	[convertToLabelGesture release];
	
	[todo release];
		
	return todo;
}

+ (UIGestureRecognizer *)newGestureForConvertingToLabel {
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(convertToLabel:)];
	tap.numberOfTapsRequired = 1;
	tap.numberOfTouchesRequired = 2;
	return tap;
}

+ (void)convertToLabel:(UITapGestureRecognizer *)gesture {
	if (gesture.state == UIGestureRecognizerStateRecognized) {
		THCUITodo *todo = (THCUITodo *)gesture.view;
		
		[THCUILabel createInView:todo.superview
					   withElement:todo.element];
		
		[todo removeFromSuperview];
	}
}

- (id)initWithFrame:(CGRect)frame {
	CGRect viewFrame = [THCUIComponentsUtils frameAroundRect:frame withBorder:kBorderWidth];
	
	[super initWithFrame:viewFrame];
	
	CGRect labelFrame = CGRectMake(0, 
								   0, 
								   frame.size.width, 
								   frame.size.height);
	self.label = [[UILabel alloc] initWithFrame:labelFrame];
	
	self.checkbox = [[UISwitch alloc] initWithFrame:CGRectMake(0, 
															   labelFrame.size.height, 
															   frame.size.width, 
															   0)];
	[self.checkbox setOn:NO animated:YES];
	
	[self.checkbox addTarget:self 
					  action:@selector(saveComponentStateToElement) 
			forControlEvents:UIControlEventValueChanged];
	
	self.bottomLayer = [[UIView alloc] initWithFrame:CGRectMake(kBorderWidth, 
															    kBorderWidth, 
															    frame.size.width, 
																labelFrame.size.height + self.checkbox.frame.size.height)];
	[self.bottomLayer addSubview:self.label];
	[self.bottomLayer addSubview:self.checkbox];
	[self addSubview:self.bottomLayer];
	
	return self;
}

- (CGFloat)x {
	return [THCUIComponentsUtils xOriginInSuperViewOfView:self.bottomLayer];
}

- (void)setX:(CGFloat)newX {
	[THCUIComponentsUtils changeXOriginOfView:self withNewX:newX ofSubview:self.bottomLayer];
}

- (CGFloat)y {
	return [THCUIComponentsUtils yOriginInSuperViewOfView:self.bottomLayer];
}

- (void)setY:(CGFloat)newY {
	[THCUIComponentsUtils changeYOriginOfView:self withNewY:newY ofSubview:self.bottomLayer];
}

- (NSString *)text {
	return self.label.text;
}

- (void)setText:(NSString *)newText {
	if ([self.label.text isEqualToString:newText]) {
		return;
	}
	
	self.label.text = newText;
	[THCUIComponentsUtils resizeLabel:self.label 
					withMinimalHeight:kMinimalLabelHeight
					 andMaximalHeight:kTextComponentHeightMax];
	
	CGRect newCheckboxRect = self.checkbox.frame;
	newCheckboxRect.origin.y = self.label.frame.origin.y + self.label.frame.size.height;
	self.checkbox.frame = newCheckboxRect;
	
	self.bottomLayer.frame = CGRectMake(self.bottomLayer.frame.origin.x, 
										self.bottomLayer.frame.origin.x, 
										self.bottomLayer.frame.size.width, 
										self.label.frame.size.height + self.checkbox.frame.size.height);
	self.frame = [THCUIComponentsUtils frameAroundRect:[THCUIComponentsUtils rectInSuperSuperViewOfView:self.bottomLayer] 
											withBorder:kBorderWidth]; 
}

- (BOOL)isChecked {
	return checkbox.on;
} 

- (void)setIsChecked:(BOOL)newState {
	checkbox.on = newState;
} 

- (void)setElement:(Element *)newElement {
	[super setElement:newElement];
	self.isChecked = ([newElement.isChecked intValue] != 0);
}

- (Element *)saveComponentStateToElement {
	self.element.isChecked = [NSNumber numberWithInt:self.isChecked];
	[super saveComponentStateToElement];
	return self.element;
}

- (NSString *)type {
	return kTypeTodo;
}

- (void)dealloc {
	[bottomLayer release];
	[checkbox release];
	[label release];
	[super dealloc];
}

@end
