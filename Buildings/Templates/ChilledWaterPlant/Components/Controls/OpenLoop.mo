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
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yValChiWatChi[nChi](each
      k=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-170,70})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yValConWatEco(k=1)
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
      each k=1) if have_secPum annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={148,110})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant yValConWatChi[nChi](each k=true)
    if not isAirCoo
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-170,110})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant yPumSec[nPumSec](each k=true)
    if have_secPum
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
  // connect(busCon.valCooTowInl.y, valCooTowInl.y)

  // FIXME : These bus declarations shouldn't be needed (see connect statement below)

  Buildings.Templates.Components.Interfaces.Bus cooTow[nCooTow] if not isAirCoo
    annotation (HideResult=false);
  Buildings.Templates.Components.Interfaces.Bus valCooTowInl[nCooTow] if not isAirCoo
    annotation (HideResult=false);
  Buildings.Templates.Components.Interfaces.Bus valCooTowOut[nCooTow] if not isAirCoo
    annotation (HideResult=false);

//   Buildings.Templates.Components.Interfaces.Bus chi[nChi]
//     annotation (HideResult=false);
//   Buildings.Templates.Components.Interfaces.Bus valChiWatChi[nChi]
//     annotation (HideResult=false);
//   Buildings.Templates.Components.Interfaces.Bus valConWatChi[nChi] if not isAirCoo
//     annotation (HideResult=false);

equation

  connect(busCon.valByp.y, yValByp.y);
  connect(busCon.valChiByp.y, yValChiByp.y);

  connect(busCon.chi.TSet, chiTSet.y);
  connect(busCon.chi.on, chiOn.y);
  connect(busCon.valChiWatChi.y, yValChiWatChi.y);
  connect(busCon.valConWatChi.y1, yValConWatChi.y);

  connect(busCon.pumPri.y1, yPumPri.y);
  connect(busCon.pumPri.y, ySpePumPri.y);

  connect(busCon.pumSec.y1, yPumSec.y);
  connect(busCon.pumSec.y, ySpePumSec.y);

// FIXME: Should be connect(busCon.cooTow.y, yCooTowFan.y);
  connect(cooTow.y, yCooTowFan.y);
  connect(busCon.cooTow, cooTow);

// FIXME: Should be connect(busCon.valCooTowInl.y1, yValCooTowInl.y);
  connect(valCooTowInl.y1, yValCooTowInl.y);
  connect(busCon.valCooTowInl, valCooTowInl);

// FIXME: Should be connect(busCon.valCooTowOut.y1, yValCooTowOut.y);
  connect(valCooTowOut.y1, yValCooTowOut.y);
  connect(busCon.valCooTowOut, valCooTowOut);

  connect(busCon.pumCon.y1, yPumCon.y);
  connect(busCon.pumCon.y, ySpePumCon.y);
  connect(busCon.valConWatEco.y, yValConWatEco.y);

  annotation (
  defaultComponentName="conChiWat",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end OpenLoop;
