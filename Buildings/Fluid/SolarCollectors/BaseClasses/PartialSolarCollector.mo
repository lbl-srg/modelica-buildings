within Buildings.Fluid.SolarCollectors.BaseClasses;
partial model PartialSolarCollector "Partial model for solar collectors"
 extends Buildings.Fluid.Interfaces.LumpedVolumeDeclarations;
  extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters(
    final dp_nominal = dp_nominal_final,
    final computeFlowResistance=(abs(dp_nominal) > Modelica.Constants.eps));
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    final m_flow_nominal=m_flow_nominal_final);

  constant Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(HideResult=true);

  parameter Integer nSeg = 3
    "Number of segments used to discretize the collector model";

  parameter Modelica.Units.SI.Angle azi(displayUnit="deg")
    "Surface azimuth (0 for south-facing; -90 degree for east-facing; +90 degree for west facing";
  parameter Modelica.Units.SI.Angle til(displayUnit="deg")
    "Surface tilt (0 for horizontally mounted collector)";
  parameter Real rho(
    final min=0,
    final max=1,
    final unit = "1") "Ground reflectance";

  parameter Modelica.Units.SI.HeatCapacity CTot=
    if per.CTyp==Buildings.Fluid.SolarCollectors.Types.HeatCapacity.TotalCapacity then
      per.C
    elseif per.CTyp==Buildings.Fluid.SolarCollectors.Types.HeatCapacity.DryCapacity then
      per.C+rho_default*per.V*cp_default
    else
      385*per.mDry+rho_default*per.V*cp_default
    "Heat capacity of solar collector with fluid";

  parameter Boolean use_shaCoe_in = false
    "Enables an input connector for shaCoe"
    annotation(Dialog(group="Shading"));
  parameter Real shaCoe(
    min=0.0,
    max=1.0) = 0 "Shading coefficient. 0.0: no shading, 1.0: full shading"
    annotation(Dialog(enable = not use_shaCoe_in, group = "Shading"));

  parameter Buildings.Fluid.SolarCollectors.Types.NumberSelection nColType=
  Buildings.Fluid.SolarCollectors.Types.NumberSelection.Number
    "Selection of area specification format"
    annotation(Dialog(group="Area declarations"));
  parameter Integer nPanels= 0 "Desired number of panels in the simulation"
    annotation(Dialog(group="Area declarations", enable= (nColType == Buildings.Fluid.SolarCollectors.Types.NumberSelection.Number)));

  parameter Modelica.Units.SI.Area totalArea=0
    "Total area of panels in the simulation" annotation (Dialog(group=
          "Area declarations", enable=(nColType == Buildings.Fluid.SolarCollectors.Types.NumberSelection.Area)));

  parameter Buildings.Fluid.SolarCollectors.Types.SystemConfiguration sysConfig=
  Buildings.Fluid.SolarCollectors.Types.SystemConfiguration.Series
    "Selection of system configuration"
    annotation(Dialog(group="Configuration declarations"));
  parameter Integer nPanelsSer=0 "Number of array panels in series"
    annotation(Dialog(group="Configuration declarations", enable= (sysConfig == Buildings.Fluid.SolarCollectors.Types.SystemConfiguration.Array)));
  parameter Integer nPanelsPar=0 "Number of array panels in parallel"
    annotation(Dialog(group="Configuration declarations", enable= (sysConfig == Buildings.Fluid.SolarCollectors.Types.SystemConfiguration.Array)));

  Modelica.Blocks.Interfaces.RealInput shaCoe_in if use_shaCoe_in
    "Shading coefficient"
    annotation(Placement(transformation(extent={{-140,60},{-100,20}})));

  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(
    transformation(extent={{-110,70},{-90,90}})));
  Buildings.BoundaryConditions.SolarIrradiation.DiffusePerez HDifTilIso(
    final outSkyCon=true,
    final outGroCon=true,
    final til=til,
    final azi=azi,
    final rho=rho) "Diffuse solar irradiation on a tilted surface"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));

  Buildings.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil(
    final til=til,
    final azi=azi) "Direct solar irradiation on a tilted surface"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));

  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium =
    Medium, allowFlowReversal=allowFlowReversal) "Mass flow rate sensor"
    annotation (Placement(transformation(extent={{-90,-11},{-70,11}})));
  Buildings.Fluid.FixedResistances.PressureDrop res(
    redeclare final package Medium = Medium,
    final from_dp=from_dp,
    final show_T=show_T,
    final m_flow_nominal=m_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final linearized=linearizeFlowResistance,
    final homotopyInitialization=homotopyInitialization,
    deltaM=deltaM,
    final dp_nominal=dp_nominal_final) "Flow resistance"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

  // The size of the liquid volume has been increased to also add
  // the heat capacity of the metal.
  Buildings.Fluid.MixingVolumes.MixingVolume vol[nSeg](
    each nPorts=2,
    redeclare package Medium = Medium,
    each final m_flow_nominal=m_flow_nominal,
    each final energyDynamics=energyDynamics,
    each final p_start=p_start,
    each final T_start=T_start,
    each final m_flow_small=m_flow_small,
    each final V=CTot/cp_default/rho_default*nPanels_internal/nSeg,
    each final massDynamics=massDynamics,
    each final X_start=X_start,
    each final C_start=C_start,
    each final C_nominal=C_nominal,
    each final mSenFac=mSenFac,
    each final allowFlowReversal=allowFlowReversal,
    each final prescribedHeatFlowRate=false)
    "Volume of fluid in one segment of the solar collector"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={50,-20})));

  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSen[nSeg]
    "Temperature sensor"
    annotation (Placement(transformation(
      extent={{-10,10},{10,-10}},
      rotation=180,
      origin={0,-20})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow QGai[nSeg]
    "Rate of solar heat gain"
    annotation (Placement(transformation(extent={{50,40},{70,60}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow QLos[nSeg]
    "Rate of heat loss"
    annotation (Placement(transformation(extent={{50,10},{70,30}})));
  replaceable parameter Buildings.Fluid.SolarCollectors.Data.GenericASHRAE93 per
    constrainedby Buildings.Fluid.SolarCollectors.Data.BaseClasses.Generic
    "Performance data"
    annotation(Placement(transformation(extent={{60,-80},{80,-60}})),choicesAllMatching=true);

protected
  Modelica.Blocks.Interfaces.RealInput shaCoe_internal
    "Internally used shading coefficient";

  final parameter Modelica.Units.SI.MassFlowRate m_flow_nominal_final(
      displayUnit="kg/s") = nPanelsPar_internal*per.mperA_flow_nominal*per.A
    "Nominal mass flow rate through the system of collectors";

  final parameter Modelica.Units.SI.PressureDifference dp_nominal_final(
      displayUnit="Pa") = nPanelsSer_internal*per.dp_nominal
    "Nominal pressure loss across the system of collectors";

  parameter Modelica.Units.SI.Area ATot_internal=nPanels_internal*per.A
    "Area used in the simulation";

  parameter Real nPanels_internal=
    if nColType == Buildings.Fluid.SolarCollectors.Types.NumberSelection.Number then
      nPanels
    else
      totalArea/per.A "Number of panels used in the simulation";
  parameter Real nPanelsSer_internal=
    if sysConfig == Buildings.Fluid.SolarCollectors.Types.SystemConfiguration.Series then
      nPanels
    else if sysConfig == Buildings.Fluid.SolarCollectors.Types.SystemConfiguration.Parallel then
      1
    else
      nPanelsSer "Number of panels in series";
  parameter Real nPanelsPar_internal=
    if sysConfig == Buildings.Fluid.SolarCollectors.Types.SystemConfiguration.Parallel then
      nPanels
    else if sysConfig == Buildings.Fluid.SolarCollectors.Types.SystemConfiguration.Series then
      1
    else
      nPanelsPar "Number of panels in parallel";

  parameter Medium.ThermodynamicState sta_default = Medium.setState_pTX(
    T=Medium.T_default,
    p=Medium.p_default,
    X=Medium.X_default[1:Medium.nXi]) "Medium state at default properties";
  parameter Modelica.Units.SI.SpecificHeatCapacity cp_default=
      Medium.specificHeatCapacityCp(sta_default)
    "Specific heat capacity of the fluid";
  parameter Modelica.Units.SI.Density rho_default=Medium.density(sta_default)
    "Density, used to compute fluid mass";

initial equation
  assert(homotopyInitialization, "In " + getInstanceName() +
    ": The constant homotopyInitialization has been modified from its default value. This constant will be removed in future releases.",
    level = AssertionLevel.warning);

  if sysConfig==Buildings.Fluid.SolarCollectors.Types.SystemConfiguration.Array then
    assert(abs(nPanelsPar_internal*nPanelsSer_internal-nPanels_internal) < 1E-6,
      "In " + getInstanceName() +
      ": The product of the number of panels in series and parallel is not equal to the total number of panels in the array.",
      level = AssertionLevel.error);
  end if;

equation
  connect(shaCoe_internal,shaCoe_in);

  if not use_shaCoe_in then
    shaCoe_internal=shaCoe;
  end if;

  connect(weaBus, HDifTilIso.weaBus) annotation (Line(
      points={{-100,80},{-80,80}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaBus, HDirTil.weaBus) annotation (Line(
      points={{-100,80},{-90,80},{-90,50},{-80,50}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(port_a, senMasFlo.port_a) annotation (Line(
      points={{-100,0},{-90,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senMasFlo.port_b, res.port_a) annotation (Line(
      points={{-70,0},{-60,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vol[nSeg].ports[2], port_b) annotation (Line(
      points={{51,-10},{51,0},{100,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vol[1].ports[1], res.port_b) annotation (Line(
      points={{49,-10},{49,0},{-40,0}},
      color={0,127,255},
      smooth=Smooth.None));
      for i in 1:(nSeg - 1) loop
    connect(vol[i].ports[2], vol[i + 1].ports[1]);
  end for;
  connect(vol.heatPort, temSen.port)            annotation (Line(
      points={{40,-20},{10,-20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(QGai.port, vol.heatPort) annotation (Line(
      points={{70,50},{90,50},{90,-40},{30,-40},{30,-20},{40,-20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(QLos.port, vol.heatPort) annotation (Line(
      points={{70,20},{90,20},{90,-40},{30,-40},{30,-20},{40,-20}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (
    defaultComponentName="solCol",
    Documentation(info="<html>
<p>
This component is a partial model of a solar thermal collector.
It can be expanded to create solar collector models based on either ASHRAE93 or
EN12975 ratings data.
</p>

<h4>References</h4>
<p>
<a href=\"https://energyplus.net/assets/nrel_custom/pdfs/pdfs_v23.2.0/EngineeringReference.pdf\">
EnergyPlus 23.2.0 Engineering Reference</a>
</p>
</html>", revisions="<html>
<ul>
<li>
February 27, 2024, by Jelger Jansen:<br/>
Refactor model.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3604\">Buildings, #3604</a>.
</li>
<li>
December 11, 2023, by Michael Wetter:<br/>
Corrected implementation of pressure drop calculation for the situation where the collectors are in parallel,
e.g., if <code>sysConfig == Buildings.Fluid.SolarCollectors.Types.SystemConfiguration.Parallel</code>.<br/>
Changed assignment of <code>computeFlowResistance</code> to <code>final</code> based on
<code>dp_nominal</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3597\">Buildings, #3597</a>.
</li>
<li>
September 16, 2021, by Michael Wetter:<br/>
Changed <code>lat</code> from being a parameter to an input from weather bus.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1477\">IBPSA, #1477</a>.
</li>
<li>
April 14, 2020, by Michael Wetter:<br/>
Changed <code>homotopyInitialization</code> to a constant.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1341\">IBPSA, #1341</a>.
</li>
<li>
November 12, 2019, by Filip Jorissen:<br/>
Set <code>prescribedHeatFlowRate=false</code>
to avoid a division by zero at zero flow when using SteadyState dynamics.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1636\">Buildings, issue 1636</a>.
</li>
<li>
April 27, 2018, by Michael Wetter:<br/>
Corrected <code>displayUnit</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/912\">Buildings, issue 912</a>.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
February 8, 2015, by Filip Jorissen:<br/>
Propagated multiple parameters from <code>LumpedVolumeDeclarations</code>,
set <code>prescribedHeatFlowRate = true</code> in <code>vol</code>.
</li>
<li>
September 18, 2014, by Michael Wetter:<br/>
Removed the separate instance of
<code>Modelica.Thermal.HeatTransfer.Components.HeatCapacitor</code> and
added this capacity to the volume.
This is in response to
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/276\">
https://github.com/lbl-srg/modelica-buildings/issues/276</a>.
</li>
<li>
June 25, 2014, by Michael Wetter:<br/>
Improved comments for tilt to address
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/246\">
https://github.com/lbl-srg/modelica-buildings/issues/246</a>.
</li>
<li>
October 8, 2013, by Michael Wetter:<br/>
Removed parameter <code>show_V_flow</code> in declaration of instance <code>res</code>.
</li>
<li>
January 4, 2013, by Peter Grant:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialSolarCollector;
