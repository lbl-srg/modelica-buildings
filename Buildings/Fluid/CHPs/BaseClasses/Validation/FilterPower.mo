within Buildings.Fluid.CHPs.BaseClasses.Validation;
model FilterPower "Validate model FilterPower"
  extends Modelica.Icons.Example;

  parameter Buildings.Fluid.CHPs.Data.ValidationData1 per
    "CHP performance data"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable PEleDem(
    table=[0,0; 300,500; 600,2000; 900,3000;
           1200,0; 1500,6000; 1800,6000],
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments)
    "Electricity demand"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Fluid.CHPs.BaseClasses.FilterPower filPow(
    final PEleMax=per.PEleMax,
    final PEleMin=per.PEleMin,
    final dPEleMax=per.dPEleMax,
    final use_powerRateLimit=per.use_powerRateLimit)
    "Constraints for electric power"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

equation
  connect(PEleDem.y[1], filPow.PEleDem)
    annotation (Line(points={{-38,0},{18,0}}, color={0,0,127}));

annotation (
  experiment(StopTime=1800, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/CHPs/BaseClasses/Validation/FilterPower.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Fluid.CHPs.BaseClasses.FilterPower\">
Buildings.Fluid.CHPs.BaseClasses.FilerPower</a>
for applying constraints and sending a warning message if the electric power
is outside boundaries. The constraints include minimum and maximum electric power and
the maximum rate of change in power output.
</p>
</html>", revisions="<html>
<ul>
<li>
October 31, 2019, by Jianjun Hu:<br/>
Refactored implementation.
</li>
<li>
July 01 2019, by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"));
end FilterPower;
