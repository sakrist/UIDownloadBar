//
//  UIDownloadBar.h
//  UIDownloadBar
//
//  Created by SAKrisT on 7/8/10.
//  Copyright 2010 www.developers-life.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class UIProgressView;
@protocol UIDownloadBarDelegate;

@interface UIDownloadBar : UIProgressView

- (UIDownloadBar *) initWithURL:(NSURL *)fileURL
                         frame:(CGRect)frame
                       timeout:(NSInteger)timeout
                      delegate:(id<UIDownloadBarDelegate>)theDelegate;

@property (nonatomic, readonly) NSMutableData* receivedData;
@property (nonatomic, readonly, retain) NSURLRequest* downloadRequest;
@property (nonatomic, readonly, retain) NSURLConnection* downloadConnection;
@property (nonatomic, assign) id<UIDownloadBarDelegate> delegate;

@property (nonatomic, readonly) float percentComplete;
@property (nonatomic, retain) NSString *possibleFilename;

- (void) startDownload;

- (void) forceStop;

- (void) forceContinue;

@end


@protocol UIDownloadBarDelegate <NSObject>

@optional
- (void) downloadBar:(UIDownloadBar *)downloadBar didFinishWithData:(NSData *)fileData suggestedFilename:(NSString *)filename;
- (void) downloadBar:(UIDownloadBar *)downloadBar didFailWithError:(NSError *)error;
- (void) downloadBarUpdated:(UIDownloadBar *)downloadBar;

@end
