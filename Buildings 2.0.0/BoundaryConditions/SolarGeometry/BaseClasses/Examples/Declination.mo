within Buildings.BoundaryConditions.SolarGeometry.BaseClasses.Examples;
model Declination "Test model for declination"
  extends Modelica.Icons.Example;
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.Declination decAng
    "Declination angle"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Buildings.Utilities.Time.ModelTime modTim "Model time"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
equation
  connect(modTim.y, decAng.nDay) annotation (Line(
      points={{1,10},{18,10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
  Documentation(info="<html>
<p>
This component computes the solar declination, which is the angle between
the equatorial plane and the solar beam.
</p>
</html>", revisions="<html>
<ul>
<li>
May 17, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
  experiment(StopTime=3.1536e+007),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/SolarGeometry/BaseClasses/Examples/Declination.mos"
        "Simulate and plot"));
end Declination;
