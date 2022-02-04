within Buildings.Examples.ChillerPlants.RP1711.BaseClasses;
model YorkCalc
  extends Buildings.Fluid.HeatExchangers.CoolingTowers.YorkCalc;

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yFanSpe annotation (Placement(
        transformation(extent={{100,30},{120,50}}), iconTransformation(extent={{100,20},
            {140,60}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay uniDel(final samplePeriod=1) "Break loop"
    annotation (Placement(transformation(extent={{60,30},{80,50}})));

equation
  connect(y, uniDel.u) annotation (Line(points={{-120,80},{40,80},{40,40},{58,40}},
        color={0,0,127}));
  connect(uniDel.y, yFanSpe)
    annotation (Line(points={{82,40},{110,40}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{72,34},{106,16}},
          lineColor={0,0,127},
          textString="yFanSpe")}),                               Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end YorkCalc;
