@interface TargetActionPair : NSObject {

@private
	
	id target;
	
	SEL action;
}

@property(retain, nonatomic) id target;

@property(nonatomic) SEL action;

- (void) executeForEvent:(id) event;

@end
