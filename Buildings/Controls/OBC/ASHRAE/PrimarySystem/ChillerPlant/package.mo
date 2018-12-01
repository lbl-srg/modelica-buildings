within Buildings.Controls.OBC.ASHRAE.PrimarySystem;
package ChillerPlant "Chiller plant control sequences as from ASHRAE Fundamentals of Chilled Water Plant Design and Control SDL"

annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains sequences for controlling a chiller plant comprising a single or multiple chillers, 
chilled and condenser water pumps, cooling towers and an optional water side economizer. The control sequences 
are implemented based on ASHRAE Fundamentals of Design & Control of Chilled Water Plants, Chapter 7 and Steve 
Taylor's update document: OBC Plant SOO. fixme: finalize source citation once implemented.
</p>
</html>"),
  Icon(graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0)}));
end ChillerPlant;
