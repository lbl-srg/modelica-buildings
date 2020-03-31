within Buildings.Fluid.HeatExchangers.ActiveBeams.Data;
record Generic "Generic data record for active beam"
   extends Modelica.Icons.Record;

  parameter BaseClasses.AirFlow primaryAir(
    r_V={0,0.2,1},
    f={0,0.5,1}) "Performance data for primary air";
  parameter
    Buildings.Fluid.HeatExchangers.ActiveBeams.Data.BaseClasses.WaterFlow water(
      r_V={0,0.5,1},
      f={0,0.7,1}) "Performance data for water";

  parameter BaseClasses.TemperatureDifference dT(
    r_dT={0,0.5,1},
    f={0,0.5,1})
    "Performance data for normalized temperature difference room minus water inlet";

  parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal
    "Nominal air mass flow rate per beam"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.MassFlowRate mWat_flow_nominal
    "Nominal water mass flow rate per beam"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpWat_nominal(displayUnit="Pa")
    "Water-side nominal pressure drop per beam"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.PressureDifference dpAir_nominal(displayUnit="Pa")
    "Air-side nominal pressure drop"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.TemperatureDifference dT_nominal
    "Nominal temperature difference water inlet minus room air"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal
    "Nominal capacity per beam" annotation (Dialog(group="Nominal condition"));

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
Performance data for a generic active beam.
</p>
</html>"));
end Generic;
