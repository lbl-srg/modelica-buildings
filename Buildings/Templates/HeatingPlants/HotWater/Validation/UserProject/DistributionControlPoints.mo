within Buildings.Templates.HeatingPlants.HotWater.Validation.UserProject;
block DistributionControlPoints
  "Emulation of control points from HW distribution system"
  extends Modelica.Blocks.Icons.Block;

  parameter Integer nSenDpHeaWatRem
    "Number of remote HW differential pressure sensors used for HW pump speed control"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  Controls.OBC.CDL.Continuous.Sources.Constant dpHeaWatRem[nSenDpHeaWatRem](
    each k=Buildings.Templates.Data.Defaults.dpHeaWatSet_max)
    "HW differential pressure used for HW pump speed control"
    annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
  Interfaces.Bus bus "CHW plant control bus" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={100,0}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={100,0})));
equation
  connect(dpHeaWatRem.y, bus.dpHeaWatRem)
  annotation (Line(points={{14,0},{100,
          0}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
This class generates signals typically yielded by sensors 
from the HW distribution system. 
It is aimed for validation purposes only.
</p>
</html>"));
end DistributionControlPoints;
