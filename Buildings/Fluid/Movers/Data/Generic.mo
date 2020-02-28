within Buildings.Fluid.Movers.Data;
record Generic "Generic data record for movers"
  extends Modelica.Icons.Record;

  // Pressure requires default values to avoid in Dymola the message
  // Failed to expand the variable pressure.V_flow.
  parameter Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters pressure(
    V_flow = {0, 0},
    dp =     {0, 0}) "Volume flow rate vs. total pressure rise"
    annotation(Evaluate=true,
               Dialog(group="Pressure curve"));

  parameter Boolean use_powerCharacteristic=false
    "Use power data instead of motor efficiency"
    annotation (Dialog(group="Power computation"));

  parameter
    Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters
    hydraulicEfficiency(
      V_flow={0},
      eta={0.7}) "Hydraulic efficiency (used if use_powerCharacteristic=false)"
    annotation (Dialog(group="Power computation",
                       enable=not use_powerCharacteristic));
  parameter
    Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters
    motorEfficiency(
      V_flow={0},
      eta={0.7})
    "Electric motor efficiency (used if use_powerCharacteristic=false)"
    annotation (Dialog(group="Power computation",
                       enable=not use_powerCharacteristic));

  // Power requires default values to avoid in Dymola the message
  // Failed to expand the variable Power.V_flow
  parameter BaseClasses.Characteristics.powerParameters power(
    V_flow={0},
    P={0})
    "Volume flow rate vs. electrical power consumption (used if use_powerCharacteristic=true)"
   annotation (Dialog(group="Power computation",
                      enable=use_powerCharacteristic));

  parameter Boolean motorCooledByFluid=true
    "If true, then motor heat is added to fluid stream"
    annotation(Dialog(group="Motor heat rejection"));

  parameter Real speed_nominal(
    final min=0,
    final unit="1") = 1 "Nominal rotational speed for flow characteristic"
    annotation (Dialog(group="Normalized speeds (used in model, default values assigned from speeds in rpm)"));

  parameter Real constantSpeed(final min=0, final unit="1") = constantSpeed_rpm/speed_rpm_nominal
    "Normalized speed set point, used if inputType = Buildings.Fluid.Types.InputType.Constant"
    annotation (Dialog(group="Normalized speeds (used in model, default values assigned from speeds in rpm)"));

  parameter Real[:] speeds(each final min = 0, each final unit="1") = speeds_rpm/speed_rpm_nominal
    "Vector of normalized speed set points, used if inputType = Buildings.Fluid.Types.InputType.Stages"
    annotation (Dialog(group="Normalized speeds (used in model, default values assigned from speeds in rpm)"));

  parameter Modelica.Units.NonSI.AngularVelocity_rpm speed_rpm_nominal=1500
    "Nominal rotational speed for flow characteristic"
    annotation (Dialog(group="Speeds in RPM"));

  parameter Modelica.Units.NonSI.AngularVelocity_rpm constantSpeed_rpm=
      speed_rpm_nominal
    "Speed set point, used if inputType = Buildings.Fluid.Types.InputType.Constant"
    annotation (Dialog(group="Speeds in RPM"));

  parameter Modelica.Units.NonSI.AngularVelocity_rpm[:] speeds_rpm={
      speed_rpm_nominal}
    "Vector of speed set points, used if inputType = Buildings.Fluid.Types.InputType.Stages"
    annotation (Dialog(group="Speeds in RPM"));

  // Set a parameter in order for
  // (a) FlowControlled_m_flow and FlowControlled_dp being able to set a reasonable
  //     default pressure curve if it is not specified here, and
  // (b) SpeedControlled_y and SpeedControlled_Nrpm being able to issue an assert
  //     if no pressure curve is specified.
  final parameter Boolean havePressureCurve=
    sum(pressure.V_flow) > Modelica.Constants.eps and
    sum(pressure.dp) > Modelica.Constants.eps
    "= true, if default record values are being used";

  annotation (
  defaultComponentPrefixes = "parameter",
  defaultComponentName = "per",
  Documentation(revisions="<html>
<ul>
<li>
February 19, 2016, by Filip Jorissen:<br/>
Refactored model such that <code>SpeedControlled_Nrpm</code>,
<code>SpeedControlled_y</code> and <code>FlowControlled</code>
are integrated into one record.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/417\">#417</a>.
</li>
<li>
February 17, 2016, by Michael Wetter:<br/>
Changed parameter <code>N_nominal</code> to
<code>speed_rpm_nominal</code> as it is the same quantity as <code>speeds_rmp</code>.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/396\">#396</a>.
</li>
<li>
January 19, 2016, by Filip Jorissen:<br/>
Added parameter <code>speeds_rpm</code>.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/396\">#396</a>.
</li>
<li>
February 13, 2015, by Michael Wetter:<br/>
Updated documentation.
</li>
<li>
January 6, 2015, by Michael Wetter:<br/>
Revised record for OpenModelica.
</li>
<li>
November 22, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Record containing parameters for pumps or fans.
</p>
<h4>Typical use</h4>
<p>
This record may be used to assign for example fan performance data using
declaration such as
</p>
<pre>
  Buildings.Fluid.Movers.SpeedControlled_y fan(
    redeclare package Medium = Medium,
      per(pressure(V_flow={0,m_flow_nominal,2*m_flow_nominal}/1.2,
                   dp={2*dp_nominal,dp_nominal,0}))) \"Fan\";
</pre>
<p>
This data record can be used with
<a href=\"modelica://Buildings.Fluid.Movers.SpeedControlled_Nrpm\">
Buildings.Fluid.Movers.SpeedControlled_Nrpm</a>,
<a href=\"modelica://Buildings.Fluid.Movers.SpeedControlled_y\">
Buildings.Fluid.Movers.SpeedControlled_y</a>,
<a href=\"modelica://Buildings.Fluid.Movers.FlowControlled_dp\">
Buildings.Fluid.Movers.FlowControlled_dp</a>,
<a href=\"modelica://Buildings.Fluid.Movers.FlowControlled_m_flow\">
Buildings.Fluid.Movers.FlowControlled_m_flow</a>.
</p>
<p>
An example that uses manufacturer data can be found in
<a href=\"modelica://Buildings.Fluid.Movers.Validation.Pump_Nrpm_stratos\">
Buildings.Fluid.Movers.Validation.Pump_Nrpm_stratos</a>.
</p>
<h4>Parameters in RPM</h4>
<p>
The parameters <code>speed_rpm_nominal</code>,
<code>constantSpeed_rpm</code> and
<code>speeds_rpm</code> are used to assign the non-dimensional speeds
</p>
<pre>
  parameter Real constantSpeed(final min=0, final unit=\"1\") = constantSpeed_rpm/speed_rpm_nominal;
  parameter Real[:] speeds(each final min = 0, each final unit=\"1\") = speeds_rpm/speed_rpm_nominal;
</pre>
<p>
In addition, <code>speed_rpm_nominal</code> is used in
<a href=\"modelica://Buildings.Fluid.Movers.SpeedControlled_Nrpm\">
Buildings.Fluid.Movers.SpeedControlled_Nrpm</a>
to normalize the control input signal.
Otherwise, these speed parameters in RPM are not used in the models.
</p>
</html>"));
end Generic;
