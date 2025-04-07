within Buildings.Templates.Plants.Boilers.HotWater.Validation.UserProject;
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
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant u1Sch(k=true)
    "Plant enable schedule"
    annotation (Placement(transformation(extent={{-8,30},{12,50}})));
equation
  connect(TOut.y, bus.TOut)
    annotation (Line(points={{14,0},{100,0}}, color={0,0,127}));
  connect(u1Sch.y, bus.u1Sch) annotation (Line(points={{14,40},{80,40},{80,0},{
          100,0}}, color={255,0,255}));
  annotation (
    defaultComponentName="sigBAS",
    Documentation(info="<html>
<p>
This class generates signals typically provided by the BAS.
It is aimed for validation purposes only.
</p>
</html>"));
end BASControlPoints;
