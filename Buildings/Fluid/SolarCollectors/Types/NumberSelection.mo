within Buildings.Fluid.SolarCollectors.Types;
type NumberSelection = enumeration(
    Number "Number of panels",
    Area "Total panel area") "Enumeration of options for how users will specify
      the number of solar collectors in a system"
  annotation(Documentation(info="<html>
<p>
Enumeration used to define the different methods of declaring solar thermal
system size.
</p>
</html>"));
