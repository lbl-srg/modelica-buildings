within Buildings.Fluid.Movers.Preconfigured;
model SpeedControlled_y "Fan or pump with ideally controlled normalized speed y as input signal and pre-configured parameters"
  extends Buildings.Fluid.Movers.SpeedControlled_y(
    final per(
            pressure(
              V_flow=m_flow_nominal/rho_default*{0, 1, 2},
              dp=if rho_default < 500
                   then dp_nominal*{1.12, 1, 0}
                   else dp_nominal*{1.14, 1, 0.42}),
            powerOrEfficiencyIsHydraulic=true,
            etaHydMet=Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.EulerNumber,
            etaMotMet=Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.GenericCurve),
    final inputType=Buildings.Fluid.Types.InputType.Continuous,
    final init=Modelica.Blocks.Types.Init.InitialOutput,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial);

  parameter Modelica.Units.SI.PressureDifference dp_nominal
    "Nominal pressure head for preconfiguration"
    annotation(Dialog(group="Nominal condition"));
annotation(Documentation(info="<html>
<p>
This model is the preconfigured version for
<a href=\"Modelica://Buildings.Fluid.Movers.SpeedControlled_y\">
Buildings.Fluid.Movers.SpeedControlled_y</a>.
It automatically configures a mover model based on
<code>m_flow_nominal</code> and <code>dp_nominal</code>.
</p>
<p>
The configuration is as follows:
</p>
<ul>
<li>
Based on the parameters <code>m_flow_nominal</code> and <code>dp_nominal</code>,
a pressure curve is constructed based on regression results of pump records in
<a href=\"Modelica://Buildings.Fluid.Movers.Data.Pumps.Wilo\">
Buildings.Fluid.Movers.Data.Pumps.Wilo</a>.
For more information, see documentation of
<code>Buildings.Fluid.HydronicConfiguration.UsersGuide.ModelParameters</code>
(currently under development branch
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1884\">#1884</a>.)
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
end SpeedControlled_y;
