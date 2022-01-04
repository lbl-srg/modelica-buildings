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
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yValCHWChi[nChi](each
      k=1) annotation (Placement(transformation(
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
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant ySpePumSec[nPumSec](
      each k=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={70,70})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant yValCWChi[nChi](each k=true)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-90,70})));

protected
  Buildings.Templates.Components.Interfaces.Bus busChi[nChi] "Chiller bus"
    annotation (Placement(transformation(extent={{120,-40},{160,0}})));
  Buildings.Templates.Components.Interfaces.Bus busValCHWChi[nChi]
    "Bus for chiller chilled water-side isolation valves"
    annotation (Placement(transformation(extent={{122,-82},{162,-42}})));
  Buildings.Templates.Components.Interfaces.Bus busValCWChi[nChi]
    "Bus for chiller condenser water-side isolation valves"
    annotation (Placement(transformation(extent={{-138,-80},{-98,-40}})));
equation
  /* Control point connection - start */
  connect(busCHW.pumPri.valByp.y, yValByp.y);
  connect(busCHW.pumPri.valChiByp.y, yValChiByp.y);
  connect(busCW.pum.yValWSE, yValWSE.y);
  connect(busChi.TSet, chiTSet.y);
  connect(busChi.on, chiOn.y);
  connect(busValCHWChi[:].y, yValCHWChi[:].y);
  connect(busValCWChi[:].y, yValCWChi[:].y);

  for i in 1:nPumPri loop
    connect(busCHW.pumPri.ySpe[i], ySpePumPri[i].y);
  end for;
  for i in 1:nPumSec loop
    connect(busCHW.pumSec.ySpe[i], ySpePumSec[i].y);
  end for;
  for i in 1:nCooTow loop
    connect(busCW.cooTow.yFan[i], yCooTowFan[i].y);
    connect(busCW.cooTow.yVal[i], yCooTowVal[i].y);
  end for;
  for i in 1:nPumCon loop
    connect(busCW.ySpe[i], ySpePumCon[i].y);
  end for;
  /* Control point connection - end */
  connect(busChi, busCHW.chi) annotation (Line(
      points={{140,-20},{194,-20},{194,0.1},{220.1,0.1}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(busValCHWChi, busCHW.valCHWChi) annotation (Line(
      points={{142,-62},{142,-60},{196,-60},{196,-58},{194,-58},{194,0.1},{220.1,
          0.1}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));

  connect(busValCWChi, busCW.valCWChi) annotation (Line(
      points={{-118,-60},{-118,0.1},{-197.9,0.1}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (
  defaultComponentName="conAHU",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end OpenLoop;
