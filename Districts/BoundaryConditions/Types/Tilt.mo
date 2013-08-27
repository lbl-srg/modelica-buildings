within Districts.BoundaryConditions.Types;
package Tilt "Enumeration for surface tilt"
  constant Modelica.SIunits.Angle FacingUp=0
    "Tilt for surface the faces straight up";
  constant Modelica.SIunits.Angle Wall =    Modelica.Constants.pi/2
    "Tilt for wall";
  constant Modelica.SIunits.Angle FacingDown =   Modelica.Constants.pi
    "Tilt for surface that faces straight down";
  annotation(preferedView="info", Documentation(info="<html>
<p>
 Enumeration to define the tilt of a surface for the irradiation model.
 For example, for a solar collector that has a tilt of <i>20&deg;</i>,
 use a tilt of <code>20*Modelica.Constants.pi/180</code>.
 </p>
 <p>
  This enumaration is consistent with
  <a href=\"modelica://Buildings.HeatTransfer.Types.Tilt\">
  Buildings.HeatTransfer.Types.Tilt</a>,
  in which a ceiling has a tilt of <i>0&deg;</i>.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 14, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Tilt;
