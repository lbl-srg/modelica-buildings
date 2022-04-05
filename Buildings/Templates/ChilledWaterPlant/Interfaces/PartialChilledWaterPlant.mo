within Buildings.Templates.ChilledWaterPlant.Interfaces;
partial model PartialChilledWaterPlant

  replaceable package Medium = Buildings.Media.Water;

  parameter Buildings.Templates.ChilledWaterPlant.Components.Types.Configuration
    typ "Type of system"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

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

  inner parameter Boolean have_CHWDedPum
    "Set to true if parallel chillers are connected to dedicated pumps on chilled water side"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  inner parameter Boolean have_CWDedPum
    "Set to true if parallel chillers are connected to dedicated pumps on condenser water side"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  inner parameter Boolean have_secondary
    "= true if plant has secondary pumping"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  inner parameter Boolean have_WSE
    "=true if plant has waterside economizer"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  inner parameter Boolean is_series
    "= true if chillers are in series"
    annotation (Evaluate=true, Dialog(group="Configuration"));

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

protected
  final inner parameter Boolean isAirCoo=
    typ == Buildings.Templates.ChilledWaterPlant.Components.Types.Configuration.AirCooled
    "= true, chillers in group are air cooled, 
    = false, chillers in group are water cooled";

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
