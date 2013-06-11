within Buildings.Fluid.SolarCollectors.BaseClasses;
model PartialSolarCollector "Partial model for solar collectors"
 extends Buildings.Fluid.Interfaces.LumpedVolumeDeclarations;
  extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters(final dp_nominal = dp_nominal_final);
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    showDesignFlowDirection=false,
    final m_flow_nominal=perPar.mperA_flow_nominal*perPar.A,
    final show_T=true);
  parameter Integer nSeg(min=3) = 3
    "Number of segments used to discretize the collector model";

  parameter Modelica.SIunits.Angle lat "Latitude";
  parameter Modelica.SIunits.Angle azi "Surface azimuth";
  parameter Modelica.SIunits.Angle til "Surface tilt";
  parameter Real rho "Ground reflectance";
  // fixme: C must scale with the area.
  parameter Modelica.SIunits.HeatCapacity C=385*perPar.mDry
    "Heat capacity of solar collector without fluid (default: cp_copper*mDry)";

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
    "Total are of panels in the simulation"
    annotation(Dialog(group="Area declarations", enable=(nColType == Buildings.Fluid.SolarCollectors.Types.NumberSelection.Area)));

  parameter Buildings.Fluid.SolarCollectors.Types.SystemConfiguration sysConfig=
  Buildings.Fluid.SolarCollectors.Types.SystemConfiguration.Series
    "Selection of system configuration"
    annotation(Dialog(group="Configuration declarations"));

  Modelica.Blocks.Interfaces.RealInput shaCoe_in if use_shaCoe_in
    "Shading coefficient"
  annotation(Placement(transformation(extent={{-140,60},{-100,20}},   rotation=0)));

  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heaCap[nSeg](
    each C=C/nSeg,
    T(each start =   T_start)) if
       not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)
    "Heat capacity for one segment of the the solar collector"
    annotation (Placement(transformation(extent={{-40,-44},{-20,-24}})));

  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
                                                               annotation (Placement(
        transformation(extent={{-110,86},{-90,106}})));
  Buildings.BoundaryConditions.SolarIrradiation.DiffusePerez HDifTilIso(
    final outSkyCon=true,
    final outGroCon=true,
    final til=til,
    final lat=lat,
    final azi=azi,
    final rho=rho)       annotation (Placement(transformation(extent={{-80,72},{-60,92}})));

  Buildings.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil(
    final til=til,
    final lat=lat,
    final azi=azi) annotation (Placement(transformation(extent={{-80,46},{-60,66}})));

  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-80,-11},{-60,11}})));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM res(
    redeclare final package Medium = Medium,
    final from_dp=from_dp,
    final show_T=show_T,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=dp_nominal,
    final allowFlowReversal=allowFlowReversal,
    final show_V_flow=show_V_flow,
    final linearized=linearizeFlowResistance,
    final homotopyInitialization=homotopyInitialization,
    use_dh=false) "Flow resistance"
    annotation (Placement(transformation(extent={{-50,-10},
            {-30,10}}, rotation=0)));
    // fixme: V must scale with area, and it must be divided by nSeg
  Buildings.Fluid.MixingVolumes.MixingVolume vol[nSeg](
    each nPorts=2,
    redeclare package Medium = Medium,
    each final m_flow_nominal=m_flow_nominal,
    each final energyDynamics=energyDynamics,
    each final p_start=p_start,
    each final T_start=T_start,
    each final V=perPar.V/nSeg)
    "Volume of fluid in one segment of the solar collector"
    each m_flow_nominal=m_flow_nominal,
    each V=perPar.V,
    each energyDynamics=energyDynamics,
    each p_start=p_start,
    each T_start=T_start) "Medium volumes"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={48,-16})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSen[nSeg]
    "Temperature sensor"
          annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={6,-16})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow QLos[nSeg]
    annotation (Placement(transformation(extent={{38,20},{58,40}})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow heaGai[nSeg]
    annotation (Placement(transformation(extent={{38,60},{58,80}})));

protected
  parameter SolarCollectors.Data.GenericSolarCollector perPar
    "Partial performance data"
    annotation(choicesAllMatching=true);

    Modelica.Blocks.Interfaces.RealInput shaCoe_internal
    "Internally used shading coefficient";

    final parameter Modelica.SIunits.Pressure dp_nominal_final=
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

equation
  connect(shaCoe_internal,shaCoe_in);

  if not use_shaCoe_in then
    shaCoe_internal=shaCoe;
  end if;

  connect(weaBus, HDifTilIso.weaBus) annotation (Line(
      points={{-100,96},{-88,96},{-88,82},{-80,82}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaBus, HDirTil.weaBus) annotation (Line(
      points={{-100,96},{-88,96},{-88,56},{-80,56}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(port_a, senMasFlo.port_a) annotation (Line(
      points={{-100,0},{-80,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senMasFlo.port_b, res.port_a) annotation (Line(
      points={{-60,0},{-50,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heaCap.port, vol.heatPort) annotation (Line(
      points={{-30,-44},{30,-44},{30,-16},{38,-16}},
      color={191,0,0},
      smooth=Smooth.None));
      connect(vol[nSeg].ports[2], port_b) annotation (Line(
      points={{50,-6},{50,0},{100,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vol[1].ports[1], res.port_b) annotation (Line(
      points={{46,-6},{46,0},{-30,0}},
      color={0,127,255},
      smooth=Smooth.None));
      for i in 1:(nSeg - 1) loop
    connect(vol[i].ports[2], vol[i + 1].ports[1]);
  end for;
  connect(vol.heatPort, temSen.port)            annotation (Line(
      points={{38,-16},{16,-16}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(QLos.port, vol.heatPort)    annotation (Line(
      points={{58,30},{76,30},{76,-44},{30,-44},{30,-16},{38,-16}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heaGai.port, vol.heatPort)   annotation (Line(
      points={{58,70},{76,70},{76,-44},{30,-44},{30,-16},{38,-16}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),
            graphics),
    Icon(graphics),
    defaultComponentName="solCol",
    Documentation(info="<html>
<p>
This component is a partial model of a solar thermal collector. It can be expanded to create solar collector models based on either ASHRAE93 or EN12975
 ratings data.
</p>
<h4>Notice</h4>
<p>
1. As mentioned in the reference, the SRCC incident angle modifier equation coefficients are only valid for incident angles of 60 degrees or less.
 Because these curves behave poorly for angles greater than 60 degrees 
 the model does not calculatue either direct or diffuse solar radiation gains
 when the incidence angle is greater than 60 degrees. 
<br/>
2. By default, the estimated heat capacity of the collector without fluid is calculated based on the dry mass and the specific heat capacity of copper.
</p>
<h4>References</h4>
<p>
<a href=\"http://www.energyplus.gov\">EnergyPlus 7.0.0 Engineering Reference</a>, October 13, 2011.
</p>
</html>", revisions="<html>
<ul>
<li>
January 4, 2013, by Peter Grant:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialSolarCollector;
