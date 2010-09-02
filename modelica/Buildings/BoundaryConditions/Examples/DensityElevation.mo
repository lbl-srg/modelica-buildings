within Buildings.BoundaryConditions.Examples;
model DensityElevation "Test model for air density by elevation"
  import Buildings;
  Modelica.SIunits.Density airDen "Air density";
  parameter Modelica.SIunits.Height h=1000 "Elevation of the location";
equation
  airDen = Buildings.BoundaryConditions.Density_Elevation(h);
  annotation (Diagram(graphics), Commands(file="DensityElevation.mos" "run"));
end DensityElevation;
