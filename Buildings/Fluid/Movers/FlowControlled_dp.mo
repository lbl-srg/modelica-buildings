within Buildings.Fluid.Movers;
model FlowControlled_dp
  "Fan or pump with ideally controlled head dp as input signal"
  extends Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine(
    final preVar=Buildings.Fluid.Movers.BaseClasses.Types.PrescribedVariable.PressureDifference,
    final computePowerUsingSimilarityLaws=per.havePressureCurve,
    preSou(dp_start=dp_start, control_dp= not prescribeSystemPressure),
    final stageInputs(each final unit="Pa") = heads,
    final constInput(final unit="Pa") = constantHead,
    filter(
      final y_start=dp_start,
      u_nominal=abs(dp_nominal),
      u(final unit="Pa"),
      y(final unit="Pa")),
    eff(
      per(
        final pressure = if per.havePressureCurve then
          per.pressure
        else
          Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters(
            V_flow = {i/(nOri-1)*2.0*m_flow_nominal/rho_default for i in 0:(nOri-1)},
            dp =     {i/(nOri-1)*2.0*dp_nominal for i in (nOri-1):-1:0}),
      final use_powerCharacteristic = if per.havePressureCurve then per.use_powerCharacteristic else false)));

  parameter Modelica.SIunits.PressureDifference dp_start(
    min=0,
    displayUnit="Pa")=0 "Initial value of pressure raise"
    annotation(Dialog(tab="Dynamics", group="Filtered speed"));

  // For air, we set dp_nominal = 600 as default, for water we set 10000
  parameter Modelica.SIunits.PressureDifference dp_nominal(
    min=0,
    displayUnit="Pa")=
      if rho_default < 500 then 500 else 10000 "Nominal pressure raise, used to normalized the filter if use_inputFilter=true,
        to set default values of constantHead and heads, and
        and for default pressure curve if not specified in record per"
    annotation(Dialog(group="Nominal condition"));

  parameter Modelica.SIunits.PressureDifference constantHead(
    min=0,
    displayUnit="Pa")=dp_nominal
    "Constant pump head, used when inputType=Constant"
    annotation(Dialog(enable=inputType == Buildings.Fluid.Types.InputType.Constant));

  // By default, set heads proportional to sqrt(speed/speed_nominal)
  parameter Modelica.SIunits.PressureDifference[:] heads(
    each min=0,
    each displayUnit="Pa")=
    dp_nominal*{(per.speeds[i]/per.speeds[end])^2 for i in 1:size(per.speeds, 1)}
    "Vector of head set points, used when inputType=Stages"
    annotation(Dialog(enable=inputType == Buildings.Fluid.Types.InputType.Stages));
  parameter Boolean prescribeSystemPressure = false
    "=true, to control mover such that pressure difference is obtained across two remote points in system"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

  Modelica.Blocks.Interfaces.RealInput dpMea(
    final quantity="PressureDifference",
    final displayUnit="Pa",
    final unit="Pa")=gain.u if prescribeSystemPressure
    "Measurement of pressure difference between two points where the set point should be obtained"
    annotation (Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=90,
        origin={-80,120})));

  Modelica.Blocks.Interfaces.RealInput dp_in(final unit="Pa") if
    inputType == Buildings.Fluid.Types.InputType.Continuous
    "Prescribed pressure rise"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,120}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,120})));

  Modelica.Blocks.Interfaces.RealOutput dp_actual(final unit="Pa")
    "Pressure difference between the mover inlet and outlet"
    annotation (Placement(transformation(extent={{100,40},{120,60}}),
        iconTransformation(extent={{100,40},{120,60}})));

protected
  Modelica.Blocks.Math.Gain gain(final k=-1)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={36,30})));
