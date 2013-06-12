within Buildings.Fluid.SolarCollectors.Types;
type SystemConfiguration = enumeration(
    Parallel "Panels connected in parallel",
    Series "Panels connected in series")
  "Enumeration of options for how the panels are connected"
  annotation(Documentation(info="<html>
  Enumeration used to define the different types of area measurements 
  used in solar collector testing.</html>"));
