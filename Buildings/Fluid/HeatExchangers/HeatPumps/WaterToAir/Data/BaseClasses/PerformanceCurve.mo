within Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.Data.BaseClasses;
record PerformanceCurve "Data record for a performance curve"
  extends
    Buildings.Fluid.HeatExchangers.HeatPumps.Data.BaseClasses.PerformanceCurve;
//-----------------------------Performance curves-----------------------------//
  parameter Real  capFunFF2[:]
    "Polynomial coefficients for heating/cooling capacity function of water flow fration"
    annotation (Dialog(group="Performance curves"));
  parameter Real  EIRFunFF2[:]
    "Polynomial coefficients for EIR function of water flow fration"
    annotation (Dialog(group="Performance curves"));
  parameter Real  wasHeaFunT[6]
    "Biquadratic coefficients for waste heat function of temperature"
    annotation (Dialog(group="Performance curves"));
//------------------------Range for performance curves------------------------//
  parameter Real  ff2Min
    "Minimum flow fraction of Medium2 for which performance data are valid"
    annotation (Dialog(group="Minimum and maximum values"));
  parameter Real  ff2Max
    "Maximum flow fraction of Medium2 for which performance data are valid"
    annotation (Dialog(group="Minimum and maximum values"));

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
