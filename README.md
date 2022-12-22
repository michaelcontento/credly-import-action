# credly-import-action v1

This action will download a given users certificates and badges from [Credly] and stores them within the current repository as **(a)** JSON file and **(b)** badges as image raw image file.

## Usage

See [action.yaml](action.yaml), but basically:

```yaml
- uses: michaelcontento/credly-import-action@v1
  with:
    # The user of whom we want to grab the infos
    name: michael-contento
```

By default this action will store the following files:

- JSON file containting informations about all available certifications
    - `CredlyBadges.json`
- A folder full of images
    - `CredlyBadges/*`

## Custom paths

If you want to change the path where the JSON file and/or the images are stored, use `datafile` and/or `imagedir` - like:

```yaml
- uses: michaelcontento/credly-import-action@v1
  with:
    name: michael-contento
    datafile: data/CustomFile.json
    # Final path:  ./data/CustomFile.json
    imagedir: ima/ges
    # Final path:  ./ima/ges/*
```

## Skipping image downloading

If you don't want to store the badge images locally, just the `skip_image_downloading` option like so:

```yaml
- uses: michaelcontento/credly-import-action@v1
  with:
    name: michael-contento
    skip_image_downloading: 1
    # Only the ./CredlyBadges.json file will be created
```

## License

MIT licensed, see [LICENSE.md](./LICENSE.md) for full details.

  [Credly]: https://info.credly.com/
