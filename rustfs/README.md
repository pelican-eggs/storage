![RustFS](https://docs.rustfs.com/images/logo.svg)

# RustFS S3
RustFS is fully compatible with the Amazon S3 API and can be used as a drop-in replacement for MinIO or other S3-compatible storage solutions.

## Features

Auto-generate access keys and secret keys on server creation, bypassing default RustFS keys

## Update

Auto-update RustFS to the latest version using the "update" startup feature

Automatic key rotation using the "rotate" startup feature

## Auto Rotate

It's possible to rotate your keys by changing the startup option to "rotate"

Once this is changed, restart your server and it will automatically move your current keys to old and create your new keys

Be sure to change your startup back to "normal" once you have started your server using "rotate". This will ensure that you don't accidentally rotate your keys twice

## Ports 
| Port | Default                 |
|------|-------------------------|
| API  | 9001 (Uses SERVER_PORT) |
| UI   | 9002                    |

## MUSL vs GNU Binary

This egg uses the **musl version** of RustFS (`rustfs-linux-x86_64-musl-latest.zip`), which is statically linked and has no GLIBC dependencies. This ensures compatibility with all Debian/Ubuntu-based Docker images, regardless of the installed GLIBC version.

The gnu version would require GLIBC 2.38+, which is not available in many standard container images.
