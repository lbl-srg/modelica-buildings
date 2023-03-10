within Buildings.Controls.OBC.ASHRAE.G36.Types;
package DemandLimitLevels "Demand limit levels"
  constant Integer cooling0 = 0 "Cooling demand limit level 0";
  constant Integer cooling1 = 1 "Cooling demand limit level 1";
  constant Integer cooling2 = 2 "Cooling demand limit level 2";
  constant Integer cooling3 = 3 "Cooling demand limit level 3";
  constant Integer heating0 = 0 "Heating demand limit level 0";
  constant Integer heating1 = 1 "Heating demand limit level 1";
  constant Integer heating2 = 2 "Heating demand limit level 2";
  constant Integer heating3 = 3 "Heating demand limit level 3";

  annotation (
  Documentation(info="<html>
<p>
This package provides constants for indicating different cooling or heating
demand limit level for zone setpoint adjustment, PART 5.B.3.
</p>
</html>", revisions="<html>
<ul>
<li>
August 16, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(graphics={
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
end DemandLimitLevels;
