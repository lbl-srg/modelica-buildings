within Buildings.Templates.ChilledWaterPlants.Components.Controls;
block OpenLoop "Open loop controller (output signals only)"
  extends
    Buildings.Templates.ChilledWaterPlants.Components.Controls.Interfaces.PartialController(
      final typ=Buildings.Templates.ChilledWaterPlants.Components.Types.Controller.OpenLoop);

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
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yValPriMinFloByp(k=1)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={28,110})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yCooTowFan[nCooTow](
      each k=1) if not isAirCoo annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-50,110})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant yCooTowOn[nCooTow](
      each k=true) if not isAirCoo annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-50,70})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant yValCooTowInlIso[nCooTow](
      each k=true) if not isAirCoo annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-90,110})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant yValCooTowOutIso[nCooTow](
      each k=true) if not isAirCoo annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-90,70})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant ySpePumCon[nPumCon](
      each k=1) if not isAirCoo annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={68,110})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yValChiWatChiIso[nChi](each
      k=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-170,70})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant yValConWatEcoIso(k=true)
    if not isAirCoo
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-130,110})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant yValChiWatChiByp(k=false)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={28,70})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant ySpePumSec[nPumSec](
      each k=1) if have_secPum annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={148,110})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant yValConWatChiIso[nChi](each k=true)
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
  // connect(busCon.valCooTowInlIso.y, valCooTowInlIso.y)

  // FIXME : These bus declarations shouldn't be needed (see connect statement below)

  Buildings.Templates.Components.Interfaces.Bus cooTow[nCooTow] if not isAirCoo
    annotation (HideResult=false);
  Buildings.Templates.Components.Interfaces.Bus valCooTowInlIso[nCooTow] if not isAirCoo
    annotation (HideResult=false);
  Buildings.Templates.Components.Interfaces.Bus valCooTowOutIso[nCooTow] if not isAirCoo
    annotation (HideResult=false);

//   Buildings.Templates.Components.Interfaces.Bus chi[nChi]
//     annotation (HideResult=false);
//   Buildings.Templates.Components.Interfaces.Bus valChiWatChiIso[nChi]
//     annotation (HideResult=false);
//   Buildings.Templates.Components.Interfaces.Bus valConWatChiIso[nChi] if not isAirCoo
//     annotation (HideResult=false);

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yValChiWatEcoByp(k=1)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-130,70})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant ySpePumEco[1](each k=1)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-130,30})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant yPumEco[1](each k=true)
    if not isAirCoo annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-130,-10})));
equation

  connect(bus.valPriMinFloByp.y, yValPriMinFloByp.y);
  connect(bus.valChiWatChiByp.y1, yValChiWatChiByp.y);

  connect(bus.chi.TChiWatChiSupSet, chiTSet.y);
  connect(bus.chi.y1, chiOn.y);
  connect(bus.valChiWatChiIso.y, yValChiWatChiIso.y);
  connect(bus.valConWatChiIso.y1, yValConWatChiIso.y);

  connect(bus.pumPri.y1, yPumPri.y);
  connect(bus.pumPri.y, ySpePumPri.y);

  connect(bus.pumSec.y1, yPumSec.y);
  connect(bus.pumSec.y, ySpePumSec.y);

// FIXME: Should be connect(busCon.cooTow.y, yCooTowFan.y);
  connect(cooTow.y, yCooTowFan.y);
  connect(cooTow.y1, yCooTowOn.y);
  connect(bus.cooTow, cooTow);

// FIXME: Should be connect(busCon.valCooTowInlIso.y1, yValCooTowInlIso.y);
  connect(valCooTowInlIso.y1, yValCooTowInlIso.y);
  connect(bus.valCooTowInlIso, valCooTowInlIso);

// FIXME: Should be connect(busCon.valCooTowOutIso.y1, yValCooTowOutIso.y);
  connect(valCooTowOutIso.y1, yValCooTowOutIso.y);
  connect(bus.valCooTowOutIso, valCooTowOutIso);

  connect(bus.pumCon.y1, yPumCon.y);
  connect(bus.pumCon.y, ySpePumCon.y);

  connect(bus.valConWatEcoIso.y1, yValConWatEcoIso.y);
  connect(bus.pumEco.y, ySpePumEco.y);
  connect(bus.pumEco.y1, yPumEco.y);
  connect(bus.valChiWatEcoByp.y, yValChiWatEcoByp.y);

  annotation (
  defaultComponentName="conChiWat",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end OpenLoop;
