within Buildings.Examples.DistrictReservoirNetworks.Networks;
model TJunction
  extends Buildings.Fluid.FixedResistances.Junction(
  final dp_nominal={0,0,0},
  final tau=5*60);
  annotation (Icon(graphics={Ellipse(
          extent={{-38,36},{40,-40}},
          lineColor={28,108,200},
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid)}));
end TJunction;
