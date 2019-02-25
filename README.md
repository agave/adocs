# Adocs

Build your documentation using AsciiDoctor, it's fun and richer than plain-old Markdown!

Install `adocs` globally or within your project:

```
$ npm i -g adocs # or `npm i adocs --save-dev`
```

## How it works?

The `adocs` binary (bash-script) will scan your project for `**/*.adoc` files, and then will invoke `asciidoctor` to compile them.

> Output directory is `asciidocfx` by design, generated documentation is saved in `asciidocfx/docs` then.

**Options:**

- Use `--fx` to setup and run `AsciidocFx` for editing and preview your files
- Use `--live` to start a `live-server` from generated documentation
- Use `--watch` to watch all `*.adoc` files and rebuild with `nodemon`

**Pro-tip:**

Use a `Makefile` to setup a `make docs` target, e.g.

```Makefile
docs:
  @adocs --live $(PORT) & adocs --watch
```

This way both spawned processes will be stopped at once when `SIGINT` is received so you don't need to have separated tasks for.

## What's the purpose?

Having documentation available to consume is a high-level requirement:

1. Documentation updates MUST be in sync with latest changes in code
2. Using pure source code comments is not suitable for non-technical users
3. Using a separated repository turns this out even more hard to maintain and sync
4. If you put your documentation too far from where it belongs then reasoning about is not clear

> Using tons of `README.md` files over the repository works fine, it integrates well with GitHub and other VCS platforms, it does not requires much tooling: it just works.
>
> But we need to go beyond: building a user-friendly version for final users, maintaining technical docs for devs, hosting source code, etc.

With `adocs` we create documentation that can be published as rich documents for web consumption.

They're also easy to read and write as Markdown, and hopefully compatible with most of VCS platforms so you can focus only on being creative.

We hope you enjoy!
