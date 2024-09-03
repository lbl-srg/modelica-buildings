within Buildings.Fluid.Actuators.Dampers;
model MixingBoxMinimumFlow
  "Outside air mixing box with parallel damper for minimum outside air flow rate"
 extends Buildings.Fluid.Actuators.Dampers.MixingBox;
  import Modelica.Constants;

  parameter Modelica.Units.SI.MassFlowRate mOutMin_flow_nominal
    "Mass flow rate minimum outside air damper"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpDamOutMin_nominal(min=0,
      displayUnit="Pa") "Pressure drop of damper in minimum outside air leg"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpFixOutMin_nominal(
    min=0,
    displayUnit="Pa") = 0
    "Pressure drop of duct and other resistances in minimum outside air leg"
    annotation (Dialog(group="Nominal condition"));
  parameter Real yOutMin_start=y_start
    "Initial value of signal for minimum outside air damper"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",enable=use_inputFilter));

  Modelica.Fluid.Interfaces.FluidPort_a port_OutMin(redeclare package Medium =
        Medium, m_flow(start=0, min=if allowFlowReversal then -Constants.inf else
                0))
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,90},{-90,110}}), iconTransformation(extent={{-110,90},{-90,110}})));
  Modelica.Blocks.Interfaces.RealInput yOutMin
    "Damper position minimum outside air (0: closed, 1: open)"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
          rotation=270,
        origin={-60,120}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-60,120})));
  Modelica.Blocks.Interfaces.RealOutput yOutMin_actual "Actual valve position"
    annotation (Placement(transformation(extent={{-52,58},{-32,78}}),
        iconTransformation(extent={{-52,58},{-32,78}})));

  Buildings.Fluid.Actuators.Dampers.Exponential damOAMin(
    redeclare final package Medium = Medium,
    final from_dp=from_dp,
    final linearized=linearized,
    final use_deltaM=use_deltaM,
    final deltaM=deltaM,
    final roundDuct=roundDuct,
    final ReC=ReC,
    final a=a,
    final b=b,
    final yL=yL,
    final yU=yU,
    final k1=k1,
    final l=l,
    final use_constant_density=use_constant_density,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=mOutMin_flow_nominal,
    final dpDamper_nominal=dpDamOutMin_nominal,
    final dpFixed_nominal=dpFixOutMin_nominal,
    final use_inputFilter=false) "Damper for minimum outside air intake"
    annotation (Placement(transformation(extent={{48,32},{68,52}})));
protected
  Modelica.Blocks.Interfaces.RealOutput yOutMin_filtered if use_inputFilter
    "Filtered damper position in the range 0..1"
    annotation (Placement(transformation(extent={{-32,78},{-12,98}}),
        iconTransformation(extent={{60,50},{80,70}})));

  Buildings.Fluid.BaseClasses.ActuatorFilter filterOutMin(
    final n=order,
    final f=fCut,
    final normalized=true,
    final initType=Modelica.Blocks.Types.Init.InitialOutput,
    final y_start=y_start) if use_inputFilter
    "Second order filter to approximate valve opening time, and to improve numerics"
    annotation (Placement(transformation(extent={{-56,81},{-42,95}})));

equation
 connect(filterOutMin.y, yOutMin_filtered) annotation (Line(
      points={{-41.3,88},{-22,88}},
      color={0,0,127},
      smooth=Smooth.None));
  if use_inputFilter then
  connect(yOutMin, filterOutMin.u) annotation (Line(
      points={{-60,120},{-60,88},{-57.4,88}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(filterOutMin.y, yOutMin_actual) annotation (Line(
      points={{-41.3,88},{-36,88},{-36,68},{-42,68}},
      color={0,0,127},
      smooth=Smooth.None));
  else
    connect(yOutMin, yOutMin_actual) annotation (Line(
      points={{-60,120},{-60,68},{-42,68}},
      color={0,0,127},
      smooth=Smooth.None));
  end if;
  //////
  connect(port_OutMin, damOAMin.port_a) annotation (Line(
      points={{-100,100},{-80,100},{-80,72},{-68,72},{-68,42},{48,42}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(damOAMin.port_b, port_Sup) annotation (Line(
      points={{68,42},{80,42},{80,60},{100,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(yOutMin_actual, damOAMin.y) annotation (Line(
      points={{-42,68},{-12,68},{-12,58},{58,58},{58,54}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (                       Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-60,34},{80,28}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-126,144},{-86,112}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yMin"),
        Rectangle(
          extent={{-98,98},{-54,92}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,92},{-54,34}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-68,62},{-50,84},{-42,84},{-60,62},{-68,62}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),
defaultComponentName="eco",
Documentation(revisions="<html>
<ul>
<li>
June 10, 2021, by Michael Wetter:<br/>
Changed implementation of the filter.<br/>
This is for consistency with the changes done in
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1498\">#1498</a>.
</li>
<li>
February 26, 2020, by Antoine Gautier:<br/>
Updated parameter bindings consistently with refactoring of
<a href=\"modelica://Buildings.Fluid.Actuators.BaseClasses.PartialDamperExponential\">
Buildings.Fluid.Actuators.BaseClasses.PartialDamperExponential</a>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1188\">#1188</a>.
</li>
<li>
March 24, 2017, by Michael Wetter:<br/>
Renamed <code>filteredInput</code> to <code>use_inputFilter</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/665\">#665</a>.
</li>
<li>
March 22, 2017, by Michael Wetter:<br/>
Removed the assignments of <code>AOut</code>, <code>AExh</code>, <code>AOutMin</code>
and <code>ARec</code> as these are done in the damper instance using
a final assignment of the parameter.
This allows scaling the model with <code>m_flow_nominal</code>,
which is generally known in the flow leg,
and <code>v_nominal</code>, for which a default value can be specified.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/544\">#544</a>.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
February 14, 2012 by Michael Wetter:<br/>
Added filter to approximate the travel time of the actuator.
</li>
<li>
February 3, 2012, by Michael Wetter:<br/>
Removed assignment of <code>m_flow_small</code> as it is no
longer used in its base class.
</li>
<li>
February 24, 2010 by Michael Wetter:<br/>
Changed implementation of flow resistance. Instead of using a
fixed resistance and a damper model in series, only one model is used
that internally adds these two resistances. This leads to smaller systems
of nonlinear equations. This new implementation extends
<a href=\"modelica://Buildings.Fluid.Actuators.Dampers.MixingBox\">
Buildings.Fluid.Actuators.Dampers.MixingBox</a>.
</li>
<li>
July 20, 2007 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Model of an outside air mixing box with air dampers and a flow path for the minimum outside air flow rate.
</p>
<p>
If <code>dp_nominalIncludesDamper=true</code>, then the parameter <code>dp_nominal</code>
is equal to the pressure drop of the damper plus the fixed flow resistance at the nominal
flow rate.
If <code>dp_nominalIncludesDamper=false</code>, then <code>dp_nominal</code>
does not include the flow resistance of the air damper.
</p>
</html>"));
end MixingBoxMinimumFlow;
