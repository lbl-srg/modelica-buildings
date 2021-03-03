within Buildings.Experimental.Templates.AHUs.Controls;
block Dummy "Dummy controller with constant signals"
  extends Interfaces.Controller;

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yEcoOut(k=1)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-180,170})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yEcoRet(k=1)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-120,170})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yEcoExh(k=1)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-90,170})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yCoiCooVar(k=1) if
       typCoiCoo==Types.Coil.WaterBased or
       typCoiCoo==Types.Coil.DXVariableSpeed
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-60,110})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant yCoiCooSta(k=1) if
       typCoiCoo==Types.Coil.DXMultiStage
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,110})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yFanSupVar(k=1) if
   typFanSup==Types.Fan.SingleVariable or
   typFanSup==Types.Fan.MultipleVariable
   annotation (Placement(transformation(
    extent={{-10,-10},{10,10}},
    rotation=-90,
    origin={40,70})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant yFanSupCst(k=true) if
       typFanSup==Types.Fan.SingleConstant annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={80,70})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yEcoOutMin(k=1)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-150,170})));
equation
    // Non graphical connections - START
  connect(yCoiCooVar.y, ahuBus.ahuO.yCoiCoo);
  connect(yFanSupCst.y, ahuBus.ahuO.yFanSup);
  // Non graphical connections - STOP
  connect(yEcoOut.y, ahuBus.ahuO.yEcoOut) annotation (Line(points={{-180,158},{-180,
          0.1},{-200.1,0.1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(yEcoRet.y, ahuBus.ahuO.yEcoRet) annotation (Line(points={{-120,158},{
          -120,0.1},{-200.1,0.1}},
                              color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(yEcoExh.y, ahuBus.ahuO.yEcoExh) annotation (Line(points={{-90,158},{
          -90,0.1},{-200.1,0.1}},
                              color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(yCoiCooSta.y, ahuBus.ahuO.yCoiCoo) annotation (Line(points={{-20,98},{
          -20,0.1},{-200.1,0.1}}, color={255,127,0}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(yFanSupVar.y, ahuBus.ahuO.yFanSup) annotation (Line(points={{40,58},{40,
          50},{-60,50},{-60,0.1},{-200.1,0.1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(yEcoOutMin.y, ahuBus.ahuO.yEcoOutMin) annotation (Line(points={{-150,
          158},{-150,0.1},{-200.1,0.1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  annotation (
  defaultComponentName="conAhu",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Dummy;
