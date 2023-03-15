within Buildings.Templates.HeatingPlants.HotWater.Validation.UserProject;
block BASControlPoints "Emulation of control points from the BAS"
extends Modelica.Blocks.Icons.Block;

Interfaces.Bus bus "HW plant control bus" annotation (Placement(
      transformation(
      extent={{-10,-10},{10,10}},
      rotation=-90,
      origin={100,0}), iconTransformation(
      extent={{-10,-10},{10,10}},
      rotation=-90,
      origin={100,0})));
Controls.OBC.CDL.Continuous.Sources.Constant THeaWatSupSet(each k=60 + 273.15)
  "HW supply temperature setpoint"
  annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
connect(THeaWatSupSet.y, bus.THeaWatSupSet)
  annotation (Line(points={{12,0},{100,0}}, color={0,0,127}));
annotation (
  defaultComponentName="sigBAS",
  Diagram(coordinateSystem(preserveAspectRatio=
          false, extent={{-200,-180},{200,180}})),
  Documentation(info="<html>
<p>
This class generates signals typically provided by the BAS.
It is aimed for validation purposes only.
</p>
</html>"));
end BASControlPoints;
