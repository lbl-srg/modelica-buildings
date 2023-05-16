within Buildings.Fluid.HeatExchangers.DXCoils.Cooling.WaterSource.Data.Generic.BaseClasses;
record PerformanceCurve "Data record for a performance curve"
  extends
    Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.PerformanceCurve;
//-----------------------------Performance curves-----------------------------//

  parameter Real capFunFFCon[:]
    "Polynomial coefficients for cooling capacity function of water flow fration at condensers"
    annotation (Dialog(group="Performance curves"));

  parameter Real EIRFunFFCon[:]
    "Polynomial coefficients for EIR function of water flow fration at condensers"
    annotation (Dialog(group="Performance curves"));
//------------------------Range for performance curves------------------------//

  parameter Real ffConMin
    "Minimum water flow fraction at condensers for which performance data are valid"
    annotation (Dialog(group="Minimum and maximum values"));
  parameter Real ffConMax
    "Maximum water flow fraction at condensers for which performance data are valid"
    annotation (Dialog(group="Minimum and maximum values"));
  annotation (defaultComponentName="per", Documentation(info="<html>
<p>
This record declares the data used to specify performance curves for water source DX coils.
</p>
<p>
See the information section of
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.Cooling.WaterSource.Data.Generic.Coil\">
Buildings.Fluid.HeatExchangers.DXCoils.Cooling.WaterSource.Data.Generic.DXCoil</a>
for a description of the data.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 17, 2017 by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Text(
          extent={{-95,53},{-12,-2}},
          textColor={0,0,255},
          textString="capFunT"),
        Text(
          extent={{7,55},{90,0}},
          textColor={0,0,255},
          textString="%capFunT"),
        Text(
          extent={{-105,-9},{-48,-48}},
          textColor={0,0,255},
          textString="capFunFF"),
        Text(
          extent={{2,-16},{94,-38}},
          textColor={0,0,255},
          textString="%capFunFF"),
        Text(
          extent={{-95,-49},{-12,-104}},
          textColor={0,0,255},
          textString="EIRFunT"),
        Text(
          extent={{7,-53},{84,-94}},
          textColor={0,0,255},
          textString="%EIRFunT")}));
end PerformanceCurve;
