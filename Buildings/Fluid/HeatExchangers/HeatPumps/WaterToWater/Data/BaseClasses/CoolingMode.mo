within Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.Data.BaseClasses;
record CoolingMode
  "Base data record for Water to Water Heat Pump in cooling mode"
  extends Modelica.Icons.Record;

  parameter Integer nSta(min=0)
    "Total number of stages in cooling mode operation";
    // 0 stages if heat pump is only used for heating purpose

  parameter
    Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.Data.BaseClasses.CoolingPerformance
    cooPer[nSta] "Cooling mode performance data"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));

//-----------------------------Cooling mode nominal condition-----------------------------//

  parameter Modelica.SIunits.Temperature T_nominal=273.15+10
    "Reference cooling mode temperature"
      annotation(Dialog(tab="General",group="Cooling mode nominal condition"));

  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal
    "Cooling mode load side nominal water mass flow rate"
    annotation (Dialog(group="Cooling mode nominal condition"));

  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal
    "Cooling mode source side nominal water mass flow rate"
    annotation (Dialog(group="Cooling mode nominal condition"));

//   parameter Modelica.SIunits.Pressure p_nominal=101325 "Nominal pressure"
//     annotation(Dialog(tab="General",group="Cooling mode nominal condition"));
  annotation (preferedView="info",defaultComponentName="cooMod",
  Documentation(info="<html>
This is data record for Water to Water Heat Pump in cooling mode. 
</html>",
revisions="<html>
<ul>
<li>
January 12, 2013, by Kaustubh Phalak:<br>
First implementation.
</li>
</ul>
</html>"));

end CoolingMode;
