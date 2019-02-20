within Buildings.Fluid.Actuators.BaseClasses;
model ActuatorSignal
  "Partial model that implements the filtered opening for valves and dampers"

  parameter Boolean use_inputFilter=true
    "= true, if opening is filtered with a 2nd order CriticalDamping filter"
    annotation(Dialog(tab="Dynamics", group="Filtered opening"));
  parameter Modelica.SIunits.Time riseTime=120
    "Rise time of the filter (time to reach 99.6 % of an opening step)"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",enable=use_inputFilter));
  parameter Integer order(min=1) = 2 "Order of filter"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",enable=use_inputFilter));
  parameter Modelica.Blocks.Types.Init init=Modelica.Blocks.Types.Init.InitialOutput
    "Type of initialization (no init/steady state/initial state/initial output)"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",enable=use_inputFilter));
  parameter Real y_start=1 "Initial value of output"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",enable=use_inputFilter));

  Modelica.Blocks.Interfaces.RealInput y(min=0, max=1)
    "Actuator position (0: closed, 1: open)"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
          rotation=270,
        origin={0,120}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,120})));

  Modelica.Blocks.Interfaces.RealOutput y_actual "Actual valve position"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));

  // Classes used to implement the filtered opening
protected
  Modelica.Blocks.Interfaces.RealOutput y_filtered if use_inputFilter
    "Filtered valve position in the range 0..1"
    annotation (Placement(transformation(extent={{40,78},{60,98}}),
        iconTransformation(extent={{60,50},{80,70}})));

  Modelica.Blocks.Continuous.Filter filter(
     final order=order,
     f_cut=5/(2*Modelica.Constants.pi*riseTime),
     final init=init,
     final y_start=y_start,
     final analogFilter=Modelica.Blocks.Types.AnalogFilter.CriticalDamping,
     final filterType=Modelica.Blocks.Types.FilterType.LowPass,
     x(each stateSelect=StateSelect.always)) if
        use_inputFilter
    "Second order filter to approximate valve opening time, and to improve numerics"
    annotation (Placement(transformation(extent={{6,81},{20,95}})));

equation
 connect(filter.y, y_filtered) annotation (Line(
      points={{20.7,88},{50,88}},
      color={0,0,127}));
  if use_inputFilter then
  connect(y, filter.u) annotation (Line(
      points={{1.11022e-15,120},{1.11022e-15,88},{4.6,88}},
      color={0,0,127}));
  connect(filter.y, y_actual) annotation (Line(
      points={{20.7,88},{30,88},{30,70},{50,70}},
      color={0,0,127}));
  else
    connect(y, y_actual) annotation (Line(
      points={{1.11022e-15,120},{0,120},{0,70},{50,70}},
      color={0,0,127}));
  end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Line(
          points={{0,40},{0,100}}),
        Line(
          points={{0,70},{40,70}}),
        Rectangle(
          visible=use_inputFilter,
          extent={{-32,40},{32,100}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Ellipse(
          visible=use_inputFilter,
          extent={{-32,100},{32,40}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Text(
          visible=use_inputFilter,
          extent={{-20,92},{20,48}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          textString="M",
          textStyle={TextStyle.Bold})}),
Documentation(info="<html>
<p>
This model implements the filter that is used to approximate the travel
time of the actuator.
Models that extend this model use the signal
<code>y_actual</code> to obtain the
current position of the actuator.
</p>
<p>
The filter order can be changed to modify the transient response
of the actuator.
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
