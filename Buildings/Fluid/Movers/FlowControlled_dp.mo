within Buildings.Fluid.Movers;
model FlowControlled_dp
  "Fan or pump with ideally controlled head dp as input signal"
  extends Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine(
    final preVar=Buildings.Fluid.Movers.BaseClasses.Types.PrescribedVariable.PressureDifference,
    final computePowerUsingSimilarityLaws=per.havePressureCurve,
    preSou(dp_start=dp_start),
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
            V_flow=  {i/(nOri-1)*2.0*m_flow_nominal/rho_default for i in 0:(nOri-1)},
            dp=      {i/(nOri-1)*2.0*dp_nominal for i in (nOri-1):-1:0}),
      final use_powerCharacteristic = if per.havePressureCurve then per.use_powerCharacteristic else false)));

  parameter Modelica.SIunits.PressureDifference dp_start(
    min=0,
    displayUnit="Pa")=0 "Initial value of pressure raise"
    annotation(Dialog(tab="Dynamics", group="Filtered speed"));

  // For air, we set dp_nominal = 600 as default, for water we set 10000
  parameter Modelica.SIunits.PressureDifference dp_nominal(
    min=0,
    displayUnit="Pa")=
      if rho_default < 500 then 500 else 10000 "Nominal pressure raise, used to normalized the filter if filteredSpeed=true,
        to set default values of constantHead and heads, and 
        and for default pressure curve if not specified in record per"
    annotation(Dialog(group="Nominal condition"));

  parameter Modelica.SIunits.PressureDifference constantHead(
    min=0,
    displayUnit="Pa")=dp_nominal
    "Constant pump head, used when inputType=Constant"
    annotation(Dialog(enable=inputType == Buildings.Fluid.Types.InputType.Constant));

  parameter Modelica.SIunits.PressureDifference[:] heads(
    each min=0,
    each displayUnit="Pa") = dp_nominal*{1}
    "Vector of head set points, used when inputType=Stages"
    annotation(Dialog(enable=inputType == Buildings.Fluid.Types.InputType.Stages));

  Modelica.Blocks.Interfaces.RealInput dp_in(min=0, final unit="Pa") if
    inputType == Buildings.Fluid.Types.InputType.Continuous
    "Prescribed pressure rise"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,120}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-2,120})));

  Modelica.Blocks.Interfaces.RealOutput dp_actual(min=0, final unit="Pa", displayUnit="Pa")
    annotation (Placement(transformation(extent={{100,10},{120,30}}),
        iconTransformation(extent={{100,10},{120,30}})));

protected
  Modelica.Blocks.Math.Gain gain(final k=-1)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={36,30})));
equation
  assert(inputSwitch.u >= -1E-3,
    "Pressure set point for mover cannot be negative. Obtained dp = " + String(inputSwitch.u));

  if filteredSpeed then
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
  connect(gain.u, dp_actual) annotation (Line(points={{36,42},{60,42},{60,20},{
          110,20}}, color={0,0,127}));
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
<p>
If <code>filteredSpeed=true</code>, then the parameter <code>dp_nominal</code> is
used to normalize the filter. This is used to improve the numerics of the transient response.
The actual pressure raise of the mover at steady-state is independent
of the value of <code>dp_nominal</code>. It is recommended to set
<code>dp_nominal</code> to approximately the pressure raise that the fan has during
full speed.
</p>
<p>
See the
<a href=\"modelica://Buildings.Fluid.Movers.UsersGuide\">
User's Guide</a> for more information.
</p>
</html>",
      revisions="<html>
<ul>
<li>
March 2, 2016, by Filip Jorissen:<br/>
Refactored model such that it directly extends <code>PartialFlowMachine</code>.
This is for
<a href=\"https://github.com/iea-annex60/modelica-annex60/issues/417\">#417</a>.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/iea-annex60/modelica-annex60/issues/404\">#404</a>.
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
        Text(
          visible = inputType == Buildings.Fluid.Types.InputType.Continuous,
          extent={{20,142},{104,108}},
          textString="dp_in"),
        Line(
          points={{32,50},{100,50}},
          color={0,0,0},
          smooth=Smooth.None),
        Text(
          visible=inputType == Buildings.Fluid.Types.InputType.Constant,
          extent={{-80,136},{78,102}},
          lineColor={0,0,255},
          textString="%dp_nominal"),
        Text(extent={{64,68},{114,54}},
          lineColor={0,0,127},
          textString="dp")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})));
end FlowControlled_dp;
