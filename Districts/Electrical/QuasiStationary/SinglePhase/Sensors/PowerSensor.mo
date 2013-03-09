within Districts.Electrical.QuasiStationary.SinglePhase.Sensors;
model PowerSensor "Power sensor"
  extends Modelica.Electrical.QuasiStationary.SinglePhase.Sensors.PowerSensor;

  Interfaces.PowerOutput P
    "Power consumed from grid if negative, or fed to grid if positive"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={80,-110})));
equation
  P.real = abs(y.re);
  P.apparent=(y.re^2 + y.im^2)^0.5;
  P.phi=Modelica.Math.atan2(y.im,y.re);
  P.cosPhi=Modelica.Math.cos(P.phi);

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Line(
          points={{80,-100},{80,0}},
          color={0,0,255},
          smooth=Smooth.None),
        Text(
          extent={{-48,-70},{-76,-90}},
          lineColor={0,0,0},
          textString="re
im",      horizontalAlignment=TextAlignment.Left),
        Text(
          extent={{118,-68},{84,-92}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="ac
re
phi")}));
end PowerSensor;
