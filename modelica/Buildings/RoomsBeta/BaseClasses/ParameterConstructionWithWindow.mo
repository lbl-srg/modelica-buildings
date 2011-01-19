within Buildings.RoomsBeta.BaseClasses;
record ParameterConstructionWithWindow
  "Record for exterior constructions that have a window"
  extends Buildings.RoomsBeta.BaseClasses.PartialParameterConstruction;

  parameter Modelica.SIunits.Area A
    "Heat transfer area of opaque construction and window combined";
  parameter Modelica.SIunits.Area AWin "Heat transfer area of window"
      annotation (Dialog(group="Glazing system"));

  final parameter Modelica.SIunits.Area AOpa = A-AWin
    "Heat transfer area of opaque construction"
    annotation (Dialog(group="Opaque construction"));

  parameter Real fFra(
    min=0,
    max=1) = 0.1 "Fraction of window frame divided by total window area"
    annotation (Dialog(group="Glazing system"));
  final parameter Modelica.SIunits.Area AFra = fFra*AWin "Frame area"
    annotation (Dialog(group="Glazing system"));
  final parameter Modelica.SIunits.Area AGla=AWin - AFra "Glass area"
    annotation (Dialog(group="Glazing system"));
  parameter Boolean linearizeRadiation = true
    "Set to true to linearize emissive power"
    annotation (Dialog(group="Glazing system"));

 replaceable parameter HeatTransfer.Data.GlazingSystems.Generic glaSys
    "Material properties of glazing system"
    annotation (Dialog(group="Glazing system"), Evaluate=true, choicesAllMatching=true, Placement(transformation(extent={{140,80},
            {160,100}})));
  annotation (
Documentation(info="<html>
<p>
This data record is used to set the parameters of constructions that do have a window.
</p>
<p>
The surface azimuth is defined in 
<a href=\"modelica://Buildings.RoomsBeta.Types.Azimuth\">
Buildings.RoomsBeta.Types.Azimuth</a>
and the surface tilt is defined in <a href=\"modelica://Buildings.RoomsBeta.Types.Tilt\">
Buildings.RoomsBeta.Types.Tilt</a>
</p>
</html>", revisions="<html>
<ul>
<li>
December 14, 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));

end ParameterConstructionWithWindow;
