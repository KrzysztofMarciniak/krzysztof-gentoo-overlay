## Krzysztof's Gentoo Overlay

A personal Gentoo overlay containing custom ebuilds and packages.

## Enable the overlay

Create the repository configuration:

```bash
sudo mkdir -p /etc/portage/repos.conf

sudo tee /etc/portage/repos.conf/krzysztof.conf > /dev/null <<'EOF'
[krzysztof]
location = /var/db/repos/krzysztof
sync-type = git
sync-uri = https://github.com/krzysztofmarciniak/krzysztof-gentoo-overlay.git
auto-sync = yes
masters = gentoo
EOF
```

Sync the overlay:

```bash
sudo emaint sync -r krzysztof
```

Verify that Portage sees it:

```bash
eselect repository list
```

## Install packages from this overlay

Search available packages:

```bash
eix-update
eix @krzysztof
```

or:

```bash
emerge --search repo:krzysztof
```

Install a package:

```bash
sudo emerge -avq <package-name>
```

## Manual sync

```bash
sudo emaint sync --repo krzysztof
```

## Repository location

The overlay is installed at:

```text
/var/db/repos/krzysztof
```

## Manifest Creation and testing
```bash
sudo ebuild example-0.0.0.ebuild manifest clean compile
```
