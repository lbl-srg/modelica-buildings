within Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Examples;
model PressureDropPipeTDep
  "Validation model for temperature-dependent Darcy-Weisbach pressure drop"
  extends Modelica.Icons.Example;

  package MediumWat = Buildings.Media.Water
    "Constant-property water transport medium";

  package MediumGly =
    Buildings.Media.Antifreeze.PropyleneGlycolWater(
      property_T=293.15,
      X_a=X_aGly)
    "Constant-property propylene-glycol/water transport medium";
  
  constant Real X_aGly(unit="1", min=0, max=1) = 0.40
    "Mass fraction of propylene glycol in the glycol-water mixture";

  parameter Modelica.Units.SI.Length length=200
    "Total represented pipe length";

  parameter Modelica.Units.SI.Radius rTub=0.02
    "Outer tube radius";

  parameter Modelica.Units.SI.Length eTub=0.002
    "Tube wall thickness";

  parameter Modelica.Units.SI.Length roughness=0.001e-3
    "Pipe roughness";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=0.20
    "Nominal mass flow rate";

  parameter Modelica.Units.SI.Time period=3600
    "Period of inlet temperature variation";

  parameter Modelica.Units.SI.Temperature TIn_mean=293.15
    "Mean inlet temperature";

  parameter Modelica.Units.SI.TemperatureDifference TIn_amp=20
    "Amplitude of inlet temperature variation";

  parameter MediumWat.ThermodynamicState staWatDef=
    MediumWat.setState_pTX(
      p=MediumWat.p_default,
      T=MediumWat.T_default,
      X=MediumWat.X_default)
    "Default state for water";

  parameter MediumGly.ThermodynamicState staGlyDef=
    MediumGly.setState_pTX(
      p=MediumGly.p_default,
      T=MediumGly.T_default,
      X=MediumGly.X_default)
    "Default state for glycol";

  Modelica.Blocks.Sources.Sine TInSig(
    amplitude=TIn_amp,
    f=1/period,
    phase=-Modelica.Constants.pi/2,
    offset=TIn_mean)
    "Sinusoidal inlet temperature"
    annotation (Placement(transformation(extent={{-110,80},{-90,100}})));

  Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.PressureDropPipeDarcy
    preDroFixWat(
      redeclare package Medium = MediumWat,
      m_flow_nominal=m_flow_nominal,
      computePressureDrop=true,
      use_TDepPressureDrop=false,
      length=length,
      rTub=rTub,
      eTub=eTub,
      roughness=roughness,
      rhoMed_default=MediumWat.density(staWatDef),
      muMed_default=MediumWat.dynamicViscosity(staWatDef))
    "Fixed-property water pressure drop"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));

  Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.PressureDropPipeDarcy
    preDroWat(
      redeclare package Medium = MediumWat,
      m_flow_nominal=m_flow_nominal,
      computePressureDrop=true,
      use_TDepPressureDrop=true,
      length=length,
      rTub=rTub,
      eTub=eTub,
      roughness=roughness,
      rhoMed_default=MediumWat.density(staWatDef),
      muMed_default=MediumWat.dynamicViscosity(staWatDef))
    "Temperature-dependent water pressure drop"
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));

  Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.PressureDropPipeDarcy
    preDroFixGly(
      redeclare package Medium = MediumGly,
      m_flow_nominal=m_flow_nominal,
      computePressureDrop=true,
      use_TDepPressureDrop=false,
      length=length,
      rTub=rTub,
      eTub=eTub,
      roughness=roughness,
      rhoMed_default=MediumGly.density(staGlyDef),
      muMed_default=MediumGly.dynamicViscosity(staGlyDef))
    "Fixed-property glycol pressure drop"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));

  Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.PressureDropPipeDarcy
    preDroGly(
      redeclare package Medium = MediumGly,
      m_flow_nominal=m_flow_nominal,
      computePressureDrop=true,
      use_TDepPressureDrop=true,
      length=length,
      rTub=rTub,
      eTub=eTub,
      roughness=roughness,
      rhoMed_default=MediumGly.density(staGlyDef),
      muMed_default=MediumGly.dynamicViscosity(staGlyDef))
    "Temperature-dependent glycol pressure drop"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));

  Buildings.Fluid.Sources.MassFlowSource_T souFixWat(
    redeclare package Medium = MediumWat,
    nPorts=1,
    use_T_in=true,
    m_flow=m_flow_nominal)
    "Mass flow source for fixed-property water case"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));

  Buildings.Fluid.Sources.Boundary_pT sinFixWat(
    redeclare package Medium = MediumWat,
    nPorts=1)
    "Sink for fixed-property water case"
    annotation (Placement(transformation(extent={{80,50},{60,70}})));

  Buildings.Fluid.Sources.MassFlowSource_T souWat(
    redeclare package Medium = MediumWat,
    nPorts=1,
    use_T_in=true,
    m_flow=m_flow_nominal)
    "Mass flow source for temperature-dependent water case"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));

  Buildings.Fluid.Sources.Boundary_pT sinWat(
    redeclare package Medium = MediumWat,
    nPorts=1)
    "Sink for temperature-dependent water case"
    annotation (Placement(transformation(extent={{80,10},{60,30}})));

  Buildings.Fluid.Sources.MassFlowSource_T souFixGly(
    redeclare package Medium = MediumGly,
    nPorts=1,
    use_T_in=true,
    m_flow=m_flow_nominal)
    "Mass flow source for fixed-property glycol case"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));

  Buildings.Fluid.Sources.Boundary_pT sinFixGly(
    redeclare package Medium = MediumGly,
    nPorts=1)
    "Sink for fixed-property glycol case"
    annotation (Placement(transformation(extent={{80,-30},{60,-10}})));

  Buildings.Fluid.Sources.MassFlowSource_T souGly(
    redeclare package Medium = MediumGly,
    nPorts=1,
    use_T_in=true,
    m_flow=m_flow_nominal)
    "Mass flow source for temperature-dependent glycol case"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));

  Buildings.Fluid.Sources.Boundary_pT sinGly(
    redeclare package Medium = MediumGly,
    nPorts=1)
    "Sink for temperature-dependent glycol case"
    annotation (Placement(transformation(extent={{80,-70},{60,-50}})));

  Modelica.Units.SI.Temperature TIn = TInSig.y
    "Inlet temperature";

  Modelica.Units.SI.PressureDifference dpFixWat = preDroFixWat.dp
    "Pressure drop of fixed-property water case";

  Modelica.Units.SI.PressureDifference dpWat = preDroWat.dp
    "Pressure drop of temperature-dependent water case";

  Modelica.Units.SI.PressureDifference dpFixGly = preDroFixGly.dp
    "Pressure drop of fixed-property glycol case";

  Modelica.Units.SI.PressureDifference dpGly = preDroGly.dp
    "Pressure drop of temperature-dependent glycol case";

  Modelica.Units.SI.PressureDifference dDpWat = dpWat - dpFixWat
    "Difference between temperature-dependent and fixed-property water pressure drop";

  Modelica.Units.SI.PressureDifference dDpGly = dpGly - dpFixGly
    "Difference between temperature-dependent and fixed-property glycol pressure drop";

