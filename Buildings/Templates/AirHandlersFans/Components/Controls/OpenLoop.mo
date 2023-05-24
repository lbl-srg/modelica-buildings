within Buildings.Templates.AirHandlersFans.Components.Controls;
block OpenLoop "Open loop controller"
  extends
    Buildings.Templates.AirHandlersFans.Components.Interfaces.PartialControllerVAVMultizone(
      final typ=Buildings.Templates.AirHandlersFans.Types.Controller.OpenLoop);

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yDamOut(k=1)
 if secOutRel.typDamOut == Buildings.Templates.Components.Types.Damper.Modulating
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-180,170})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant yDamOut1(k=true)
 if secOutRel.typDamOut == Buildings.Templates.Components.Types.Damper.TwoPosition
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-170,144})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yDamOutMin(k=1)
 if secOutRel.typDamOutMin == Buildings.Templates.Components.Types.Damper.Modulating
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-150,170})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant yDamOutMin1(k=true)
 if secOutRel.typDamOutMin == Buildings.Templates.Components.Types.Damper.TwoPosition
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-140,144})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yDamRet(k=1)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-120,170})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yDamRel(k=1)
 if secOutRel.typDamRel == Buildings.Templates.Components.Types.Damper.Modulating
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-90,170})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant yDamRel1(k=true)
 if secOutRel.typDamRel == Buildings.Templates.Components.Types.Damper.TwoPosition
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-60,170})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yCoiCoo(k=1) if coiCoo.typ
     == Buildings.Templates.Components.Types.Coil.WaterBasedCooling or coiCoo.typ
     == Buildings.Templates.Components.Types.Coil.EvaporatorVariableSpeed
     annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-60,110})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant yCoiCooSta(k=1)
    if coiCoo.typ == Buildings.Templates.Components.Types.Coil.EvaporatorMultiStage
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,110})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yFanSup(k=1)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,70})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant y1FanSup(k=true)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,70})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yCoiHea(k=1)
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,110})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yFanRet(k=1)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={160,70})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant y1FanRet(k=true)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={200,70})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yFanRel(k=1)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={80,70})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant y1FanRel(k=true)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={120,70})));
equation
  /* Control point connection - start */

  connect(yCoiCoo.y, bus.coiCoo.y);
  connect(yCoiHea.y, bus.coiHea.y);
  connect(yCoiCooSta.y, bus.coiCoo.y);

  connect(y1FanSup.y, bus.fanSup.y1);
  connect(yFanSup.y, bus.fanSup.y);
  connect(y1FanRel.y, bus.fanRel.y1);
  connect(yFanRel.y, bus.fanRel.y);
  connect(y1FanRet.y, bus.fanRet.y1);
  connect(yFanRet.y, bus.fanRet.y);

  connect(yDamOut.y, bus.damOut.y);
  connect(yDamOut1.y, bus.damOut.y1);
  connect(yDamOutMin.y, bus.damOutMin.y);
  connect(yDamOutMin1.y, bus.damOutMin.y1);
  connect(yDamRel.y, bus.damRel.y);
  connect(yDamRel1.y, bus.damRel.y1);
  connect(yDamRet.y, bus.damRet.y);
  /* Control point connection - stop */

  annotation (
  defaultComponentName="conAHU",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This is an open loop controller providing control inputs
for the templates within
<a href=\"modelica://Buildings.Templates.AirHandlersFans\">
Buildings.Templates.AirHandlersFans</a>.
It is mainly used for testing purposes.
</p>
</html>"));
end OpenLoop;
