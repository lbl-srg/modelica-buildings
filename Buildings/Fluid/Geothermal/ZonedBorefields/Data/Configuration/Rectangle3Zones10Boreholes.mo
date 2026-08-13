within Buildings.Fluid.Geothermal.ZonedBorefields.Data.Configuration;
record Rectangle3Zones10Boreholes
  "Rectangular 3-zone borefield with 10 boreholes per zone"
  extends Buildings.Fluid.Geothermal.ZonedBorefields.Data.Configuration.Template(
    borCon=Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.SingleUTube,
    nZon=3,
    cooBor={
      {0,0}, {6,0}, {12,0}, {18,0}, {24,0}, {30,0}, {36,0}, {42,0}, {48,0}, {54,0},
      {0,6}, {6,6}, {12,6}, {18,6}, {24,6}, {30,6}, {36,6}, {42,6}, {48,6}, {54,6},
      {0,12}, {6,12}, {12,12}, {18,12}, {24,12}, {30,12}, {36,12}, {42,12}, {48,12}, {54,12}},
    iZon={
      1,1,1,1,1,1,1,1,1,1,
      2,2,2,2,2,2,2,2,2,2,
      3,3,3,3,3,3,3,3,3,3},
    mBor_flow_nominal={0.25,0.25,0.25},
    dp_nominal={0,0,0},
    hBor=100,
    rBor=0.075,
    dBor=1,
    rTub=0.02,
    kTub=0.5,
    eTub=0.002,
    xC=0.05,
    roughness=0.001e-3);

  annotation (
    defaultComponentPrefixes="parameter",
    defaultComponentName="conDat",
    Documentation(info="<html>
<p>
Example configuration data record for a rectangular zoned borefield with
three zones and ten boreholes per zone.
</p>
<p>
The boreholes are arranged in three rows. Each row is assigned to one zone.
The spacing between adjacent boreholes is 6 m.
</p>
<ul>
<li>Zone 1: first row, 10 boreholes.</li>
<li>Zone 2: middle row, 10 boreholes.</li>
<li>Zone 3: third row, 10 boreholes.</li>
</ul>
<p>
The nominal pressure drops are set to zero because the corresponding examples
use the detailed Darcy-Weisbach pressure-drop option.
</p>
</html>", revisions="<html>
<ul>
<li>
August 2026, by Lone Meertens:<br/>
First implementation for examples combining zoned borefields with horizontal
plug-flow piping.
</li>
</ul>
</html>"));
end Rectangle3Zones10Boreholes;
