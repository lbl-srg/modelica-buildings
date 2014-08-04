within Buildings.Rooms.BaseClasses;
record ParameterConstructionWithWindow
  "Record for exterior constructions that have a window"
  extends Buildings.Rooms.BaseClasses.PartialParameterConstruction;

  parameter Modelica.SIunits.Area A
    "Heat transfer area of opaque construction and window combined";
  parameter Modelica.SIunits.Length hWin "Window height"
    annotation (Dialog(group="Glazing system"));
  parameter Modelica.SIunits.Length wWin "Window width"
    annotation (Dialog(group="Glazing system"));
  final parameter Modelica.SIunits.Area AWin=hWin*wWin
    "Heat transfer area of window"
      annotation (Dialog(group="Glazing system"));

  final parameter Modelica.SIunits.Area AOpa = A-AWin
    "Heat transfer area of opaque construction"
    annotation (Dialog(group="Opaque construction"));

  parameter Real fFra(
    final min=0,
    final max=1) = 0.1 "Fraction of window frame divided by total window area"
    annotation (Dialog(group="Glazing system"));

 replaceable parameter Buildings.Rooms.BaseClasses.Overhang ove(
    wR=0,
    wL=0,
    dep=0,
    gap=0) "Geometry of overhang"
    annotation (Dialog(group="Glazing system"), choicesAllMatching=true, Placement(transformation(extent={{60,20},
            {80,40}})));
 replaceable parameter Buildings.Rooms.BaseClasses.SideFins sidFin(h=0, dep=0, gap=0)
    "Geometry of side fins"
    annotation (Dialog(group="Glazing system"), choicesAllMatching=true, Placement(transformation(extent={{60,-20},
            {80,0}})));

  final parameter Modelica.SIunits.Area AFra = fFra*AWin "Frame area"
    annotation (Dialog(group="Glazing system"));
  final parameter Modelica.SIunits.Area AGla=AWin - AFra "Glass area"
    annotation (Dialog(group="Glazing system"));

 replaceable parameter HeatTransfer.Data.GlazingSystems.Generic glaSys
    "Material properties of glazing system"
    annotation (Dialog(group="Glazing system"), choicesAllMatching=true, Placement(transformation(extent={{58,62},
            {78,82}})));
  annotation (
Documentation(info="<html>
<p>
This data record is used to set the parameters of constructions that do have a window.
</p>
<p>
The surface azimuth is defined in 
<a href=\"modelica://Buildings.HeatTransfer.Types.Azimuth\">
Buildings.HeatTransfer.Types.Azimuth</a>
and the surface tilt is defined in <a href=\"modelica://Buildings.HeatTransfer.Types.Tilt\">
Buildings.HeatTransfer.Types.Tilt</a>
</p>
</html>", revisions="<html>
<ul>
<li>
May 30, 2014, by Michael Wetter:<br/>
Removed undesirable annotation <code>Evaluate=true</code>.
</li>
<li>
December 14, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));

end ParameterConstructionWithWindow;
