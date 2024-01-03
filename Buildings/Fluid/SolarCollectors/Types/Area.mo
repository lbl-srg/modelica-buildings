within Buildings.Fluid.SolarCollectors.Types;
type Area = enumeration(
    Gross "Gross area",
    Aperture "Net aperture area",
    Absorber "Absorber area")
  "Enumeration to define the area type used in solar collector calculation"
  annotation(Documentation(info="<html>
<p>
Enumeration used to define the different types of area measurements used
in solar collector testing.
</p>
</html>"));
