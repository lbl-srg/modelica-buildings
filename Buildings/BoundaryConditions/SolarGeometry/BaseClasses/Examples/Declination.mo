within Buildings.BoundaryConditions.SolarGeometry.BaseClasses.Examples;
model Declination "Test model for declination"
  extends Modelica.Icons.Example;
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.Declination decAng
    "Declination angle"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Buildings.Utilities.Time.ModelTime modTim "Model time"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));

  Modelica.Blocks.Sources.TimeTable solDecNOAA(table=[
       0, -0.4007544;
 2678400, -0.2960882;
 5097600, -0.1292836;
 7776000,  0.0824143;
10368000,  0.2656267;
13046400,  0.3860123;
15638400,  0.4027150;
18316800,  0.3123199;
20995200,  0.1414929;
23587200, -0.0587907;
26265600, -0.2544026;
28857600, -0.3817216;
28944000, -0.3843185;
31536000, -0.4010977], y(unit="rad")) "Solar declination according to NOAA"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
equation
  connect(modTim.y, decAng.nDay) annotation (Line(
      points={{1,10},{18,10}},
      color={0,0,127}));
  annotation (
  Documentation(info="<html>
<p>This model validates the computation of the solar declination, which is the angle between the equatorial plane and the solar beam. The time table <code><span style=\"font-family: Courier New,courier;\">solDecNOAA</span></code> outputs the solar declination according to the computation of the National Oceanic and Atmospheric Administration (NOAA), using their yearly calculator from <a href=\"http://www.esrl.noaa.gov/gmd/grad/solcalc/calcdetails.html\">http://www.esrl.noaa.gov/gmd/grad/solcalc/calcdetails.html</a>. The values differ slightly because the equation in <a href=\"modelica://Buildings.BoundaryConditions.SolarGeometry.BaseClasses.Declination\">Buildings.BoundaryConditions.SolarGeometry.BaseClasses.Declination</a> is an approximation. </p>
</html>", revisions="<html>
<ul>
<li>
January 6, 2015, by Michael Wetter:<br/>
Updated documentation and added validation.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/382\">issue 382</a>.
</li>
<li>
May 17, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
  experiment(Tolerance=1e-6, StopTime=3.1536e+007),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/SolarGeometry/BaseClasses/Examples/Declination.mos"
        "Simulate and plot"));
end Declination;
