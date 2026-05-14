<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Space+Grotesk:wght@500&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
<script>
    tailwind.config = {
        darkMode: "class",
        theme: {
            extend: {
                "colors": {
                    "surface-dim": "#d9dadb",
                    "surface": "#f8f9fa",
                    "tertiary-container": "#6d7488",
                    "surface-container-high": "#e7e8e9",
                    "on-secondary": "#ffffff",
                    "on-tertiary-container": "#fefcff",
                    "tertiary": "#545c6f",
                    "secondary-container": "#50d9fe",
                    "on-tertiary-fixed-variant": "#3f4759",
                    "tertiary-fixed": "#dbe2f9",
                    "primary": "#0058bc",
                    "surface-tint": "#005bc1",
                    "surface-container-highest": "#e1e3e4",
                    "outline": "#717786",
                    "error-container": "#ffdad6",
                    "on-primary-fixed-variant": "#004493",
                    "primary-fixed": "#d8e2ff",
                    "inverse-surface": "#2e3132",
                    "inverse-primary": "#adc6ff",
                    "secondary": "#00677d",
                    "on-tertiary": "#ffffff",
                    "on-primary-container": "#fefcff",
                    "primary-container": "#0070eb",
                    "surface-container": "#edeeef",
                    "tertiary-fixed-dim": "#bfc6dc",
                    "surface-variant": "#e1e3e4",
                    "secondary-fixed-dim": "#4cd6fb",
                    "on-secondary-fixed": "#001f27",
                    "error": "#ba1a1a",
                    "background": "#f8f9fa",
                    "surface-container-low": "#f3f4f5",
                    "on-error": "#ffffff",
                    "on-error-container": "#93000a",
                    "surface-bright": "#f8f9fa",
                    "on-secondary-fixed-variant": "#004e5f",
                    "surface-container-lowest": "#ffffff",
                    "secondary-fixed": "#b3ebff",
                    "outline-variant": "#c1c6d7",
                    "on-primary-fixed": "#001a41",
                    "inverse-on-surface": "#f0f1f2",
                    "on-background": "#191c1d",
                    "on-surface": "#191c1d",
                    "primary-fixed-dim": "#adc6ff",
                    "on-surface-variant": "#414755",
                    "on-primary": "#ffffff",
                    "on-secondary-container": "#005c70",
                    "on-tertiary-fixed": "#141b2c"
                },
                "borderRadius": {
                    "DEFAULT": "0.25rem",
                    "lg": "0.5rem",
                    "xl": "0.75rem",
                    "full": "9999px"
                },
                "spacing": {
                    "xl": "32px",
                    "gutter": "20px",
                    "lg": "24px",
                    "margin": "24px",
                    "sm": "12px",
                    "base": "4px",
                    "md": "16px",
                    "xs": "8px"
                },
                "fontFamily": {
                    "body-md": ["Inter"],
                    "h2": ["Inter"],
                    "body-lg": ["Inter"],
                    "label-caps": ["Inter"],
                    "h3": ["Inter"],
                    "h1": ["Inter"],
                    "data-mono": ["Space Grotesk"]
                },
                "fontSize": {
                    "body-md": ["14px", { "lineHeight": "1.5", "letterSpacing": "0.01em", "fontWeight": "400" }],
                    "h2": ["24px", { "lineHeight": "1.3", "letterSpacing": "-0.01em", "fontWeight": "600" }],
                    "body-lg": ["16px", { "lineHeight": "1.6", "letterSpacing": "0.01em", "fontWeight": "400" }],
                    "label-caps": ["12px", { "lineHeight": "1.2", "letterSpacing": "0.06em", "fontWeight": "600" }],
                    "h3": ["18px", { "lineHeight": "1.4", "letterSpacing": "0.01em", "fontWeight": "600" }],
                    "h1": ["36px", { "lineHeight": "1.2", "letterSpacing": "-0.02em", "fontWeight": "700" }],
                    "data-mono": ["14px", { "lineHeight": "1.0", "letterSpacing": "0", "fontWeight": "500" }]
                }
            }
        }
    }
</script>
<style>
    .shadow-soft { box-shadow: 0 4px 20px rgba(0, 88, 188, 0.04); }
    .hover-shadow-expand:hover { box-shadow: 0 8px 30px rgba(0, 88, 188, 0.08); }
</style>
