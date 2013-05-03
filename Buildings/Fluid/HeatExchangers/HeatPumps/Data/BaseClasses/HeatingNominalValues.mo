within Buildings.Fluid.HeatExchangers.HeatPumps.Data.BaseClasses;
record HeatingNominalValues "Data record of heating mode nominal values"

  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal(min=0)
    "Nominal heating capacity"
    annotation (Dialog(group="Nominal condition"));
  extends
    Buildings.Fluid.HeatExchangers.HeatPumps.Data.BaseClasses.PartialNominalValues;
  parameter Modelica.SIunits.Temperature T1In_nominal=273.15+21.1
    "Entering air dry-bulb temperature at rating condition"
      annotation(Dialog(tab="General",group="Nominal condition"));

  parameter Modelica.SIunits.Temperature T2In_nominal=273.15+21.1
    "Entering water temperature at rating condition"
      annotation(Dialog(tab="General",group="Nominal condition"));
annotation (defaultComponentName="heaNomVal",
              preferedView="info",
  Documentation(info="<html>
  <p>
This is the base record of heating mode nominal values for heat pump models. 
</p>
<p>
See the information section of
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.Data.HPData\">
Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.Data.HPData</a>
for a description of the data.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 24, 2013 by Kaustubh Phalak:<br>
First implementation.
</li>
</ul>
</html>"));
end HeatingNominalValues;
