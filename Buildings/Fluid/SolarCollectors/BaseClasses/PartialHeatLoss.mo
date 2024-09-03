within Buildings.Fluid.SolarCollectors.BaseClasses;
block PartialHeatLoss
  "Partial heat loss model on which ASHRAEHeatLoss and EN12975HeatLoss are based"
  extends Modelica.Blocks.Icons.Block;
  extends SolarCollectors.BaseClasses.PartialParameters;

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium in the component";

  Modelica.Blocks.Interfaces.RealInput TEnv(
    quantity="ThermodynamicTemperature",
    unit="K",
    displayUnit="degC") "Temperature of surrounding environment"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));

  Modelica.Blocks.Interfaces.RealInput TFlu[nSeg](
    each quantity="ThermodynamicTemperature",
    each unit = "K",
    each displayUnit="degC") "Temperature of the heat transfer fluid"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealOutput QLos_flow[nSeg](
    each quantity="HeatFlowRate",
    each unit="W",
    each displayUnit="W") = {QLos_internal[i]*smooth(1, if TFlu[i] > TMedMin2
     then 1 else Buildings.Utilities.Math.Functions.smoothHeaviside(TFlu[i] -
    TMedMin, dTMin)) for i in 1:nSeg}
    "Limited heat loss rate at current conditions"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  constant Modelica.Units.SI.Temperature dTMin=1
    "Safety temperature difference to prevent TFlu < Medium.T_min";
  final parameter Modelica.Units.SI.Temperature TMedMin=Medium.T_min + dTMin
    "Fluid temperature below which there will be no heat loss computed to prevent TFlu < Medium.T_min";
  final parameter Modelica.Units.SI.Temperature TMedMin2=TMedMin + dTMin
    "Fluid temperature below which there will be no heat loss computed to prevent TFlu < Medium.T_min";

  input Modelica.Units.SI.HeatFlowRate QLos_internal[nSeg]
    "Heat loss rate at current conditions for each segment";

  Modelica.Units.SI.TemperatureDifference dT[nSeg]={TEnv - TFlu[i] for i in 1:
      nSeg} "Environment minus collector fluid temperature";

  annotation (
defaultComponentName="heaLos",
Documentation(info="<html>
<p>
This component is a partial model used as the base for
<a href=\"modelica://Buildings.Fluid.SolarCollectors.BaseClasses.ASHRAEHeatLoss\">
Buildings.Fluid.SolarCollectors.BaseClasses.ASHRAEHeatLoss</a> and
<a href=\"modelica://Buildings.Fluid.SolarCollectors.BaseClasses.EN12975HeatLoss\">
Buildings.Fluid.SolarCollectors.BaseClasses.EN12975HeatLoss</a>. It contains the
input, output and parameter declarations which are common to both models. More
detailed information is available in the documentation of the extending classes.
</p>
</html>", revisions="<html>
<ul>
<li>
February 15, 2024, by Jelger Jansen:<br/>
Refactor model.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3604\">Buildings, #3604</a>.
</li>
<li>
December 17, 2017, by Michael Wetter:<br/>
Revised computation of heat loss.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1100\">
issue 1100</a>.
</li>
<li>
June 29, 2015, by Michael Wetter:<br/>
Revised implementation of heat loss near <code>Medium.T_min</code>
to make it more efficient.
</li>
<li>
November 20, 2014, by Michael Wetter:<br/>
Added missing <code>each</code> keyword.
</li>
<li>
Apr 17, 2013, by Peter Grant:<br/>
First implementation
</li>
</ul>
</html>"));
end PartialHeatLoss;
