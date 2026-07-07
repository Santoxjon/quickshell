# IconImage
**Version:** v0.3.0
**Description:** An image that can load icons from the current icon theme.

## Properties
- `iconName`: `string` - The name of the icon to load.
- `iconSize`: `int` - The size of the icon to load.
- `source`: `url` (readonly) - The URL of the loaded icon.
- `status`: `enum` (readonly) - The status of the image loading.
  - `Image.Null`
  - `Image.Ready`
  - `Image.Loading`
  - `Image.Error`
- `fallback`: `string` - A fallback icon name to use if the requested icon is not found.
- `monochrome`: `bool` - Whether to color the icon with the current text color.
- `color`: `color` - The color to use for the icon when `monochrome` is true.
- `asynchronous`: `bool` - Whether to load the icon asynchronously.
- `smooth`: `bool` - Whether to use smooth scaling for the icon.
- `mipmap`: `bool` - Whether to use mipmapping for the icon.
- `autoTransform`: `bool` - Whether to automatically transform the icon.
- `cache`: `bool` - Whether to cache the loaded icon.
- `fillMode`: `enum` - How to scale the image.
  - `Image.Stretch`
  - `Image.PreserveAspectFit`
  - `Image.PreserveAspectCrop`
  - `Image.Tile`
  - `Image.TileVertically`
  - `Image.TileHorizontally`
  - `Image.Pad`
- `horizontalAlignment`: `enum` - The horizontal alignment of the image.
  - `Image.AlignLeft`
  - `Image.AlignRight`
  - `Image.AlignHCenter`
- `verticalAlignment`: `enum` - The vertical alignment of the image.
  - `Image.AlignTop`
  - `Image.AlignBottom`
  - `Image.AlignVCenter`
- `paintedWidth`: `real` (readonly) - The width of the painted image.
- `paintedHeight`: `real` (readonly) - The height of the painted image.
- `progress`: `real` (readonly) - The progress of loading the image.
- `sourceSize`: `size` (readonly) - The size of the source image.
