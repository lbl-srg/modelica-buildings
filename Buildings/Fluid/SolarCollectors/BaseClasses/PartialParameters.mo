within Buildings.Fluid.SolarCollectors.BaseClasses;
block PartialParameters "Partial model for parameters"

  parameter Modelica.SIunits.Area A_c "Area of the collector";
  parameter Integer nSeg(min=3)=3 "Number of segments";
    parameter Real y_intercept "Y intercept (Maximum efficiency)";
  annotation(Documentation(info="<html>
  <p>
  Partial parameters used in all solar collector models
  </p>
  </html>"));
end PartialParameters;
