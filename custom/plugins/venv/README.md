# venv

The plugin provides a tweakable prompt function to show information about the
active virtual environment (if any), and provides a hook for `cd' to activate
the virtual environment of the current working directory's nearest ancestor
that has one as a child.

To use it, add `venv` to the plugins array of your zshrc file:
```
plugins=(... virtualenv)
```

The plugin defines the function `virtualenv_prompt_info`, which prints the name
of the active `$VIRTUAL_ENV`. The following values will be used in the output:

- `ZSH_THEME_VIRTUALENV_PREFIX`: the output prefix (default: `[`)
- `ZSH_THEME_VIRTUALENV_SUFFIX`: the output suffix (default: `]`)
