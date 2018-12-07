within Buildings.Controls.OBC.CDL.Utilities.Validation;
model SunRiseSet "Test model for the block SunRiseSet"
  extends Modelica.Icons.Example;

  Buildings.Utilities.Time.ModelTime modTim
    "Model time as the required input number of day"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Utilities.SunRiseSet sunRiseSetArctic(
    lat=1.2566370614359,
    lon=-1.2566370614359,
    timZon=-18000) "Arctic circle case"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  Buildings.Controls.OBC.CDL.Utilities.SunRiseSet sunRiseSetSf(
    lat=0.6457718232379,
    lon=-2.1293016874331,
    timZon=-28800)
    "using San Francisco as a test example in the northen hemisphere"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Buildings.Controls.OBC.CDL.Utilities.SunRiseSet sunRiseSetAntarctic(
    lat=-1.3089969389957,
    lon=0.99483767363677,
    timZon=14400) "Antarctic circle case"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Buildings.Controls.OBC.CDL.Utilities.SunRiseSet sunRiseSetSyd(
    lat=-0.59341194567807,
    lon=2.6354471705114,
    timZon=36000) "using Sydney as a test example in the southern hemisphere"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
equation

  connect(modTim.y, sunRiseSetArctic.nDay)
    annotation (Line(points={{-39,0},{0,0},{0,60},{38,60}}, color={0,0,127}));
  connect(modTim.y, sunRiseSetSf.nDay) annotation (Line(points={{-39,0},{0,0},{
          0,-20},{38,-20}}, color={0,0,127}));
  connect(modTim.y, sunRiseSetAntarctic.nDay)
    annotation (Line(points={{-39,0},{0,0},{0,20},{38,20}}, color={0,0,127}));

  connect(modTim.y, sunRiseSetSyd.nDay) annotation (Line(points={{-39,0},{0,0},
          {0,-60},{38,-60}}, color={0,0,127}));
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
