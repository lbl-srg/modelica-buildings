within Buildings.Fluid.Geothermal.ZonedBorefields.Data.Configuration;
record Template
  "Template for configuration data records"
  extends Modelica.Icons.Record;

  parameter Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration borCon
    "Borehole configuration";

  //--------------------------- Resistance parameters --------------------------
  parameter Boolean use_Rb = false
    "true if the value borehole thermal resistance Rb should be given and used";
  parameter Real Rb(unit="(m.K)/W") = 0.0
    "Borehole thermal resistance Rb. Only to fill in if known"
    annotation(Dialog(enable=use_Rb));

  //------------------------------ Flow parameters -----------------------------
  parameter Modelica.Units.SI.MassFlowRate[nZon] mBor_flow_nominal
    "Nominal mass flow rate per borehole in each zone"
    annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.MassFlowRate[nZon] mZon_flow_nominal = {mBor_flow_nominal[i] * nBorPerZon[i] for i in 1:nZon}
    "Nominal mass flow rate of each borefield zone"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Pressure[nZon] dp_nominal(each displayUnit="Pa")
    "Pressure losses for the entire borefield"
    annotation (Dialog(group="Nominal condition"));
  // -- Advanced flow parameters
  final parameter Modelica.Units.SI.MassFlowRate[nZon] mBor_flow_small(each min=0) = 1E-4*abs(mBor_flow_nominal)
    "Small mass flow rate for regularization of zero flow"
    annotation (Dialog(tab="Advanced"));

  //------------------------- Geometrical parameters ---------------------------
  // -- Borehole
  parameter Modelica.Units.SI.Height hBor "Total height of the borehole"
    annotation (Dialog(group="Borehole"));
  parameter Modelica.Units.SI.Radius rBor "Radius of the borehole"
    annotation (Dialog(group="Borehole"));
  parameter Modelica.Units.SI.Height dBor "Borehole buried depth"
    annotation (Dialog(group="Borehole"));

  // -- Borefield
  parameter Integer nZon(min=1) "Total number of independent bore field zones"
    annotation (Dialog(group="Borehole"));
  parameter Integer[nBor] iZon "Index of the zone corresponding to each borehole"
    annotation (Dialog(group="Borehole"));
  final parameter Integer[nZon] nBorPerZon = {sum({if iZon[j]==i then 1 else 0 for j in 1:nBor}) for i in 1:nZon}
    "Number of boreholes per borefield zone"
    annotation (Dialog(group="Borehole"));
  parameter Modelica.Units.SI.Length[:,2] cooBor
    "Cartesian coordinates of the boreholes in meters"
    annotation (Dialog(group="Borehole"));
  final parameter Integer nBor = size(cooBor, 1) "Total number of boreholes"
    annotation (Dialog(group="Borehole"));

  // -- Tube
  parameter Modelica.Units.SI.Radius rTub "Outer radius of the tubes"
    annotation (Dialog(group="Tubes"));
  parameter Modelica.Units.SI.ThermalConductivity kTub
    "Thermal conductivity of the tube" annotation (Dialog(group="Tubes"));
  parameter Modelica.Units.SI.Length eTub "Thickness of a tube"
    annotation (Dialog(group="Tubes"));
  parameter Modelica.Units.SI.Length xC
    "Shank spacing, defined as the distance between the center of a pipe and the center of the borehole"
    annotation (Dialog(group="Tubes"));

  annotation (
  defaultComponentPrefixes="parameter",
  defaultComponentName="conDat",
    Documentation(
info="<html>
<p>
This record is a template for the records in
<a href=\"modelica://Buildings.Fluid.Geothermal.ZonedBorefields.Data.Configuration\">
Buildings.Fluid.Geothermal.ZonedBorefields.Data.Configuration</a>.
</p>
<p>
See <a href=\"modelica://Buildings.Fluid.Geothermal.ZonedBorefields.Data.Configuration.Example\">
Buildings.Fluid.Geothermal.ZonedBorefields.Data.Configuration.Example</a>
for how to use this record.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 2024, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end Template;
