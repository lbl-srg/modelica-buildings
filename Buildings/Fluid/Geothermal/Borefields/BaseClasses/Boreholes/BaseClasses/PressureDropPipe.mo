within Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses;
model PressureDropPipe
  "Pressure-drop model for borehole pipe segments"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface;

  parameter Boolean use_DarcyPressureDrop = false
    "Set to true to use Darcy-Weisbach pressure drop"
    annotation (Evaluate=true);

  parameter Boolean use_TDepPressureDrop = false
    "Set to true to evaluate density and viscosity from the current fluid temperature";

  parameter Modelica.Units.SI.Length length
    "Pipe length represented by this pressure-drop component";

  parameter Modelica.Units.SI.Radius rTub
    "Outer tube radius";

  parameter Modelica.Units.SI.Length eTub
    "Tube wall thickness";

  parameter Modelica.Units.SI.Length roughness = 0.001e-3
    "Absolute pipe wall roughness";

  parameter Integer nUBend(min=0) = 0
    "Number of U-bends represented by this pressure-drop component";

  parameter Real kUBend(unit="1", min=0) = 2
    "Minor-loss coefficient of one U-bend";

  parameter Boolean from_dp = false
    "Set to true to use pressure drop as state";

  parameter Boolean linearized = false
    "Set to true to linearize pressure-flow relation";

  parameter Real n(min=1, max=2) = 2
    "Flow exponent for old pressure-drop formulation";

  parameter Real deltaM(min=1E-6) = 0.3
    "Fraction of nominal flow rate where transition to turbulent occurs";

  constant Boolean homotopyInitialization = true
    "Set to true to use homotopy method"
    annotation (HideResult=true);

  parameter Modelica.Units.SI.PressureDifference dp_nominal
    "Nominal pressure drop for old pressure-drop formulation";

  Buildings.Fluid.FixedResistances.PressureDrop preDroFix(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final from_dp=from_dp,
    final linearized=linearized,
    final n=n,
    final deltaM=deltaM,
    final show_T=show_T,
    final homotopyInitialization=homotopyInitialization,
    final dp_nominal=if use_DarcyPressureDrop then 0 else dp_nominal)
    "Nominal pressure-drop model"
    annotation (Placement(transformation(extent={{-46.0,-10.0},{-26.0,10.0}},rotation = 0.0,origin = {0.0,0.0})));

  Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.PressureDropPipeDarcy preDroDar(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final computePressureDrop=use_DarcyPressureDrop,
    final use_TDepPressureDrop=use_TDepPressureDrop,
    final length=length,
    final rTub=rTub,
    final eTub=eTub,
    final roughness=roughness,
    final nUBend=nUBend,
    final kUBend=kUBend)
    "Darcy-Weisbach pressure-drop model"
    annotation (Placement(transformation(extent={{30.0,-10.0},{50.0,10.0}},rotation = 0.0,origin = {0.0,0.0})));

  Modelica.Units.SI.PressureDifference dpMajor = preDroDar.dpMajor
    "Major Darcy-Weisbach pressure drop";

  Modelica.Units.SI.PressureDifference dpMinor = preDroDar.dpMinor
    "Minor pressure drop";

  Modelica.Units.SI.ReynoldsNumber Re = preDroDar.Re
    "Reynolds number";

equation
  connect(preDroDar.port_b, port_b)
    annotation (Line(points={{50,0},{100,0}}, color={0,127,255}));
    connect(port_a,preDroFix.port_a) annotation(Line(points = {{-100,0},{-46,0}},color = {0,127,255}));
    connect(preDroFix.port_b,preDroDar.port_a) annotation(Line(points = {{-26,0},{30,0}},color = {0,127,255}));

  annotation (
    defaultComponentName="preDro",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,40},{100,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{-100,22},{100,-24}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Rectangle(
          visible=linearized,
          extent={{-100,22},{100,-22}},
          fillPattern=FillPattern.Backward,
          fillColor={0,128,255},
          pattern=LinePattern.None,
          lineColor={255,255,255}),
        Rectangle(
          extent=DynamicSelect({{-100,10},{-100,10}}, {{100,10},{100+200*max(-1, min(0, m_flow/(abs(m_flow_nominal)))),-10}}),
          lineColor={28,108,200},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent=DynamicSelect({{-100,10},{-100,10}}, {{-100,10},{-100+200*min(1, max(0, m_flow/abs(m_flow_nominal))),-10}}),
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None)}),
    Documentation(info="<html>
<p>
This component provides the pressure-drop model used in borehole pipe segments.
It switches between the nominal pressure-drop formulation from
<a href=\"modelica://Buildings.Fluid.FixedResistances.PressureDrop\">
Buildings.Fluid.FixedResistances.PressureDrop</a>
and the Darcy-Weisbach formulation from
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.PressureDropPipeDarcy\">
Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.PressureDropPipeDarcy</a>.
</p>
<p>
If <code>use_DarcyPressureDrop=false</code>, the nominal pressure-drop model is
active and the Darcy-Weisbach model imposes zero pressure drop.
</p>
<p>
If <code>use_DarcyPressureDrop=true</code>, the nominal pressure-drop model has
zero nominal pressure drop and the Darcy-Weisbach model is active.
</p>
<p>
The outputs <code>dpMajor</code>, <code>dpMinor</code>, and <code>Re</code> are
forwarded from the Darcy-Weisbach model and are intended for post-processing.
</p>
</html>", revisions="<html>
<ul>
<li>
July 31, 2026, by Lone Meertens:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4656\">Buildings, #4656</a>.
</li>
</ul>
</html>"));
end PressureDropPipe;
