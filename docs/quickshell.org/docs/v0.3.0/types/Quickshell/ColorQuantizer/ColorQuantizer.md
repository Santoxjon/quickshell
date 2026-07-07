# ColorQuantizer

**Inherits**: `QtObject`

Quantizes an image source to a palette of colors using the median cut algorithm. This works by creating a 3D map of the image's pixels and averaging out the image’s color data recursively.

## Example

```qml
ColorQuantizer {
  id: colorQuantizer
  source: Qt.resolvedUrl("./yourImage.png")
  depth: 3 // Will produce 8 colors (2³)
  rescaleSize: 64 // Rescale to 64x64 for faster processing
}
```

## Properties

-   **rescaleSize**: `real`
    The size to rescale the image to, when rescaleSize is 0 then no scaling will be done.
    > **NOTE**: Results from color quantization don’t suffer much when rescaling, it’s recommended to rescale, otherwise the quantization process will take much longer.

-   **depth**: `real`
    Max depth for the color quantization. Each level of depth represents another binary split of the color space.

-   **colors**: `list<color>` (readonly)
    Access the colors resulting from the color quantization performed.
    > **NOTE**: The amount of colors returned from the quantization is determined by the property depth, specifically 2ⁿ where n is the depth.

-   **source**: `url`
    Path to the image you’d like to run the color quantization on.

-   **imageRect**: `rect`
    Rectangle that the source image is cropped to. Can be set to `undefined` to reset.
