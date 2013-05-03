within Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.Data.BaseClasses;
record HeatingPerformance
  "Base performance data record for water to water heat pump in heating mode"
  extends Modelica.Icons.Record;
  parameter Modelica.SIunits.AngularVelocity spe(displayUnit="1/min")
    "Rotational speed";

//-----------------------------Heating mode nominal condition-----------------------------//
  parameter Modelica.SIunits.HeatFlowRate QHea_flow_nominal(min=0)
    "Reference heating capacity"
    annotation (Dialog(group="Heating mode nominal condition"));

  parameter Modelica.SIunits.Power PHea_nominal
    "Rated power consumed by the unit in heating mode"
    annotation (Dialog(group="Heating mode nominal condition"));

//-----------------------------Heating mode non-dimensional performance curves-----------------------------//
  parameter Real heaCap[5]
    "Coefficients for non-dimensional heating capacity curve"
    annotation (Dialog(group="Heating mode performance curves"));

  parameter Real heaP[5]
    "Coefficients for non-dimensional power consumption curve (in heating mode)"
    annotation (Dialog(group="Heating mode performance curves"));

  annotation (preferedView="info",defaultComponentName="heaPer",
  Documentation(info="<html>
This is data performance record for Water to Water Heat Pump in heating mode. 
</html>",
revisions="<html>
<ul>
<li>
January 12, 2013, by Kaustubh Phalak:<br>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Text(
          extent={{-95,53},{-12,-2}},
          lineColor={0,0,255},
          textString="Q"),
        Text(
          extent={{7,55},{90,0}},
          lineColor={0,0,255},
          textString="%QHea_flow_nominal"),
        Text(
          extent={{-105,-9},{-48,-48}},
          lineColor={0,0,255},
          textString="T"),
        Text(
          extent={{2,-16},{94,-38}},
          lineColor={0,0,255},
          textString="%T_nominal"),
        Text(
          extent={{-95,-49},{-12,-104}},
          lineColor={0,0,255},
          textString="m"),
        Text(
          extent={{7,-53},{84,-94}},
          lineColor={0,0,255},
          textString="%m1_flow_nominal")}));

end HeatingPerformance;
