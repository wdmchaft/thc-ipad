//
//  THCUIComponentsFactory.m
//  thc-ipad
//
//  Created by Vanger on 14.12.10.
//  Copyright 2010 Magic Ink. All rights reserved.
//

#import "THCUIComponentsFactory.h"
#import "THCUILabelWithElement.h"
#import "THCUITextViewWithElement.h"
#import "THCUITodo.h"
#import "THCUIImage.h"

@implementation THCUIComponentsFactory

@synthesize textViewDelegate;

+ (THCUIComponentsFactory *)newFactoryWithTextViewDelegate:(id<UITextViewDelegate>) textViewDelegate {
	THCUIComponentsFactory* factory = [THCUIComponentsFactory alloc];
	
	factory.textViewDelegate = textViewDelegate;
	
	return factory;
}

//TODO: reimplement this crap!
- (id<THCUIComponentWithElementProtocol>)addComponentToView:(UIView *)view withElement:(id<ElementInterface>)element {
	if ([element.type isEqualToString:kTypeLabel])
		return [THCUILabelWithElement addLabelToView:view withElement:element withDelegate:self.textViewDelegate];
		 
	if ([element.type isEqualToString:kTypeTextView])
		return [THCUITextViewWithElement addTextViewToView:view withElement:element withDelegate:self.textViewDelegate];

	if ([element.type isEqualToString:kTypeTodo])
		return [THCUITodo addTodoToView:view withElement:element withDelegate:self.textViewDelegate];

	if ([element.type isEqualToString:kTypeImage])
		return [THCUIImage addImageToView:view withElement:element];
	
	
	[NSException raise:@"Invalid argument" format:@"Unknown element.type '%@'", element.type];
	return NULL;
}

@end