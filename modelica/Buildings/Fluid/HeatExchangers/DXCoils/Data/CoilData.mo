within Buildings.Fluid.HeatExchangers.DXCoils.Data;
record CoilData "Performance record for DX Cooling Coil"
  extends Modelica.Icons.Record;
  parameter Boolean sinSpeOpe = true
    "The data record is used for single speed operation"
    annotation(Evaluate=true, HideResult=true);
  parameter Integer nSpe( min=1) "Number of standard compressor speeds"
    annotation (Evaluate = true,
                Dialog(enable = not sinSpeOpe));
  parameter Real minSpeRat( min=0,max=1)=0.2 "Minimum speed ratio"
    annotation (Evaluate = true,
                Dialog(enable = not sinSpeOpe));
  //performance data should be available for 'nSpe' speeds
  parameter Buildings.Fluid.HeatExchangers.DXCoils.Data.BaseClasses.Generic per[nSpe]
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  parameter Modelica.SIunits.MassFlowRate m_flow_small = 0.0001*per[1].nomVal.m_flow_nominal
    "Small mass flow rate in case of no-flow condition"
    annotation (Dialog(group="Minimum conditions"));
annotation (defaultComponentName="datCoi", Documentation(info="<html>
This record is used as a template for performance data for the DX cooling coil model.
</html>",
revisions="<html>
<ul>
<li>
July 23, 2012 by Kaustubh Phalak:<br>
First implementation.
</li>
</ul>
</html>"));
end CoilData;
