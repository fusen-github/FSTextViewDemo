//
//  ViewController.m
//  FSTextViewDemo
//
//  Created by 四维图新 on 16/3/20.
//  Copyright © 2016年 四维图新. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITextViewDelegate>

@property (nonatomic, weak) UIToolbar *toolBar;

@property (nonatomic, assign) NSInteger lastLineCount;

@property (nonatomic, assign) CGFloat lastToolBarH;

@property (nonatomic, assign) CGFloat lastTextFieldH;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UITextView *textView = [[UITextView alloc] init];
    
    textView.layer.cornerRadius = 5;
    
    textView.layer.masksToBounds = YES;
    
    textView.delegate = self;
    
    // 要先设置 font 大小才能自适应的计算出textView默认高度
    textView.font = [UIFont systemFontOfSize:18];
    
    [textView sizeToFit];
    
    textView.backgroundColor = [UIColor whiteColor];
    
    
    UIToolbar *toolBar = [[UIToolbar alloc] init];
    
    self.toolBar = toolBar;
    
    toolBar.frame = CGRectMake(0, self.view.bounds.size.height - textView.bounds.size.height - 20, self.view.bounds.size.width, textView.bounds.size.height + 20);
    
    toolBar.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self.view addSubview:toolBar];
    
    
    textView.frame = CGRectMake(60, 10, toolBar.bounds.size.width - 120, textView.bounds.size.height);
    
    [toolBar addSubview:textView];
}

- (void)keyboardWillShow:(NSNotification *)noti
{
    CGRect endRect = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat keyboardH = endRect.size.height;
    
    NSTimeInterval time = [[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:time animations:^{
       
        self.toolBar.transform = CGAffineTransformMakeTranslation(0, -keyboardH);
    }];
    
}

- (void)keyboardWillHide:(NSNotification *)noti
{
    NSTimeInterval time = [[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:time animations:^{
        
        self.toolBar.transform = CGAffineTransformIdentity;
    }];
}


- (void)textViewDidChange:(UITextView *)textView
{
    self.lastTextFieldH = textView.bounds.size.height;
    
    self.lastToolBarH = self.toolBar.bounds.size.height;
    
    CGFloat toolBarY = self.toolBar.frame.origin.y;
    
    CGFloat height = textView.contentSize.height - textView.textContainerInset.top - textView.textContainerInset.bottom;
    
    NSInteger lineCount = round(height) / textView.font.lineHeight;
    
    if (lineCount != self.lastLineCount && lineCount >= 1)
    {
        if (lineCount == 1 && self.lastLineCount == 0)
        {
            return;
        }
        
        CGSize size = [textView.text sizeWithAttributes:@{NSFontAttributeName:textView.font}];
        
        CGFloat addHeight = lineCount > self.lastLineCount ? size.height : -size.height;
        
        self.toolBar.frame = CGRectMake(0, toolBarY - addHeight, self.view.bounds.size.width, self.lastToolBarH + addHeight);
        
        textView.frame = CGRectMake(60, 10, self.toolBar.bounds.size.width - 120, self.toolBar.bounds.size.height - 20);
    }
    
    self.lastLineCount = lineCount;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}



@end
