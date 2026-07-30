within Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Examples;
model PressureDropCircularPipeMassFlowDriven
  "Validation of PressureDropCircularPipe with mass-flow-driven flow"
  extends .Modelica.Icons.Example;

  package Medium = .Buildings.Media.Water;

  parameter .Modelica.Units.SI.Pressure p0 = 300000
    "Boundary pressure";
  parameter .Modelica.Units.SI.MassFlowRate m_flow_nominal = 0.3
    "Nominal mass flow rate";
  parameter .Modelica.Units.SI.MassFlowRate m_flowAmplitude = 0.3
    "Amplitude of imposed mass flow rate";
  parameter .Modelica.Units.SI.Length length = 100
    "Pipe length";
  parameter .Modelica.Units.SI.Radius rTub = 0.02
    "Outer tube radius";
  parameter .Modelica.Units.SI.Length eTub = 0.002
    "Tube wall thickness";
  parameter .Modelica.Units.SI.Length roughness = 0.001e-3
    "Absolute pipe wall roughness";
  parameter .Modelica.Units.SI.Density rhoMed = 1000
    "Fluid density";
  parameter .Modelica.Units.SI.DynamicViscosity muMed = 1e-3
    "Fluid dynamic viscosity";
  parameter Integer nUBend(min=0) = 1
    "Number of U-bends";
  parameter Real KUBend(unit="1", min=0) = 2
    "Minor-loss coefficient of one U-bend";

  final parameter Real KMinor(unit="1") = nUBend*KUBend
    "Total minor-loss coefficient";

  .Buildings.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    T=293.15,
    nPorts=1)
    "Mass flow source"
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));

  .Buildings.Fluid.Sources.Boundary_pT bou(
    redeclare package Medium = Medium,
    p=p0,
    T=293.15,
    nPorts=1)
    "Pressure boundary"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

  .Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.PressureDropCircularPipe preDro(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    computePressureDrop=true,
    length=length,
    rTub=rTub,
    eTub=eTub,
    roughness=roughness,
    rhoMed=rhoMed,
    muMed=muMed,
    nUBend=nUBend,
    KUBend=KUBend)
    "Pressure-drop component"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  .Modelica.Blocks.Sources.Sine mFlo(
    amplitude=m_flowAmplitude,
    f=1/1000,
    offset=0)
    "Prescribed mass flow rate"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));

  .Modelica.Units.SI.MassFlowRate m_flowSet
    "Prescribed mass flow rate";

  .Modelica.Units.SI.PressureDifference dpFun
    "Pressure drop recomputed from imposed mass flow rate";

  .Modelica.Units.SI.PressureDifference dpFunNoMinor
    "Pressure drop recomputed without minor losses";

  .Modelica.Units.SI.PressureDifference dpMinor
    "Minor-loss contribution";

  .Modelica.Units.SI.PressureDifference errDp
    "Difference between component pressure drop and function evaluation";

equation
  connect(mFlo.y, sou.m_flow_in)
    annotation (Line(points={{-79,40},{-74,40},{-74,8},{-72,8}}, color={0,0,127}));

  connect(sou.ports[1], preDro.port_a)
    annotation (Line(points={{-50,0},{-10,0}}, color={0,127,255}));

  connect(preDro.port_b, bou.ports[1])
    annotation (Line(points={{10,0},{60,0}}, color={0,127,255}));

  m_flowSet = mFlo.y;

  dpFun =
    .Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.pressureLossCircularPipe(
      length=length,
      rTub=rTub,
      eTub=eTub,
      roughness=roughness,
      rhoMed=rhoMed,
      muMed=muMed,
      m_flow=preDro.m_flow,
      KMinor=KMinor);

  dpFunNoMinor =
    .Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.pressureLossCircularPipe(
      length=length,
      rTub=rTub,
      eTub=eTub,
      roughness=roughness,
      rhoMed=rhoMed,
      muMed=muMed,
      m_flow=preDro.m_flow,
      KMinor=0);

  dpMinor = dpFun - dpFunNoMinor;

  errDp = preDro.dp - dpFun;

  annotation (
    __Dymola_Commands(file=
      "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/BaseClasses/Boreholes/BaseClasses/Examples/PressureDropCircularPipeMassFlowDriven.mos"
      "Simulate and plot"),
    experiment(
      StopTime=2000,
      Tolerance=1e-6),
    Documentation(info="<html>
<p>
This validation model checks the mass-flow-driven use case of
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.PressureDropCircularPipe\">
Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.PressureDropCircularPipe</a>.
</p>

<p>
The mass flow rate is imposed by a mass flow source, and the pressure drop is
computed by the pressure-drop component. This validates the forward hydraulic
relation
</p>
<p align=\"center\" style=\"font-style:italic;\">
  m&#775; &rarr; &Delta;p.
</p>

<p>
The imposed mass flow rate is sinusoidal and crosses zero. This checks positive
flow, reverse flow, and the low-flow region.
</p>

<p>
The model recomputes the pressure drop with
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.pressureLossCircularPipe\">
Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.pressureLossCircularPipe</a>
using the mass flow rate from the component. The variable <code>errDp</code>
should remain close to zero.
</p>

<p>
The variable <code>dpFunNoMinor</code> is the pressure drop without U-bend
minor losses, and <code>dpMinor</code> is the added U-bend minor-loss
contribution.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 22, 2026, by L. Meertens:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4656\">Buildings, #4656</a>.
</li>
</ul>
</html>"));

end PressureDropCircularPipeMassFlowDriven;
