within Buildings.Examples.DistrictReservoirNetworks.Networks;
model TJunction
  extends Buildings.Fluid.FixedResistances.Junction(
  final dp_nominal={0,0,0},
  final tau=5*60);
  annotation (Icon(graphics={Ellipse(
          extent={{-38,36},{40,-40}},
          lineColor={28,108,200},
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid)}),
              Documentation(info="<html>
<p>
Model that sets parameters for the T-junctions that are used in all
the examples in
<a href=\"Buildings.Examples.DistrictReservoirNetworks\">
Buildings.Examples.DistrictReservoirNetworks</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 12, 2020, by Michael Wetter:<br/>
Added documentation.
</li>
</ul>
</html>"));
end TJunction;
