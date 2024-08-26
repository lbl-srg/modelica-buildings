within Buildings.Fluid.Actuators.BaseClasses;
model ActuatorSignal
  "Partial model that implements the filtered opening for valves and dampers"

  constant Integer order(min=1) = 2 "Order of filter";

  parameter Boolean use_inputFilter=true
    "= true, if opening is filtered with a 2nd order CriticalDamping filter"
    annotation(Dialog(tab="Dynamics", group="Filtered opening"));

  parameter Boolean use_linearDynamics = true
    "Set to true to use an actuator dynamics that models the change in actuator position linear in time"
    annotation(Dialog(tab="Dynamics", group="Filtered opening"));

  parameter Modelica.Units.SI.Time riseTime=120
    "Rise time of the filter (time to reach 99.6 % of an opening step)"
    annotation (Dialog(
      tab="Dynamics",
      group="Filtered opening",
      enable=use_inputFilter));
  parameter Modelica.Blocks.Types.Init init=Modelica.Blocks.Types.Init.InitialOutput
    "Type of initialization (no init/steady state/initial state/initial output)"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",enable=use_inputFilter));
  parameter Real y_start=1 "Initial position of actuator"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",enable=use_inputFilter));

  Modelica.Blocks.Interfaces.RealInput y(min=0, max=1)
    "Actuator position (0: closed, 1: open)"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
          rotation=270,
        origin={0,120}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,120})));

  Modelica.Blocks.Interfaces.RealOutput y_actual
    "Actual actuator position"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));

  // Classes used to implement the filtered opening
protected
  final parameter Modelica.Units.SI.Frequency fCut=5/(2*Modelica.Constants.pi*
      riseTime) "Cut-off frequency of filter";

  parameter Boolean casePreInd = false
    "In case of PressureIndependent the model I/O is modified"
    annotation(Evaluate=true);
  Modelica.Blocks.Interfaces.RealOutput y_internal(unit="1")
    "Output connector for internal use (= y_actual if not casePreInd)";
  Modelica.Blocks.Interfaces.RealOutput y_filtered if use_inputFilter
    "Filtered valve position in the range 0..1"
    annotation (Placement(transformation(extent={{40,78},{60,98}}),
        iconTransformation(extent={{60,50},{80,70}})));

  Buildings.Fluid.BaseClasses.ActuatorFilter filter(
    final n=order,
    final f=fCut,
    final normalized=true,
    final initType=init,
    final y_start=y_start) if use_inputFilter and not use_linearDynamics
    "Second order filter to approximate actuator opening time, and to improve numerics"
    annotation (Placement(transformation(extent={{16,89},{24,96}})));

  Modelica.Blocks.Nonlinear.SlewRateLimiter actPos(
    Rising=1/riseTime,
    Falling=-1/riseTime,
    Td=10/riseTime,
    initType=init,
    y_start=y_start,
    strict=true)
    if use_inputFilter and use_linearDynamics
      "Actuator position"
    annotation (Placement(transformation(extent={{16,76},{24,84}})));
equation
  connect(filter.y, y_filtered)
    annotation (Line(points={{24.4,92.5},{34,92.5},{34,88},{50,88}},
                     color={0,0,127}));
  connect(actPos.y, y_filtered)
    annotation (Line(points={{24.4,80},{34,80},{34,88},
          {50,88}}, color={0,0,127}));

  if use_inputFilter then
    connect(y, filter.u) annotation (Line(points={{0,120},{0,92.5},{15.2,92.5}},
                           color={0,0,127}));
  connect(actPos.u, y)
    annotation (Line(points={{15.2,80},{0,80},{0,120}}, color={0,0,127}));

    connect(y_filtered, y_internal);
  else
    connect(y, y_internal) annotation (Line(
      points={{1.11022e-15,120},{0,120},{0,70},{50,70}},
      color={0,0,127}));
  end if;
  if not casePreInd then
    connect(y_internal, y_actual);
  end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Line(
          points={{0,48},{0,108}}),
        Line(
          points={{0,70},{40,70}}),
        Rectangle(
          visible=use_inputFilter,
          extent={{-32,40},{34,100}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Ellipse(
          visible=use_inputFilter,
          extent={{-32,100},{34,40}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Text(
          visible=use_inputFilter,
          extent={{-20,94},{22,48}},
          textColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          textString="M",
          textStyle={TextStyle.Bold}),
        Text(
          extent={{-40,126},{-160,76}},
          textColor={0,0,0},
          textString=DynamicSelect("", String(y, format=".2f")))}),
Documentation(info="<html>
<p>
This model implements the filter that is used to approximate the travel
time of the actuator.
Models that extend this model use the signal
<code>y_actual</code> to obtain the
current position of the actuator.
</p>
<p>
See
<a href=\"modelica://Buildings.Fluid.Actuators.UsersGuide\">
Buildings.Fluid.Actuators.UsersGuide</a>
for a description of the filter.
</p>
</html>", revisions="<html>
<ul>
<li>
June 10, 2021, by Michael Wetter:<br/>
Changed implementation of the filter and changed the parameter <code>order</code> to a constant
as most users need not change this value.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1498\">#1498</a>.
</li>
<li>
April 6, 2020, by Antoine Gautier:<br/>
Add the boolean parameter <code>casePreInd</code>.<br/>
This is needed for the computation of the damper opening in
<a href=\"modelica://Buildings.Fluid.Actuators.Dampers.PressureIndependent\">
Buildings.Fluid.Actuators.Dampers.PressureIndependent</a>.
</li>
<li>
February 21, 2020, by Michael Wetter:<br/>
Changed icon to display its operating state.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1294\">#1294</a>.
</li>
<li>
November 14, 2019, by Michael Wetter:<br/>
Set <code>start</code> attribute for <code>filter.x</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1252\">#1252</a>.
</li>
<li>
October 25, 2019, by Jianjun Hu:<br/>
Improved icon graphics annotation. This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1225\">#1225</a>.
</li>
<li>
February 16, 2018, by Filip Jorissen:<br/>
Propagated parameter <code>order</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/891\">#891</a>.
</li>
<li>
March 24, 2017, by Michael Wetter:<br/>
Renamed <code>filteredInput</code> to <code>use_inputFilter</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/665\">#665</a>.
</li>
<li>
February 14, 2012 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ActuatorSignal;
