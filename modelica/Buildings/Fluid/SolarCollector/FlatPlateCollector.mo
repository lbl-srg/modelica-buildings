within Buildings.Fluid.SolarCollector;
model FlatPlateCollector "Model of a flat plate solar thermal collector"
  extends Buildings.Fluid.Interfaces.LumpedVolumeDeclarations;
  extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters(dp_nominal=
       per.dp_nominal);
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    m_flow_nominal=rho*per.VperA_flow_nominal*per.AGro,
    showDesignFlowDirection=false,
    final show_T=true);

  parameter Buildings.Fluid.SolarCollector.Data.GlazedFlatPlate.Generic per
    "Performance data" annotation (choicesAllMatching=true);

  parameter Modelica.SIunits.Angle lat "Latitude";
  parameter Modelica.SIunits.Angle azi "Surface azimuth";
  parameter Modelica.SIunits.Angle til "Surface tilt";
  parameter Modelica.SIunits.HeatCapacity C=385*per.mDry
    "Heat capacity of solar collector without fluid (cp_copper*mDry)";
  parameter Real shaCoe(
    min=0.0,
    max=1.0) = 0 "shading coefficient 0.0: no shading, 1.0: full shading";
  //   parameter Modelica.SIunits.MassFlowRate m_flow_nominal=rho*per.VperA_flow_nominal
  //       *per.AGro "Nominal mass flow rate"
  //     annotation (Dialog(group="Nominal condition"));

  Buildings.Fluid.FixedResistances.FixedResistanceDpM res(
    redeclare package Medium = Medium,
    from_dp=true,
    use_dh=true,
    show_T=true,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal,
    dh=0.1) annotation (Placement(transformation(extent={{-70,-10},{-50,10}},
          rotation=0)));
  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    V=if per.V > 0 then per.V else V_small,
    nPorts=2,
    m_flow_nominal=m_flow_nominal,
    prescribedHeatFlowRate=true,
    p_start=p_start,
    T_start=T_start) "Volume for pipe fluid" annotation (Placement(
        transformation(extent={{41,-20},{61,-40}},rotation=0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatport_a annotation (
      Placement(transformation(extent={{-110,30},{-90,50}}), iconTransformation(
          extent={{-106,10},{-86,30}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heatport_b annotation (
      Placement(transformation(extent={{90,30},{110,50}}),iconTransformation(
          extent={{90,10},{110,30}})));

  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heaCap(each C=C)
    "Heat capacity for one segment of the the solar collector"
    annotation (Placement(transformation(extent={{16,-24},{36,-4}})));
  BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
        transformation(extent={{-110,-50},{-90,-30}}), iconTransformation(
          extent={{16,90},{36,110}})));
  BoundaryConditions.SolarIrradiation.DiffuseIsotropic HDifTilIso(
    outSkyCon=true,
    outGroCon=true,
    til=til)
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil(
    til=til,
    lat=lat,
    azi=azi)
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Fluid.SolarCollector.BaseClasses.FlatPlateSolarGain solHeaGai(
    A=per.AGro,
    B0=per.B0,
    B1=per.B1,
    C0=per.C0,
    C1=per.C1,
    C2=per.C2,
    shaCoe=shaCoe,
    til=til)
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=vol.heatPort.T)
    annotation (Placement(transformation(extent={{-80,-104},{-60,-84}})));
  HeatTransfer.Sources.PrescribedHeatFlow preHeaFloCon
    "Prescribed heat flow rate"
    annotation (Placement(transformation(extent={{-11,-60},{9,-40}})));
protected
  parameter Modelica.SIunits.Volume V_small=0.001;
  parameter Medium.ThermodynamicState sta_nominal=Medium.setState_pTX(
      T=Medium.T_default,
      p=Medium.p_default,
      X=Medium.X_default);
  parameter Modelica.SIunits.Density rho=Medium.density(sta_nominal)
    "Density, used to compute mass flow rate";

equation
  connect(heatport_a, heatport_a) annotation (Line(
      points={{-100,40},{-100,40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heaCap.port, vol.heatPort) annotation (Line(
      points={{26,-24},{26,-30},{41,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatport_a, vol.heatPort) annotation (Line(
      points={{-100,40},{12,40},{12,-30},{41,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatport_b, vol.heatPort) annotation (Line(
      points={{100,40},{12,40},{12,-30},{41,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(res.port_b, vol.ports[1]) annotation (Line(
      points={{-50,6.10623e-16},{-22,6.10623e-16},{-22,0},{49,0},{49,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(HDifTilIso.HSkyDifTil, solHeaGai.HSkyDifTil) annotation (Line(
      points={{-59,-24},{-50,-24},{-50,-42},{-42,-42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDifTilIso.HGroDifTil, solHeaGai.HGroDifTil) annotation (Line(
      points={{-59,-36},{-54,-36},{-54,-45.2},{-42,-45.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDirTil.H, solHeaGai.HDirTil) annotation (Line(
      points={{-59,-70},{-54,-70},{-54,-48},{-42,-48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDirTil.inc, solHeaGai.incAng) annotation (Line(
      points={{-59,-74},{-50,-74},{-50,-54},{-42,-54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaBus, HDifTilIso.weaBus) annotation (Line(
      points={{-100,-40},{-88,-40},{-88,-30},{-80,-30}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus, HDirTil.weaBus) annotation (Line(
      points={{-100,-40},{-88,-40},{-88,-70},{-80,-70}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.TDryBul, solHeaGai.TEnv) annotation (Line(
      points={{-100,-40},{-88,-40},{-88,-84},{-48,-84},{-48,-57},{-42,-57}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(realExpression.y, solHeaGai.T) annotation (Line(
      points={{-59,-94},{-46,-94},{-46,-60},{-42,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solHeaGai.Q, preHeaFloCon.Q_flow) annotation (Line(
      points={{-19,-50},{-11,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preHeaFloCon.port, vol.heatPort) annotation (Line(
      points={{9,-50},{26,-50},{26,-30},{41,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(port_a, res.port_a) annotation (Line(
      points={{-100,5.55112e-16},{-85,5.55112e-16},{-85,6.10623e-16},{-70,
          6.10623e-16}},
      color={0,127,255},
      smooth=Smooth.None));

  connect(vol.ports[2], port_b) annotation (Line(
      points={{53,-20},{52,-20},{52,5.55112e-16},{100,5.55112e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
    Diagram(graphics),
    Icon(graphics={
        Text(
          extent={{-88,-104},{86,-128}},
          lineColor={0,0,255},
          textString="%name"),
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
<h4>Overview</h4>
<p>
This component models the flat plate solar thermal collector. 
</p>
<h4>Notice</h4>
<p>
1. As metioned in the reference, the SRCC incident angle modifier equation coefficients are only valid for incident angles of 60 degree or less. 
Because these curves can be valid yet behavor poorly for angles greater than 60 degree, the model cuts off collectors' gains of both direct and diffuse solar radiation for incident angles greater than 60 degrees. 
<br>
2. By default, the esitimated heat capacity of the collector without fluid is calculated based on the dry mass and the specific heat capacity of copper.
<h4>References</h4>
<p>
<a href=\"http://www.energyplus.gov\">EnergyPlus 7.0.0 Engineering Reference</a>, October 13, 2011.
</p>
</html>", revisions="<html>
<ul>
<li>
June 8, 2012, by Wangda Zuo:<br>
First implementation.
</li>
</ul>
</html>"));
end FlatPlateCollector;
