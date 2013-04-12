within Buildings.Fluid.SolarCollectors.BaseClasses;
partial block PartialParameters "partial model for parameters"
  parameter Modelica.SIunits.Area A_c "Area of the collector";
  parameter Integer nSeg( min = 2)=3 "Number of segments";
    parameter Real y_intercept "Y intercept (Maximum efficiency)";
  annotation(Documentation(info="<html>
  Partial parameters used in all solar collector models</html>"));
end PartialParameters;
