within Buildings.Templates.Plants.Chillers.Components.Controls;
block patchController
  extends Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Controller;
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput FIXME_yConWatIsoVal[nChi](
    final min=fill(0, nChi),
    final max=fill(1, nChi),
    final unit=fill("1", nChi))
    if have_heaConWatPum and not (not have_fixSpeConWatPum and not have_WSE)
    "Condenser water isolation valve position: incorrect enable condition"
    annotation(Placement(transformation(extent={{936,190},{976,230}}),
      iconTransformation(extent={{138,60},{178,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput FIXME_y1ConWatIsoVal[nChi]
    if have_heaConWatPum and not have_fixSpeConWatPum and not have_WSE
    "Chiller condenser water isolation valve commanded setpoint: incorrect enable condition"
    annotation(Placement(transformation(extent={{938,300},{978,340}}),
      iconTransformation(extent={{140,90},{180,130}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant FIXME_TConWatSup(
    final k=303.75)
    if closeCoupledPlant and not have_airCoo
    "Invalid condition in subcomponent"
    annotation(Placement(transformation(extent={{-980,-690},{-960,-670}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput FIXME_dpChiWatPumSet[nSenChiWatPum](
    final quantity=fill("PressureDifference", nSenChiWatPum),
    final unit=fill("Pa", nSenChiWatPum))
    if have_locSenChiWatPum
    "Invalid condition"
    annotation(Placement(transformation(extent={{1068,550},{1108,590}}),
      iconTransformation(extent={{140,210},{180,250}})));
equation
  connect(disChi.yConWatIsoVal, FIXME_yConWatIsoVal)
    annotation(Line(points={{762,-466},{780,-466},{780,210},{956,210}},
      color={0,0,127}));
  connect(disChi.y1ConWatIsoVal, FIXME_y1ConWatIsoVal)
    annotation(Line(points={{762,-468},{826,-468},{826,320},{958,320}},
      color={255,0,255}));
  connect(FIXME_TConWatSup.y, towCon.TConWatSup)
    annotation(Line(points={{-958,-680},{-380,-680},{-380,-660},{-268,-660}},
      color={0,0,127}));
  connect(chiWatSupSet.dpChiWatPumSet, FIXME_dpChiWatPumSet)
    annotation(Line(points={{-476,452},{305,452},{305,570},{1088,570}},
      color={0,0,127}));
end patchController;
