//
//  GleeMWFrameDataPool.h
//  MWTestSprite
//
//  Created by xu Jesse on 12-4-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define O_CLIPDATA_NUM 4
#define O_FRAMEDATA_NUM 4

typedef enum ClipType{
	ClipType_ImageNormal = 0x0000,
	ClipType_ImageFlipX = 0x0002,
	ClipType_ImageFlipY = 0x0004,
	ClipType_ImageFlipXY = 0x0006,
	ClipType_Ecllipse = 0x0001,
	ClipType_Line = 0x0005,
	ClipType_Rect = 0x0007,
	ClipType_RoundRect = 0x000b,
	ClipType_CollisionRect = 0x000f	
}ClipType;

/****** copy to objc ******/
@interface CCMWClipAdditionalData : NSObject {
    //ecclipse data
	float startAngle;
	float endAngle;
    
    
	//line
	CGPoint pt2;
    
	//ecclipse, line, rect, roundedRect
	int color;
	
	//ecclipse, rect, roundedRect, PositionerRoundedRect
	CGSize size;
	
	//round rect
	float arcWidth;
	float arcHeight;
	
	//image
	CGRect imageRect;
}
@property (nonatomic,assign)float startAngle;
@property (nonatomic,assign)float endAngle;
@property (nonatomic,assign)CGPoint pt2;
@property (nonatomic,assign)int color;
@property (nonatomic,assign)CGSize size;
@property (nonatomic,assign)float arcWidth;
@property (nonatomic,assign)float arcHeight;
@property (nonatomic,assign)CGRect imageRect;

@end

//
@interface CCMWClipData : NSObject
{
    //the global frame index of current clip
	int clipFrameIndex;
	
	//global index of current clip in XXClipPool 
	int clipAdditionalDataIndex;
	ClipType type;
	CGPoint clipPos;
	
	int imageIndex;
	
    
	//additional data if the clip is not an image
	CCMWClipAdditionalData* clipAdditionalData;    
}
@property (nonatomic,retain) CCMWClipAdditionalData* clipAdditionalData; 
@property (nonatomic,assign)int clipFrameIndex;
@property (nonatomic,assign)int clipAdditionalDataIndex;
@property (nonatomic,assign)ClipType type;
@property (nonatomic,assign)CGPoint clipPos;
@property (nonatomic,assign)int imageIndex;
-(void)dealloc;
@end


//
@interface CCMWFrameData : NSObject {
    NSMutableArray* clipDataList; //CCMWClipData
	int numOfImageClip;
	int frameGlobalIndex;
	int delay;
	int xinc;
	int yinc;
}
@property (nonatomic,retain)NSMutableArray* clipDataList;
@property (nonatomic,assign)int numOfImageClip;
@property (nonatomic,assign)int frameGlobalIndex;
@property (nonatomic,assign)int delay;
@property (nonatomic,assign)int xinc;
@property (nonatomic,assign)int yinc;
-(void)dealloc;
@end

//
@interface CCMWAnimationData : NSObject {
    NSMutableArray* frameDataList;//CCMWFrameData
    NSString* animeFileName;
	int animeIndex;
}
@property (nonatomic,retain)NSMutableArray* frameDataList;
@property (nonatomic,retain)NSString* animeFileName;
@property (nonatomic,assign)int animeIndex;
-(void)dealloc;
@end

//
@interface CCMWAnimationFileData : NSObject {
    @public
    NSString* fileName;
    
	unsigned int numOfImage;
	
	/*  Animation table 
	 *  index of frames in the frameTable for Animation
	 *  FORMAT:
	 *    1. [frametable-start][frametable-end]
	 *    2. [frametable-start][frametable-end]
	 *    3. [frametable-start][frametable-end]
	 */
	short* animationTable;
    
