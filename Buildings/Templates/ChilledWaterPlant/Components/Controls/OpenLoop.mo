within Buildings.Templates.ChilledWaterPlant.Components.Controls;
block OpenLoop "Open loop controller (output signals only)"
  extends
    Buildings.Templates.ChilledWaterPlant.Components.Controls.Interfaces.PartialController(
      final typ=Buildings.Templates.ChilledWaterPlant.Components.Types.Controller.OpenLoop);

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant chiOn[nChi](each k=true)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={188,70})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiTSet[nChi](each k=1)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={188,110})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant ySpePumPri[nPumPri](each k=1)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={108,110})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yValByp(k=1)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={28,110})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yCooTowFan[nCooTow](
      each k=1) if not isAirCoo annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-50,110})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant yValCooTowInl[nCooTow](
      each k=true) if not isAirCoo annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-90,110})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant yValCooTowOut[nCooTow](
      each k=true) if not isAirCoo annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-90,70})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant ySpePumCon[nPumCon](
      each k=1) if not isAirCoo annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={68,110})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yValCHWChi[nChi](each
      k=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-170,70})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yValCWWSE(k=1)
    if not isAirCoo
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-130,70})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant yValChiByp(k=false)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={28,70})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant ySpePumSec[nPumSec](
      each k=1) if have_secondary annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={148,110})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant yValCWChi[nChi](each k=true)
    if not isAirCoo
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-170,110})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant yPumSec[nPumSec](each k=true)
    if have_secondary
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={148,70})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant yPumPri[nPumPri](each k=true)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={108,70})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant yPumCon[nPumCon](each k=true)
    if not isAirCoo
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={68,70})));
protected
  Buildings.Templates.Components.Interfaces.Bus busCooTow[nCooTow]
    "Cooling towers control buses"
    annotation (Placement(transformation(extent={{40,-40},{80,0}})));
  Buildings.Templates.Components.Interfaces.Bus busValCooTowInl[nCooTow]
    "Cooling tower inlet valve control buses"
    annotation (Placement(transformation(extent={{40,-80},{80,-40}})));
  Buildings.Templates.Components.Interfaces.Bus busValCooTowOut[nCooTow]
    "Cooling tower outlet valve control buses"
    annotation (Placement(transformation(extent={{40,-120},{80,-80}})));
equation
  connect(busCon.valByp.y, yValByp.y);
  connect(busCon.valChiByp.y, yValChiByp.y);
  connect(busCon.chi.TSet, chiTSet.y);
  connect(busCon.chi.on, chiOn.y);
  connect(busCon.valCHWChi.y, yValCHWChi.y);
  connect(busCon.pumPri.y, yPumPri.y);
  connect(busCon.pumPri.ySpe, ySpePumPri.y);

  connect(busCon.pumSec.y, yPumSec.y);
  connect(busCon.pumSec.ySpe, ySpePumSec.y);

  connect(yCooTowFan.y, busCooTow.y);
  connect(busValCooTowInl.y, yValCooTowInl.y);
  connect(busValCooTowOut.y, yValCooTowOut.y);
  connect(busCon.cooTow, busCooTow);
  connect(busCon.valCooTowInl, busValCooTowInl);
  connect(busCon.valCooTowOut, busValCooTowOut);

  connect(busCon.valCWChi.y, yValCWChi.y);
  connect(busCon.pumCon.y, yPumCon.y);
  connect(busCon.pumCon.ySpe, ySpePumCon.y);
  connect(busCon.valCWWSE.y, yValCWWSE.y);

  annotation (
  defaultComponentName="conCHW",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end OpenLoop;
