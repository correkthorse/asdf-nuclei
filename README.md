<div align="center">

# asdf-nuclei ![Build](https://github.com/correkthorse/asdf-nuclei/workflows/Build/badge.svg) ![Lint](https://github.com/correkthorse/asdf-nuclei/workflows/Lint/badge.svg)

[nuclei](https://nuclei.projectdiscovery.io/) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Why?](#why)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`: generic POSIX utilities.

# Install

Plugin:

```shell
asdf plugin add nuclei
# or
asdf plugin add nuclei https://github.com/correkthorse/asdf-nuclei.git
```

nuclei:

```shell
# Show all installable versions
asdf list-all nuclei

# Install specific version
asdf install nuclei latest

# Set a version globally (on your ~/.tool-versions file)
asdf global nuclei latest

# Now nuclei commands are available
nuclei --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Why

Nuclei is a fast tool for configurable targeted scanning based on templates offering massive extensibility and ease of use.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/correkthorse/asdf-nuclei/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [projectdiscovery](https://projectdiscovery.io/)
