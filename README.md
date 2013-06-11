# Vagrant Box Generator for OpenStack's DevStack

## Usage

To generate a brand new Vagrant box, simply run:

    ./script/build

and go take a walk.

If you want to use an alternate provider (such as VMware Fusion), simply
provide the provider name like so:

    ./script/build vmware_fusion

## Box Details

* The operating system is Ubuntu 12.04
* The generated box will have a pre-determined private IP address
  of **172.16.100.10**. This helps to expose all the entire virtual machine
  ports to your workstation
* The fixed address range for Nova instances
  is **172.16.100.129** - **172.16.100.254**
* The floating address range for Nova instances
  is **172.16.100.65** - **172.16.100.126**
* The default password for the admin user, mysql, rabbit, etc. is `"stack"`
* The `"default"` security group has ICMP and SSH traffic enabled by default
* Offline mode will be enabled after initial build from setting `OFFLINE=True`
* Reclone mode is disabled by default from setting `RECLONE=no`
* Placing a `local.sh` file (which is executable) in the same directory as your
  project Vagrantfile allows you to further customize the devstack setup.

## Development

### Development Setup

Setting up for development should *only* require the following:

    git clone <git_url>
    cd <repo-dir>
    ./script/bootstrap

### Refreshing/Updating Local Copy

Similiar to the **Development Setup**:

    git pull
    ./script/bootstrap

## <a name="development"></a> Development

* Source hosted at [GitHub][repo]
* Report issues/questions/feature requests on [GitHub Issues][issues]

Pull requests are very welcome! Make sure your patches are well tested.
Ideally create a topic branch for every separate change you make. For
example:

1. Fork the repo
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## <a name="authors"></a> Authors

Created and maintained by [Fletcher Nichol][fnichol] (<fnichol@nichol.ca>)

[fnichol]:      https://github.com/fnichol
[repo]:         https://github.com/fnichol/devstack-vagrant-basebox
[issues]:       https://github.com/fnichol/devstack-vagrant-basebox/issues
[contributors]: https://github.com/fnichol/devstack-vagrant-basebox/contributors
