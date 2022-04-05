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

  // Vectorized sub-bus need to be declared, otherwise Modelica doesn't know
  // how to expand undeclared parameter in connect statement such as
  // connect(busCon.valCHWChi.y, valCHWChi.y)

  Buildings.Templates.Components.Interfaces.Bus chi[nChi]
    annotation (HideResult=false);
  Buildings.Templates.Components.Interfaces.Bus valCHWChi[nChi]
    annotation (HideResult=false);
  Buildings.Templates.Components.Interfaces.Bus cooTow[nCooTow] if not isAirCoo
    annotation (HideResult=false);
  Buildings.Templates.Components.Interfaces.Bus valCooTowInl[nCooTow] if not isAirCoo
    annotation (HideResult=false);
  Buildings.Templates.Components.Interfaces.Bus valCooTowOut[nCooTow] if not isAirCoo
    annotation (HideResult=false);
  Buildings.Templates.Components.Interfaces.Bus valCWChi[nChi] if not isAirCoo
    annotation (HideResult=false);

equation

  connect(busCon.valByp.y, yValByp.y);
  connect(busCon.valChiByp.y, yValChiByp.y);

  for i in 1:nChi loop
    connect(chi[i].TSet, chiTSet[i].y);
    connect(chi[i].on, chiOn[i].y);
    connect(valCHWChi[i].y, yValCHWChi[i].y);
    connect(valCWChi[i].y, yValCWChi[i].y);
  end for;
  connect(busCon.chi, chi);
  connect(busCon.valCHWChi, valCHWChi);
  connect(busCon.valCWChi, valCWChi);

  connect(busCon.pumPri.y, yPumPri.y);
  connect(busCon.pumPri.ySpe, ySpePumPri.y);

  connect(busCon.pumSec.y, yPumSec.y);
  connect(busCon.pumSec.ySpe, ySpePumSec.y);

  for i in 1:nCooTow loop
    connect(cooTow[i].y, yCooTowFan[i].y);
    connect(valCooTowInl[i].y, yValCooTowInl[i].y);
    connect(valCooTowOut[i].y, yValCooTowOut[i].y);
  end for;
  connect(busCon.cooTow, cooTow);
  connect(busCon.valCooTowInl, valCooTowInl);
  connect(busCon.valCooTowOut, valCooTowOut);

  connect(busCon.pumCon.y, yPumCon.y);
  connect(busCon.pumCon.ySpe, ySpePumCon.y);
  connect(busCon.valCWWSE.y, yValCWWSE.y);

  annotation (
  defaultComponentName="conCHW",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end OpenLoop;
