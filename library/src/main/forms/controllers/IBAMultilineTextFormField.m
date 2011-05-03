//
// Copyright 2010 Itty Bitty Apps Pty Ltd
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this
// file except in compliance with the License. You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software distributed under
// the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
// ANY KIND, either express or implied. See the License for the specific language governing
// permissions and limitations under the License.
//

#import "IBAMultilineTextFormField.h"
#import "IBAFormConstants.h"
#import "IBAMultilineTextFormFieldCell.h"
#import "IBAInputCommon.h"


static NSString *kZeroSpaceString = @"\xE2\x80\x8B";

@interface IBAMultilineTextFormField ()
- (void)resizeFormField;
@end


@implementation IBAMultilineTextFormField

@synthesize multilineTextFormFieldCell = multilineTextFormFieldCell_;

- (void)dealloc {
	multilineTextFormFieldCell_.textView.delegate = nil;
	IBA_RELEASE_SAFELY(multilineTextFormFieldCell_);

	[super dealloc];
}


#pragma mark -
#pragma mark Cell management

- (IBAFormFieldCell *)cell {
	return [self multilineTextFormFieldCell];
}

- (IBAMultilineTextFormFieldCell *)multilineTextFormFieldCell {
	if (multilineTextFormFieldCell_ == nil) {
		multilineTextFormFieldCell_ = [[IBAMultilineTextFormFieldCell alloc] initWithFormFieldStyle:self.formFieldStyle 
																					reuseIdentifier:@"IBAMultilineTextFormFieldCell"];
		multilineTextFormFieldCell_.textView.delegate = self;
		multilineTextFormFieldCell_.textView.userInteractionEnabled = NO;
	}

	return multilineTextFormFieldCell_;
}

- (void)updateCellContents {
	self.multilineTextFormFieldCell.label.text = self.title;
	self.multilineTextFormFieldCell.textView.text = [self formFieldStringValue];
}


#pragma mark -
#pragma mark IBAInputRequestor

- (NSString *)dataType {
	return IBAInputDataTypeText;
}

- (void)activate {  
//	self.multilineTextFormFieldCell.textView.backgroundColor = [UIColor clearColor];
	self.multilineTextFormFieldCell.textView.userInteractionEnabled = YES;

	[super activate];
}

- (BOOL)deactivate {
	BOOL deactivated = [self setFormFieldValue:self.multilineTextFormFieldCell.textView.text];
	if (deactivated) {
		self.multilineTextFormFieldCell.textView.userInteractionEnabled = NO;
		deactivated = [super deactivate];
	}

	return deactivated;
}

- (UIResponder *)responder {
	return self.multilineTextFormFieldCell.textView;
}


#pragma mark -
#pragma mark Getting and setting the form field value
//- (id)formFieldValue {
//	NSString *text = [super formFieldValue];
//	text = (text == nil) ? kZeroSpaceString : text;
//	if (![text hasPrefix:kZeroSpaceString]) {
//		text = [kZeroSpaceString stringByAppendingString:text];
//	}
//	
//	return text;
//}
//
//- (BOOL)setFormFieldValue:(id)formVieldValue {
//	NSString *text = formVieldValue;
//	if ([text hasPrefix:kZeroSpaceString]) {
//		text = [text substringFromIndex:1];
//	}
//	
//	return [super setFormFieldValue:text];
//}

#pragma mark -
#pragma mark UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
	[self resizeFormField];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
	[self resizeFormField];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
	[self resizeFormField];
}

- (void)resizeFormField {
	[[self cell] sizeToFit];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:IBAFormFieldResized object:self userInfo:nil];
}

@end
