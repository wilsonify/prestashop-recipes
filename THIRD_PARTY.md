# Third-party and generated content

This repository is the companion source for *PrestaShop Recipes* (Apress,
2017). Most of it is first-party recipe code. Three paths contain PrestaShop
code or generated assets. They stay in the repository on purpose: the chapters
tell the reader to copy these exact files, and replacing them with a download
would break the teaching flow.

## `9781484225738/source code/`

PrestaShop 1.6.1.x core classes patched for the book's examples:

- `Product.php`, `Cart.php`, `controllers/admin/AdminProductsController.php`
  and the admin templates are based on PrestaShop **1.6.1.6** (the closest
  upstream tag; the book adds its own changes).
- `bookings/` and `testimonials/` are book-authored modules.
- `ajax-cart.js`, `cart-summary.js` and `product.js` are theme overrides.

Upstream: <https://github.com/PrestaShop/PrestaShop/tree/1.6.1.6>. License:
Open Software License 3.0 (the file headers carry the notice).

The base revision was identified by diffing the unmodified files against the
1.6.1.x tags: `Product.php` has 16 changed lines versus 1.6.1.6, and
`AdminProductsController.php` has 7. The remaining differences are the book's
deposit/booking changes. The exact publication snapshot is not recorded by the
publisher, so treat the repository copy as authoritative for the recipes.

## `03-04-Adding-a-Datetimepicker-to-Your-Product-Page/controllers/front/ProductController.php`

Based on PrestaShop 1.6.1.6 `controllers/front/ProductController.php`, with the
datetimepicker additions from the recipe and small local fixes (image-upload
error constant and `random_bytes` filename generation). It is intentionally a
full-file copy because the chapter instructs the reader to replace the core
controller. License: OSL 3.0.

## `03-01-How-to-Create-a-PS-Theme/classic/`

PrestaShop's `classic` theme, version **2.2.0** (compatible with PrestaShop
8.2.1+), copied as the starting point for the theme chapter.

`assets/js/theme.js` and `assets/css/theme.css` are generated Webpack bundles
from the upstream theme; their source and `package.json` are not part of this
repository. They are retained because the chapter uses the built theme as-is.
Do not hand-edit them; update by replacing the whole `classic/` directory from a
matching PrestaShop release if the example is revised. License: OSL 3.0; the
theme's `thirdPartyNotice.json` lists the bundled npm packages.

## Why these are not downloaded by a script

These are not build dependencies. The reader copies a file or directory into a
PrestaShop installation, and the book's instructions refer to the exact contents
committed here. A fetch script would add a network prerequisite to a set of
copy-and-paste examples without improving reproducibility. If these examples are
ever revised, diff them against the matching upstream tag and record the new
base revision here.
