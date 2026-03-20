within Buildings.Templates.Plants.Chillers.Components.Controls;
block patchController
  extends Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Controller;
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput FIXME_dpChiWatSet[
    nSenChiWatPum](final quantity=fill("PressureDifference", nSenChiWatPum),
    final unit=fill("Pa", nSenChiWatPum)) if not have_senDpChiWatRemWir
    "Invalid condition"
    annotation(Placement(transformation(extent={{1162,562},{1202,602}}),
        iconTransformation(extent={{120,180},{160,220}})));
equation
  connect(chiWatSupSet.dpChiWatSet, FIXME_dpChiWatSet)
    annotation (Line(points={{-476,452},{305,452},{305,582},{1182,582}},
                                                      color={0,0,127}));
end patchController;
