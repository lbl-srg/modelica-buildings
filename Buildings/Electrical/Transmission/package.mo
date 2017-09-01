within Buildings.Electrical;
package Transmission "Package with models for transmission lines"
  extends Modelica.Icons.Package;

annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
          {100,100}}), graphics={
      Ellipse(
        extent={{40,8},{16,-28}},
        lineColor={0,0,0},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Line(
        points={{28,8},{-54,8},{-64,8},{-72,-10},{-64,-28},{-52,-28},{28,-28}},
        color={0,0,0},
        smooth=Smooth.Bezier),
      Line(
        points={{-70,-10},{-88,-10}},
        color={0,0,0},
        smooth=Smooth.None),
      Line(
        points={{54,-10},{28,-10}},
        color={0,0,0},
        smooth=Smooth.None)}), Documentation(info="<html>
<p>
This package contains cables that can be used
to represent a line in a electric grid. The package contains
several functions and records to parametrize cables either using
default values or values from commercial cables.
</p>
<p>
The package
<a href=\"modelica://Buildings.Electrical.Transmission.Grids\">
Buildings.Electrical.Transmission.Grids</a>
contains models of
electrical networks.
</p>
<h4>Commercial cables</h4>
<p>
The package contains several low voltage and medium voltage cable with
pre-defined physical and geometrical properties like characteristic resistances and
diameters. There are different conventions to measure the cables.
</p>

<h5>Cross-sectional area</h5>
<p>
A measure of cross-sectional area in square mm. E.g. 50 mm<sup>2</sup>
wire has a nominal circula area of 50 mm<sup>2</sup> and a diameter of
7.98 mm.
</p>

<h5>AWG (American Wire Gauge)</h5>
<p>
A measure of wire thickness (which also dictates cross-sectional area, and
for a given material, ampacity). E.g. 24 AWG wire has a nominal diameter of
0.0201 in or 0.511 mm.
</p>

<h5>kcmil (thousand of Circular Mils)</h5>
<p>
kcmil is an abbreviation for thousands of circular mils, an old measurement of
wire gauge. 1 kcmil = 0.5067 square millimeters. A mil is 1/1000 inch.
A wire 200 mils in diameter is 40 kcmil. kcmil is generally used for very
large-diameter wire. Most wires use AWG.
</p>

</html>", revisions="<html>
<ul>
<li>
June 3, 2014, by Marco Bonvini:<br/>
Added User's guide.
</li>
</ul>
</html>"));
end Transmission;
