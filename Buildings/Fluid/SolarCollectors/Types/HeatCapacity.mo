within Buildings.Fluid.SolarCollectors.Types;
type HeatCapacity = enumeration(
    TotalCapacity
      "Total thermal capacity of the solar collector (i.e. including fluid)",
    DryCapacity
      "Dry thermal capacity and fluid volume of the solar collector",
    DryMass
      "Dry mass and fluid volume of the solar collector")
  "Enumeration to define how the heat capacity of the solar collector is calculated"
  annotation(Documentation(info="<html>
<p>
Enumeration used to define the different types of area measurements used
in solar collector testing.
</p>
</html>"));
