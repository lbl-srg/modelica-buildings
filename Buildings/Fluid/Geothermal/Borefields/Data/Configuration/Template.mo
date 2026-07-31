within Buildings.Fluid.Geothermal.Borefields.Data.Configuration;
record Template
  "Template for configuration data records"
  extends Modelica.Icons.Record;

  parameter Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration borCon
    "Borehole configuration";

  parameter Boolean use_Rb = false
    "true if the value borehole thermal resistance Rb should be given and used";
  parameter Real Rb(unit="(m.K)/W") = 0.0
    "Borehole thermal resistance Rb. Only to fill in if known"
    annotation(Dialog(enable=use_Rb));
  parameter Modelica.Units.SI.MassFlowRate mBor_flow_nominal
    "Nominal mass flow rate per borehole"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mBorFie_flow_nominal=
      mBor_flow_nominal*nBor "Nominal mass flow of borefield"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Pressure dp_nominal(displayUnit="Pa")
    "Pressure losses for the entire borefield"
    annotation (Dialog(group="Nominal condition"));
  parameter Boolean use_DarcyPressureDrop = false
    "Set to true to compute the vertical pipe pressure drop from Darcy-Weisbach"
    annotation (Evaluate=true, Dialog(tab="Advanced", group="Pressure drop"));
  parameter Boolean use_TDepPressureDrop = false
    "Set to true to evaluate density and viscosity from the medium temperature for the Darcy-Weisbach pressure drop"
    annotation (Dialog(tab="Advanced", group="Pressure drop",enable=use_DarcyPressureDrop));
  parameter Boolean use_TDepRConv = false
    "Set to true to evaluate fluid thermal properties from the medium temperature for the pipe convection resistance"
    annotation (Dialog(tab="Advanced", group="Heat transfer"));
  parameter Buildings.Fluid.Geothermal.Borefields.Types.FluidPropertyEvaluation
    fluidPropertyEvaluation=
      Buildings.Fluid.Geothermal.Borefields.Types.FluidPropertyEvaluation.use_MediaFunctions
    "Method used to evaluate fluid properties for temperature-dependent heat-transfer and pressure-drop correlations"
    annotation (Dialog(
      tab="Advanced",
      group="Fluid properties",
      enable=use_TDepRConv or use_TDepPressureDrop));
  parameter Modelica.Units.SI.MassFraction X_a(min=0, max=0.6) 
    "Mass fraction of propylene glycol in water, used if fluidPropertyEvaluation is PropyleneGlycolWater"
    annotation (Dialog(
      tab="Advanced",
      group="Fluid properties",
      enable=(use_TDepRConv or use_TDepPressureDrop) and
        fluidPropertyEvaluation == Buildings.Fluid.Geothermal.Borefields.Types.FluidPropertyEvaluation.PropyleneGlycolWater));


  //------------------------- Geometrical parameters ---------------------------
  parameter Modelica.Units.SI.Height hBor "Total height of the borehole"
    annotation (Dialog(group="Borehole"));
  parameter Modelica.Units.SI.Radius rBor "Radius of the borehole"
    annotation (Dialog(group="Borehole"));
  parameter Modelica.Units.SI.Height dBor "Borehole buried depth"
    annotation (Dialog(group="Borehole"));
  parameter Integer nBor = size(cooBor, 1) "Total number of boreholes"
    annotation (Dialog(group="Borehole"));

  parameter Modelica.Units.SI.Length[:,2] cooBor
    "Cartesian coordinates of the boreholes in meters"
    annotation (Dialog(group="Borehole"));

  // -- Tube
  parameter Modelica.Units.SI.Radius rTub "Outer radius of the tubes"
    annotation (Dialog(group="Tubes"));
  parameter Modelica.Units.SI.ThermalConductivity kTub
    "Thermal conductivity of the tube" annotation (Dialog(group="Tubes"));
  parameter Modelica.Units.SI.Length eTub "Thickness of a tube"
    annotation (Dialog(group="Tubes"));
  final parameter Modelica.Units.SI.Volume VTubBorFie=
    nBor*
    (if borCon == Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.SingleUTube
       then 2 else 4)*
    hBor*Modelica.Constants.pi*(rTub - eTub)^2
    "Total fluid volume in the vertical pipes of the borefield"
    annotation (Dialog(tab="Advanced", group="Derived quantities", enable=false));
  parameter Modelica.Units.SI.Length xC
    "Shank spacing, defined as the distance between the center of a pipe and the center of the borehole"
    annotation (Dialog(group="Tubes"));
  parameter Modelica.Units.SI.Length roughness = 0.001e-3
    "Absolute pipe wall roughness, default for smooth HDPE pipe"
    annotation (Dialog(group="Tubes"));

  //------------------------- Advanced parameters ------------------------------

  /*--------Flow: */
  parameter Modelica.Units.SI.MassFlowRate mBor_flow_small(min=0) = 1E-4*abs(
    mBor_flow_nominal) "Small mass flow rate for regularization of zero flow"
    annotation (Dialog(tab="Advanced"));

  annotation (
  defaultComponentPrefixes="parameter",
  defaultComponentName="conDat",
    Documentation(
info="<html>
<p>
This record is a template for the records in
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.Data.Configuration\">
Buildings.Fluid.Geothermal.Borefields.Data.Configuration</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 18, 2026, by L. Meertens:<br/>
Added parameters for Darcy-Weisbach pressure-drop calculation, pipe roughness,
and total vertical GHE fluid volume.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4656\">Buildings, #4656</a>.
</li>
<li>
July 15, 2018, by Michael Wetter:<br/>
Revised implementation, added <code>defaultComponentPrefixes</code> and
<code>defaultComponentName</code>.
</li>
<li>
June 28, 2018, by Damien Picard:<br/>
First implementation.
</li>
</ul>
</html>"));
end Template;
