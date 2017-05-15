within Buildings.Electrical.Transmission.MediumVoltageCables;
record Generic "Data record for a generic medium voltage cable"
  extends Modelica.Icons.MaterialProperty;
  extends Buildings.Electrical.Transmission.BaseClasses.BaseCable;
  parameter String size(start="")
    "AWG or kcmil code representing the conductor size";
  parameter Buildings.Electrical.Types.CharacteristicResistance Rdc(start=0)
    "Characteristic DC resistance of the cable @ T_ref";
  parameter Modelica.SIunits.Length d "Inner diameter";
  parameter Modelica.SIunits.Length D "Outer diameter";
  parameter Modelica.SIunits.Length GMR "Geometrical Mean Radius of the cable";
  parameter Modelica.SIunits.Length GMD
    "Geometrical Mean Diameter of the cable";

  redeclare function extends lineResistance
    "Function that computes the resistance of a cable"
      input Buildings.Electrical.Transmission.MediumVoltageCables.Generic cable
      "Record that contains cable properties";
  algorithm
    R := l*cable.Rdc*Buildings.Electrical.Transmission.Functions.R_AC_correction(
    cable.size, cable.material);
      annotation(Inline=true, Documentation(revisions="<html>
<ul>
<li>
September 23, 2014, by Marco Bonvini:<br/>
Added function and documentation
</li>
</ul>
</html>", info="<html>
<p>
This function computes the overall resistance of a cable.
</p>
<p>
When the voltage level is medium or high, the cables have a DC resistance that needs
to be corrected to account for the effects cause by the AC voltage.
The correction is
</p>
<p align=\"center\" style=\"font-style:italic;\">
R = l<sub>CABLE</sub> R<sub>DC</sub> f<sub>CORR</sub>(s, m),
</p>
<p>
where <i>R<sub>DC</sub> </i> is the characteristic DC resistance per unit length,
<i>l<sub>CABLE</sub></i> is the length of the cable, and
<i>f<sub>CORR</sub>(s, m)</i> is a function that corrects the DC value and depends on the
size of the cable <i>s</i> and its material <i>m</i>. See
<a href=\"modelica://Buildings.Electrical.Transmission.Functions.R_AC_correction\">
Buildings.Electrical.Transmission.Functions.R_AC_correction</a> for more details.
</p>

</html>"));
  end lineResistance;

  redeclare function extends lineInductance
    "Function that computes the resistance of a cable"
    input Buildings.Electrical.Transmission.MediumVoltageCables.Generic cable
      "Record that contains cable properties";
  algorithm
    L := l*2e-7*log(cable.GMD/cable.GMR);
      annotation(Inline=true, Documentation(revisions="<html>
<ul>
<li>
September 23, 2014, by Marco Bonvini:<br/>
Added function and documentation
</li>
</ul>
</html>", info="<html>
<p>
This function computes the overall inductance of a cable.
</p>
<p>
When the voltage level is medium or high, the cables have geometric parameters that can
be used to compute the inductance as
</p>
<p align=\"center\" style=\"font-style:italic;\">
R = l<sub>CABLE</sub> 2 10<sup>-7</sup> log(GMD/GMR),
</p>
<p>
where <i>l<sub>CABLE</sub></i> is the length of the cable, and
<i>GMD</i> and <i>GMR</i> are the geometric mean distance and the geometric mean radius
of the cable.
</p>
</html>"));
  end lineInductance;

  redeclare function extends lineCapacitance
    "Function that computes the capacitance of a cable"
    input Buildings.Electrical.Transmission.MediumVoltageCables.Generic cable
      "Record that contains cable properties";
  protected
    Modelica.SIunits.Length r "Radius";
  algorithm
    r := cable.d/2.0;
    C := l*2*Modelica.Constants.pi*Modelica.Constants.epsilon_0/log(cable.GMD/r);
      annotation(Inline=true, Documentation(revisions="<html>
<ul>
<li>
September 23, 2014, by Marco Bonvini:<br/>
Added function and documentation
</li>
</ul>
</html>", info="<html>
<p>
This function computes the overall capacity of a cable.
</p>
<p>
When the voltage level is medium or high, the cables have geometric parameters that can
be used to compute the capacity as
</p>
<p align=\"center\" style=\"font-style:italic;\">
C = l<sub>CABLE</sub> 2 &pi; &epsilon;<sub>0</sub>/log(GMD/r),
</p>
<p>
where <i>l<sub>CABLE</sub></i> is the length of the cable,
<i>&epsilon;<sub>0</sub></i> is the dielectric constant of the air, <i>GMD</i>
is the geometric mean distance, and <i>r = d/2</i> where <i>d</i> is the inner
diameter of the cable.
</p>
</html>"));
  end lineCapacitance;

  annotation (Documentation(info="<html>
<p>
This is a base record for specifying physical properties for medium
voltage commercial cables. New cables can be added by extending
it.
</p>
<p>
For medium voltage cables, the geometric properties of the cable and the material are
specified. For example some of the properties that are specified are:
</p>
<pre>
Rdc   : Characteristic DC resistance at T = T_ref[Ohm/m]
T_ref : Reference temperature of the material [K]
d     : Inner diameter [m]
D     : Outer diameter [m]
Amp   : Ampacity [A]
</pre>
<p>
other properties such as the geometric mean diameter GMD and the
geometric mean radius GMR are by default computed using functions,
but this can be overriden.
</p>
</html>", revisions="<html>
<ul>
<li>
September 23, 2014, by Marco Bonvini:<br/>
Revised structure of the record, not it extends the base records
and add details for the medium voltage cables.
</li>
<li>
Sept 19, 2014, by Marco Bonvini:<br/>
Added User's guide.
</li>
</ul>
</html>"));
end Generic;
