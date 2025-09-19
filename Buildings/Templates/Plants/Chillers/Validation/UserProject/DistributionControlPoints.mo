within Buildings.Templates.Plants.Chillers.Validation.UserProject;
block DistributionControlPoints
  "Emulation of control points from CHW distribution system"
  extends Modelica.Blocks.Icons.Block;

  parameter Integer nSenDpChiWatRem
    "Number of remote CHW differential pressure sensors used for CHW pump speed control"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dpChiWatRem[nSenDpChiWatRem](
    each k=Buildings.Templates.Data.Defaults.dpChiWatRemSet_max)
    "CHW differential pressure used for CHW pump speed control"
    annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
  Plants.Chillers.Interfaces.Bus bus "CHW plant control bus" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={100,0}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={100,0})));
equation
  connect(dpChiWatRem.y, bus.dpChiWatRem) annotation (Line(points={{14,0},{100,
          0}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (Documentation(info="<html>
<p>
This class generates signals typically yielded by
sensors from the CHW distribution system.
It is aimed for validation purposes only.
</p>
</html>"));
end DistributionControlPoints;
