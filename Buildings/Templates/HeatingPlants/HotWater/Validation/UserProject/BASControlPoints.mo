within Buildings.Templates.HeatingPlants.HotWater.Validation.UserProject;
block BASControlPoints "Emulation of control points from the BAS"
  extends Modelica.Blocks.Icons.Block;
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TOut(
    k=10+273.15)
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-8,-10},{12,10}})));

  Interfaces.Bus bus "HW plant control bus"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={100,0}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={100,0})));
equation
  connect(TOut.y, bus.TOut);
  annotation (
    defaultComponentName="sigBAS",
    Documentation(info="<html>
<p>
This class generates signals typically provided by the BAS.
It is aimed for validation purposes only.
</p>
</html>"));
end BASControlPoints;
