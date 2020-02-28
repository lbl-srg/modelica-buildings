within Buildings.ThermalZones.Detailed.BaseClasses;
record ParameterConstructionWithWindow
  "Record for exterior constructions that have a window"
  extends Buildings.ThermalZones.Detailed.BaseClasses.PartialParameterConstruction;

  parameter Modelica.Units.SI.Area A
    "Heat transfer area of opaque construction and window combined";
  parameter Modelica.Units.SI.Length hWin "Window height"
    annotation (Dialog(group="Glazing system"));
  parameter Modelica.Units.SI.Length wWin "Window width"
    annotation (Dialog(group="Glazing system"));
  final parameter Modelica.Units.SI.Area AWin=hWin*wWin
    "Heat transfer area of window" annotation (Dialog(group="Glazing system"));

  final parameter Modelica.Units.SI.Area AOpa=A - AWin
    "Heat transfer area of opaque construction"
    annotation (Dialog(group="Opaque construction"));

  parameter Real fFra(
    final min=0,
    final max=1) = 0.1 "Fraction of window frame divided by total window area"
    annotation (Dialog(group="Glazing system"));

 parameter Buildings.ThermalZones.Detailed.BaseClasses.Overhang ove(
    wR=0,
    wL=0,
    dep=0,
    gap=0) "Geometry of overhang"
    annotation (Dialog(group="Glazing system"), choicesAllMatching=true, Placement(transformation(extent={{60,20},
            {80,40}})));
 parameter Buildings.ThermalZones.Detailed.BaseClasses.SideFins sidFin(h=0, dep=0, gap=0)
    "Geometry of side fins"
    annotation (Dialog(group="Glazing system"), choicesAllMatching=true, Placement(transformation(extent={{60,-20},
            {80,0}})));

  final parameter Modelica.Units.SI.Area AFra=fFra*AWin "Frame area"
    annotation (Dialog(group="Glazing system"));
  final parameter Modelica.Units.SI.Area AGla=AWin - AFra "Glass area"
    annotation (Dialog(group="Glazing system"));

  parameter HeatTransfer.Data.GlazingSystems.Generic glaSys
    "Material properties of glazing system"
    annotation (Dialog(group="Glazing system"), choicesAllMatching=true, Placement(transformation(extent={{58,62},
            {78,82}})));
  final parameter Boolean haveOverhangOrSideFins = (ove.dep > 1E-8) or (sidFin.dep > 1E-8)
    "Flag, true if the construction has either an overhang or side fins"
    annotation(Evaluate=true);

  annotation (
Documentation(info="<html>
<p>
This data record is used to set the parameters of constructions that do have a window.
</p>
<p>
The surface azimuth is defined in
<a href=\"modelica://Buildings.Types.Azimuth\">
Buildings.Types.Azimuth</a>
and the surface tilt is defined in <a href=\"modelica://Buildings.Types.Tilt\">
Buildings.Types.Tilt</a>
</p>
</html>", revisions="<html>
<ul>
<li>
October 28, 2014, by Michael Wetter:<br/>
Removed <code>replacable</code> keyword for parameters that are records as this is not needed.
</li>
<li>
October 27, 2014, by Michael Wetter:<br/>
Introduced the parameter <code>haveOverhangOrSideFins</code> which is needed by
<a href=\"modelica://Buildings.ThermalZones.Detailed.BaseClasses.ExteriorBoundaryConditionsWithWindow\">
Buildings.ThermalZones.Detailed.BaseClasses.ExteriorBoundaryConditionsWithWindow</a>.
</li>
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