	/* Animation Frame Table 
	 * Golbal frame list
	 *  FORMAT
	 *      1. [FRAME-INDEX][delay][xinc][yinc]
	 * 		2. [FRAME-INDEX][delay][xinc][yinc]
	 * 		3. [FRAME-INDEX][delay][xinc][yinc]
	 * 
	 * 		4. [FRAME-INDEX][delay][xinc][yinc]
	 * 		5. [FRAME-INDEX][delay][xinc][yinc]
	 * 
	 *      6. [FRAME-INDEX][delay][xinc][yinc]
	 * 		7. [FRAME-INDEX][delay][xinc][yinc]
	 * 		8. [FRAME-INDEX][delay][xinc][yinc]
	 * 
	 * 		9. [FRAME-INDEX][delay][xinc][yinc]
	 * 		10.[FRAME-INDEX][delay][xinc][yinc]
	 */
	short* frameTable;
	
	/*   Frame Pool Table
	 *  COntian information about certain clip inside a frame
	 *  FORMAT
	 *  
	 *       [CLIP INDEX][X][Y][FLAG]
	 *       [CLIP INDEX][X][Y][FLAG]   - FRAME 0
	 *       [CLIP INDEX][X][Y][FLAG]
	 *       
	 *       [CLIP INDEX][X][Y][FLAG]
	 *       [CLIP INDEX][X][Y][FLAG]    - FRAME 1
	 *       [CLIP INDEX][X][Y][FLAG]
	 *       [CLIP INDEX][X][Y][FLAG]
	 *       
	 *       [CLIP INDEX][X][Y][FLAG]
	 *       [CLIP INDEX][X][Y][FLAG]   - FRAME 2
	 *       [CLIP INDEX][X][Y][FLAG]
	 *  
	 */
	
	short* framePoolTable;
    
	/*   Clip Pool Table
	 *  FORMAT
	 *  Image
	 *  	[x][y][w][h]
	 *  	[x][y][w][h]
	 *  	[x][y][w][h]
	 *  
	 *  Ellipse
	 *  	[w][h][startAngle][endAngle][color]
	 *  	[w][h][startAngle][endAngle][color]
	 *  	[w][h][startAngle][endAngle][color]
	 *  
	 *  Line
	 *     [x2][y2][color]
	 *     [x2][y2][color]
	 *     
	 *  Rect
	 *     [w][h][color]
	 *     [w][h][color]
	 *     
	 *  RoundedRect
	 *     [w][h][arcwidth][archeight][color]
	 *     [w][h][arcwidth][archeight][color]
	 *     
	 *  PositionerRoundedRect
	 *     [w][h]
	 *     [w][h]
	 */
	
	short* imageClipPool;
	int*   ellipseClipPool;
	int*   lineClipPool;
	int*   rectangleClipPool;
	int*   roundedRectangleClipPool;
	short* positionerRectangleClipPool;
	
	/*  Animation table 
	 *  indicate the start-end index of the global frame in framePoolTable which store clip information
	 *  can be retrived by using frameTable[x*4]*2 and frameTable[x*4]*2+1
	 *  FORMAT:
	 *  frameTableIndex[0] = [startIndex in frameTable for frame 0][endIndex]
	 *  frameTableIndex[1] = [startIndex in frameTable for frame 1][endIndex]
	 *    
	 */
	short* frameTableIndex;
	short* imageIndex;	
}
@property (nonatomic,retain) NSString* fileName;
-(void)dealloc;
@end

//
@interface CCMWFrameDataPool : NSObject {
    NSMutableArray* animationFileDataList;//CCMWAnimationFileData
}
@property (nonatomic,retain)NSMutableArray* animationFileDataList;

+ (CCMWFrameDataPool*) sharedDataPool;
- (void) releaseAllAnimationFileData;

- (CCMWAnimationFileData*) loadFrameData:(NSString*) fileName;
- (CCMWAnimationFileData*) getAnimationFileDataWithName:(NSString*) fileName;

- (CCMWAnimationData*) getAnimationData:(int) animeIndex withAnimationFileData:(CCMWAnimationFileData*) animationFileData;
- (CCMWAnimationData*) getAnimationData:(int) animeIndex withFileName:(NSString*) fileName;

@end
/************************/
