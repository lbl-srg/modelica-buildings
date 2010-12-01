within Buildings.BoundaryConditions.SolarGeometry.BaseClasses.Examples;
model IncidenceAngle "Test model for incidence angle"
  import Buildings;
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.SolarTime solTim
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.EquationOfTime eqnTim
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.LocalTime locTim
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.Declination decAng
    "Declination angle"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.SolarHourAngle
    solHouAng
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.IncidenceAngle incAng(
    lat=0,
    azi=0,
    til=90) annotation (Placement(transformation(extent={{60,10},{80,30}})));
  Buildings.Utilities.SimulationTime simTim
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
equation
  connect(eqnTim.eqnTim, solTim.equTim) annotation (Line(
      points={{-39,10},{-32,10},{-32,-4},{-22,-4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(locTim.locTim, solTim.locTim) annotation (Line(
      points={{-39,-30},{-32,-30},{-32,-15.4},{-22,-15.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solTim.solTim, solHouAng.solTim) annotation (Line(
      points={{1,-10},{18,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(decAng.decAng, incAng.decAng) annotation (Line(
      points={{41,50},{50,50},{50,25.4},{57.8,25.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solHouAng.solHouAng, incAng.solHouAng) annotation (Line(
      points={{41,-10},{48,-10},{48,15.2},{58,15.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(simTim.y, eqnTim.nDay) annotation (Line(
      points={{-79,10},{-62,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(simTim.y, locTim.cloTim) annotation (Line(
      points={{-79,10},{-70,10},{-70,-30},{-62,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(simTim.y, decAng.nDay) annotation (Line(
      points={{-79,10},{-70,10},{-70,50},{18,50}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Commands(file="IncidenceAngle.mos" "run"));
end IncidenceAngle;
