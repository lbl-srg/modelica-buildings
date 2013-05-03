within Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.Data.BaseClasses;
record CoolingPerformance
  "Base performance data record for water to water heat pump in cooling mode"
  extends Modelica.Icons.Record;
  parameter Modelica.SIunits.AngularVelocity spe(displayUnit="1/min")
    "Rotational speed";
//-----------------------------Cooling mode nominal condition-----------------------------//
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal(max=0)
    "Reference cooling capacity (negative number)"
    annotation (Dialog(group="Cooling mode nominal condition"));

  parameter Modelica.SIunits.Power P_nominal
    "Rated power consumed by the unit in cooling mode"
    annotation (Dialog(group="Cooling mode nominal condition"));

//---------------------Cooling mode non-dimensional performance curves----------------------//
  parameter Real cooCap[5]
    "Coefficients for non-dimensional cooling capacity curve"
    annotation (Dialog(group="Cooling mode performance curves"));

  parameter Real cooP[5]
    "Coefficients for non-dimensional power consumption curve (in cooling mode)"
    annotation (Dialog(group="Cooling mode performance curves"));

  annotation (preferedView="info",defaultComponentName="cooPer",
  Documentation(info="<html>
This is performance data record for Water to Water Heat Pump in cooing mode. 
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
          textString="%Q_flow_nominal"),
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

end CoolingPerformance;
