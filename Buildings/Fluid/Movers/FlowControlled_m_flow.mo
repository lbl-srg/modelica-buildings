within Buildings.Fluid.Movers;
model FlowControlled_m_flow
  "Fan or pump with ideally controlled mass flow rate as input signal"
  extends Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine(
    final preVar=Buildings.Fluid.Movers.BaseClasses.Types.PrescribedVariable.FlowRate,
    final computePowerUsingSimilarityLaws=per.havePressureCurve,
    final stageInputs(each final unit="kg/s")=massFlowRates,
    final constInput(final unit="kg/s")=constantMassFlowRate,
    final _m_flow_nominal = m_flow_nominal,
    filter(
      final y_start=m_flow_start,
      u(final unit="kg/s"),
      y(final unit="kg/s"),
      x(each nominal=m_flow_nominal),
      u_nominal=m_flow_nominal),
    eff(
      per(
        final pressure = if per.havePressureCurve then
          per.pressure
        else
          Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters(
            V_flow = {i/(nOri-1)*2.0*m_flow_nominal/rho_default for i in 0:(nOri-1)},
            dp =     {i/(nOri-1)*2.0*dp_nominal for i in (nOri-1):-1:0}),
        final etaHydMet=
          if (per.etaHydMet ==
               Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.Power_VolumeFlowRate
            or per.etaHydMet ==
               Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.EulerNumber)
            and not per.havePressureCurve then
              Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.NotProvided
          else per.etaHydMet,
        final etaMotMet=
          if (per.etaMotMet ==
               Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.Efficiency_MotorPartLoadRatio
            or per.etaMotMet ==
               Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.GenericCurve)
            and (not per.haveWMot_nominal and not per.havePressureCurve) then
               Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.NotProvided
          else per.etaMotMet),
      r_N(start=if abs(m_flow_nominal) > 1E-8 then m_flow_start/m_flow_nominal else 0)),
    preSou(m_flow_start=m_flow_start));

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal(
    final min=Modelica.Constants.small)
    "Nominal mass flow rate" annotation (Dialog(group="Nominal condition"));

  // For air, we set dp_nominal = 600 as default, for water we set 10000
  parameter Modelica.Units.SI.PressureDifference dp_nominal(
    final min=Modelica.Constants.small,
    displayUnit="Pa") = if rho_default < 500 then 500 else 10000
    "Nominal pressure raise, used for default pressure curve if not specified in record per"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.MassFlowRate m_flow_start(min=0) = 0
    "Initial value of mass flow rate"
    annotation (Dialog(tab="Dynamics", group="Filtered speed"));

  parameter Modelica.Units.SI.MassFlowRate constantMassFlowRate=m_flow_nominal
    "Constant pump mass flow rate, used when inputType=Constant" annotation (
      Dialog(enable=inputType == Buildings.Fluid.Types.InputType.Constant));

  // By default, set massFlowRates proportional to (speed/speed_nominal)
  parameter Modelica.Units.SI.MassFlowRate[:] massFlowRates=m_flow_nominal*{per.speeds[
      i]/per.speeds[end] for i in 1:size(per.speeds, 1)}
    "Vector of mass flow rate set points, used when inputType=Stage"
    annotation (Dialog(enable=inputType == Buildings.Fluid.Types.InputType.Stages));

  parameter Modelica.Units.SI.Pressure dpMax(
    min=0,
    displayUnit="Pa") = 2*max(eff.per.pressure.dp)
   "Maximum pressure allowed to operate the model, if exceeded, the simulation stops with an error"
   annotation(Dialog(tab="Advanced"));

  Modelica.Blocks.Interfaces.RealInput m_flow_in(
    final unit="kg/s",
    nominal=m_flow_nominal)
    if inputType == Buildings.Fluid.Types.InputType.Continuous
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
  assert(-dp <= dpMax,
    "In " + getInstanceName() + ": Model operates with head -dp = " + String(-dp) + " Pa,
    exceeding the pressure allowed by the parameter " + getInstanceName() + ".dpMax.
    This can happen if the model forces a high mass flow rate through a closed actuator,
    or if the performance record is unreasonable. Please verify your model, and
    consider using one of the other pump or fan models.");

  if use_inputFilter then
    connect(filter.y, m_flow_actual) annotation (Line(
      points={{41,70.5},{44,70.5},{44,50},{110,50}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(filter.y, preSou.m_flow_in)
      annotation (Line(points={{41,70.5},{44,70.5},{44,8}}, color={0,0,127}));
  else
  connect(inputSwitch.y, m_flow_actual) annotation (Line(points={{1,50},{110,50}},
                                             color={0,0,127}));
  connect(inputSwitch.y, preSou.m_flow_in) annotation (Line(
      points={{1,50},{44,50},{44,8}},
      color={0,0,127},
      smooth=Smooth.None));
  end if;

  connect(inputSwitch.u, m_flow_in) annotation (Line(
      points={{-22,50},{-26,50},{-26,80},{0,80},{0,120}},
      color={0,0,127},
      smooth=Smooth.None));

  annotation (
      Icon(graphics={
        Text(
          extent={{-40,126},{-160,76}},
          textColor={0,0,127},
          visible=inputType == Buildings.Fluid.Types.InputType.Continuous or inputType == Buildings.Fluid.Types.InputType.Stages,
          textString=DynamicSelect("m_flow", if inputType == Buildings.Fluid.Types.InputType.Continuous then String(m_flow_in, leftJustified=false, significantDigits=3) else String(stage)))}),
  defaultComponentName="mov",
  Documentation(
   info="<html>
<p>
This model describes a fan or pump with prescribed mass flow rate.
</p>
<p>
Note that if the model operates with a head that is larger than <code>dpMax</code>, which by default is
two times larger than the largest head declared in <code>eff.per.pressure.dp</code>,
the simulation will stop with an error message.
This guards against unreasonably high pressure drops and electrical power use,
which can happen if the model is forcing mass flow rate through a closed actuator.
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
March 1, 2023, by Hongxiang Fu:<br/>
Refactored the model with a new declaration for
<code>m_flow_nominal</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1705\">#1705</a>.
</li>
<li>
April 27, 2022, by Hongxiang Fu:<br/>
Replaced <code>not use_powerCharacteristic</code> with the enumerations
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod\">
Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod</a>
and
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod\">
Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod</a>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">#2668</a>.
</li>
<li>
November 15, 2022, by Michael Wetter:<br/>
Added assertion if model operates with a pressure higher than <code>dpMax</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1659\">#1659</a>.
</li>
<li>
March 7, 2022, by Michael Wetter:<br/>
Set <code>final massDynamics=energyDynamics</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1542\">#1542</a>.
</li>
<li>
June 17, 2021, by Michael Wetter:<br/>
Changed implementation of the filter.<br/>
Removed parameter <code>y_start</code> which is not used because <code>m_flow_start</code> is used.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1498\">#1498</a>.
</li>
<li>
February 21, 2020, by Michael Wetter:<br/>
Changed icon to display its operating stage.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1294\">#1294</a>.
</li>
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
</html>"));
end FlowControlled_m_flow;
