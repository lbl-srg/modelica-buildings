within Buildings.Fluid.Movers.Preconfigured;
model SpeedControlled_Nrpm "Fan or pump with ideally controlled speed Nrpm as input signal and pre-configured parameters"
  extends Buildings.Fluid.Movers.SpeedControlled_Nrpm(
    final per(
            pressure(
              V_flow=m_flow_nominal/rho_default*{0, 2},
              dp=dp_nominal*{2, 0}),
            speed_rpm_nominal=speed_rpm_nominal,
            powerOrEfficiencyIsHydraulic=true,
            etaHydMet=Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.EulerNumber,
            etaMotMet=Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.GenericCurve),
    final inputType=Buildings.Fluid.Types.InputType.Continuous,
    final init=Modelica.Blocks.Types.Init.InitialOutput,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial);

  parameter Modelica.Units.SI.PressureDifference dp_nominal
    "Nominal pressure head for preconfiguration"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.NonSI.AngularVelocity_rpm speed_rpm_nominal
    "Nominal rotational speed for preconfiguration"
    annotation (Dialog(group="Nominal condition"));

annotation(Documentation(info="<html>
<p>
This model is the preconfigured version for
<a href=\"Modelica://Buildings.Fluid.Movers.SpeedControlled_Nrpm\">
Buildings.Fluid.Movers.SpeedControlled_Nrpm</a>.
It automatically configures a mover model based on
<code>m_flow_nominal</code>, <code>dp_nominal</code>,
and <code>speed_rpm_nominal</code>.
</p>
<p>
The configuration is as follows:
</p>
<ul>
<li>
Based on the parameters <code>m_flow_nominal</code> and <code>dp_nominal</code>,
a linear function for the head is constructed that goes through the points
(<code>0</code>, <code>2 dp_nominal</code>),
(<code>m_flow_nominal</code>, <code>dp_nominal</code>) and
(<code>2 m_flow_nominal</code>, <code>0</code>).
</li>
<li>
The hydraulic efficiency is computed based on the Euler number.
See <a href=\"modelica://Buildings.Fluid.Movers.UsersGuide\">
Buildings.Fluid.Movers.UsersGuide</a>
for details.
</li>
<li>
The motor efficiency is computed based on a generic curve
See <a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.motorEfficiencyCurve\">
Buildings.Fluid.Movers.BaseClasses.Characteristics.motorEfficiencyCurve</a>
for details.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
August 17, 2022, by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">#2668</a>.
</li>
</ul>
</html>"));
end SpeedControlled_Nrpm;
