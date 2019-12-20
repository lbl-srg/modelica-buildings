within Buildings.Fluid.Movers;
model FlowControlled_m_flow
  "Fan or pump with ideally controlled mass flow rate as input signal"
  extends Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine(
    final preVar=Buildings.Fluid.Movers.BaseClasses.Types.PrescribedVariable.FlowRate,
    final computePowerUsingSimilarityLaws=per.havePressureCurve,
    final stageInputs(each final unit="kg/s")=massFlowRates,
    final constInput(final unit="kg/s")=constantMassFlowRate,
    filter(
      final y_start=m_flow_start,
      u_nominal=m_flow_nominal,
      u(final unit="kg/s"),
      y(final unit="kg/s")),
    eff(
      per(
        final pressure = if per.havePressureCurve then
          per.pressure
        else
          Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters(
            V_flow = {i/(nOri-1)*2.0*m_flow_nominal/rho_default for i in 0:(nOri-1)},
            dp =     {i/(nOri-1)*2.0*dp_nominal for i in (nOri-1):-1:0}),
      final use_powerCharacteristic = if per.havePressureCurve then per.use_powerCharacteristic else false)),
    preSou(m_flow_start=m_flow_start));

  // For air, we set dp_nominal = 600 as default, for water we set 10000
  parameter Modelica.SIunits.PressureDifference dp_nominal(min=0, displayUnit="Pa")=
    if rho_default < 500 then 500 else 10000
    "Nominal pressure raise, used for default pressure curve if not specified in record per"
    annotation(Dialog(group="Nominal condition"));

  parameter Modelica.SIunits.MassFlowRate m_flow_start(min=0)=0
    "Initial value of mass flow rate"
    annotation(Dialog(tab="Dynamics", group="Filtered speed"));

  parameter Modelica.SIunits.MassFlowRate constantMassFlowRate=m_flow_nominal
    "Constant pump mass flow rate, used when inputType=Constant"
    annotation(Dialog(enable=inputType == Buildings.Fluid.Types.InputType.Constant));

  // By default, set massFlowRates proportional to (speed/speed_nominal)
  parameter Modelica.SIunits.MassFlowRate[:] massFlowRates=
    m_flow_nominal*{per.speeds[i]/per.speeds[end] for i in 1:size(per.speeds, 1)}
    "Vector of mass flow rate set points, used when inputType=Stage"
    annotation(Dialog(enable=inputType == Buildings.Fluid.Types.InputType.Stages));

  Modelica.Blocks.Interfaces.RealInput m_flow_in(
    final unit="kg/s",
    nominal=m_flow_nominal) if
       inputType == Buildings.Fluid.Types.InputType.Continuous
    "Prescribed mass flow rate"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,120}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,120})));
  Modelica.Blocks.Interfaces.RealOutput m_flow_actual(
    final unit="kg/s",
    nominal=m_flow_nominal) "Actual mass flow rate"
    annotation (Placement(transformation(extent={{100,40},{120,60}}),
        iconTransformation(extent={{100,40},{120,60}})));

equation
  if use_inputFilter then
    connect(filter.y, m_flow_actual) annotation (Line(
      points={{34.7,88},{44,88},{44,50},{110,50}},
      color={0,0,127},
      smooth=Smooth.None));
  else
    connect(inputSwitch.y, preSou.m_flow_in) annotation (Line(
      points={{1,50},{44,50},{44,8}},
      color={0,0,127},
      smooth=Smooth.None));
  end if;
   connect(m_flow_actual, preSou.m_flow_in) annotation (Line(
      points={{110,50},{44,50},{44,8}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(inputSwitch.u, m_flow_in) annotation (Line(
      points={{-22,50},{-26,50},{-26,80},{0,80},{0,120}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (defaultComponentName="fan",
  Documentation(
   info="<html>
<p>
This model describes a fan or pump with prescribed mass flow rate.
The efficiency of the device is computed based
on the efficiency and pressure curves that are defined
in record <code>per</code>, which is of type
<a href=\"modelica://Buildings.Fluid.Movers.SpeedControlled_Nrpm\">
Buildings.Fluid.Movers.SpeedControlled_Nrpm</a>.
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
March 24, 2017, by Michael Wetter:<br/>
Renamed <code>filteredSpeed</code> to <code>use_inputFilter</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/665\">#665</a>.
</li>
<li>
November 10, 2016, by Michael Wetter:<br/>
Changed default values for <code>massFlowRates</code>.<br/>
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
<li>March 24, 2010, by Michael Wetter:<br/>
Revised implementation to allow zero flow rate.
</li>
<li>October 1, 2009
    by Michael Wetter:<br/>
       Model added to the Buildings library.
</ul>
</html>"),
    Icon(graphics={
        Text(
          visible = inputType == Buildings.Fluid.Types.InputType.Continuous,
          extent={{22,146},{114,102}},
          textString="m_flow_in"),
        Line(
          points={{2,50},{100,50}},
          color={0,0,0},
          smooth=Smooth.None),
        Text(extent={{50,66},{100,52}},
          lineColor={0,0,127},
          textString="m_flow"),
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
end FlowControlled_m_flow;
