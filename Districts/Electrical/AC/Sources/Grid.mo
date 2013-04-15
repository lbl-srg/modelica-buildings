within Districts.Electrical.AC.Sources;
model Grid "Electrical grid"
  import Districts;

  parameter Modelica.SIunits.Frequency f "Frequency of the grid";
  parameter Modelica.SIunits.Voltage V "RMS voltage of the grid";
  parameter Modelica.SIunits.Angle phi(start=0) "Phase shift of the grid";

  Districts.Electrical.AC.Interfaces.PowerOutput P
    "Power consumed from grid if negative, or fed to grid if positive"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    // fixme: apparent is wrong

protected
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground ground "Ground"
    annotation (Placement(transformation(extent={{-70,-80},{-50,-60}})));
  Districts.Electrical.AC.Sources.VoltageSource                         sou(
    final f=f,
    final V=V,
    final phi=phi,
    measureP=true) "Voltage source"
     annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-60,-10})));
public
  Districts.Electrical.AC.Interfaces.SinglePhasePlug sPhasePlug
    "Single phase connector" annotation (Placement(transformation(extent={{-10,-108},
            {10,-88}}), iconTransformation(
        extent={{-20,-21},{20,21}},
        rotation=90,
        origin={-1,-100})));
equation

  connect(sou.n, ground.pin) annotation (Line(
      points={{-60,-20},{-60,-60}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(sou.sPhasePlug, sPhasePlug)  annotation (Line(
      points={{-60,0},{-60,14},{0,14},{0,-98}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(sou.P, P) annotation (Line(
      points={{-55,-17},{24.5,-17},{24.5,0},{110,0}},
      color={0,0,127},
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
