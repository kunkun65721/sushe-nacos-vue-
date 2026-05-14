---
name: Liquid-Glass Cinematic System
colors:
  surface: '#141313'
  surface-dim: '#141313'
  surface-bright: '#3a3939'
  surface-container-lowest: '#0e0e0e'
  surface-container-low: '#1c1b1b'
  surface-container: '#201f1f'
  surface-container-high: '#2a2a2a'
  surface-container-highest: '#353434'
  on-surface: '#e5e2e1'
  on-surface-variant: '#c4c7c8'
  inverse-surface: '#e5e2e1'
  inverse-on-surface: '#313030'
  outline: '#8e9192'
  outline-variant: '#444748'
  surface-tint: '#c6c6c7'
  primary: '#ffffff'
  on-primary: '#2f3131'
  primary-container: '#e2e2e2'
  on-primary-container: '#636565'
  inverse-primary: '#5d5f5f'
  secondary: '#c6c6c6'
  on-secondary: '#303030'
  secondary-container: '#474747'
  on-secondary-container: '#b5b5b5'
  tertiary: '#ffffff'
  on-tertiary: '#2f3131'
  tertiary-container: '#e2e2e2'
  on-tertiary-container: '#636565'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#e2e2e2'
  primary-fixed-dim: '#c6c6c7'
  on-primary-fixed: '#1a1c1c'
  on-primary-fixed-variant: '#454747'
  secondary-fixed: '#e2e2e2'
  secondary-fixed-dim: '#c6c6c6'
  on-secondary-fixed: '#1b1b1b'
  on-secondary-fixed-variant: '#474747'
  tertiary-fixed: '#e2e2e2'
  tertiary-fixed-dim: '#c6c6c7'
  on-tertiary-fixed: '#1a1c1c'
  on-tertiary-fixed-variant: '#454747'
  background: '#141313'
  on-background: '#e5e2e1'
  surface-variant: '#353434'
typography:
  display-xl:
    fontFamily: Instrument Serif
    fontSize: 80px
    fontWeight: '400'
    lineHeight: '1.1'
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Instrument Serif
    fontSize: 48px
    fontWeight: '400'
    lineHeight: '1.2'
  headline-md:
    fontFamily: Instrument Serif
    fontSize: 32px
    fontWeight: '400'
    lineHeight: '1.3'
  body-lg:
    fontFamily: Barlow
    fontSize: 18px
    fontWeight: '400'
    lineHeight: '1.6'
    letterSpacing: 0.01em
  body-md:
    fontFamily: Barlow
    fontSize: 16px
    fontWeight: '400'
    lineHeight: '1.6'
  label-sm:
    fontFamily: Barlow
    fontSize: 12px
    fontWeight: '600'
    lineHeight: '1'
    letterSpacing: 0.1em
rounded:
  sm: 0.5rem
  DEFAULT: 1rem
  md: 1.5rem
  lg: 2rem
  xl: 3rem
  full: 9999px
spacing:
  unit: 8px
  gutter: 24px
  margin-page: 64px
  container-max: 1440px
---

## Brand & Style

This design system is engineered to evoke the awe and precision of high-end interstellar travel. The brand personality is silent, expansive, and high-fidelity, prioritizing a sense of "technological luxury" over traditional corporate warmth. It targets an audience that values elite craftsmanship and futuristic aesthetics.

The visual style merges **Glassmorphism** with **Minimalism**. It relies on the interplay between absolute darkness and luminous light. By stripping away all color except for black and white, the system highlights the structural quality of the "liquid-glass" surfaces, creating a multi-layered interface that feels like a head-up display (HUD) in a deep-space vessel. The emotional response is one of calm, focused intensity and premium quality.

## Colors

The palette is strictly monochromatic to maintain a cinematic depth.
- **Deepest Black (#000000):** Used as the infinite void for the primary background. No gradients should be used on the base canvas; it must remain pure black to allow glass layers to pop.
- **Pure White (#FFFFFF):** Reserved for primary typography and high-contrast UI triggers.
- **Translucent White:** Variable opacities of white (5% to 20%) are used to create the "liquid-glass" effect. These layers catch the "light" from the background or elements beneath them, simulating real glass refraction.

## Typography

The typographic tension between the two faces defines the system's character. 
- **Instrument Serif (Italic):** This is used for all headlines and display text. The italicized serif introduces a sense of human elegance and motion, reminiscent of vintage celestial charts or high-fashion editorial.
- **Barlow:** This is the functional "cockpit" font. Used for body copy, data, and labels. Its slightly condensed, industrial proportions suggest technical efficiency. Labels should frequently use uppercase with increased letter spacing to enhance the futuristic HUD aesthetic.

## Layout & Spacing

This design system utilizes a **fixed-fluid hybrid grid**. The main content area conforms to a 12-column grid with generous margins to evoke the feeling of a wide-screen cinematic frame. 

Spacing is governed by an 8px rhythmic scale. Use excessive negative space to allow the "liquid-glass" elements to breathe; components should feel like they are floating in the vacuum of space. Horizontal layouts are preferred over vertical stacks to mimic the panoramic view of a spaceship bridge.

## Elevation & Depth

Depth is not created through shadows, but through **refractive layering**.
- **Standard Layer:** Used for navigation bars and secondary widgets. Features a `4px` backdrop blur and a `1px` border at 10% white opacity.
- **Strong Layer:** Used for modals, hover states, and primary focal points. Features a `50px` backdrop blur, creating a "milky" liquid effect that obscures content behind it heavily.
- **Luminous Borders:** Every glass surface must have a thin `0.5px` or `1px` border. This border should use a linear gradient (top-left to bottom-right) from 20% white to 5% white to simulate a faint light source hitting the glass edge.

## Shapes

The shape language is strictly **Ultra-Rounded**. 
- All buttons, input fields, and tags must utilize a `9999px` (pill) radius. 
- Larger cards and containers should use a `rounded-xl` setting (3rem / 48px) to maintain a soft, aerodynamic silhouette.
- Sharp corners are prohibited as they break the "liquid" metaphor. Elements should look like polished obsidian or molded glass.

## Components

### Buttons
Primary buttons are pure white with black text, utilizing the pill shape. Secondary buttons are "liquid-glass" with a `4px` blur and a thin white border.

### Inputs
Input fields are transparent with a `1px` luminous border. Upon focus, the border opacity increases, and a subtle `4px` backdrop blur activates to highlight the active field.

### Chips & Tags
Small pill shapes with a `4px` blur. Text is always `label-sm` (uppercase Barlow).

### Cards
Large containers with a `50px` "strong" backdrop blur. Borders should be almost invisible (5-10% white) to allow the blur to define the edge against the black background.

### HUD Indicators
Small, non-interactive elements like "System Active" or "Coordinates" should use Barlow in a small point size with high letter spacing, placed near the edges of glass containers.