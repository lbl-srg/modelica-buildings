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

  // (Being tested) New efficiency computation choices
  parameter Buildings.Fluid.Movers.BaseClasses.Types.EfficiencyMethod effMet[3]=
     {Buildings.Fluid.Movers.BaseClasses.Types.EfficiencyMethod.Values,
      Buildings.Fluid.Movers.BaseClasses.Types.EfficiencyMethod.NotProvided,
      Buildings.Fluid.Movers.BaseClasses.Types.EfficiencyMethod.NotProvided}
    "Efficiency computation choices of eta, etaHyd, and etaMot, respective";

  final parameter Integer effMetInt[3] = Integer(effMet)
    "Efficiency computation enumerations expressed as integers";

  final parameter Boolean use_powerCharacteristic=
    effMetInt[1]==3 or effMetInt[2]==3
    "The power curve is used for either total efficiency or hydraulic efficiency";

  final parameter Boolean use_eulerNumber=
    effMetInt[1]==4 or effMetInt[2]==4
    "The Euler number is used for either total efficiency or hydraulic efficiency";

  // Arrays for efficiency values
  parameter
    Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters
    totalEfficiency(
      V_flow={0},
      eta={0.49}) "Total efficiency"
    annotation (Dialog(group="Power computation",
                       enable=effMetInt[1]==2));
  parameter
    Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters
    hydraulicEfficiency(
      V_flow={0},
      eta={0.7}) "Hydraulic efficiency"
    annotation (Dialog(group="Power computation",
                       enable=effMetInt[2]==2));
  parameter
    Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters
    motorEfficiency(
      V_flow={0},
      eta={0.7})
    "Electric motor efficiency"
    annotation (Dialog(group="Power computation",
                       enable=effMetInt[3]==2));

  // Power curve
  //   It requires default values to suppress Dymola message
  //   "Failed to expand the variable Power.V_flow"
  parameter Buildings.Fluid.Movers.BaseClasses.Characteristics.powerParameters power(
    V_flow={0},
    P={0})
    "Power (either consumed or hydraulic) vs. volumetric flow rate"
   annotation (Dialog(group="Power computation",
                      enable=etaMetInt[1]==3 or etaMetInt[2]==3));

  // Peak condition
  parameter Buildings.Fluid.Movers.BaseClasses.Euler.peak peak(
    V_flow=0,
    dp=0,
    eta=0.7)
    "Volume flow rate, pressure rise, and efficiency (either total or hydraulic) at peak condition"
    annotation (Dialog(group="Power computation",
                       enable=etaMetInt[1]==4 or etaMetInt[2]==4));

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
November 30, 2021, by Hongxiang Fu:<br/>
The switches <code>use_powerCharacteristic</code> and
<code>use_motorEfficiency</code> are given the <code>final</code> keyword
and now must be assigned via the enumeration
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Types.PowerMethod\">
Buildings.Fluid.Movers.BaseClasses.Types.PowerMethod</a>.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">issue 2668</a>.
</li>
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
