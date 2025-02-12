within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic;
package PlantEnable "Package of sequences for enabling plant and the associated devices"

annotation (
preferredView="info", Documentation(info="<html>
<p>
This package contains sequences for enabling plant and the associate devices.
The sequences are implemented based on ASHRAE Gudeline36-2021, section 5.20.2.
</html>"),
Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineThickness=5,
          borderPattern=BorderPattern.Raised),
        Text(
          extent={{-120,146},{100,108}},
          textColor={0,0,255},
          textString="%name"),
        Ellipse(extent={{-80,80},{80,-80}}, lineColor={28,108,200},fillColor={170,255,213},
          fillPattern=FillPattern.Solid),
        Ellipse(extent={{-90,90},{90,-90}}, lineColor={28,108,200}),
        Rectangle(extent={{-75,2},{75,-2}}, lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-66,46},{76,10}},
          textColor={28,108,200},
          textString="START"),
        Text(
          extent={{-66,-8},{76,-44}},
          textColor={28,108,200},
          textString="STOP")}));
end PlantEnable;
