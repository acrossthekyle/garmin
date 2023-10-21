# Garmin

Collection of projects created over the years for Garmin watches.

[See code documentation here](docs/DOCS.md)

## Contributing

If you see something you want to fix, or add, then submit a Pull Request.

In order to get your development environment set up, see [Garmin Documentation](https://developer.garmin.com/connect-iq/connect-iq-basics/getting-started/).

## Process Flow

Follow these steps in order to work with/on the desired project.

### 1. Create development branch

```
source scripts/dev.sh --project temperature --type widget
```

> [!NOTE]
> This will automatically increment the project version.

### 2. Modify project code and test in simulator

```
source scripts/run.sh --project temperature --type widget --device vivoactive4
```

> [!NOTE]
> Provide the `-n` CLI option to skip the Generating step

### 3. Create a Beta build

```
source scripts/beta.sh --project temperature --type widget
```

> [!NOTE]
> This will automatically update both the project ID and version in the manifest file by including "bbbb"
> at the end of the project ID, and adding the current date in seconds to the end of the version number.

### 4. Create a Release (production) build

```
source scripts/release.sh --project temperature --type widget
```
