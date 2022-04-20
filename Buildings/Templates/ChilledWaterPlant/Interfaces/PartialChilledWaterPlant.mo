within Buildings.Templates.ChilledWaterPlant.Interfaces;
partial model PartialChilledWaterPlant

  replaceable package Medium = Buildings.Media.Water;

  // Structure parameters

  parameter Buildings.Templates.ChilledWaterPlant.Components.Types.Configuration
    typ "Type of system"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  final inner parameter Boolean isAirCoo=
    typ == Buildings.Templates.ChilledWaterPlant.Components.Types.Configuration.AirCooled
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
    "= true if plant has secondary pumping"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  inner parameter Boolean have_eco
    "=true if plant has waterside economizer"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  inner parameter Boolean have_parChi
    "= true if plant chillers are in parallel"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  // User defined structure
  parameter Boolean have_minFloByp
    "= true if chilled water loop has a minimum flow bypass";
  inner parameter Boolean have_chiWatChiByp = have_eco
    "= true if chilled water loop has a chiller bypass"
    annotation(Evaluate=true, Dialog(enable=have_eco, group="Configuration"));
  parameter Boolean have_TPriRet = not have_secPum
    "= true if plant chilled water return temperature is measured"
    annotation(Evaluate=true, Dialog(enable=have_secPum, group="Configuration"));
  final parameter Boolean have_TSecRet = have_secPum and not have_eco
    "= true if secondary return temperature is measured"
    annotation(Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_TChiWatRet = false
    "= true if loop chilled water return temperature is measured"
    annotation(Evaluate=true, Dialog(enable=have_minFloByp and not have_eco, group="Configuration"));
  parameter Boolean have_VSecRet_flow = false
    "= true if secondary return chilled water flow is measured"
    annotation(Evaluate=true, Dialog(enable=have_secPum, group="Configuration"));
  final parameter Boolean have_VSecSup_flow = have_secPum and not have_VSecRet_flow
    "= true if secondary supply chilled water flow is measured"
    annotation(Evaluate=true,
      Dialog(enable=have_secPum and not have_VSecRet_flow,
        group="Configuration"));

  // Record

  parameter Buildings.Templates.ChilledWaterPlant.Interfaces.Data dat(
    final typ=typ) "Chilled water plant data";

  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare final package Medium=Medium) "Chilled water supply"
    annotation (Placement(transformation(extent={{190,0},{210,20}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare final package Medium=Medium) "Chilled water return"
    annotation (Placement(transformation(extent={{190,-80},{210,-60}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus
    "Weather control bus"
    annotation (Placement(transformation(
      extent={{-20,20},{20,-20}},
      rotation=180,
      origin={0,100})));

  Buildings.Templates.ChilledWaterPlant.BaseClasses.BusChilledWater busCon
    "Chilled water loop control bus"
    annotation (Placement(transformation(
      extent={{-20,20},{20,-20}},
      rotation=90,
      origin={200,60})));


  annotation (Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-200,-100},{200,100}}),
    graphics={
      Rectangle(
        extent={{-200,100},{200,-100}},
        lineColor={0,0,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
        preserveAspectRatio=false, extent={{-200,-100},{200,100}}), graphics={
      Rectangle(
        extent={{-200,80},{200,40}},
        lineColor={0,0,0},
        fillPattern=FillPattern.Solid,
        fillColor={245,239,184},
        pattern=LinePattern.None)}));
end PartialChilledWaterPlant;
