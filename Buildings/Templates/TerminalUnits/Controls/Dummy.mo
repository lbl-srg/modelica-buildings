within Buildings.Templates.TerminalUnits.Controls;
block Dummy "Dummy controller with constant signals"
  extends Buildings.Templates.BaseClasses.Controls.TerminalUnits.SingleDuct;

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yDamVAV(k=1)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-100,110})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yCoiReh(k=1)
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,110})));
equation
  connect(yDamVAV.y, busTer.out.yDamVAV) annotation (Line(points={{-100,98},{-100,
          0.1},{-200.1,0.1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(yCoiReh.y, busTer.out.yCoiReh) annotation (Line(points={{20,98},{20,0.1},
          {-200.1,0.1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  annotation (
  defaultComponentName="conTer",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Dummy;
