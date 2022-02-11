# Resources for scaling EnergyPlus buildings

The resources in this folder can be used to create large office buildings with N floors and N*5
conditioned thermal zones.

## Resources description

### makeEplusBuilding.py

The main usage of the functions in this file are to read, scale and write energyplus models that
have been manually templated to be scaled to N number of floors.
The templated raw idf contains anchors {mid} and {top} to identify objects that are specific to
middle and top floors, and the function scale_building_template is used to find these anchors,
multiply middle floors and their components (zones, lights, loads, envelope) and inform the
coordinates of new middle floors and top floor.

See Buildings/Resources/Data/Examples/ZoneScaling/raw/RefBldgLargeOfficeNew2004_Chicago_template.idf
for an example of a template.

The typical process for creating a new scaled model is:
```python
template = read_idf(template_path)
scaled = scale_building_template(template, floor_count)
write_idf(scaled, output_path)
```

### RefBldgLargeOfficeNew2004_Chicago_original.idf

This model is a formatted copy of the large office building reference model, using New Construction for the Chicago (5A) climate zone.
The source of this model is the [Commercial Reference Building models library](https://www.energy.gov/eere/buildings/commercial-reference-buildings) developed by the U.S. Department of Energy.

### RefBldgLargeOfficeNew2004_Chicago_template.idf

This model is a manual transformation of the reference building model. The following manipulations were done:
- All the objects that are not used by Spawn are removed. This is most easily done by running the original model through Spawn and copying the filtered IDF file that is created during simulation.
- All surfaces coordinates are offset to be relative to the origin point of their respective zone. This is done using the `offset_surface_coordinates` utility function in makeEplusBuilding.py.
- If an object name contains the string "mid" or "top", these strings are replaced with anchors _{mid}_ and _{top}_ respectively. After scaling, these anchors will take the value "fl{i}" with i being the floor that object belongs to.
- Zone object elevation for middle and top floors are replaced with anchors _{midZ}_ or _{topZ}_ respectively. After scaling, these anchors will take the value of that floor elevation.
