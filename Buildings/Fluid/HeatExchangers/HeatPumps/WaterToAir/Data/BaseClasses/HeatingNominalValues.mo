within Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.Data.BaseClasses;
record HeatingNominalValues "Data record of heating mode nominal values"
  extends
    Buildings.Fluid.HeatExchangers.HeatPumps.Data.BaseClasses.HeatingNominalValues;
  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal
    "Nominal water mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Real wasHeaRecFra_nominal=0.2
    "Waste heat recovery fraction of power input at nominal condition"
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
