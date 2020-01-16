within Buildings.Examples.DistrictReservoirNetworks.Examples.BaseClasses;
block PowerMeter
  "Block that sums input and integrates it from power to energy"
  extends Modelica.Blocks.Interfaces.PartialRealMISO(
   u(each unit="W"),
   y(unit="J"));

  Modelica.Blocks.Math.MultiSum multiSum(final nu=nu)
    annotation (Placement(transformation(extent={{-34,-6},{-22,6}})));
  Modelica.Blocks.Continuous.Integrator integrator(
    final initType=Modelica.Blocks.Types.Init.InitialState)
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
equation
  connect(multiSum.u, u)
    annotation (Line(points={{-34,0},{-100,0}}, color={0,0,127}));
  connect(multiSum.y, integrator.u)
    annotation (Line(points={{-20.98,0},{38,0}}, color={0,0,127}));
  connect(y, integrator.y)
    annotation (Line(points={{117,0},{61,0}}, color={0,0,127}));
  annotation (Icon(graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid)}), Documentation(info="<html>
<p>
Block that sums all input signals, and outputs the time integrated value of this sum.
This block is used to convert power to energy.
</p>
</html>", revisions="<html>
<ul>
<li>
January 16, 2020, by Michael Wetter:<br/>
Added documentation.
</li>
</ul>
</html>"));
end PowerMeter;
