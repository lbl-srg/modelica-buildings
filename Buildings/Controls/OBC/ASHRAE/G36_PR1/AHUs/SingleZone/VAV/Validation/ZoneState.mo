within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Validation;
model ZoneState "Validation models of determining zone state"
  import Buildings;
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.ZoneState zonSta
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse uCoo(
    period=2,
    offset=0,
    startTime=1,
    amplitude=1) "Cooling control signal"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse uHea(
    period=2,
    offset=0,
    amplitude=1,
    startTime=2) "Heating control signal"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
equation
  connect(uHea.y, zonSta.uHea) annotation (Line(points={{-79,30},{-50,30},{
          -50,4},{-2,4}}, color={0,0,127}));
  connect(uCoo.y, zonSta.uCoo) annotation (Line(points={{-79,-30},{-50,-30},{
          -50,-4},{-2,-4}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                   Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}), Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,58},{64,-2},{-36,-62},{-36,58}})}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=3,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"));
end ZoneState;
