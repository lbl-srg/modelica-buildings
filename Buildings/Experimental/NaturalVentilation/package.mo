within Buildings.Experimental;
package NaturalVentilation "Natural ventilation control sequences"









annotation (Documentation(info="<html>
  <p>
  This package contains natural ventilation modules and their constitutive blocks, 
  <p> as well as a package of Alarms (to indicate that the window behavior or resulting room conditions are out of range)
  <p> and a VAV package that indicates control outputs that should be sent to a VAV during natural ventilation mode.
  
  The three main modules are as follows:
  <p>
  1. Natural Ventilation Module
  <p>
  2. Natural Ventilation Module with a Dynamic Duration Night Flush
  <p>
  3. Natural Ventilation Module with a Fixed Duration Night Flush
  <p>
  Blocks in the Lockouts, NightFlush, and Window packages are the composite pieces of the above sequences. 
<p>
</p>
</html>"),Icon(graphics={
      Rectangle(
        extent={{-100,100},{100,-100}},
        lineColor={217,67,180},
        lineThickness=1,
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-60,60},{60,-60}},
        lineColor={217,67,180},
        lineThickness=1,
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Line(
        points={{0,60},{0,-60}},
        color={217,67,180},
        thickness=1),
      Line(
        points={{-60,0},{60,0}},
        color={217,67,180},
        thickness=1)}));
end NaturalVentilation;
