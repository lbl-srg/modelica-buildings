within Buildings.ThermalZones;
package ISO13790 "Reduced order models based on ISO 13790"
  extends Modelica.Icons.Package;

annotation (
    Icon(graphics={
  Line(
    points={{44,14},{44,-30}},
    color={0,0,0},
    smooth=Smooth.None),
  Line(
    points={{12,-30},{82,-30}},
    color={0,0,0},
    smooth=Smooth.None),
  Line(
    points={{22,-52},{70,-52}},
    color={0,0,0},
    smooth=Smooth.None),
  Rectangle(
    extent={{-80,36},{-10,-10}},
    lineColor={0,0,0},
    fillColor={255,255,255},
    fillPattern=FillPattern.Solid),
  Line(
    points={{10,14},{80,14}},
    color={0,0,0},
    smooth=Smooth.None)}),
    Documentation(info="<html>
    <p>This package contains models for reduced building physics of thermal zones 
    based on a thermal network consisting of five resistances and one capacitance. 
    The models are based on the ISO 13790:2008 Standard.</p>
    
  </html>"));
end ISO13790;