equation
  assert(inputSwitch.u >= -1E-3,
    "Pressure set point for mover cannot be negative. Obtained dp = " + String(inputSwitch.u));

  if use_inputFilter then
    connect(filter.y, gain.u) annotation (Line(
      points={{34.7,88},{36,88},{36,42}},
      color={0,0,127},
      smooth=Smooth.None));
  else
    connect(inputSwitch.y, gain.u) annotation (Line(
      points={{1,50},{36,50},{36,42}},
      color={0,0,127},
      smooth=Smooth.None));
  end if;

  connect(inputSwitch.u, dp_in) annotation (Line(
      points={{-22,50},{-26,50},{-26,80},{0,80},{0,120}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preSou.dp_in, gain.y) annotation (Line(
      points={{56,8},{56,14},{36,14},{36,19}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senRelPre.p_rel, dp_actual) annotation (Line(points={{50.5,-26.35},{
          50.5,-38},{74,-38},{74,50},{110,50}},
                                           color={0,0,127}));
  annotation (defaultComponentName="fan",
  Documentation(info="<html>
<p>
This model describes a fan or pump with prescribed head.
The input connector provides the difference between
outlet minus inlet pressure.
The efficiency of the device is computed based
on the efficiency and pressure curves that are defined
in record <code>per</code>, which is of type
<a href=\"modelica://Buildings.Fluid.Movers.SpeedControlled_Nrpm\">
Buildings.Fluid.Movers.SpeedControlled_Nrpm</a>.
</p>
<h4>Main equations</h4>
<p>
See the
<a href=\"modelica://Buildings.Fluid.Movers.UsersGuide\">
User's Guide</a>.
</p>
<h4>Typical use and important parameters</h4>
<p>
If <code>use_inputFilter=true</code>, then the parameter <code>dp_nominal</code> is
used to normalize the filter. This is used to improve the numerics of the transient response.
The actual pressure raise of the mover at steady-state is independent
of the value of <code>dp_nominal</code>. It is recommended to set
<code>dp_nominal</code> to approximately the pressure raise that the mover has during
full speed.
</p>
<h4>Options</h4>
<p>
Parameter <code>prescribeSystemPressure</code>
can be used to control the mover such that the pressure
difference set point is obtained across two points
in the system, instead of across the fan.
This allows an efficient implementation of
static pressure reset controllers.
A measurement of the pressure difference between the
two points in system then needs to be connected
to <code>RealInput dpMea</code>.
This functionality is demonstrated in
<a href=\"modelica://Buildings.Fluid.Movers.Validation.FlowControlled_dpSystem\">
Buildings.Fluid.Movers.Validation.FlowControlled_dpSystem</a>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
May 5, 2017, by Filip Jorissen:<br/>
Added parameters, documentation and functionality for
<code>prescribeSystemPressure</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/770\">#770</a>.
</li>
<li>
March 24, 2017, by Michael Wetter:<br/>
Renamed <code>filteredSpeed</code> to <code>use_inputFilter</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/665\">#665</a>.
</li>
<li>
December 2, 2016, by Michael Wetter:<br/>
Removed <code>min</code> attribute as otherwise numerical noise can cause
the assertion on the limit to fail.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/606\">#606</a>.
</li>
<li>
November 14, 2016, by Michael Wetter:<br/>
Changed default values for <code>heads</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/583\">#583</a>.
</li>
<li>
March 2, 2016, by Filip Jorissen:<br/>
Refactored model such that it directly extends <code>PartialFlowMachine</code>.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/417\">#417</a>.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
November 5, 2015, by Michael Wetter:<br/>
Removed the parameters <code>use_powerCharacteristics</code> and <code>power</code>
from the performance data record <code>per</code>
because
<a href=\"modelica://Buildings.Fluid.Movers.FlowControlled_dp\">
Buildings.Fluid.Movers.FlowControlled_dp</a>
and
<a href=\"modelica://Buildings.Fluid.Movers.FlowControlled_m_flow\">
Buildings.Fluid.Movers.FlowControlled_m_flow</a>
fix the flow rate or head, which can give a flow work that is higher
than the power consumption specified in this record.
Hence, users should use the efficiency data for this model.
The record has been moved to
<a href=\"modelica://Buildings.Fluid.Movers.Data.SpeedControlled_y\">
Buildings.Fluid.Movers.Data.SpeedControlled_y</a>
as it makes sense to use it for the movers
<a href=\"modelica://Buildings.Fluid.Movers.FlowControlled_Nrpm\">
Buildings.Fluid.Movers.FlowControlled_Nrpm</a>
and
<a href=\"modelica://Buildings.Fluid.Movers.FlowControlled_y\">
Buildings.Fluid.Movers.FlowControlled_y</a>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/457\">
issue 457</a>.
</li>
<li>
April 2, 2015, by Filip Jorissen:<br/>
Added code for supporting stage input and constant input.
</li>
<li>
January 6, 2015, by Michael Wetter:<br/>
Revised model for OpenModelica.
</li>
<li>
February 14, 2012, by Michael Wetter:<br/>
Added filter for start-up and shut-down transient.
</li>
<li>
May 25, 2011, by Michael Wetter:<br/>
Revised implementation of energy balance to avoid having to use conditionally removed models.
</li>
<li>
July 27, 2010, by Michael Wetter:<br/>
Redesigned model to fix bug in medium balance.
</li>
<li>July 5, 2010, by Michael Wetter:<br/>
Changed <code>assert(dp_in >= 0, ...)</code> to <code>assert(dp_in >= -0.1, ...)</code>.
The former implementation triggered the assert if <code>dp_in</code> was solved for
in a nonlinear equation since the solution can be slightly negative while still being
within the solver tolerance.
</li>
<li>March 24, 2010, by Michael Wetter:<br/>
Revised implementation to allow zero flow rate.
</li>
<li>October 1, 2009,
    by Michael Wetter:<br/>
       Added model to the Buildings library.
</ul>
</html>"),
    Icon(graphics={
        Line(
          points={{2,50},{100,50}},
          color={0,0,0},
          smooth=Smooth.None),
        Text(
          visible = inputType == Buildings.Fluid.Types.InputType.Continuous,
          extent={{20,142},{104,108}},
          textString="dp_in"),
        Text(extent={{60,66},{110,52}},
          lineColor={0,0,127},
          textString="dp"),
        Rectangle(
          visible=use_inputFilter,
          extent={{-34,40},{32,100}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Ellipse(
          visible=use_inputFilter,
          extent={{-34,100},{32,40}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Text(
          visible=use_inputFilter,
          extent={{-22,92},{20,46}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          textString="M",
          textStyle={TextStyle.Bold})}));
end FlowControlled_dp;
