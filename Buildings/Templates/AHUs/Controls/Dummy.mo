within Buildings.Templates.AHUs.Controls;
block Dummy "Dummy controller with constant signals"
  extends Buildings.Templates.BaseClasses.Controls.AHUs.SupplyReturn;

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yDamOut(k=1)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-180,170})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yDamRet(k=1)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-120,170})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yDamRel(k=1)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-90,170})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yCoiCoo(k=1) if
     coiCoo.typ == Buildings.Templates.Types.Coil.WaterBased or
     coiCoo.typHex == Buildings.Templates.Types.HeatExchanger.DXVariableSpeed
     annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-60,110})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant yCoiCooSta(k=1) if
    coiCoo.typHex == Buildings.Templates.Types.HeatExchanger.DXMultiStage
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,110})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant ySpeFanSup(k=1)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,70})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant yFanSup(k=true)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={100,70})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yDamOutMin(k=1)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-150,170})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yCoiHea(k=1) if
    coiHea.typ == Buildings.Templates.Types.Coil.WaterBased or
    coiHea.typHex == Buildings.Templates.Types.HeatExchanger.DXVariableSpeed
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,110})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant ySpeFanRet(k=1)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={140,70})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant yFanRet(k=true)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={180,70})));
equation
    // Non graphical connections - START
  connect(yCoiCoo.y, busAHU.out.yCoiCoo);
  connect(yCoiHea.y, busAHU.out.yCoiHea);
  connect(yFanSup.y,busAHU.out.yFanSup);
  connect(ySpeFanSup.y,busAHU.out.ySpeFanSup);
  connect(ySpeFanRet.y, busAHU.out.ySpeFanRet);
  connect(yFanRet.y, busAHU.out.yFanRet);
  // Non graphical connections - STOP
  connect(yCoiCooSta.y,busAHU.out.yCoiCoo)
    annotation (Line(points={{-20,98},{-20,0.1},{-200.1,0.1}},
                                  color={255,127,0}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));

  connect(yDamOut.y,busAHU.out.yDamOut)  annotation (Line(points={{-180,158},{
          -180,0.1},{-200.1,0.1}}, color={0,0,127}));
  connect(yDamOutMin.y,busAHU.out.yDamOutMin)  annotation (Line(points={{-150,
          158},{-150,0.1},{-200.1,0.1}}, color={0,0,127}));
  connect(yDamRet.y,busAHU.out.yDamRet)  annotation (Line(points={{-120,158},{
          -120,0.1},{-200.1,0.1}}, color={0,0,127}));
  connect(yDamRel.y,busAHU.out.yDamRel)  annotation (Line(points={{-90,158},{
          -90,0.1},{-200.1,0.1}}, color={0,0,127}));

  annotation (
  defaultComponentName="conAHU",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Dummy;
