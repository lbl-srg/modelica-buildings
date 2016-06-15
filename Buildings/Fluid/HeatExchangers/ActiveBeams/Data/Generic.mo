within Buildings.Fluid.HeatExchangers.ActiveBeams.Data;
record Generic "Generic data record for active beam"
   extends Modelica.Icons.Record;

  parameter BaseClasses.AirFlow primaryAir(
    r_V={0,0.2,1},
    f={0,0.5,1})
    "Performance data for primary air";
  parameter
    Buildings.Fluid.HeatExchangers.ActiveBeams.Data.BaseClasses.WaterFlow water(
      r_V={0,0.5,1},
      f={0,0.7,1}) "Performance data for water";

  parameter BaseClasses.TemperatureDifference dT(
    r_dT={0,0.5,1},
    f={0,0.5,1})
    "Performance data for normalized temperature difference room minus water inlet";

    // fixme: for mAir_flow, mWat_flow_nominal, dpWat_nominal and Q_flow_nominal, state whether
    //        it is per beam or total, and make sure these quantities are correctly scaled
    //        if the number of beams changes
  parameter Modelica.SIunits.MassFlowRate mAir_flow_nominal "Nominal air mass flow rate"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.SIunits.MassFlowRate mWat_flow_nominal
    "Nominal water mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dpWat_nominal(displayUnit="Pa")
    "Water-side nominal pressure difference"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.SIunits.TemperatureDifference dT_nominal
    "Nominal temperature difference water inlet minus room air"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal "Nominal capacity"
    annotation (Dialog(group="Nominal condition"));

  annotation (defaultComponentName="per",
Documentation(revisions="<html>
<ul>
<li>
June 13, 2016, by Michael Wetter:<br/>
Revised implementation.
</li>
<li>
May 20, 2016, by Alessandro Maccarini:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Performance data for a generic active beam for heating mode.
</p>
</html>"));
end Generic;
