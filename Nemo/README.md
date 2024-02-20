# Nemo

## Description

The "Nucleus for European Modelling of the Ocean" (NEMO) is a state-of-the-art modelling framework. It is used for research activities and forecasting services in ocean and climate sciences. NEMO is developed by a European consortium with the objective of ensuring long term reliability and sustainability.
NEMO license can be seen in [README](https://forge.nemo-ocean.eu/nemo/nemo/-/blob/main/LICENSE?ref_type=heads).

See [NEMO Home](https://www.nemo-ocean.eu/) for detail.

This is a set of patch in order to build this application on A64FX microprocessor with Fujitsu compiler.

## Attach patch files

```
# for v4.2.0
patch -p 1 < fj-v4.2.0.patch

# for v4.2.1
patch -p 1 < fj-v4.2.1.patch
```

## License
The contents in this directory are distributed under NEMO license.
