Exploratory package (read: API very subject to change & breakage) for playing with different approaches to modeling and working with Color.

I'm interested in exploring generative accessible palettes, in addition to playing with validating accessibility of existing palettes.


## Developing

### Examples

```
cd examples
elm reactor
open http://localhost:8000/src/Main.elm
```

### Running tests

I couldn't get the tests working on travis ci properly :( But there are tests!

```
npm install
npm test
```

### Maybe TODOs

- What other common web palettes would be helpful to have available? are there others?
- Transparency -- rgba and hsla. worth adding?
- API -- other color formats & conversions?
