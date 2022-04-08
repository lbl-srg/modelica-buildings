within Buildings.Templates.ChilledWaterPlant.Components.ChillerSection.Interfaces;
record Data "Data for chiller section"
  extends Modelica.Icons.Record;

  // Structure parameters

  parameter
    Buildings.Templates.ChilledWaterPlant.Components.Types.ChillerSection typ
    "Type of chiller section"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nChi
    "Number of chillers"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean isAirCoo
    "= true, chillers are air cooled,
    = false, chillers are water cooled"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  final parameter Boolean is_series = typ ==Buildings.Templates.ChilledWaterPlant.Components.Types.ChillerSection.ChillerSeries
    "= true if chillers are connected in series";

  parameter Boolean have_dedChiWatPum
    "Set to true if parallel chillers are connected to dedicated pumps on chilled water side";
  parameter Boolean have_dedConWatPum
    "Set to true if parallel chillers are connected to dedicated pumps on condenser water side";

  // Equipment characteristics

  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal(min=0)=0
    "Condenser water side nominal mass flow rate"
    annotation(Dialog(group="Nominal condition", enable=not isAirCoo));
  parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal(min=0)
    "Chilled water side nominal mass flow rate"
    annotation(Dialog(group="Nominal condition"));

  parameter
    Buildings.Templates.ChilledWaterPlant.Components.Chillers.Interfaces.Data
    chi[nChi](
    each final isAirCoo=isAirCoo,
    each m1_flow_nominal=m1_flow_nominal/nChi,
    each m2_flow_nominal=m2_flow_nominal/nChi) "Chiller data"
    annotation (Dialog(group="Chiller"));
  parameter
    Buildings.Templates.Components.Data.Valve valChiWatChi[nChi](
      each final m_flow_nominal = m2_flow_nominal/nChi,
      each dpValve_nominal = 0)
    "Chiller chilled water side isolation valve"
    annotation(Dialog(group = "Valve", enable=is_series or not have_dedChiWatPum));
  parameter
    Buildings.Templates.Components.Data.Valve valConWatChi[nChi](
      each final m_flow_nominal = m1_flow_nominal/nChi,
      each dpValve_nominal = 0)
    "Chiller chilled water side isolation valve"
    annotation(Dialog(group = "Valve", enable=not have_dedConWatPum));

end Data;
