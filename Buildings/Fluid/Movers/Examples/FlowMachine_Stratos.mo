within Buildings.Fluid.Movers.Examples;
model FlowMachine_Stratos "Stratos pum with speed as input"
  extends Modelica.Icons.Example;
 extends Buildings.Fluid.Movers.Examples.BaseClasses.FlowMachine_ZeroFlow(
    redeclare package Medium = Buildings.Media.ConstantPropertyLiquidWater,
    gain(k=floMacSta.per.N_nominal),
    m_flow_nominal=floMacSta.per.pressure.V_flow[3]*1000,
    dp_nominal=floMacSta.per.pressure.dp[3]/2,
    redeclare Buildings.Fluid.Movers.FlowMachine_Nrpm floMacSta(
      redeclare package Medium = Medium,
      filteredSpeed=false,
      redeclare Buildings.Fluid.Movers.Data.Pumps.Stratos25slash1to6 per),
    redeclare Buildings.Fluid.Movers.FlowMachine_Nrpm floMacDyn(
      redeclare package Medium = Medium,
      filteredSpeed=false,
      redeclare Buildings.Fluid.Movers.Data.Pumps.Stratos25slash1to6 per));
equation
  connect(gain.y, floMacSta.Nrpm) annotation (Line(
      points={{-25,100},{30,100},{30,92}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.y, floMacDyn.Nrpm) annotation (Line(
      points={{-25,100},{10,100},{10,30},{30,30},{30,12}},
      color={0,0,127},
      smooth=Smooth.None));

  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{160,
            160}}), graphics),
experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Movers/Examples/FlowMachine_Stratos.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>This example demonstrates and tests the use of a flow machine that uses
a performance data from a Stratos pump.</p>
</html>", revisions="<html>
<ul>
<li>April 18, 2014
    by Filip Jorissen:<br/>
       Initial version
</li>
</ul>
</html>"));
end FlowMachine_Stratos;
