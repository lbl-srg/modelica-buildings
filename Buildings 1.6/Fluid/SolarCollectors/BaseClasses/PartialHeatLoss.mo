within Buildings.Fluid.SolarCollectors.BaseClasses;
block PartialHeatLoss
  "Partial heat loss model on which ASHRAEHeatLoss and EN12975HeatLoss are based"
  extends Modelica.Blocks.Icons.Block;
  extends SolarCollectors.BaseClasses.PartialParameters;

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium in the component";

  parameter Modelica.SIunits.Irradiance G_nominal
    "Irradiance at nominal conditions"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.TemperatureDifference dT_nominal
    "Ambient temperature at nomincal conditions"
     annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Fluid flow rate at nominal conditions"
    annotation(Dialog(group="Nominal condition"));

  Modelica.Blocks.Interfaces.RealInput TEnv(
    quantity="ThermodynamicTemperature",
    unit="K",
    displayUnit="degC") "Temperature of surrounding environment"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));

public
  Modelica.Blocks.Interfaces.RealInput TFlu[nSeg](
    quantity="ThermodynamicTemperature",
    unit = "K",
    displayUnit="degC") "Temperature of the heat transfer fluid"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealOutput QLos[nSeg](
    quantity="HeatFlowRate",
    unit="W",
    displayUnit="W") "Limited heat loss rate at current conditions"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  final parameter Modelica.SIunits.HeatFlowRate QUse_nominal(fixed = false)
    "Useful heat gain at nominal conditions";
  final parameter Modelica.SIunits.HeatFlowRate QLos_nominal(fixed = false)
    "Heat loss at nominal conditions";
  final parameter Modelica.SIunits.HeatFlowRate QLosUA[nSeg](fixed = false)
    "Heat loss at current conditions";
  final parameter Modelica.SIunits.Temperature dT_nominal_fluid[nSeg](each
  start = 293.15, fixed = false)
    "Temperature of each semgent in the collector at nominal conditions";
  Medium.ThermodynamicState sta_default=Medium.setState_pTX(
      T=Medium.T_default,
      p=Medium.p_default,
      X=Medium.X_default);
  Modelica.SIunits.SpecificHeatCapacity Cp_default = Medium.specificHeatCapacityCp(sta_default)
    "Specific heat capacity of the fluid";
  Modelica.SIunits.HeatFlowRate QLosInt[nSeg]
    "Heat loss rate at current conditions";

equation
  for i in 1:nSeg loop
    QLos[i] = QLosInt[i] * Buildings.Utilities.Math.Functions.smoothHeaviside(
     TFlu[i]-(Medium.T_min+1), 1);
  end for;

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
        detailed information is available in the documentation for the extending classes.
      </p>
    </html>", revisions="<html>
      <ul>
        <li>
          Apr 17, 2013, by Peter Grant:<br/>
          First implementation
        </li>
      </ul>
    </html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),
            graphics),
    Icon(graphics));
end PartialHeatLoss;
