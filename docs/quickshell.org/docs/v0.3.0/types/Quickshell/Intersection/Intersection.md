# Intersection

**Inherits**: `QtObject`

Intersection strategy for Regions. See also `Region.intersection`.

## Enumerations

### Intersection
- **Xor**: Create an intersection of this region and the other, leaving only the area not covered by both. (opposite of `Intersect`)
- **Subtract**: Subtract this region, cutting this region out of the other. (opposite of `Combine`)
- **Intersect**: Create an intersection of this region and the other, leaving only the area covered by both. (opposite of `Xor`)
- **Combine**: Combine this region, leaving a union of this and the other region. (opposite of `Subtract`)
