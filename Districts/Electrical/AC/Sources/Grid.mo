within Districts.Electrical.AC.Sources;
model Grid "Electrical grid"
  import Districts;

  parameter Modelica.SIunits.Frequency f "Frequency of the grid";
  parameter Modelica.SIunits.Voltage V "RMS voltage of the grid";
  parameter Modelica.SIunits.Angle phi(start=0) "Phase shift of the grid";

  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.NegativePin pin
    "Pin for electrical connection"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}}),
        iconTransformation(extent={{-10,-110},{10,-90}})));

  Districts.Electrical.AC.Interfaces.PowerOutput P(
    real=senPow.y.re,
    apparent=if senPow.y.re >= 0 then (senPow.y.re^2 + senPow.y.im^2)^0.5 else
        -(senPow.y.re^2 + senPow.y.im^2)^0.5,
    phi=Modelica.Math.atan2(senPow.y.im, senPow.y.re),
    cosPhi=Modelica.Math.cos(Modelica.Math.atan2(senPow.y.im, senPow.y.re)))
    "Power consumed from grid if negative, or fed to grid if positive"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    // fixme: apparent is wrong

protected
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground ground "Ground"
    annotation (Placement(transformation(extent={{-70,-80},{-50,-60}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Sources.VoltageSource sou(
    final f=f,
    final V=V,
    final phi=phi) "Voltage source"
     annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-60,-10})));
  Districts.Electrical.AC.Sensors.PowerSensor
                      senPow "Power sensor"
                   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-8})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Sensors.CurrentSensor senCur
    "Current sensor" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-60})));
equation
  connect(ground.pin, sou.pin_n) annotation (Line(
      points={{-60,-60},{-60,-20}},
      color={85,170,255},
      smooth=Smooth.None));

  connect(senCur.pin_p, pin) annotation (Line(
      points={{0,-70},{4.44089e-16,-70},{4.44089e-16,-100}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(senCur.pin_n, senPow.currentP) annotation (Line(
      points={{0,-50},{0,-18}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(senPow.voltageP, ground.pin) annotation (Line(
      points={{-10,-8},{-30,-8},{-30,-40},{-60,-40},{-60,-60}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(senPow.currentN, sou.pin_p) annotation (Line(
      points={{1.11022e-15,2},{0,2},{0,20},{-60,20},{-60,0}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(senPow.voltageN, sou.pin_p) annotation (Line(
      points={{10,-8},{20,-8},{20,20},{-60,20},{-60,0}},
      color={85,170,255},
      smooth=Smooth.None));
  annotation (
  defaultComponentName="gri",
    Documentation(info="<html>
<p>
Model that can be used to connect to the electrical grid supply.
</p>
<p>
The convention is that <code>P.real</code> is positive if real power is
consumed from the grid, and negative if it is fed into the grid.
</p>
<p>
The parameter <code>V</code> is the root means square of the voltage.
In US households, this is <i>120</i> Volts.
</p>
</html>",
 revisions="<html>
<ul>
<li>
January 2, 2012, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{16,132},{98,102}},
          textString="%name",
          lineColor={0,0,255}),
        Line(
          points={{-60,-32},{-60,-72}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-74,-32},{-44,-32}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-72,-38},{-48,-28},{-28,-16},{-16,-2},{-12,14}},
          color={175,175,175},
          smooth=Smooth.Bezier),
        Line(
          points={{-46,-38},{-22,-28},{-2,-16},{10,-2},{14,14}},
          color={175,175,175},
          smooth=Smooth.Bezier),
        Line(
          points={{-72,-32},{-72,-38}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-46,-32},{-46,-38}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-14,20},{16,20}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{0,20},{0,-20}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-12,20},{-12,14}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{14,20},{14,14}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{14,14},{38,24},{58,36},{70,50},{74,66}},
          color={175,175,175},
          smooth=Smooth.Bezier),
        Line(
          points={{-12,14},{12,24},{32,36},{44,50},{48,66}},
          color={175,175,175},
          smooth=Smooth.Bezier),
        Line(
          points={{60,72},{60,32}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{46,72},{76,72}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{48,72},{48,66}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{74,72},{74,66}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-100,-76},{-96,-74},{-88,-68},{-76,-54},{-72,-38}},
          color={175,175,175},
          smooth=Smooth.Bezier),
        Line(
          points={{-100,-88},{-82,-80},{-62,-68},{-50,-54},{-46,-38}},
          color={175,175,175},
          smooth=Smooth.Bezier),
        Line(
          points={{48,68},{72,78},{92,90},{98,94},{100,96}},
          color={175,175,175},
          smooth=Smooth.Bezier),
        Line(
          points={{74,68},{84,72},{100,82}},
          color={175,175,175},
          smooth=Smooth.Bezier)}),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics));
end Grid;
