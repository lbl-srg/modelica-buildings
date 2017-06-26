within Buildings.Air.Systems.SingleZone.VAV.BaseClasses.Validation;
model HysteresisWithDelay
  import Buildings;
  extends Modelica.Icons.Example;
  Buildings.Air.Systems.SingleZone.VAV.BaseClasses.HysteresisWithDelay
    hysteresisWithDelay(waitTimeToOn=0, waitTimeToOff=30)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Blocks.Sources.Sine pulse1(amplitude=0.2, freqHz=1/360)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
equation
  connect(pulse1.y, hysteresisWithDelay.u)
    annotation (Line(points={{-19,0},{19,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end HysteresisWithDelay;
