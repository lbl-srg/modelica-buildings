within Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Examples;
model PressureDropPipePressureDriven
  "Validation of PressureDropPipeDarcy
 with pressure-driven flow"
  extends .Modelica.Icons.Example;

  package Medium = .Buildings.Media.Water;

  parameter .Modelica.Units.SI.Pressure p0 = 300000
    "Base pressure";
  parameter .Modelica.Units.SI.PressureDifference dpAmplitude = 5000
    "Amplitude of imposed pressure difference";
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
  parameter .Modelica.Units.SI.MassFlowRate m_flow_nominal = 0.3
    "Nominal mass flow rate";
  parameter Integer nUBend(min=0) = 1
    "Number of U-bends";
  parameter Real kUBend(unit="1", min=0) = 2
    "Minor-loss coefficient of one U-bend";
  final parameter Real kMinor(unit="1") = nUBend*kUBend
    "Total minor-loss coefficient";

  .Buildings.Fluid.Sources.Boundary_pT bouA(
    redeclare package Medium = Medium,
    use_p_in=true,
    T=293.15,
    nPorts=1)
    "Pressure boundary with prescribed pressure"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  .Buildings.Fluid.Sources.Boundary_pT bouB(
    redeclare package Medium = Medium,
    p=p0,
    T=293.15,
    nPorts=1)
    "Fixed downstream pressure boundary"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

  .Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.PressureDropPipeDarcy preDro(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    computePressureDrop=true,
    length=length,
    rTub=rTub,
    eTub=eTub,
    roughness=roughness,
    rhoMed_default=rhoMed,
    muMed_default=muMed,
    nUBend=nUBend,
    kUBend=kUBend)
    "Pressure-drop component"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  .Modelica.Blocks.Sources.Sine dpPre(
    amplitude=dpAmplitude,
    f=1/1000,
    offset=0)
    "Prescribed pressure difference"
    annotation (Placement(transformation(extent={{-100.0,34.0},{-80.0,54.0}},rotation = 0.0,origin = {0.0,0.0})));

  .Modelica.Blocks.Sources.Constant pBas(k=p0)
    "Base pressure"
    annotation (Placement(transformation(extent={{-100.0,68.0},{-80.0,88.0}},rotation = 0.0,origin = {0.0,0.0})));

  .Modelica.Blocks.Math.Add pA(k1=1, k2=1)
    "Upstream pressure"
    annotation (Placement(transformation(extent={{-60.0,52.0},{-40.0,72.0}},rotation = 0.0,origin = {0.0,0.0})));

  .Modelica.Units.SI.PressureDifference dpSet
    "Prescribed pressure difference";

  .Modelica.Units.SI.PressureDifference dpFun
    "Pressure drop recomputed from solved mass flow rate";

  .Modelica.Units.SI.PressureDifference dpFunNoMinor
    "Pressure drop recomputed without minor losses";

  .Modelica.Units.SI.PressureDifference dpMinor
    "Minor-loss contribution";

  .Modelica.Units.SI.PressureDifference errDp
    "Difference between component pressure drop and function evaluation";
  
  .Modelica.Units.SI.PressureDifference dpFunMajor;
  .Modelica.Units.SI.PressureDifference dpFunMinor;
  .Modelica.Units.SI.ReynoldsNumber ReFun;

  .Modelica.Units.SI.PressureDifference dpFunNoMinorMajor;
  .Modelica.Units.SI.PressureDifference dpFunNoMinorMinor;
  .Modelica.Units.SI.ReynoldsNumber ReFunNoMinor;

equation
  connect(pBas.y, pA.u1)
    annotation (Line(points={{-79,78},{-70,78},{-70,68},{-62,68}}, color={0,0,127}));

  connect(dpPre.y, pA.u2)
    annotation (Line(points={{-79,44},{-70,44},{-70,56},{-62,56}}, color={0,0,127}));

  connect(pA.y, bouA.p_in)
    annotation (Line(points={{-39,62},{-34,62},{-34,20},{-88,20},{-88,8},{-82,8}}, color={0,0,127}));

  connect(bouA.ports[1], preDro.port_a)
    annotation (Line(points={{-60,0},{-10,0}}, color={0,127,255}));

  connect(preDro.port_b, bouB.ports[1])
    annotation (Line(points={{10,0},{60,0}}, color={0,127,255}));

  dpSet = dpPre.y;

  (dpFun, dpFunMajor, dpFunMinor, ReFun) =
    .Buildings.Fluid.FixedResistances.Functions.pressureLossPipe(
      length=length,
      rTub=rTub,
      eTub=eTub,
      roughness=roughness,
      rhoMed=rhoMed,
      muMed=muMed,
      m_flow=preDro.m_flow,
      kMinor=kMinor);

  (dpFunNoMinor, dpFunNoMinorMajor, dpFunNoMinorMinor, ReFunNoMinor) =
    .Buildings.Fluid.FixedResistances.Functions.pressureLossPipe(
      length=length,
      rTub=rTub,
      eTub=eTub,
      roughness=roughness,
      rhoMed=rhoMed,
      muMed=muMed,
      m_flow=preDro.m_flow,
      kMinor=0);

  dpMinor = dpFun - dpFunNoMinor;

  errDp = preDro.dp - dpFun;

  annotation (
    __Dymola_Commands(file=
      "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/BaseClasses/Boreholes/BaseClasses/Examples/PressureDropPipePressureDriven.mos"
      "Simulate and plot"),
    experiment(
      StopTime=2000,
      Tolerance=1e-6),
    Documentation(info="<html>
<p>
This validation model checks the pressure-driven use case of
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.PressureDropPipeDarcy\">
Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.PressureDropPipeDarcy</a>.
</p>

<p>
The pressure difference is imposed by pressure boundaries, and the mass flow
rate is solved by the hydraulic network. This validates the inverse hydraulic
relation
</p>
<p align=\"center\" style=\"font-style:italic;\">
  &Delta;p &rarr; m&#775;.
</p>

<p>
The imposed pressure difference is sinusoidal and crosses zero. This checks
positive flow, reverse flow, and the low-flow region.
</p>

<p>
The model recomputes the pressure drop with
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.pressureLossCircularPipe\">
Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.pressureLossCircularPipe</a>
using the mass flow rate solved in the component. The variable
<code>errDp</code> should remain close to zero.
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

end PressureDropPipePressureDriven;
