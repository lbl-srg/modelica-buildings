within Buildings.Controls.OBC.CDL.Types.Validation;
model SunRiseSet
  extends Modelica.Icons.Example;

  Buildings.Utilities.Time.ModelTime modTim "Model time"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  SunRiseSet sunRiseSet(
    lon=-1.221730476396,
    lat=1.2566370614359,
    timZon=-18000)
    annotation (Placement(transformation(extent={{42,-10},{62,10}})));
equation

  connect(modTim.y, sunRiseSet.nDay)
    annotation (Line(points={{-9,0},{40,0}}, color={0,0,127}));
  annotation (uses(Buildings(version="5.1.0")));
end SunRiseSet;
