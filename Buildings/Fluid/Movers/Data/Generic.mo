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
  final parameter Modelica.Units.SI.VolumeFlowRate V_flow_max=
    if havePressureCurve
      then (pressure.V_flow[end]
                -(pressure.V_flow[end] - pressure.V_flow[end - 1])
                /(pressure.dp[end] - pressure.dp[end - 1])
                * pressure.dp[end])
    else 0
      "Volume flow rate on the curve when pressure rise is zero";
  final parameter Modelica.Units.SI.PressureDifference dpMax(
    displayUnit="Pa")=
    if havePressureCurve
      then (pressure.dp[1]
                -(pressure.dp[1] - pressure.dp[2])
                /(pressure.V_flow[1] - pressure.V_flow[2])
                * pressure.V_flow[1])
    else 0
      "Pressure rise on the curve when flow rate is zero";

  // Efficiency computation choices
  parameter Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod etaHydMet=
    if havePressureCurve
    then Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.EulerNumber
    else Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.NotProvided
    "Efficiency computation method for the hydraulic efficiency etaHyd"
    annotation (Dialog(group="Power computation"));
  parameter Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod etaMotMet=
    if powerOrEfficiencyIsHydraulic and havePressureCurve
    then Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.GenericCurve
    else Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.NotProvided
    "Efficiency computation method for the motor efficiency etaMot"
    annotation (Dialog(group="Power computation"));

  parameter Boolean powerOrEfficiencyIsHydraulic=true
    "=true if hydraulic power or efficiency is provided, instead of total"
    annotation (Dialog(group="Power computation",
    enable=max(power.P)>Modelica.Constants.eps
    or max(efficiency.eta)>Modelica.Constants.eps));

  // Arrays for efficiency values
  parameter
    Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters
    efficiency(
      V_flow={0},
      eta={0.7}) "Total or hydraulic efficiency vs. volumetric flow rate"
    annotation (Dialog(group="Power computation",
                       enable=etaHydMet == Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.Efficiency_VolumeFlowRate));
  parameter
    Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters
    motorEfficiency(
      V_flow={0},
      eta={0.7})
    "Motor efficiency vs. volumetric flow rate"
    annotation (Dialog(group="Power computation",
                       enable=etaMotMet == Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.Efficiency_VolumeFlowRate));
  parameter
    Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters_yMot
    motorEfficiency_yMot(y={0}, eta={0.7})
    "Motor efficiency vs. part load ratio yMot, where yMot = WHyd/WMot_nominal"
    annotation (Dialog(group="Power computation", enable=etaMotMet ==
      Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.Efficiency_MotorPartLoadRatio));

  // Power curve
  //   It requires default values to suppress Dymola message
  //   "Failed to expand the variable Power.V_flow"
  parameter Buildings.Fluid.Movers.BaseClasses.Characteristics.powerParameters power(
    V_flow={0},
    P={0})
    "Power (either consumed or hydraulic) vs. volumetric flow rate"
   annotation (Dialog(group="Power computation",
                      enable =   etaHydMet==
      Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.Power_VolumeFlowRate));

  // Peak condition
  parameter Buildings.Fluid.Movers.BaseClasses.Euler.peak peak(
    V_flow=peak_internal.V_flow,
    dp=peak_internal.dp,
    eta=peak_internal.eta)
    "Volume flow rate, pressure rise, and efficiency (either total or hydraulic) at peak condition"
    annotation (Dialog(group="Power computation",
                       enable =  etaHydMet==
      Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.EulerNumber));
  final parameter Buildings.Fluid.Movers.BaseClasses.Euler.peak peak_internal=
    if etaHydMet == Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.EulerNumber
    then Buildings.Fluid.Movers.BaseClasses.Euler.getPeak(pressure=pressure,power=power)
    else Buildings.Fluid.Movers.BaseClasses.Euler.peak(V_flow=V_flow_max/2,
                                                   dp=dpMax/2,
                                                   eta=max(efficiency.eta))
    "Internal peak variable";
  // The getPeak() function automatically handles the estimation of peak point
  //   when insufficient information is provided from the pressure curve.

  // Motor
  parameter Boolean motorCooledByFluid=true
    "If true, then motor heat is added to fluid stream"
    annotation(Dialog(group="Motor heat rejection"));
  parameter Modelica.Units.SI.Power WMot_nominal=
    if max(power.P)>Modelica.Constants.eps
    then
      if powerOrEfficiencyIsHydraulic
        then max(power.P)*1.2
        else max(power.P)
    else
      if havePressureCurve
        then if powerOrEfficiencyIsHydraulic
          then V_flow_max/2 * dpMax/2 /peak.eta*1.2
          else V_flow_max/2 * dpMax/2 /0.7*1.2
        else 0
    "Rated motor power"
      annotation(Dialog(group="Power computation",
                        enable= etaMotMet==
        Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.Efficiency_MotorPartLoadRatio
                        or      etaMotMet==
        Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.GenericCurve));
  parameter Modelica.Units.SI.Efficiency etaMot_max(max=1)= 0.7
    "Maximum motor efficiency"
    annotation (Dialog(group="Power computation", enable=etaMotMet ==
      Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.GenericCurve));
  final parameter
    Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters_yMot
      motorEfficiency_yMot_generic=
        Buildings.Fluid.Movers.BaseClasses.Characteristics.motorEfficiencyCurve(
          P_nominal=WMot_nominal,
          eta_max=etaMot_max)
    "Motor efficiency  vs. part load ratio"
    annotation (Dialog(enable=false));
  final parameter Boolean haveWMot_nominal=WMot_nominal > Modelica.Constants.eps
    "= true, if the rated motor power is provided";

  // Speed
  parameter Real speed_nominal(
    final min=0,
    final unit="1") = 1 "Nominal rotational speed for flow characteristic"
    annotation (Dialog(group="Normalized speeds"));

  parameter Real constantSpeed(final min=0, final unit="1") = 1
    "Normalized speed set point, used if inputType = Buildings.Fluid.Types.InputType.Constant"
    annotation (Dialog(group="Normalized speeds"));

  parameter Real[:] speeds(each final min = 0, each final unit="1") = {1}
    "Vector of normalized speed set points, used if inputType = Buildings.Fluid.Types.InputType.Stages"
    annotation (Dialog(group="Normalized speeds"));

  // Set a parameter in order for
  // (a) FlowControlled_m_flow and FlowControlled_dp to be able to set a reasonable
  //     default pressure curve if it is not specified here, and
  // (b) SpeedControlled_y to be able to issue an assert
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
August 20, 2024, by Hongxiang Fu:<br/>
Now the function
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Euler.getPeak\">
Buildings.Fluid.Movers.BaseClasses.Euler.getPeak</a>
is not called unless the Euler number method is selected.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1912\">IBPSA, #1912</a>.
</li>
<li>
April 8, 2024, by Hongxiang Fu:<br/>
Default efficiency methods now depend on whether a pressure curve is available.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3819\">#3819</a>.
</li>
<li>
March 29, 2023, by Hongxiang Fu:<br/>
Deleted angular speed parameters with the unit rpm.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1704\">IBPSA, #1704</a>.
</li>
<li>
March 1, 2022, by Hongxiang Fu:<br/>
<ul>
<li>
Modified the record to allow separate specifications of different
efficiency variables.
</li>
<li>
Added parameters for computation using Euler number.
</li>
<li>
Added parameters for providing the motor efficiency as an array
vs. motor part load ratio.
</li>
<li>
Moved the computation of <code>V_flow_max</code> here from
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine\">
Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine</a>
and <code>dpMax</code> here from
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface\">
Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface</a>
</li>
</ul>
These are for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">#2668</a>.
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
<a href=\"modelica://Buildings.Fluid.Movers.SpeedControlled_y\">
Buildings.Fluid.Movers.SpeedControlled_y</a>,
<a href=\"modelica://Buildings.Fluid.Movers.FlowControlled_dp\">
Buildings.Fluid.Movers.FlowControlled_dp</a>,
<a href=\"modelica://Buildings.Fluid.Movers.FlowControlled_m_flow\">
Buildings.Fluid.Movers.FlowControlled_m_flow</a>.
</p>
<p>
An example that uses manufacturer data can be found in
<a href=\"modelica://Buildings.Fluid.Movers.Validation.Pump_y_stratos\">
Buildings.Fluid.Movers.Validation.Pump_y_stratos</a>.
</p>
<h4>Declaration of the peak condition</h4>
<p>
The variable <code>peak</code> is intentionally declared in a way that each of its
element is declared individually. If it was delcared the same way as does
<code>peak_internal</code>, Modelica would prevent the modification of its
specific elements with the following error message:<br/>
<code>
Record has a value, and attempt to modify specific elements.<br/>
The element modification of e.g. V_flow will be ignored.<br/>
</code>
The other variable <code>peak_internal</code> uses a function call to compute its
default values. By passing them to <code>peak</code> one by one, the model can
both have default values and also allow the user to override them easily.
See <a href=\"https://github.com/modelica/ModelicaSpecification/issues/791\">
Modelica Specification issue #791</a>.
</p>
</html>"));
end Generic;
