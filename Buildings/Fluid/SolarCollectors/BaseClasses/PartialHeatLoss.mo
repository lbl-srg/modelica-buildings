within Buildings.Fluid.SolarCollectors.BaseClasses;
block PartialHeatLoss
  "Partial heat loss model on which ASHRAEHeatLoss and EN12975HeatLoss are based"
  extends Modelica.Blocks.Interfaces.BlockIcon;
  extends SolarCollectors.BaseClasses.PartialParameters;

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium in the component";

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
  parameter Modelica.SIunits.Irradiance G_nominal
    "Irradiance at nominal conditions"
    annotation(Dialog(group="Nominal condition"));
   parameter Modelica.SIunits.Temperature dT_nominal
    "Ambient temperature at nomincal conditions"
     annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Fluid flow rate at nominal conditions"
    annotation(Dialog(group="Nominal condition"));

protected
  Modelica.SIunits.Temperature TEnvVector[nSeg] = fill(TEnv,nSeg)
    "Vector of nSeg entries of TEnv";
  final parameter Modelica.SIunits.HeatFlowRate QUse_nominal(fixed = false)
    "Useful heat gain at nominal conditions";
  final parameter Modelica.SIunits.HeatFlowRate QLos_nominal(fixed = false)
    "Heat loss at nominal conditions";
  final parameter Modelica.SIunits.HeatFlowRate QLosUA[nSeg](fixed = false)
    "Heat loss at current conditions";
  final parameter Modelica.SIunits.Temperature dT_nominal_fluid[nSeg](each start = 293.15, fixed = false)
    "Temperature of each semgent in the collector at nominal conditions";
  Medium.ThermodynamicState sta[nSeg]=Medium.setState_pTX(
      T=dT_nominal_fluid+TEnvVector,
      p=Medium.p_default,
      X=Medium.X_default);
  Modelica.SIunits.SpecificHeatCapacity Cp[nSeg] = Medium.specificHeatCapacityCp(sta)
    "Specific heat capacity of the fluid";
 Modelica.SIunits.SpecificHeatCapacity Cp_avg = sum(Cp[1:nSeg])/nSeg
    "Average specific heat across the solar collector";

  annotation (
    defaultComponentName="heaLos",
    Documentation(info="<html>
<p>
This component is a partial model used as the base for <a href=\"modelica://Buildings.Fluid.SolarCollectors.BaseClasses.ASHRAEHeatLoss\">
Buildings.Fluid.SolarCollectors.BaseClasses.ASHRAEHeatLoss</a> and <a href=\"modelica://Buildings.Fluid.SolarCollectors.BaseClasses.EN12975HeatLoss\">
Buildings.Fluid.SolarCollectors.BaseClasses.EN12975HeatLoss</a>. It contains the input, output and parameter declarations which are common
to both models. More detailed information is available in the documentation for the extending classes.
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
