within Buildings.BoundaryConditions.SolarGeometry.BaseClasses.Examples;
model SolarHourAngle "Test model for solar hour angle"
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.SolarTime solTim
    "Solar time"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.EquationOfTime eqnTim
    "Equation of time"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.LocalTime locTim
    "Local time"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.SolarHourAngle
    solHouAng "Solar hour Angle"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Utilities.SimulationTime simTim
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
equation
  connect(solTim.solTim, solHouAng.solTim) annotation (Line(
      points={{21,30},{38,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(locTim.locTim, solTim.locTim) annotation (Line(
      points={{-19,10},{-10,10},{-10,24.6},{-2,24.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(eqnTim.eqnTim, solTim.equTim) annotation (Line(
      points={{-19,50},{-10,50},{-10,36},{-2,36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(simTim.y, locTim.cloTim) annotation (Line(
      points={{-59,30},{-50,30},{-50,10},{-42,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(simTim.y, eqnTim.nDay) annotation (Line(
      points={{-59,30},{-50,30},{-50,50},{-42,50}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Commands(file="SolarHourAngle.mos" "run"));
end SolarHourAngle;
