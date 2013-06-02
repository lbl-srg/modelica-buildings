within Buildings.Fluid.SolarCollectors.BaseClasses;
model PartialSolarCollector "Partial model for solar collectors"
 extends Buildings.Fluid.Interfaces.LumpedVolumeDeclarations;
 // fixme: the assignment dp_nominal=perPar.dp_nominal is wrong. perPar has the static pressure
  extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters(dp_nominal = perPar.dp_nominal);
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    showDesignFlowDirection=false,
    m_flow_nominal=perPar.mperA_flow_nominal*perPar.A,
    final show_T=true);
  parameter Integer nSeg(min=3) = 3
    "Number of segments used to discretize the collector model";

  parameter Modelica.SIunits.Angle lat "Latitude";
  parameter Modelica.SIunits.Angle azi "Surface azimuth";
  parameter Modelica.SIunits.Angle til "Surface tilt";
  // fixme: C must scale with the area.
  parameter Modelica.SIunits.HeatCapacity C=385*perPar.mDry
    "Heat capacity of solar collector without fluid (cp_copper*mDry)";
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heaCap[nSeg](each C=C/
        nSeg) if
     not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)
    "Heat capacity for one segment of the the solar collector"
    annotation (Placement(transformation(extent={{-40,-44},{-20,-24}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
                                                               annotation (Placement(
        transformation(extent={{-110,68},{-90,88}}), iconTransformation(extent=
            {{16,90},{36,110}})));
  Buildings.BoundaryConditions.SolarIrradiation.DiffusePerez HDifTilIso(
    final outSkyCon=true,
    final outGroCon=true,
    final til=til,
    final lat=lat,
    final azi=azi) annotation (Placement(transformation(extent={{-80,72},{-60,92}})));
  Buildings.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil(
    til=til,
    lat=lat,
    azi=azi) annotation (Placement(transformation(extent={{-80,46},{-60,66}})));
  parameter Modelica.SIunits.Temperature TEnv_nominal "Outside air temperature"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Irradiance G_nominal
    "Irradiance at nominal condition"
    annotation(Dialog(group="Nominal condition"));

protected
  parameter SolarCollectors.Data.GenericSolarCollector perPar
    "Partial performance data"
    annotation(choicesAllMatching=true);

public
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
equation
  connect(weaBus, HDifTilIso.weaBus) annotation (Line(
      points={{-100,78},{-88,78},{-88,82},{-80,82}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaBus, HDirTil.weaBus) annotation (Line(
      points={{-100,78},{-88,78},{-88,56},{-80,56}},
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
    Diagram(graphics),
    Icon(graphics={
        Rectangle(
          extent={{-86,100},{88,-100}},
          lineColor={215,215,215},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-10,80},{10,-100}},
          lineColor={215,215,215},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{30,80},{50,-100}},
          lineColor={215,215,215},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-50,80},{-28,-100}},
          lineColor={215,215,215},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,100},{60,80}},
          lineColor={215,215,215},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-24,28},{28,-24}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-48,2},{-28,2}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=1),
        Line(
          points={{34,2},{54,2}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=1),
        Line(
          points={{-8,-8},{6,6}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=1,
          origin={30,34},
          rotation=180),
        Line(
          points={{-34,-38},{-18,-22}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=1),
        Line(
          points={{-8,-8},{6,6}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=1,
          origin={32,-28},
          rotation=90),
        Line(
          points={{-6,-6},{8,8}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=1,
          origin={-22,32},
          rotation=90),
        Line(
          points={{-10,0},{10,0}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=1,
          origin={4,-38},
          rotation=90),
        Line(
          points={{-10,0},{10,0}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=1,
          origin={2,42},
          rotation=90)}),
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
