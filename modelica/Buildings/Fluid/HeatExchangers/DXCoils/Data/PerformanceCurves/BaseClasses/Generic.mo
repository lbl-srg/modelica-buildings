within Buildings.Fluid.HeatExchangers.DXCoils.Data.PerformanceCurves.BaseClasses;
record Generic "Base performance curves data record"
  extends Modelica.Icons.Record;
//-----------------------------Performance curves-----------------------------//
  parameter Real  capFunT[6]
    "Biquadratic coefficients for cooling capacity function of temperature"
    annotation (Dialog(group="Performance curves"));
  parameter Real  capFunFF[:]
    "Polynomial coefficients for cooling capacity function of flow fration"
    annotation (Dialog(group="Performance curves"));
  parameter Real  EIRFunT[6]
    "Biquadratic coefficients for EIR function of temperature"
    annotation (Dialog(group="Performance curves"));
  parameter Real  EIRFunFF[:]
    "Polynomial coefficients for EIR function of flow fration"
    annotation (Dialog(group="Performance curves"));
//------------------------Range for performance curves------------------------//
 // fixme: Instead of range, *Min and *Max should be used as is used for the chiller
  parameter Modelica.SIunits.Temperature   TConInRanCap[2]
    "Range of condenser inlet temperature for cooling capacity function"
    annotation (Dialog(group="Minimum and maximum values"));
  parameter Modelica.SIunits.Temperature   TWetBulInRanCap[2]
    "Range of coil wetbulb inlet temperature for cooling capacity function"
    annotation (Dialog(group="Minimum and maximum values"));
  parameter Real  ffRanCap[2]
    "Range of flow fraction for cooling capacity function"
    annotation (Dialog(group="Minimum and maximum values"));
  parameter Modelica.SIunits.Temperature   TConInRanEIR[2]
    "Range of condenser inlet temperature for EIR function"
    annotation (Dialog(group="Minimum and maximum values"));
  parameter Modelica.SIunits.Temperature   TWetBulInRanEIR[2]
    "Range of coil wetbulb inlet temperature for EIR function"
    annotation (Dialog(group="Minimum and maximum values"));
  parameter Real  ffRanEIR[2] "Range of flow fraction for EIR function"
    annotation (Dialog(group="Minimum and maximum values"));
  annotation (defaultComponentName="per", Documentation(info="<html>
This base record for performance curves coefficents for cooling capacity and EIR curve-fits.<br> 
Note: In case of multispeed (or variable speed) operation with different capFunFF and EIRFunFF
curves for each speed, user must ensure that array size of all capFunFF and EIRFunFF are same. 
For example 
in <a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.Data.PerformanceCurves.Curve_III\">
Buildings.Fluid.HeatExchangers.DXCoils.Data.PerformanceCurves.Curve_III</a> 
capFunFF is a cubic curve where as in  
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.Data.PerformanceCurves.Curve_I\">
Buildings.Fluid.HeatExchangers.DXCoils.Data.PerformanceCurves.Curve_I</a> 
capFunFF is a linear function but its array size kept same in both performance curves.
This allows using these performance curves for different speeds in the same model.
</html>",
revisions="<html>
<ul>
<li>
August 15, 2012 by Kaustubh Phalak:<br>
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
          textString="capFunFF"),
        Text(
          extent={{2,-16},{94,-38}},
          lineColor={0,0,255},
          textString="%capFunFF"),
        Text(
          extent={{-95,-49},{-12,-104}},
          lineColor={0,0,255},
          textString="EIRFunT"),
        Text(
          extent={{7,-53},{84,-94}},
          lineColor={0,0,255},
          textString="%EIRFunT")}));
end Generic;
