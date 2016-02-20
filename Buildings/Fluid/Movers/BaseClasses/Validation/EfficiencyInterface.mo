within Buildings.Fluid.Movers.BaseClasses.Validation;
model EfficiencyInterface "Simple model to validate EfficiencyInterface"
  extends Modelica.Icons.Example;
  Buildings.Fluid.Movers.BaseClasses.EfficiencyInterface  eff
    "Flow machine interface model"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Constant dp(k=-200) "Pressure difference"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Sources.Constant rho(k=1.2) "Density"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.Sources.Ramp m_flow(height=1.2, duration=1) "Mass flow rate"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
equation
  connect(eff.rho, rho.y)
    annotation (Line(points={{-12,0},{-39,0}}, color={0,0,127}));
  connect(m_flow.y, eff.m_flow) annotation (Line(points={{-39,-30},{-26,-30},{-26,
          -6},{-12,-6}}, color={0,0,127}));
  connect(eff.dp, dp.y) annotation (Line(points={{-12,6},{-28,6},{-28,30},{-39,
          30}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    Documentation(info="<html>
<p>
Simple validation model for the efficiency interface model.
</p>
</html>", revisions="<html>
<ul>
<li>
February 19, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(StopTime=1),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Movers/BaseClasses/Validation/EfficiencyInterface.mos"
        "Simulate and plot"));
end EfficiencyInterface;
