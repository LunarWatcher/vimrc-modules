# Vimrc modules

This repo contains some vimrc modules primarily used in [my .vimrc](https://codeberg.org/LunarWatcher/dotfiles/blob/master/.vimrc). They're kept separate for reusability, and as an attempt to reduce the already highly monolithic behaviour of my vimrc.


## Functional modules
All functional modules are loaded automatically, and are heavily influenced by personal preference. In addition, to reduce complexity, the plugin will never implement:

* Special plugin loading stuff. A single option is implemented that allows for disabling all plugin loading so specific plugins can be loaded manually. Individual options beyond this will not be supported, unless it's absolutely necessary for things to work reliably. 
* Config options for things that boil down to preference. If you need to make changes to these standards, make a fork and customise it to your needs there.
* Features for things that aren't part of Vim, or for things that don't involve any of the plugins I have installed
* Things that could be a standalone plugin with more reusability. That said, some plugins may start out as modules here and then graduate to plugins. Whether this'll ever happen is TBD

## Library modules
Library modules exclusively supply various helper functions.

## License
MIT. See the LICENSE file.
