within Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.Data.BaseClasses;
record HeatingMode "Data record for water to water heat pump in heating mode"
  extends Modelica.Icons.Record;

  parameter Integer nSta(min=0)
    "Total number of stages in heating mode operation";
    // 0 stages if heat pump is only used for cooling purpose

  parameter
    Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.Data.BaseClasses.HeatingPerformance
    heaPer[nSta] "Heating mode performance data"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));

//-----------------------------Heating mode nominal condition-----------------------------//

  parameter Modelica.SIunits.Temperature T_nominal=273.15+10
    "Reference heating mode temperature"
    annotation(Dialog(tab="General",group="Heating mode nominal condition"));

  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal
    "Heating mode load side nominal water mass flow rate"
    annotation (Dialog(group="Heating mode nominal condition"));

  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal
    "Heating mode source side nominal water mass flow rate"
    annotation (Dialog(group="Heating mode nominal condition"));

//   parameter Modelica.SIunits.Pressure p_nominal=101325 "Nominal pressure"
//     annotation(Dialog(tab="General",group="Cooling mode nominal condition"));

  annotation (preferedView="info",defaultComponentName="heaMod",
  Documentation(info="<html>
This is data record for Water to Water Heat Pump in heating mode. 
</html>",
revisions="<html>
<ul>
<li>
January 12, 2013, by Kaustubh Phalak:<br>
First implementation.
</li>
</ul>
</html>"));

end HeatingMode;
