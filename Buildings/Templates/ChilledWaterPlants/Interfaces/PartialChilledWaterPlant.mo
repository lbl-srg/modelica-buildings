within Buildings.Templates.ChilledWaterPlants.Interfaces;
partial model PartialChilledWaterPlant "Interface class for CHW plant"

  replaceable package Medium = Buildings.Media.Water;

  // Structure parameters

  parameter
    Buildings.Templates.ChilledWaterPlants.Components.Types.Configuration typ
    "Type of system"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  final inner parameter Boolean isAirCoo=
    typ ==Buildings.Templates.ChilledWaterPlants.Components.Types.Configuration.AirCooled
    "= true, chillers are air cooled,
    = false, chillers are water cooled"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  // Number of components

  inner parameter Integer nChi "Number of chillers"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  inner parameter Integer nPumPri "Number of primary pumps"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  inner parameter Integer nPumSec "Number of secondary pumps"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  inner parameter Integer nPumCon "Number of condenser pumps"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  inner parameter Integer nCooTow "Number of cooling towers"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  // Component properties from type

  inner parameter Boolean have_dedChiWatPum
    "Set to true if parallel chillers are connected to dedicated pumps on chilled water side"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  inner parameter Boolean have_dedConWatPum
    "Set to true if parallel chillers are connected to dedicated pumps on condenser water side"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  inner parameter Boolean have_secPum
    "Set to true if plant has secondary pumping"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  inner parameter Boolean have_eco
    "=true if plant has waterside economizer"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  inner parameter Boolean have_parChi
    "Set to true if plant chillers are in parallel"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  // User defined structure
  parameter Boolean have_minFloByp
    "Set to true if chilled water loop has a minimum flow bypass";
  inner parameter Boolean have_chiWatChiByp = have_eco
    "Set to true if chilled water loop has a chiller bypass"
    annotation(Evaluate=true, Dialog(enable=have_eco, group="Configuration"));
  parameter Boolean have_TPriRet = not have_secPum
    "Set to true if plant chilled water return temperature is measured"
    annotation(Evaluate=true, Dialog(enable=have_secPum, group="Configuration"));
  final parameter Boolean have_TSecRet = have_secPum and not have_eco
    "Set to true if secondary return temperature is measured"
    annotation(Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_TChiWatRet = false
    "Set to true if loop chilled water return temperature is measured"
    annotation(Evaluate=true, Dialog(enable=have_minFloByp and not have_eco, group="Configuration"));
  parameter Boolean have_VSecRet_flow = false
    "Set to true if secondary return chilled water flow is measured"
    annotation(Evaluate=true, Dialog(enable=have_secPum, group="Configuration"));
  final parameter Boolean have_VSecSup_flow = have_secPum and not have_VSecRet_flow
    "Set to true if secondary supply chilled water flow is measured"
    annotation(Evaluate=true,
      Dialog(enable=have_secPum and not have_VSecRet_flow,
        group="Configuration"));

  // Record

  parameter Buildings.Templates.ChilledWaterPlants.Data.ChilledWaterPlant dat(
      final typ=typ) "Chilled water plant data";

  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare final package Medium=Medium) "CHW supply"
    annotation (Placement(transformation(extent={{290,-10},{310,10}}),
        iconTransformation(extent={{192,90},{212,110}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare final package Medium=Medium) "CHW return"
    annotation (Placement(transformation(extent={{290,-190},{310,-170}}),
        iconTransformation(extent={{192,-112},{212,-92}})));
  Buildings.BoundaryConditions.WeatherData.Bus busWea "Weather bus"
    annotation (Placement(transformation(
      extent={{-20,20},{20,-20}},
      rotation=180,
      origin={0,280}), iconTransformation(
        extent={{-20,20},{20,-20}},
        rotation=180,
        origin={0,200})));

  Buildings.Templates.ChilledWaterPlants.Interfaces.Bus bus
    "CHW plant control bus" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-300,140}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-200,100})));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-200,-200},{200,200}}),
    graphics={
      Rectangle(
        extent={{-200,200},{202,-200}},
        lineColor={0,0,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid)}),
   Diagram(coordinateSystem(
      preserveAspectRatio=false,
      extent={{-300,-280},{300,280}})));
end PartialChilledWaterPlant;
