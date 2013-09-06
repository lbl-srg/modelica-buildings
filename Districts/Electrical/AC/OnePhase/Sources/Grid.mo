within Districts.Electrical.AC.OnePhase.Sources;
model Grid "Electrical grid"

  Districts.Electrical.AC.Interfaces.PowerOutput P
    "Power consumed from grid if negative, or fed to grid if positive"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  replaceable Districts.Electrical.AC.OnePhase.Interfaces.Terminal_p terminal
                                                               annotation (Placement(transformation(extent={{-10,
            -110},{10,-90}}), iconTransformation(extent={{-10,-110},{10,-90}})));
  parameter Modelica.SIunits.Frequency f(start=50) "Frequency of the source";
  parameter Modelica.SIunits.Voltage V(start=220);
  parameter Modelica.SIunits.Angle Phi(start=0);
  replaceable Districts.Electrical.AC.OnePhase.Sources.FixedVoltage sou(
    potentialReference=true,
    definiteReference=true,
    f=f,
    V=V,
    Phi=Phi) "Voltage source"
     annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={10,0})));
equation
  P.real = -sou.S[1];
  P.apparent = sqrt(sou.S[2]^2 + sou.S[1]^2);
  P.phi = sou.phi;
  P.cosPhi = cos(sou.phi);
  connect(sou.terminal, terminal) annotation (Line(
      points={{-4.44089e-16,6.66134e-16},{-4.44089e-16,-100},{4.44089e-16,-100}},
      color={0,120,120},
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
January 2, 2012, by Michael Wetter:<br/>
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
          extent={{-120,130},{120,100}},
          lineColor={0,120,120},
          textString="%name"),
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
