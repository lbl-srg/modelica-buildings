within Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources;
model Grid_N "Electrical grid with neutral cable"
  parameter Modelica.Units.SI.Frequency f(start=60) "Frequency of the source";
  parameter Modelica.Units.SI.Voltage V(start=480) "RMS voltage of the source";
  parameter Modelica.Units.SI.Angle phiSou=0 "Phase shift of the source";
  Buildings.Electrical.AC.Interfaces.PowerOutput P[3]
    "Power consumed from grid if positive, or fed to grid if negative"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces.Terminal4_p terminal
    "Connector for three-phase unbalanced systems"
                                                  annotation (Placement(transformation(extent={{-10,
            -110},{10,-90}}), iconTransformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-100})));
  Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.FixedVoltage_N sou(
    potentialReference=true,
    definiteReference=true,
    f=f,
    V=V,
    phiSou=phiSou) "Voltage source"
     annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        origin={10,0})));
equation
  for i in 1:3 loop
    P[i].real = -sou.vPhase[i].S[1];
    P[i].apparent = sqrt(sou.vPhase[i].S[2]^2 + sou.vPhase[i].S[1]^2);
    P[i].phi = sou.vPhase[i].phi;
    P[i].cosPhi = cos(sou.vPhase[i].phi);
  end for;
  connect(sou.terminal, terminal) annotation (Line(
      points={{-4.44089e-16,6.66134e-16},{-4.44089e-16,-100},{4.44089e-16,-100}},
      color={127,0,127},
      smooth=Smooth.None));
  annotation (
  defaultComponentName="gri",
    Documentation(info="<html>
<p>
Model that can be used to represent the electrical grid supply with a neutral cable connection.
The neutral cable is connected to the ground.
</p>
<p>
The model has an output connector named <code>P[n]</code> with <code>n = 3</code> that
contains information about the power supplied by the grid to the network.
The convention is that <code>P[i].real</code> is positive if real power is
consumed from the grid, and negative if it is fed into the grid.
The connector has size equal to three because each element
of the vector refers to a single phase.
</p>
<p>
The parameter <code>V</code> is the root means square of the voltage.
In US, a typical value <i>480</i> Volts.
</p>
</html>",
 revisions="<html>
<ul>
<li>
August 31, 2016, by Michael Wetter:<br/>
Corrected sign error in documentation string of variable <code>P</code>.
</li>
<li>
August 27, 2014, by Marco Bonvini:<br/>
Revised documentation.
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
          textColor={0,120,120},
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
          smooth=Smooth.Bezier)}));
end Grid_N;