equation
  connect(TInSig.y, souFixWat.T_in)
    annotation (Line(points={{-89,90},{-86,90},{-86,64},{-82,64}}, color={0,0,127}));
  connect(TInSig.y, souWat.T_in)
    annotation (Line(points={{-89,90},{-86,90},{-86,24},{-82,24}}, color={0,0,127}));
  connect(TInSig.y, souFixGly.T_in)
    annotation (Line(points={{-89,90},{-86,90},{-86,-16},{-82,-16}}, color={0,0,127}));
  connect(TInSig.y, souGly.T_in)
    annotation (Line(points={{-89,90},{-86,90},{-86,-56},{-82,-56}}, color={0,0,127}));

  connect(souFixWat.ports[1], preDroFixWat.port_a)
    annotation (Line(points={{-60,60},{-10,60}}, color={0,127,255}));
  connect(preDroFixWat.port_b, sinFixWat.ports[1])
    annotation (Line(points={{10,60},{60,60}}, color={0,127,255}));

  connect(souWat.ports[1], preDroWat.port_a)
    annotation (Line(points={{-60,20},{-10,20}}, color={0,127,255}));
  connect(preDroWat.port_b, sinWat.ports[1])
    annotation (Line(points={{10,20},{60,20}}, color={0,127,255}));

  connect(souFixGly.ports[1], preDroFixGly.port_a)
    annotation (Line(points={{-60,-20},{-10,-20}}, color={0,127,255}));
  connect(preDroFixGly.port_b, sinFixGly.ports[1])
    annotation (Line(points={{10,-20},{60,-20}}, color={0,127,255}));

  connect(souGly.ports[1], preDroGly.port_a)
    annotation (Line(points={{-60,-60},{-10,-60}}, color={0,127,255}));
  connect(preDroGly.port_b, sinGly.ports[1])
    annotation (Line(points={{10,-60},{60,-60}}, color={0,127,255}));

  annotation (
    experiment(StopTime=3600, Tolerance=1e-6),
    __Dymola_Commands(file=
      "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/BaseClasses/Boreholes/BaseClasses/Examples/PressureDropPipeTDep.mos"
      "Simulate and plot"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-90},{100,110}})),
    Documentation(info="<html>
<p>
This validation model compares fixed and temperature-dependent
Darcy-Weisbach pressure drop for a ground heat exchanger pipe.
</p>
<p>
Four cases are simulated side by side:
</p>
<ul>
<li>
Fixed-property water.
</li>
<li>
Water using local temperature-dependent water correlations for density and
dynamic viscosity.
</li>
<li>
Fixed-property propylene-glycol/water.
</li>
<li>
Propylene-glycol/water using local temperature-dependent glycol correlations
for density and dynamic viscosity.
</li>
</ul>
<p>
The mass flow rate is constant and the inlet temperature is varied
sinusoidally. The model verifies that only the temperature-dependent cases
change pressure drop due to the fluid-property evaluation.
</p>
<p>
The temperature-dependent pressure-drop cases are enabled by setting
<code>use_TDepPressureDrop=true</code> on the pressure-drop components.
The fluid type and glycol mass fraction are derived from the redeclared
<code>Medium</code>. The glycol mass fraction can be adjusted with
<code>X_aGly</code>, which is used only in the glycol medium redeclaration.
</p>
</html>", revisions="<html>
<ul>
<li>
July 27, 2026, by Lone Meertens:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4483\">Buildings, #4483</a>.
</li>
</ul>
</html>"));
end PressureDropPipeTDep;
