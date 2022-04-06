within Buildings.Templates.ChilledWaterPlant.Components.Economizer.Interfaces;
record Data "Data for waterside economizer"
  extends Modelica.Icons.Record;

  // Structure parameters

  parameter Buildings.Templates.ChilledWaterPlant.Components.Types.Economizer
    typ "Type of waterside economizer"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Boolean isAirCoo
    "= true, chillers are air cooled,
    = false, chillers are water cooled"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  final parameter Boolean have_eco=
    typ ==Buildings.Templates.ChilledWaterPlant.Components.Types.Economizer.WatersideEconomizer
    "Return section has a waterside economizer";

  // Equipment characteristics

  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal(min=0)=0
    "Condenser water side nominal mass flow rate"
    annotation(Dialog(group="Nominal condition", enable=not isAirCoo));
  parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal(min=0)
    "Chilled water side nominal mass flow rate"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpConWatChiValve_nominal=0
    "Waterside economizer bypass valve pressure drop"
    annotation (Dialog(group="Valve"));

  //FixMe add the rest of the Waterside Economizer parameters

end Data;
