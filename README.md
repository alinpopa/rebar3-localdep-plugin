## Configuration

- Firstly you need to set an env variable to your local repository: `export LOCALDEP_DIR=~/my_repo`
- ...then add the following plugin to your rebar.config:

```
{plugins, [
    {rebar_localdep, {git, "https://github.com/alinpopa/rebar3-localdep-plugin.git"}}
]}.
```

## Example

If a project's deps specification was the following:

```
{deps, [
  {my_lib, {localdep, "my_lib"}}
]}.
```

This assumes that a folder, which has a rebar structure, named 'my_lib' is in that $LOCALDEP_DIR folder.

