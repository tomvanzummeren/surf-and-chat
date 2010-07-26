@class CellHeight;
@class MsnContact;

@interface Message : NSObject {

@private
	NSString *text;
	
	MsnContact *sender;
	
	CellHeight *cellHeight;
	
	UIImage *avatar;
	
	BOOL mine;
}

@property (retain, nonatomic) NSString *text;

@property (retain, nonatomic) MsnContact *sender;

@property (retain, nonatomic) UIImage *avatar;

@property (nonatomic) BOOL mine;

@property (readonly, nonatomic) CellHeight *cellHeight;

@end
