within Buildings.Controls.OBC.CDL.Utilities.Validation;
model SunRiseSet2 "Test model for the block SunRiseSet"
  extends Modelica.Icons.Example;

  Buildings.Controls.OBC.CDL.Utilities.SunRiseSet sunRiseSetArctic(
    lat=1.2566370614359,
    lon=-1.2566370614359,
    timZon=-18000) "Arctic circle case"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Buildings.Controls.OBC.CDL.Utilities.SunRiseSet sunRiseSetSf(
    lat=0.6457718232379,
    lon=-2.1293016874331,
    timZon=-28800) "San Francisco as a test example in the northen hemisphere"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  Buildings.Controls.OBC.CDL.Utilities.SunRiseSet sunRiseSetAntarctic(
    lat=-1.3089969389957,
    lon=0.99483767363677,
    timZon=14400) "Antarctic circle case"
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  Buildings.Controls.OBC.CDL.Utilities.SunRiseSet sunRiseSetSyd(
    lat=-0.59341194567807,
    lon=2.6354471705114,
    timZon=36000) "Sydney as a test example in the southern hemisphere"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
equation

annotation (
  experiment(StartTime=43200, StopTime=345600, Tolerance=1e-06),
  __Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Utilities/Validation/SunRiseSet2.mos"
        "Simulate and plot", executeCall=simulateModel(
          "Buildings.Controls.OBC.CDL.Utilities.Validation.SunRiseSet2",
          startTime=43200,
          stopTime=345600,
          numberOfIntervals=500,
          method="dassl",
          tolerance=1e-06,
          resultFile="SunRiseSet2")),
  Documentation(info="<html>
<p>This example includes 4 tests for the <a href=\"modelica://Buildings.Controls.OBC.CDL.Utilities.SunRiseSet\">
Buildings.Controls.OBC.CDL.Utilities.SunRiseSet</a> block: 2 normal cases, an arctic and antarctic case.
The normal cases are represented by San Francisco and Sydney, where there is a sunrise and sunset every day. </p>
<p>This model starts the simulation from 12 hour instead of 0. </p>
</html>",
revisions="<html>
<ul>
<li>
November 27, 2018, by Kun Zhang:<br/>
First implementation.
</li>
</ul>
</html>"));
end SunRiseSet2;
