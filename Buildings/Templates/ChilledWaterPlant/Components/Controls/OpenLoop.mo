within Buildings.Templates.ChilledWaterPlant.Components.Controls;
block OpenLoop "Open loop controller (output signals only)"
  extends
    Buildings.Templates.ChilledWaterPlant.Components.Controls.Interfaces.PartialController(
      final typ=Buildings.Templates.ChilledWaterPlant.Components.Types.Controller.OpenLoop);

  //  Buildings.Controls.OBC.CDL.Integers.Sources.Constant


  Buildings.Controls.OBC.CDL.Logical.Sources.Constant chiOn[nChi](each k=true)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={130,110})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiTSet[nChi](each k=1)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={170,110})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant ySpePumPri[nPumPri](each k=1)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={90,110})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yValByp(k=1)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={10,110})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yCooTowFan[nCooTow](
      each k=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-50,110})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant yCooTowVal[nCooTow](
      each k=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-90,110})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant ySpePumCon[nPumCon](
      each k=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={50,110})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yValChi[nChi](each k=1)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-170,70})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yValWSE(k=1)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-130,70})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant yValChiByp(k=false)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={10,70})));
equation
  /* Control point connection - start */
  connect(busCHW.pumPri.valByp.y, yValByp.y);
  connect(busCHW.pumPri.valChiByp.y, yValChiByp.y);
  connect(busCW.pum.yValWSE, yValWSE.y);
  for i in 1:nChi loop
    connect(busCHW.chiGro.chi[i].TSet, chiTSet[i].y);
    connect(busCHW.chiGro.chi[i].on, chiOn[i].y);
    connect(busCHW.chiGro.yValChi[i], yValChi[i].y);
    connect(busCW.pum.yValChi[i], yValChi[i].y);
  end for;
  for i in 1:nPumPri loop
    connect(busCHW.pumPri.ySpe[i], ySpePumPri[i].y);
  end for;
  for i in 1:nCooTow loop
    connect(busCW.cooTow.yFan[i], yCooTowFan[i].y);
    connect(busCW.cooTow.yVal[i], yCooTowVal[i].y);
  end for;
  for i in 1:nPumCon loop
    connect(busCW.pum.ySpe[i], ySpePumCon[i].y);
  end for;
  /* Control point connection - end */
  annotation (
  defaultComponentName="conAHU",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end OpenLoop;
