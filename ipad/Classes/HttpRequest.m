
#import "HttpRequest.h"

@interface HttpRequest()
- (NSString *) createPostParameterData;
@end

@implementation HttpRequest

- (id) initForGet:(NSString *)url {
	if (self = [super init]) {
		requestUrl = url;
		[requestUrl retain];

		requestMethod = @"GET";
		[requestMethod retain];
	}
	return self;
}

- (id) initForPost:(NSString *)url withParameters:(NSDictionary *) parameters {
	if (self = [super init]) {
		requestUrl = url;
		[requestUrl retain];

		postParameters = parameters;
		[postParameters retain];

		requestMethod = @"POST";
		[requestMethod retain];
	}
	return self;
}

- (NSData *) performForData:(NSError **) error {
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]
															  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
														  timeoutInterval:300];
	NSString *lastSessionId = [[NSUserDefaults standardUserDefaults] valueForKey:@"lastSessionId"];
	if (lastSessionId) {
		[urlRequest setValue:[NSString stringWithFormat:@"JSESSIONID=%@", lastSessionId] forHTTPHeaderField:@"Cookie"];
	}	
	
	[urlRequest setHTTPMethod:requestMethod];
	if (postParameters) {
		NSString *parameterData = [self createPostParameterData];
		[urlRequest setHTTPBody:[parameterData dataUsingEncoding:NSUTF8StringEncoding]];
	}
	
	NSURLResponse *response;
	NSError *httpError;
	NSData *urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&httpError];
	*error = nil;
	if (httpError) {
		*error = httpError;
		return nil;
	}
	return urlData;
}

- (NSString *) perform:(NSError **) error {
	NSData *urlData = [self performForData:error];
	
	NSString *dataString = [[[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding] autorelease];
	if (!dataString) {
		NSLog(@"dataString is nil; maybe the received data was in a wrong encoding? Expected UTF-8");
	}
	return dataString;
}

- (NSString *) createPostParameterData {
	NSMutableString *parameterData = [[[NSMutableString alloc] init] autorelease];
	NSEnumerator *enumerator = [postParameters keyEnumerator];
	NSArray *parameterNames = [enumerator allObjects];
	for (int i = 0; i < [parameterNames count]; i++) {
		NSString *parameterName = [parameterNames objectAtIndex:i];
		NSString *parameterValue = [postParameters objectForKey:parameterName];
		
		NSString * encodedValue = (NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef) parameterValue, NULL, (CFStringRef) @"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
		
		[parameterData appendString:parameterName];
		[parameterData appendString:@"="];
		[parameterData appendString:encodedValue];
		
		if (i < [parameterNames count] - 1) {
			[parameterData appendString:@"&"];
		}
	}
	return parameterData;
}

- (void) dealloc {
	[requestUrl release];
	[postParameters release];
	[requestMethod release];
	[super dealloc];
}


@end
