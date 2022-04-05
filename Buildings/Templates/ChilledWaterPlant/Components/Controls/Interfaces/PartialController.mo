within Buildings.Templates.ChilledWaterPlant.Components.Controls.Interfaces;
block PartialController "Partial controller for CHW plant"

  parameter Buildings.Templates.ChilledWaterPlant.Components.Types.Controller typ
    "Type of controller"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Buildings.Templates.ChilledWaterPlant.Components.Controls.Interfaces.Data dat(
      final typ=typ,
      final nSenDpCHWRem=nSenDpCHWRem,
      final nChi=nChi,
      final have_WSE=have_WSE,
      final have_senDpCHWLoc=have_senDpCHWLoc,
      final have_fixSpeConWatPum=have_fixSpeConWatPum,
      final have_ctrHeaPre=have_ctrHeaPre) "Controller data";

  outer replaceable Buildings.Templates.ChilledWaterPlant.Components.ReturnSection.Interfaces.PartialReturnSection
    retSec "CHW return section";
  // FIXME: only for water-cooled plants.
  outer replaceable Buildings.Templates.ChilledWaterPlant.Components.CoolingTowerGroup.Interfaces.PartialCoolingTowerGroup
    cooTowGro "Cooling towers";
  outer replaceable Buildings.Templates.ChilledWaterPlant.Components.CondenserWaterPumpGroup.Interfaces.PartialCondenserWaterPumpGroup
    pumCon "Condenser water pump group";

  parameter Boolean have_WSE
    "Set to true if the plant has a WSE";
  parameter Boolean have_parChi
    "Set to true if the plant has parallel chillers";
  final parameter Modelica.Units.SI.HeatFlowRate cap_nominal(final min=0)=
    sum(capChi_nominal)
    "Plant design capacity (>0 by convention)"
    annotation (Dialog(tab="General", group="Chillers configuration"));
  parameter Modelica.Units.SI.HeatFlowRate capChi_nominal[nChi](each final min=0)
    "Design chiller capacities vector"
    annotation (Dialog(tab="General", group="Chillers configuration"));
  parameter Modelica.Units.SI.Temperature TCHWSup_nominal(displayUnit="degC")
    "Design (minimum) CHW supply temperature (identical for all chillers)"
    annotation (Dialog(tab="General", group="Chillers configuration"));
  outer parameter Boolean have_CHWDedPum
    "Set to true if parallel chillers are connected to dedicated pumps on chilled water side"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  // FIXME: only for water-cooled plants.
  parameter Boolean have_CWDedPum
    "Set to true if parallel chillers are connected to dedicated pumps on condenser water side"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  // FIXME: only for water-cooled plants.
  parameter Boolean have_fixSpeConWatPum = false
    "Set to true if the plant has fixed speed CW pumps. (Must be false if the plant has WSE.)"
    annotation(Dialog(tab="General", group="Condenser water pump",
      enable=not have_WSE and not isAirCoo));
  parameter Boolean have_senDpCHWLoc = false
    "Set to true if there is a local DP sensor hardwired to the plant controller"
    annotation (Dialog(tab="General", group="Configuration"));
  parameter Integer nSenDpCHWRem = 1
    "Number of remote CHW differential pressure sensors"
    annotation (Dialog(tab="General", group="Chilled water pump"));

  parameter Boolean have_ctrHeaPre = false
    "Set to true if head pressure control available from chiller controller"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Modelica.Units.SI.MassFlowRate mCHWChi_flow_nominal[nChi]=
    fill(mCHWPri_flow_nominal/nChi,nChi)
    "Design (maximum) chiller CHW mass flow rate (for each chiller)";
  parameter Modelica.Units.SI.MassFlowRate mCHWPri_flow_nominal
    "Design (maximum) primary CHW mass flow rate (for the plant)";


  outer parameter Integer nChi "Number of chillers"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  outer parameter Integer nPumPri "Number of primary pumps"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  outer parameter Integer nPumSec "Number of secondary pumps"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  outer parameter Integer nPumCon "Number of condenser pumps"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  outer parameter Integer nCooTow "Number of cooling towers"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  outer parameter Boolean isAirCoo
    "= true, chillers in group are air cooled, 
    = false, chillers in group are water cooled";
  outer parameter Boolean have_secondary
    "= true if plant has secondary pumping";

  Buildings.Templates.ChilledWaterPlant.BaseClasses.BusChilledWater busCon(
    final nChi = nChi, final nCooTow = nCooTow)
    "Control bus" annotation (Placement(transformation(extent={{200,-20},{240,20}}),
        iconTransformation(extent={{80,-20},{120,20}})));
  annotation (
    __Dymola_translate=true,
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-151,-114},{149,-154}},
          lineColor={0,0,255},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-200},{220,
            200}})));
end PartialController;
