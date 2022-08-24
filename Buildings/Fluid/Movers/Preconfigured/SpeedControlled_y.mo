within Buildings.Fluid.Movers.Preconfigured;
model SpeedControlled_y "SpeedControlled_y with pre-filled parameters"
  extends Buildings.Fluid.Movers.SpeedControlled_y(
    final per(
            pressure(V_flow=m_flow_nominal/rho_default*{0,1,2},
                     dp=dp_nominal*{2,1,0}),
            powerOrEfficiencyIsHydraulic=true,
            etaHydMet=Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.EulerNumber,
            etaMotMet=Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.GenericCurve),
    final addPowerToMedium=false,
    final inputType=Buildings.Fluid.Types.InputType.Continuous,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial);

  parameter Modelica.Units.SI.PressureDifference dp_nominal
    "Nominal pressure head for preconfiguration"
    annotation(Dialog(group="Nominal condition"));
annotation(Documentation(info="<html>
<p>
This model is the preconfigured version for
<a href=\"Modelica://Buildings.Fluid.Movers.SpeedControlled_y\">
Buildings.Fluid.Movers.SpeedControlled_y</a>.
It automatically configures a mover model based on
<code>m_flow_nominal</code> and <code>dp_nominal</code>
provided by the user and no other input is allowed.
</p>
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
