within Buildings.Air.Systems.SingleZone.VAV.BaseClasses.Validation;
model HysteresisWithHold
  import Buildings;
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.Sine pulse1(amplitude=0.2, freqHz=1/360)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Air.Systems.SingleZone.VAV.BaseClasses.HysteresisWithHold
    hysteresisWithHold(offHolDur=30, onHolDur=150)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
equation
  connect(pulse1.y, hysteresisWithHold.u)
    annotation (Line(points={{-19,0},{0,0},{18,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end HysteresisWithHold;
