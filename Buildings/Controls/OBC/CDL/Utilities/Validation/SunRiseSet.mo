within Buildings.Controls.OBC.CDL.Utilities.Validation;
model SunRiseSet "Test model for the block SunRiseSet"
  extends Modelica.Icons.Example;

  Buildings.Utilities.Time.ModelTime modTim
    "Model time as the required input number of day"
    annotation (Placement(transformation(extent={{-46,-10},{-26,10}})));
  Buildings.Controls.OBC.CDL.Utilities.SunRiseSet sunRiseSet_arctic(
    lon=-1.2566370614359,
    lat=1.2566370614359,
    timZon=-18000) "Arctic circle case"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Buildings.Controls.OBC.CDL.Utilities.SunRiseSet sunRiseSet_sf(
    lon=-2.1293016874331,
    lat=0.6457718232379,
    timZon=-28800)
    "Sunrise and sunset hours in San Francisco as a normal test example"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Utilities.SunRiseSet sunRiseSet_antarctic(
    lon=0.99483767363677,
    lat=-1.3089969389957,
    timZon=14400) "Antarctic circle case"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
equation

  connect(modTim.y, sunRiseSet_arctic.nDay)
    annotation (Line(points={{-25,0},{8,0},{8,40},{38,40}}, color={0,0,127}));
  connect(modTim.y, sunRiseSet_sf.nDay)
    annotation (Line(points={{-25,0},{38,0}}, color={0,0,127}));
  connect(modTim.y, sunRiseSet_antarctic.nDay)
    annotation (Line(points={{-25,0},{8,0},{8,-40},{38,-40}}, color={0,0,127}));

annotation (
  experiment(StopTime=31536000, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Utilities/Validation/SunRiseSet.mos"
        "Simulate and plot"),
  Documentation(info="<html>
  <p>
  This example includes 3 tests for the SunRiseSet component: a normal case,
  an arctic and antarctic case.
  </p>
  <p>
  The normal case is represented by San Francisco,
  where there is sunrise and sunset every day.
  </p>
  <p>
  In the arctic circle (in the north hemisphere),
  there is no sunset in summer and no sunrise in winter for consecutive days.
  </p>
  <p>
  In the antarctic circle (in the south hemisphere), there is no sunrise in summer
  and no sunset in winter for consecutive days.</p>
  </html>",
  revisions="<html>
  <ul>
  <li>
  November 27, 2018, by Kun Zhang:<br/>
  First implementation.
  </li>
  </ul>
  </html>"));
end SunRiseSet;
