within Buildings.Fluid.HeatExchangers.HeatPumps.AirToAir.Data;
record HPData "Performance record for a heat pump with one or multiple stages"
  extends Modelica.Icons.Record;
  parameter Integer nHeaSta(min=1) "Number of heating stages"
    annotation (Evaluate = true);
  parameter Integer nCooSta(min=1) "Number of heating stages"
    annotation (Evaluate = true);
  parameter
    Buildings.Fluid.HeatExchangers.HeatPumps.AirToAir.Data.BaseClasses.HeatingStage
    heaSta[nHeaSta]
    "Data record for heat pump performance in heating mode at each stage";
  parameter
    Buildings.Fluid.HeatExchangers.HeatPumps.AirToAir.Data.BaseClasses.CoolingStage
    cooSta[nCooSta]
    "Data record for heat pump performance in cooling mode at each stage";
  parameter Modelica.SIunits.MassFlowRate m1_flow_small = 0.0001*heaSta[1].nomVal.m1_flow_nominal
    "Small mass flow rate for regularization near zero flow"
    annotation (Dialog(group="Minimum conditions"));
  parameter Modelica.SIunits.MassFlowRate m2_flow_small = 0.0001*heaSta[1].nomVal.m2_flow_nominal
    "Small mass flow rate for regularization near zero flow"
    annotation (Dialog(group="Minimum conditions"));

end HPData;
