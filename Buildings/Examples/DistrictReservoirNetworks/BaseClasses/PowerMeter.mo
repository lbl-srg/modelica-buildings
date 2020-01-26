within Buildings.Examples.DistrictReservoirNetworks.BaseClasses;
block PowerMeter
  "Block that sums input, integrates it from power to energy and normalized the output"
  extends Modelica.Blocks.Interfaces.PartialRealMISO(
   u(each unit="W"),
   y(unit="1"));

  Modelica.Blocks.Math.MultiSum multiSum(final nu=nu)
    annotation (Placement(transformation(extent={{-34,-6},{-22,6}})));
  Modelica.Blocks.Continuous.Integrator integrator(
    final k=1/totEneRN3,
    final initType=Modelica.Blocks.Types.Init.InitialState)
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
protected
 constant Modelica.SIunits.Energy totEneRN3 = 2.72961e+12
   "Total energy for Reservoir 3 that is used to normalized results";
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
Block that sums all input signals, and outputs the time integrated value of this sum,
normalized by the constant
<a href=\"modelica://Buildings.Examples.DistrictReservoirNetworks.totalEnergyRN3\">
Buildings.Examples.DistrictReservoirNetworks.totalEnergyRN3</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 25, 2020, by Michael Wetter:<br/>
Normalized output by the total energy of the reservoir network 3.
</li>
<li>
January 16, 2020, by Michael Wetter:<br/>
Added documentation.
</li>
</ul>
</html>"));
end PowerMeter;
