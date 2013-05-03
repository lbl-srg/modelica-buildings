within Buildings.Fluid.HeatExchangers.HeatPumps.AirToAir.Data.BaseClasses;
record CoolingNominalValues "Data record of cooling mode nominal values"
  extends
    Buildings.Fluid.HeatExchangers.HeatPumps.Data.BaseClasses.CoolingNominalValues;

//   parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal(max=0)
//     "Nominal cooling capacity (negative number)"
//     annotation (Dialog(group="Nominal condition"));
//   extends
//     Buildings.Fluid.HeatExchangers.HeatPumps.Data.BaseClasses.PartialNominalValues;
//
//   parameter Real SHR_nominal "Nominal sensible heat ratio"
//     annotation (Dialog(group="Nominal condition"));
//
//   parameter Modelica.SIunits.Temperature T1In_nominal=273.15+19.4
//     "Entering air dry-bulb temperature at rating condition"
//       annotation(Dialog(tab="General",group="Nominal condition"));
//
//   parameter Modelica.SIunits.Temperature T2In_nominal=308.15
//     "Entering water temperature at rating condition"
//       annotation(Dialog(tab="General",group="Nominal condition"));
//
//   parameter Modelica.SIunits.Time tWet = 1400
//     "Time until moisture drips from coil when a dry coil is switched on"
//      annotation(Dialog(tab="General",group="Re-evaporation data"));
//   parameter Real gamma(min=0) = 1.5
//     "Ratio of evaporation heat transfer divided by latent heat transfer at nominal conditions"
//      annotation(Dialog(tab="General",group="Re-evaporation data"));

annotation (defaultComponentName="cooNomVal",
              preferedView="info",
  Documentation(info="<html>
  <p>
This is the base record of cooling mode nominal values for heat pump models. 
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
end CoolingNominalValues;
