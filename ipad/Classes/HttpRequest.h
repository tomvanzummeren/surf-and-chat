
#import <Foundation/Foundation.h>
#import "HttpRequest.h"

/*!
 * Performs an HTTP request using either GET or POST method.
 *
 * @author Tom van Zummeren
 */
@interface HttpRequest : NSObject {
	
@private
	NSString *requestUrl;
	
	NSDictionary *postParameters;
	
	NSString *requestMethod;
	
}

- (id) initForGet:(NSString *)url;

- (id) initForPost:(NSString *)url withParameters:(NSDictionary *) parameters;

- (NSData *) performForData:(NSError **) error;

- (NSString *) perform:(NSError **) error;

@end
