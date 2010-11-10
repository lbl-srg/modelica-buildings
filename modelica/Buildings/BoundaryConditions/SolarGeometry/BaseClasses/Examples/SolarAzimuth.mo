within Buildings.BoundaryConditions.SolarGeometry.BaseClasses.Examples;
model SolarAzimuth "Test model for zenith angle"
  parameter Modelica.SIunits.Angle lat= 0.2 "Latitude";
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.SolarTime solTim
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.EquationOfTime eqnTim
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.LocalTime locTim
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.SolarHourAngle
    solHouAng "Solar hour angle"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.ZenithAngle zenAng(lat=lat)
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.Declination decAng
    "Declination angle"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.SolarAzimuth solAzi(lat=lat)
    annotation (Placement(transformation(extent={{100,10},{120,30}})));
  Utilities.SimulationTime simTim
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
equation
  connect(eqnTim.eqnTim, solTim.equTim) annotation (Line(
      points={{-39,10},{-30,10},{-30,-4},{-22,-4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solTim.solTim, solHouAng.solTim) annotation (Line(
      points={{1,-10},{18,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(zenAng.zenAng, solAzi.zenAng) annotation (Line(
      points={{81,50},{90,50},{90,26},{98,26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(locTim.locTim, solTim.locTim) annotation (Line(
      points={{-39,-30},{-30,-30},{-30,-15.4},{-22,-15.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solTim.solTim, solAzi.solTim) annotation (Line(
      points={{1,-10},{10,-10},{10,-38},{90,-38},{90,14},{98,14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(decAng.decAng, zenAng.decAng) annotation (Line(
      points={{-39,50},{8,50},{8,55.4},{58,55.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solHouAng.solHouAng, zenAng.solHouAng) annotation (Line(
      points={{41,-10},{48,-10},{48,45.2},{58,45.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(simTim.y, eqnTim.nDay) annotation (Line(
      points={{-79,10},{-62,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(simTim.y, decAng.nDay) annotation (Line(
      points={{-79,10},{-70,10},{-70,50},{-62,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(simTim.y, locTim.cloTim) annotation (Line(
      points={{-79,10},{-70,10},{-70,-30},{-62,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(decAng.decAng, solAzi.decAng) annotation (Line(
      points={{-39,50},{8,50},{8,20},{98,20}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{150,
            100}}), graphics),
    Commands(file="SolarAzimuth.mos" "run"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{150,
            100}})));
end SolarAzimuth;
