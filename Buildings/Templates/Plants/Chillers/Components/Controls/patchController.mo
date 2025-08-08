within Buildings.Templates.Plants.Chillers.Components.Controls;
block patchController
  extends Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Controller;
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dpChiWatPumSet[nSenChiWatPum](
     final unit=fill("Pa", nSenChiWatPum), final quantity=fill(
        "PressureDifference", nSenChiWatPum))
    "Chilled water differential pressure setpoint" annotation (Placement(
        transformation(extent={{0,800},{40,840}}), iconTransformation(extent={{140,
            -160},{180,-120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput FIXME_yConWatIsoVal[nChi](
    final min=fill(0, nChi),
    final max=fill(1, nChi),
    final unit=fill("1", nChi))
    if have_heaConWatPum and not (not have_fixSpeConWatPum and not have_WSE)
    "Condenser water isolation valve position: incorrect enable condition"
    annotation (Placement(transformation(extent={{936,190},{976,230}}),
        iconTransformation(extent={{138,60},{178,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput FIXME_y1ConWatIsoVal[nChi]
    if have_heaConWatPum and not have_fixSpeConWatPum and not have_WSE
    "Chiller condenser water isolation valve commanded setpoint: incorrect enable condition"
    annotation (Placement(transformation(extent={{938,300},{978,340}}),
        iconTransformation(extent={{140,90},{180,130}})));
equation
  connect(chiWatSupSet.dpChiWatPumSet, dpChiWatPumSet) annotation (Line(points=
          {{-476,452},{-380,452},{-380,820},{20,820}}, color={0,0,127}));
  connect(disChi.yConWatIsoVal, FIXME_yConWatIsoVal) annotation (Line(points={{
          762,-466},{780,-466},{780,210},{956,210}}, color={0,0,127}));
  connect(disChi.y1ConWatIsoVal, FIXME_y1ConWatIsoVal) annotation (Line(points=
          {{762,-468},{826,-468},{826,320},{958,320}}, color={255,0,255}));
end patchController;
