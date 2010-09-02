within Buildings.BoundaryConditions.SkyTemperature.BaseClasses.Examples;
model DiurnalCorrection "Test model for diurnal correction"
  import Buildings;
public
  Buildings.Utilities.SimulationTime simTim
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.BoundaryConditions.SkyTemperature.BaseClasses.DiurnalCorrection_t
    diuCor_t annotation (Placement(transformation(extent={{-20,0},{0,20}})));
equation
  connect(simTim.y, diuCor_t.cloTim) annotation (Line(
      points={{-39,10},{-22,10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Commands(file="DiurnalCorrection.mos" "run"));
end DiurnalCorrection;
