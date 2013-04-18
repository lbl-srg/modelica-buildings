within Buildings.Fluid.SolarCollectors.BaseClasses;
block PartialHeatLoss
  "Partial heat loss model on which ASHRAEHeatLoss and EN12975HeatLoss are based"
  extends Modelica.Blocks.Interfaces.BlockIcon;
  extends SolarCollectors.BaseClasses.PartialParameters;
  Modelica.Blocks.Interfaces.RealInput TEnv(
    quantity="Temperature",
    unit="K",
    displayUnit="degC") "Temperature of environment"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  parameter Integer nSeg(min=3) = 3 "Number of segments in the collector model";
public
  Modelica.Blocks.Interfaces.RealInput TFlu[nSeg](
    quantity="Temperature",
    unit = "K",
    displayUnit="degC") "Temperature of the heat transfer fluid"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealOutput QLos[nSeg](
    quantity = "HeatFlowRate",
    unit = "W",
    displayUnit="W")
    "Rate at which heat is lost to ambient from a given segment at current conditions"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  parameter Modelica.SIunits.Irradiance I_nominal
    "Irradiance at nominal conditions"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature TEnv_nominal
    "Ambient temperature at nomincal conditions"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Fluid flow rate at nominal conditions"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.SpecificHeatCapacity Cp
    "Specific heat capacity of the fluid";
protected
  final parameter Modelica.SIunits.HeatFlowRate QUse_nominal(fixed = false)
    "Useful heat gain at nominal conditions";
  final parameter Modelica.SIunits.HeatFlowRate QLos_nominal(fixed = false)
    "Heat loss at nominal conditions";
  final parameter Modelica.SIunits.HeatFlowRate QLosUA[nSeg](fixed = false)
    "Heat loss at current conditions";
  final parameter Modelica.SIunits.Temperature TFlu_nominal[nSeg](each start = 293.15, fixed = false)
    "Temperature of each semgent in the collector at nominal conditions";

  annotation (
    defaultComponentName="heaLos",
    Documentation(info="<html>
<p>
This component is a partial model used as the base for ASHRAEHeatLoss and EN12975HeatLoss. It contains the input, output and parameter declarations which are common
to both models. More detailed information is available in the documentation for ASHRAEHeallLoss and EN12975HeatLoss.
</p>
</html>", revisions="<html>
<ul>
<li>
Apr 17, 2013, by Peter Grant:<br>
First implementation
</li>
</ul>
</html>"),
    Diagram(graphics),
    Icon(graphics={Text(
          extent={{-48,-32},{36,-66}},
          lineColor={0,0,255},
          textString="%name")}));
end PartialHeatLoss;
