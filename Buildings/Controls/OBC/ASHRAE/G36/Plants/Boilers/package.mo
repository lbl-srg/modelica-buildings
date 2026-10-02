within Buildings.Controls.OBC.ASHRAE.G36.Plants;
package Boilers "Boiler plant control sequences"

annotation (preferredView="info",
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
          radius=25.0)}),
  Documentation(info="<html>
                <p>
                This package contains control sequences for a boiler plant comprising a single boiler or multiple boilers, 
                hot water pumps and flow-control devices. <br/>
                The control sequences are implemented based on ASHRAE Guideline
                36, 2021.
                </p>
                </html>"));
end Boilers;
