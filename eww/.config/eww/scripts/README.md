# Wallpaper Widget - Dynamic Updates

## Overview

The wallpaper widget now dynamically adapts to show all wallpapers found in your wallpapers directory, instead of being limited to a static 17 wallpapers.

## Performance Optimizations

### 1. **Intelligent Caching**

All scripts now use file-based caching to avoid redundant operations:

- Wallpaper lists are cached and only rescanned when the wallpapers directory is modified
- Thumbnail generation only happens when needed
- Count operations are cached separately for efficiency

### 2. **Increased Poll Interval**

Changed from 5s to 10s polling interval to reduce overhead while maintaining responsiveness

### 3. **Lazy Evaluation**

The widget uses `:visible` properties to conditionally render wallpaper tiles, so only necessary elements are created

### 4. **Sorted Results**

Wallpapers are sorted consistently to prevent UI flickering when the list refreshes

## Features

- **Dynamic Grid Layout**: Automatically shows all available wallpapers in a 3-column grid
- **First Row Special**: Contains the close button plus 2 wallpapers
- **Subsequent Rows**: Show 3 wallpapers each
- **Scalable**: Can handle up to 100+ wallpapers efficiently
- **Scrollable**: Vertical scrolling allows navigation through large collections

## Scripts

### `get_wallpaper_count.sh`

Fast count of wallpapers without thumbnail generation. Uses cache to avoid repeated directory scans.

### `get_wallpapers_with_thumbnails.sh`

Returns original wallpaper paths (for use in change_wallpaper.sh). Uses cache and only regenerates when directory changes.

### `get_display_paths.sh`

Returns display paths (thumbnails for GIFs, original for others). Cached for performance.

### `refresh_wallpaper_cache.sh`

Manual cache invalidation script. Run this after adding/removing wallpapers if you want immediate updates instead of waiting for automatic detection.

## Usage

After adding or removing wallpapers, the widget will automatically detect changes on the next poll (within 10 seconds). For immediate refresh, run:

```bash
bash ~/.config/eww/scripts/refresh_wallpaper_cache.sh
```

## Cache Location

All cache files are stored in `/tmp/eww-thumbnails/`:

- `.cache` - Wallpaper list cache timestamp
- `.cache.json` - Cached wallpaper paths
- `.cache_display` - Display paths cache timestamp
- `.cache_display.json` - Cached display paths
- `.cache_count` - Cached wallpaper count
- `*.png` - Thumbnail images for GIF files
