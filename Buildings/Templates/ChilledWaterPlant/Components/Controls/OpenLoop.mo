within Buildings.Templates.ChilledWaterPlant.Components.Controls;
block OpenLoop "Open loop controller (output signals only)"
  extends
    Buildings.Templates.ChilledWaterPlant.Components.Controls.Interfaces.PartialController(
      final typ=Buildings.Templates.ChilledWaterPlant.Components.Types.Controller.OpenLoop);

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant yDamRel1(k=true)
 if secOutRel.typDamRel == Buildings.Templates.Components.Types.Damper.TwoPosition
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={90,50})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yCoiCoo(k=1) if coiCoo.typ
     == Buildings.Templates.Components.Types.Coil.WaterBased or coiCoo.typHex
     == Buildings.Templates.Components.Types.HeatExchanger.DXVariableSpeed
     annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={130,50})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant yCoiCooSta(k=1)
    if coiCoo.typHex == Buildings.Templates.Components.Types.HeatExchanger.DXMultiStage
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={170,50})));
equation
  /* Hardware point connection - start */

  connect(yCoiCoo.y, bus.coiCoo.y);
  connect(yCoiHea.y, bus.coiHea.y);
  connect(yCoiCooSta.y, bus.coiCoo.y);

  connect(yFanSup.y, bus.fanSup.y);
  connect(ySpeFanSup.y, bus.fanSup.ySpe);
  connect(yFanRet.y, bus.fanRet.y);
  connect(ySpeFanRet.y, bus.fanRet.ySpe);

  connect(yDamOut.y, bus.damOut.y);
  connect(yDamOut1.y, bus.damOut.y);
  connect(yDamOutMin.y, bus.damOutMin.y);
  connect(yDamOutMin1.y, bus.damOutMin.y);
  connect(yDamRel.y, bus.damRel.y);
  connect(yDamRel1.y, bus.damRel.y);
  connect(yDamRet.y, bus.damRet.y);
  /* Hardware point connection - stop */

  annotation (
  defaultComponentName="conAHU",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end OpenLoop;
