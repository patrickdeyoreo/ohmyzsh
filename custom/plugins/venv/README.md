# venv

The plugin provides a hook for `cd' to activate the nearest virtual environment
that is the immediate child of an ancestor of the current working directory. 

To use it, add `venv` to the plugins array of your zshrc file:
```
plugins=(... virtualenv)
```
