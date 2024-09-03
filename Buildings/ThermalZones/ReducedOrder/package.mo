within Buildings.ThermalZones;
package ReducedOrder "Reduced order models based on VDI 6007"
  extends Modelica.Icons.Package;


  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
  {100,100}}), graphics={
  Rectangle(
    extent={{-80,36},{-10,-10}},
    lineColor={0,0,0},
    fillColor={255,255,255},
    fillPattern=FillPattern.Solid),
  Line(
    points={{-4,14},{76,14},{14,14}},
    color={0,0,0},
    smooth=Smooth.None),
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
    smooth=Smooth.None)}), Documentation(info="<html>
    <p>This package contains models for reduced building physics of thermal
    zones and accompanying models for consideration of solar radiation and
    radiation transmission through windows.</p>
    <p>The Python package TEASER <a
    href=\"https://github.com/RWTH-EBC/TEASER\">
    https://github.com/RWTH-EBC/TEASER</a> can be used to calculate reduced
    order parameters and generate ready-to-run models.
    </p>
  </html>"));
end ReducedOrder;
