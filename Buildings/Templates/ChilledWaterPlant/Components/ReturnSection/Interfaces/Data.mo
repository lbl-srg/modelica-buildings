within Buildings.Templates.ChilledWaterPlant.Components.ReturnSection.Interfaces;
record Data "Data for return chilled water sections"
  extends Modelica.Icons.Record;

  // Structure parameters

  parameter Buildings.Templates.ChilledWaterPlant.Components.Types.ReturnSection typ
    "Type of waterside economizer"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Boolean isAirCoo
    "= true, chillers in group are air cooled,
    = false, chillers in group are water cooled"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  final parameter Boolean have_WSE=
    typ == Buildings.Templates.ChilledWaterPlant.Components.Types.ReturnSection.WatersideEconomizer
    "Return section has a waterside economizer";

  // Equipment characteristics

  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal(min=0)=0
    "Condenser water side nominal mass flow rate"
    annotation(Dialog(group="Nominal condition", enable=not isAirCoo));
  parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal(min=0)
    "Chilled water side nominal mass flow rate"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpCWValve_nominal=0
    "Waterside economizer bypass valve pressure drop"
    annotation (Dialog(group="Valve"));

  //FixMe add the rest of the WSE parameters

end Data;
