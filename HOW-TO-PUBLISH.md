## How to publish

### Compile the demos

From .
```
$ elm-live src/Styleguide.elm  --output docs/styleguide.js --dir=docs --open
```

From .examples
```
$ elm-live Main.elm  --output ../docs/main.js --dir=../docs
$ elm-live Simple.elm  --output ../docs/simple.js --dir=../docs
```


## Preview documentation

```
$ elm-make --docs=documentation.json
```

http://package.elm-lang.org/help/docs-preview

## Analyze code


```
$ elm-package bump
```

After this update the version number at the top of Styleguide.elm

## Publish

```
$ elm-package publish
```
