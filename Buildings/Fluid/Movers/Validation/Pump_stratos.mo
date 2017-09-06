within Buildings.Fluid.Movers.Validation;
model Pump_stratos "Stratos pumps with speed as input"
  extends Modelica.Icons.Example;
 extends Buildings.Fluid.Movers.Validation.BaseClasses.FlowMachine_ZeroFlow(
    redeclare package Medium = Buildings.Media.Water,
    gain(k=floMacSta.per.speed_rpm_nominal),
    m_flow_nominal=floMacSta.per.pressure.V_flow[3]*1000,
    dp_nominal=floMacSta.per.pressure.dp[3]/2,
    redeclare Buildings.Fluid.Movers.SpeedControlled_Nrpm floMacSta(
      redeclare package Medium = Medium,
      use_inputFilter=false,
      per=per),
    redeclare Buildings.Fluid.Movers.SpeedControlled_Nrpm floMacDyn(
      redeclare package Medium = Medium,
      use_inputFilter=false,
      per=per));
  parameter Data.Pumps.Wilo.Stratos25slash1to6 per
    annotation (Placement(transformation(extent={{100,100},{120,120}})));
equation
  connect(gain.y, floMacSta.Nrpm) annotation (Line(
      points={{-25,100},{30,100},{30,92}},
      color={0,0,127}));
  connect(gain.y, floMacDyn.Nrpm) annotation (Line(
      points={{-25,100},{10,100},{10,30},{30,30},{30,12}},
      color={0,0,127}));

  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{160,
            160}}), graphics),
experiment(Tolerance=1e-06, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Movers/Validation/Pump_stratos.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>This example demonstrates and tests the use of a flow machine that uses
a performance data from a Stratos pump.</p>
</html>", revisions="<html>
<ul>
<li>
February 17, 2016, by Michael Wetter:<br/>
Updated parameter names for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/396\">#396</a>.
</li>
<li>April 18, 2014
    by Filip Jorissen:<br/>
       Initial version
</li>
</ul>
</html>"));
end Pump_stratos;
