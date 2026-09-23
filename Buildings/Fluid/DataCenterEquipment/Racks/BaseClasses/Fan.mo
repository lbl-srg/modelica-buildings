within Buildings.Fluid.DataCenterEquipment.Racks.BaseClasses;
model Fan "Preconfigured server fan"
  extends Buildings.Fluid.Movers.SpeedControlled_y(
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    use_riseTime=true,
    riseTime=2,
    tau=1,
    per(
      pressure(
        V_flow={
          0,
          2*V_flow_nominal},
        dp={
          2*dp_nominal,
          0}),
      etaHydMet=Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.EulerNumber,
      etaMotMet=Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.Efficiency_VolumeFlowRate,
      motorEfficiency(V_flow={0}, eta={sqrt(eta_nominal)}),
      etaMot_max=sqrt(eta_nominal),
      powerOrEfficiencyIsHydraulic=false));

  parameter Real eta_nominal(
    final unit="1",
    final min=Modelica.Constants.small) = 0.7
    "Fan and motor combined efficiency at nominal conditions"
    annotation(Dialog(group="Fan"));

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal(min=0)
    "Design air mass flow rate"
    annotation(Dialog(group="Fan"));

  parameter Modelica.Units.SI.Power PFan_nominal(min=0)
    "Fan electricity consumption at design flow rate"
    annotation(Dialog(group="Fan"));

protected
  parameter Modelica.Units.SI.VolumeFlowRate V_flow_nominal = m_flow_nominal / rho_default
    "Nominal volumetric flow rate";

  parameter Modelica.Units.SI.PressureDifference dp_nominal(displayUnit="Pa") =
    PFan_nominal * eta_nominal / V_flow_nominal
    "Fan pressure rise at nominal conditions";

  annotation (
    Icon(graphics={
        Ellipse(
          visible=energyDynamics <> Modelica.Fluid.Types.Dynamics.SteadyState,
          extent={{3,12},{27,-12}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,100,199}),
        Text(
          extent={{-46,-42},{6,-84}},
          textColor={0,0,0},
          textString=DynamicSelect("",String(y,
            leftJustified=false,
            significantDigits=3))),
        Ellipse(
          extent={{-60,58},{56,-58}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={0,0,0}),
        Polygon(
          points={{0,52},{0,-48},{54,2},{0,52}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255})}),
    defaultComponentName="fan",
    Documentation(
      info="<html>
<p>
Preconfigured fan model.
</p>
<p>
The fan is modelled using
<a href=\"modelica://Buildings.Fluid.Movers.SpeedControlled_y\">
Buildings.Fluid.Movers.SpeedControlled_y</a>.
The fan pressure rise at the nominal volumetric flow rate is
</p>
<p align=\"center\" style=\"font-style:italic;\">
dp<sub>0</sub> = P<sub>fan,0</sub> &eta;<sub>0</sub> &frasl; V&#775;<sub>0</sub>.
</p>
<p>
The fan uses a constant total efficiency, which is set by the parameters <code>eta_nominal</code>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
September 21, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Fan;
