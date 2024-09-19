within Buildings.Fluid.Actuators.BaseClasses;
model ActuatorSignal
  "Partial model that implements the filtered opening for valves and dampers"

  parameter Boolean use_strokeTime=true
    "Set to true to continuously open and close valve using strokeTime"
    annotation(Dialog(tab="Dynamics", group="Actuator position"));

  parameter Modelica.Units.SI.Time strokeTime=120
    "Time needed to open or close valve"
    annotation (Dialog(
      tab="Dynamics",
      group="Actuator position",
      enable=use_strokeTime));
  parameter Modelica.Blocks.Types.Init init=Modelica.Blocks.Types.Init.InitialOutput
    "Type of initialization (no init/steady state/initial state/initial output)"
    annotation(Dialog(tab="Dynamics", group="Actuator position",
                      enable=use_strokeTime));
  parameter Real y_start=1 "Initial position of actuator"
    annotation(Dialog(tab="Dynamics", group="Actuator position",
                      enable=use_strokeTime));

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
  parameter Boolean casePreInd = false
    "In case of PressureIndependent the model I/O is modified"
    annotation(Evaluate=true);
  Modelica.Blocks.Interfaces.RealOutput y_internal(unit="1")
    "Output connector for internal use (= y_actual if not casePreInd)";
  Modelica.Blocks.Interfaces.RealOutput y_filtered if use_strokeTime
    "Filtered valve position in the range 0..1"
    annotation (Placement(transformation(extent={{40,78},{60,98}}),
        iconTransformation(extent={{60,50},{80,70}})));

  Modelica.Blocks.Nonlinear.SlewRateLimiter actPos(
    Rising=1/strokeTime,
    Falling=-1/strokeTime,
    Td=0.001*strokeTime,
    initType=init,
    y_start=y_start,
    strict=true) if use_strokeTime "Actuator position"
    annotation (Placement(transformation(extent={{14,82},{26,94}})));
equation
  connect(actPos.y, y_filtered)
    annotation (Line(points={{26.6,88},{50,88}},
                    color={0,0,127}));

  if use_strokeTime then
  connect(actPos.u, y)
    annotation (Line(points={{12.8,88},{0,88},{0,120}}, color={0,0,127}));

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
          visible=use_strokeTime,
          extent={{-32,40},{34,100}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Ellipse(
          visible=use_strokeTime,
          extent={{-32,100},{34,40}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Text(
          visible=use_strokeTime,
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
August 26, 2024, by Michael Wetter:<br/>
Implemented linear actuator travel dynamics.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3965\">Buildings, #3965</a>.
</li>
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
Renamed <code>filteredInput</code> to <code>use_strokeTime</code>.<br/>
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
