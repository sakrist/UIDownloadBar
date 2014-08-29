//
//  UIDownloadBar.m
//  UIDownloadBar
//
//  Created by SAKrisT on 7/8/10.
//  Copyright 2010 www.developers-life.com. All rights reserved.
//

#import "UIDownloadBar.h"

@interface UIDownloadBar () {
    NSString			*localFilename;
	NSURL				*downloadUrl;
	float				bytesReceived;
	long long			expectedBytes;
	
	BOOL				operationFinished, operationFailed, operationBreaked;

	FILE				*downFile;
    
    NSInteger           _timeOut;
}

@end

@implementation UIDownloadBar


- (void) forceStop {
	operationBreaked = YES;
}

- (void) forceContinue {
	operationBreaked = NO;
	
//	NSLog(@"%f",bytesReceived);
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: downloadUrl];
	
	[request addValue: [NSString stringWithFormat: @"bytes=%.0f-", bytesReceived ] forHTTPHeaderField: @"Range"];	
	
	_downloadConnection = [NSURLConnection connectionWithRequest:request
												  delegate: self];	
}


- (UIDownloadBar *)initWithURL:(NSURL *)fileURL
                         frame:(CGRect)frame
                       timeout:(NSInteger)timeout
                      delegate:(id<UIDownloadBarDelegate>)theDelegate {
	self = [super initWithFrame:frame];
	if(self) {
		self.delegate = theDelegate;
        _timeOut = timeout;
		downloadUrl = fileURL;
		bytesReceived = _percentComplete = 0;
		localFilename = [[[fileURL absoluteString] lastPathComponent] copy];
		_receivedData = [[NSMutableData alloc] initWithLength:0];
		self.progress = 0.0;
		self.backgroundColor = [UIColor clearColor];
        
    }
	
	return self;
}


- (void) startDownload {
    _downloadRequest = [[NSURLRequest alloc] initWithURL:downloadUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:_timeOut];
    _downloadConnection = [[NSURLConnection alloc] initWithRequest:_downloadRequest delegate:self startImmediately:YES];
    
    if(_downloadConnection == nil) {
        if ([self.delegate respondsToSelector:@selector(downloadBar:didFailWithError:)]) {
            NSError *error = [NSError errorWithDomain:@"UIDownloadBar Error" code:1 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"NSURLConnection Failed", NSLocalizedDescriptionKey, nil]];
            [self.delegate downloadBar:self didFailWithError:error];
        }
    }
}


- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {

	if (!operationBreaked) {
			
		[self.receivedData appendData:data];
		
		float receivedLen = [data length];
		bytesReceived = (bytesReceived + receivedLen);
		
		if(expectedBytes != NSURLResponseUnknownLength) {
			self.progress = ((bytesReceived/(float)expectedBytes)*100)/100;
			_percentComplete = self.progress*100;
		}
			//NSLog(@" Data receiving... Percent complete: %f", percentComplete);
		
        if ([_delegate respondsToSelector:@selector(downloadBarUpdated:)]) {
            [_delegate downloadBarUpdated:self];
        }
	
	} else {
		[connection cancel];
		NSLog(@" STOP !!!!  Receiving data was stoped");
	}
		
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(downloadBar:didFailWithError:)]) {
        [self.delegate downloadBar:self didFailWithError:error];
    }
	operationFailed = YES;
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	
	NSLog(@"[DO::didReceiveData] %d operation", (int)self);
	NSLog(@"[DO::didReceiveData] ddb: %.2f, wdb: %.2f, ratio: %.2f", 
		  (float)bytesReceived, 
		  (float)expectedBytes,
		  (float)bytesReceived / (float)expectedBytes);
	
	NSHTTPURLResponse *r = (NSHTTPURLResponse*) response;
	NSDictionary *headers = [r allHeaderFields];
	NSLog(@"[DO::didReceiveResponse] response headers: %@", headers);
	if (headers){
		if ([headers objectForKey: @"Content-Range"]) {
			NSString *contentRange = [headers objectForKey: @"Content-Range"];
			NSLog(@"Content-Range: %@", contentRange);
			NSRange range = [contentRange rangeOfString: @"/"];
			NSString *totalBytesCount = [contentRange substringFromIndex: range.location + 1];
			expectedBytes = [totalBytesCount floatValue];
		} else if ([headers objectForKey: @"Content-Length"]) {
			NSLog(@"Content-Length: %@", [headers objectForKey: @"Content-Length"]);
			expectedBytes = [[headers objectForKey: @"Content-Length"] floatValue];
		} else expectedBytes = -1;
		
		if ([@"Identity" isEqualToString: [headers objectForKey: @"Transfer-Encoding"]]) {
			expectedBytes = bytesReceived;
			operationFinished = YES;
		}
	}		
}


- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    if ([self.delegate respondsToSelector:@selector(downloadBar:didFinishWithData:suggestedFilename:)]) {
        	[self.delegate downloadBar:self didFinishWithData:self.receivedData suggestedFilename:localFilename];
    }
	operationFinished = YES;
}


- (void) dealloc {
    [_downloadConnection cancel];
}

@end
