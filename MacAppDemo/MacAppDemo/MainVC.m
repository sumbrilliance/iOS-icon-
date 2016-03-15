//
//  MainVC.m
//  MacAppDemo
//
//  Created by sumbrilliance on 16/2/15.
//  Copyright © 2016年 sumbrilliance. All rights reserved.
//

#import "MainVC.h"

@interface MainVC ()

@end

@implementation MainVC


- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}
- (IBAction)pickImageForConversion3To2x:(NSButton *)sender {
    NSOpenPanel *mutipleSelectionPanel = [NSOpenPanel openPanel];
    mutipleSelectionPanel.allowsMultipleSelection = YES;
    mutipleSelectionPanel.allowedFileTypes = [NSImage imageTypes];
    
    [mutipleSelectionPanel beginWithCompletionHandler:^(NSInteger result) {
        if (result == 1) {
            
            [mutipleSelectionPanel.URLs enumerateObjectsUsingBlock:^(NSURL * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [self output_2x_ImageFrom_3x_ImageURL:obj];
                });
            }];

        }
        
    }];
    
}
- (IBAction)pickImageAction:(NSButton *)sender {

    NSOpenPanel *panel = [NSOpenPanel openPanel];
//    [NSOpenPanel openPanel].accessoryViewDisclosed = YES;
    [NSOpenPanel openPanel].canChooseDirectories = YES;
    
    [panel beginWithCompletionHandler:^(NSInteger result) {
       
        if (result == 1) {
            NSImage *resImage = [[NSImage alloc] initWithContentsOfURL:panel.URLs.firstObject];
            NSURL *url = panel.URLs.firstObject;
            NSArray *imageNames = @[@"29@2x",@"29@3x",@"40@2x",@"40@3x",@"60@2x",@"60@3x"];
            NSArray *imagePxs =   @[@58,     @87,     @80,     @120,    @120,    @180];
            
            [self createImages:imageNames px:imagePxs fromImage:resImage andURL:url];
            

        }
        
    }];
}

- (void)createImages:(NSArray<NSString *> *)imageNames px:(NSArray<NSNumber *>*)pxs fromImage:(NSImage *)image andURL:(NSURL *)url{
    
    [imageNames enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat px = pxs[idx].floatValue;
        NSImage *newImage = [self scaleImage:image toSize:CGSizeMake(px, px)];
        [self writeToLocalImage:newImage withName:obj fromeURL:url];
    }];
    
    
}

- (NSImage *)scaleImage:(NSImage *)image toSize:(CGSize)destSize {
    CGFloat scaleRatio = [NSScreen mainScreen].backingScaleFactor;
    if ([image isValid]) {
        NSSize imageSize = [image size];
        float width  = imageSize.width;
        float height = imageSize.height;
        float targetWidth  = destSize.width/scaleRatio;
        float targetHeight = destSize.height/scaleRatio;
        float scaleFactor  = 0.0;
        float scaledWidth  = targetWidth;
        float scaledHeight = targetHeight;
        NSLog(@"scale = %f",scaleRatio);
        
        
        
        NSPoint thumbnailPoint = NSZeroPoint;
        
        if (!NSEqualSizes(imageSize, destSize))
        {
            float widthFactor  = targetWidth / width;
            float heightFactor = targetHeight / height;
            
            if (widthFactor < heightFactor)
            {
                scaleFactor = widthFactor;
            }
            else
            {
                scaleFactor = heightFactor;
            }
            
            scaledWidth  = width  * scaleFactor;
            scaledHeight = height * scaleFactor;
            
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            }
            
            else if (widthFactor > heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
            
            NSImage *newImage = [[NSImage alloc] initWithSize:CGSizeMake(destSize.width/scaleRatio, destSize.height/scaleRatio)];
            
            [newImage lockFocus];
            NSRect thumbnailRect;
            thumbnailRect.origin = thumbnailPoint;
            thumbnailRect.size.width = scaledWidth;
            thumbnailRect.size.height = scaledHeight;
            NSLog(@"width = %f",scaledWidth);
            [image drawInRect:thumbnailRect
                     fromRect:NSZeroRect
                    operation:NSCompositeSourceOver
                     fraction:1.0];
            
            [newImage unlockFocus];
                    return newImage;
        }

    }
    return nil;
}


- (void)writeToLocalImage:(NSImage *)image withName:(NSString *)name fromeURL:(NSURL *)resouceURL{
    NSData *imageData = [image TIFFRepresentation];
    NSMutableString *Mstring = [[NSMutableString alloc] initWithString:resouceURL.path];
    [Mstring insertString:name atIndex:Mstring.length-4];
    NSBitmapImageRep *rep = [NSBitmapImageRep imageRepWithData:imageData];
    NSData *dataToWrite = [rep representationUsingType:NSPNGFileType properties:nil];
    [dataToWrite writeToFile:Mstring atomically:NO];

}

- (void)output_2x_ImageFrom_3x_ImageURL:(NSURL*)url {
    NSImage *pickImage = [[NSImage alloc] initWithContentsOfURL:url];
    CGFloat screenScale = [NSScreen mainScreen].backingScaleFactor;
    //            float resImageWidth = pickImage.size.width*screenScale; // 从retina屏还原pt为px
    //            float resImageHeight = pickImage.size.height*screenScale;
    float destImageWidth = pickImage.size.width/3*2*screenScale;
    float destImageHeight = pickImage.size.height/3*2*screenScale;
    NSImage *newImage = [self scaleImage:pickImage toSize:CGSizeMake(destImageWidth, destImageHeight)];
    [self writeToLocalImage:newImage withName:@"@2x" fromeURL:url];
    [self renameImageAppend_3x_SuffixFromURL:url];
}
- (void)renameImageAppend_3x_SuffixFromURL:(NSURL *)url {
    NSMutableString *Mstring = [[NSMutableString alloc] initWithString:url.path];
    [Mstring insertString:@"@3x" atIndex:Mstring.length-4];
    NSError *error;
    [[NSFileManager defaultManager] moveItemAtPath:url.path toPath:Mstring error:&error];
    if (error) {
        NSLog(@"重命名失败 --- %@",error);
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //    NSFont *f = [[NSFont alloc] init];
    
}

@end
