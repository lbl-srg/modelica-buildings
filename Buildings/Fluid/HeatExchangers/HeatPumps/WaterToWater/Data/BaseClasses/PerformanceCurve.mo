within Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.Data.BaseClasses;
record PerformanceCurve "Data record for a performance curve"
  extends Modelica.Icons.Record;
//-----------------------------Performance curves-----------------------------//
  parameter Real  capFun[5]
    "Coefficients for non-dimensional cooling capacity curve"
    annotation (Dialog(group="Performance curves"));

  parameter Real  PFun[5]
    "Coefficients for non-dimensional power consumption curve"
    annotation (Dialog(group="Performance curves"));

  annotation (defaultComponentName="per", Documentation(info="<html>
<p>
This record declares the data used to specify performance curves for heat pumps.
</p>
<p>
See the information section of
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.Data.HPData\">
Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.Data.HPData</a>
for a description of the data.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 24, 2013 by Kaustubh Phalak:<br>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Text(
          extent={{-95,53},{-12,-2}},
          lineColor={0,0,255},
          textString="capFunT"),
        Text(
          extent={{7,55},{90,0}},
          lineColor={0,0,255},
          textString="%capFunT"),
        Text(
          extent={{-105,-9},{-48,-48}},
          lineColor={0,0,255},
          textString="capFunAirFF"),
        Text(
          extent={{2,-16},{94,-38}},
          lineColor={0,0,255},
          textString="%capFunAirFF"),
        Text(
          extent={{-95,-49},{-12,-104}},
          lineColor={0,0,255},
          textString="EIRFunWatT"),
        Text(
          extent={{7,-53},{84,-94}},
          lineColor={0,0,255},
          textString="%EIRFunWatT")}));
end PerformanceCurve;
