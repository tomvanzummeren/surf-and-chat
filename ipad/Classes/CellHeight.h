@interface CellHeight : NSObject {

@private
	CGFloat portraitOrientation;
	
	CGFloat landscapeOrientation;
}

@property(readwrite, nonatomic) CGFloat portraitOrientation;

@property(readwrite, nonatomic) CGFloat landscapeOrientation;

@end
