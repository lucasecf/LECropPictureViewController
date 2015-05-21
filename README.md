LECropPictureViewController
===========

## What is this

Want a nice crop editor for your picture? Not satisfied with the one provided for Apple? Likes rounded images?
`LECropPictureViewController` is the component for you :)! See the how works in the gif below:

<p align="center">
    <img src="Images/gif1.gif" alt="GIF 1" width="320px" />
</p>

## Install

#### Manually

Drag and copy all files in the [__LECropPictureViewController__](LECropPictureController) folder into your project.

#### Cocoapods

Soon!

## How to use

`LECropPictureViewController` works with any image. You just have to provide the image and a cropType when creating a new instance, and then present the view controller. The possible cropTypes are `LECropPictureTypeRounded` and `LECropPictureTypeRect`.

```objective-c
LECropPictureViewController *cropPictureController = [[LECropPictureViewController alloc] initWithImage:image andCropPictureType:LECropPictureTypeRounded];
[self presentViewController:cropPictureController animated:YES completion:nil];
```

The callback for the cropped picture is given through a block, when creating the editPictureController. See the exemplo below, presenting the `LECropPictureViewController` inside the delegate of a UIImagePickerController:


```objective-c
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];

    [self dismissViewControllerAnimated:NO completion:nil];

    LECropPictureViewController *cropPictureController = [[LECropPictureViewController alloc] initWithImage:image andCropPictureType:LECropPictureTypeRounded];
    cropPictureController.imageView.contentMode = UIViewContentModeScaleAspectFit;

    cropPictureController.photoAcceptedBlock = ^(UIImage *croppedPicture){
        self.imageView.image = croppedPicture;
    };

    [self presentViewController:cropPictureController animated:NO completion:nil];
}
```

## Customizing

The `LECropPictureViewController` has public properties for all it's components.

```objective-c
@property (weak, nonatomic) UIBarButtonItem *cancelButtonItem;
@property (weak, nonatomic) UIBarButtonItem *acceptButtonItem;
@property (weak, nonatomic) UIImageView *imageView;
```

With this, you can do things like changing the **contentMode** of the imageView, changing the **text** of the barButtonItems, etc.

##Collaborate
Liked the project? Is there something missing or that could be better? Feel free to contribute :)

1. Fork it

2. Create your branch
``` git checkout -b name-your-feature ```

3. Commit it
``` git commit -m 'the differece' ```

4. Push it
``` git push origin name-your-feature ```

5. Create a Pull Request

##License
This projected is licensed under the terms of the MIT license.