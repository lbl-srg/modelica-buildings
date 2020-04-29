within Buildings.Fluid.SolarCollectors.BaseClasses;
model PartialSolarCollector "Partial model for solar collectors"
 extends Buildings.Fluid.Interfaces.LumpedVolumeDeclarations;
  extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters(final dp_nominal = dp_nominal_final);
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    final m_flow_nominal=perPar.mperA_flow_nominal*perPar.A);

  constant Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(HideResult=true);

  parameter Integer nSeg(min=3) = 3
    "Number of segments used to discretize the collector model";

  parameter Modelica.SIunits.Angle lat(displayUnit="deg") "Latitude";
  parameter Modelica.SIunits.Angle azi(displayUnit="deg")
    "Surface azimuth (0 for south-facing; -90 degree for east-facing; +90 degree for west facing";
  parameter Modelica.SIunits.Angle til(displayUnit="deg")
    "Surface tilt (0 for horizontally mounted collector)";
  parameter Real rho "Ground reflectance";
  parameter Modelica.SIunits.HeatCapacity C=385*perPar.mDry
    "Heat capacity of solar collector without fluid (default: cp_copper*mDry*nPanels)";

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

  parameter Modelica.SIunits.Area totalArea=0
    "Total area of panels in the simulation"
    annotation(Dialog(group="Area declarations", enable=(nColType == Buildings.Fluid.SolarCollectors.Types.NumberSelection.Area)));

  parameter Buildings.Fluid.SolarCollectors.Types.SystemConfiguration sysConfig=
  Buildings.Fluid.SolarCollectors.Types.SystemConfiguration.Series
    "Selection of system configuration"
    annotation(Dialog(group="Configuration declarations"));

  Modelica.Blocks.Interfaces.RealInput shaCoe_in if use_shaCoe_in
    "Shading coefficient"
    annotation(Placement(transformation(extent={{-140,46},{-100,6}})));

  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(
    transformation(extent={{-110,86},{-90,106}})));
  Buildings.BoundaryConditions.SolarIrradiation.DiffusePerez HDifTilIso(
    final outSkyCon=true,
    final outGroCon=true,
    final til=til,
    final lat=lat,
    final azi=azi,
    final rho=rho) "Diffuse solar irradiation on a tilted surface"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));

  Buildings.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil(
    final til=til,
    final lat=lat,
    final azi=azi) "Direct solar irradiation on a tilted surface"
    annotation (Placement(transformation(extent={{-80,42},{-60,62}})));

  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium =
    Medium, allowFlowReversal=allowFlowReversal) "Mass flow rate sensor"
    annotation (Placement(transformation(extent={{-86,-11},{-66,11}})));
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

  // The size of the liquid volume has been increased to also
  // add the heat capacity of the metal. See the info section
  // for an explanation.
  Buildings.Fluid.MixingVolumes.MixingVolume vol[nSeg](
    each nPorts=2,
    redeclare package Medium = Medium,
    each final m_flow_nominal=m_flow_nominal,
    each final energyDynamics=energyDynamics,
    each final p_start=p_start,
    each final T_start=T_start,
    each final m_flow_small=m_flow_small,
    each final V=(perPar.V+C/cp_default/rho_default)*nPanels_internal/nSeg,
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
        origin={48,-16})));

  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSen[nSeg]
    "Temperature sensor"
    annotation (Placement(transformation(
      extent={{-10,10},{10,-10}},
      rotation=180,
      origin={2,-16})));

  Buildings.HeatTransfer.Sources.PrescribedHeatFlow heaGai[nSeg]
    "Rate of solar heat gain"
    annotation (Placement(transformation(extent={{50,38},{70,58}})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow QLos[nSeg]
    "Rate of solar heat gain"
    annotation (Placement(transformation(extent={{50,6},{70,26}})));

protected
  parameter Buildings.Fluid.SolarCollectors.Data.GenericSolarCollector perPar
    "Partial performance data"
    annotation(choicesAllMatching=true);

    Modelica.Blocks.Interfaces.RealInput shaCoe_internal
    "Internally used shading coefficient";

    final parameter Modelica.SIunits.PressureDifference dp_nominal_final(displayUnit="Pa")=
    if sysConfig == Buildings.Fluid.SolarCollectors.Types.SystemConfiguration.Series then
       nPanels_internal*perPar.dp_nominal
    else
      perPar.dp_nominal "Nominal pressure loss across the system of collectors";

  parameter Modelica.SIunits.Area TotalArea_internal=
      nPanels_internal * perPar.A "Area used in the simulation";

  parameter Real nPanels_internal=
    if nColType == Buildings.Fluid.SolarCollectors.Types.NumberSelection.Number then
      nPanels
    else
      totalArea/perPar.A "Number of panels used in the simulation";

  parameter Medium.ThermodynamicState sta_default = Medium.setState_pTX(
    T=Medium.T_default,
    p=Medium.p_default,
    X=Medium.X_default[1:Medium.nXi]) "Medium state at default properties";
  parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
    Medium.specificHeatCapacityCp(sta_default)
    "Specific heat capacity of the fluid";
  parameter Modelica.SIunits.Density rho_default=
    Medium.density(sta_default) "Density, used to compute fluid mass";

initial equation
  assert(homotopyInitialization, "In " + getInstanceName() +
    ": The constant homotopyInitialization has been modified from its default value. This constant will be removed in future releases.",
    level = AssertionLevel.warning);

equation
  connect(shaCoe_internal,shaCoe_in);

  if not use_shaCoe_in then
    shaCoe_internal=shaCoe;
  end if;

  connect(weaBus, HDifTilIso.weaBus) annotation (Line(
      points={{-100,96},{-88,96},{-88,80},{-80,80}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaBus, HDirTil.weaBus) annotation (Line(
      points={{-100,96},{-88,96},{-88,52},{-80,52}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(port_a, senMasFlo.port_a) annotation (Line(
      points={{-100,4.44089e-16},{-90,4.44089e-16},{-90,0},{-86,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senMasFlo.port_b, res.port_a) annotation (Line(
      points={{-66,0},{-60,0}},
      color={0,127,255},
      smooth=Smooth.None));
      connect(vol[nSeg].ports[2], port_b) annotation (Line(
      points={{50,-6},{50,0},{94,0},{94,4.44089e-16},{100,4.44089e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vol[1].ports[1], res.port_b) annotation (Line(
      points={{46,-6},{46,0},{-40,0}},
      color={0,127,255},
      smooth=Smooth.None));
      for i in 1:(nSeg - 1) loop
    connect(vol[i].ports[2], vol[i + 1].ports[1]);
  end for;
  connect(vol.heatPort, temSen.port)            annotation (Line(
      points={{38,-16},{12,-16}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heaGai.port, vol.heatPort)   annotation (Line(
      points={{70,48},{92,48},{92,-44},{30,-44},{30,-16},{38,-16}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(QLos.port, vol.heatPort) annotation (Line(
      points={{70,16},{92,16},{92,-44},{30,-44},{30,-16},{38,-16}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (
    defaultComponentName="solCol",
    Documentation(info="<html>
<p>
This component is a partial model of a solar thermal collector. It can be
expanded to create solar collector models based on either ASHRAE93 or
EN12975 ratings data.
</p>
<h4>Notice</h4>
<p>
As mentioned in the reference, the SRCC incident angle modifier equation
coefficients are only valid for incident angles of 60 degrees or less.
Because these curves behave poorly for angles greater than 60 degrees
the model does not calculatue either direct or diffuse solar radiation gains
when the incidence angle is greater than 60 degrees.
</p>
<p>
The heat capacity of the collector without fluid is
estimated based on the dry mass and the specific heat capacity of copper.
This heat capacity is then added to the model by increasing the size of the fluid
volume. Note that in earlier implementations, there was a separate model to take into
account this heat capacity. However, this led to a translation error if glycol
was used as the medium, because during the translation, the function
<a href=\"modelica://Modelica.Media.Incompressible.Examples.Glycol47.T_ph\">
Modelica.Media.Incompressible.Examples.Glycol47.T_ph</a> had to be differentiated,
but this function is not differentiable.
</p>
<h4>References</h4>
<p>
<a href=\"http://www.energyplus.gov\">EnergyPlus 7.0.0 Engineering Reference</a>,
October 13, 2011.<br/>
CEN 2006, European Standard 12975-1:2006, European Committee for Standardization
</p>
</html>",
revisions="<html>
<ul>
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
