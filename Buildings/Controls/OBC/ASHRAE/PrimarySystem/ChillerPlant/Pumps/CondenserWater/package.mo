within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps;
package CondenserWater "Sequences for condenser water pump control"

annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains control sequences for condenser water pumps.
The implementations are based on section 5.2.9 Condener water water pumps, 
in ASHRAE RP-1711 Advanced Sequences of Operation for HVAC Systems Phase II –
Central Plants and Hydronic Systems (draft version on March 23, 2020).
</p>
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
          radius=25.0),
                 Ellipse(
        extent={{-66,66},{68,-68}},
        lineColor={0,0,0},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid), Polygon(
        points={{0,66},{0,-68},{68,0},{0,66}},
        lineColor={0,0,0},
        fillColor={238,46,47},
        fillPattern=FillPattern.Solid)}));
end CondenserWater;
