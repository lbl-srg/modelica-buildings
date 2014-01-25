within Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses;
model HexInternalElement "Internal part of a borehole"
  extends Buildings.Fluid.Interfaces.FourPortHeatMassExchanger(
    redeclare final package Medium1 = Medium,
    redeclare final package Medium2 = Medium,
    T1_start=TFil_start,
    T2_start=TFil_start,
    final tau1=Modelica.Constants.pi*rTub^2*hSeg*rho1_nominal/m1_flow_nominal,
    final tau2=Modelica.Constants.pi*rTub^2*hSeg*rho2_nominal/m2_flow_nominal,
    final show_T=true,
    vol1(final energyDynamics=energyDynamics,
         final massDynamics=massDynamics,
         final prescribedHeatFlowRate=false,
         final homotopyInitialization=homotopyInitialization,
         final allowFlowReversal=allowFlowReversal1,
         final V=m2_flow_nominal*tau2/rho2_nominal,
         final m_flow_small=m1_flow_small),
    final vol2(final energyDynamics=energyDynamics,
         final massDynamics=massDynamics,
         final prescribedHeatFlowRate=false,
         final homotopyInitialization=homotopyInitialization,
         final V=m1_flow_nominal*tau1/rho1_nominal,
         final m_flow_small=m2_flow_small));

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium in the component" annotation (choicesAllMatching=true);

  replaceable parameter Buildings.HeatTransfer.Data.BoreholeFillings.Generic matFil
    "Thermal properties of the filling material"
    annotation (choicesAllMatching=true, Dialog(group="Filling material"),
                Placement(transformation(extent={{34,74},{54,94}})));
  replaceable parameter Buildings.HeatTransfer.Data.Soil.Generic matSoi
    "Thermal properties of soil"
    annotation (choicesAllMatching=true, Dialog(group="Soil"),
    Placement(transformation(extent={{66,74},{86,94}})));

  parameter Modelica.SIunits.Radius rTub=0.02 "Radius of the tubes"
    annotation (Dialog(group="Pipes"));
  parameter Modelica.SIunits.ThermalConductivity kTub=0.5
    "Thermal conductivity of the tubes" annotation (Dialog(group="Pipes"));
  parameter Modelica.SIunits.Length eTub=0.002 "Thickness of the tubes"
    annotation (Dialog(group="Pipes"));
  parameter Modelica.SIunits.ThermalConductivity kSoi
    "Thermal conductivity of the soil used for the calculation of the internal interference resistance";

  parameter Modelica.SIunits.Temperature TFil_start=283.15
    "Initial temperature of the filling material"
    annotation (Dialog(group="Filling material"));

  parameter Modelica.SIunits.Radius rBor "Radius of the borehole";
  parameter Modelica.SIunits.Height hSeg "Height of the element";

  parameter Real B0=17.44268 "Shape coefficient for grout resistance";
  parameter Real B1=-0.60515 "Shape coefficient for grout resistance";

  parameter Modelica.SIunits.Length xC=0.05
    "Shank spacing definied as half the center-to-center distance between the two pipes";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port
    "Heat port that connects to filling material"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  HeatTransfer.Windows.BaseClasses.ThermalConductor           RConv1(G=1)
    annotation (Placement(transformation(extent={{-82,16},{-58,40}})));
  HeatTransfer.Windows.BaseClasses.ThermalConductor           RConv2(G=1)
    annotation (Placement(transformation(extent={{-80,-40},{-56,-16}})));
  HeatTransfer.Windows.BaseClasses.ThermalConductor           Rpg1(G=1)
    annotation (Placement(transformation(extent={{-50,16},{-26,40}})));
  HeatTransfer.Windows.BaseClasses.ThermalConductor           Rpg2(G=1)
    annotation (Placement(transformation(extent={{-48,-40},{-24,-16}})));
  HeatTransfer.Windows.BaseClasses.ThermalConductor           Rgb1(G=1)
    annotation (Placement(transformation(extent={{52,26},{76,50}})));
  HeatTransfer.Windows.BaseClasses.ThermalConductor           Rgb2(G=1)
    annotation (Placement(transformation(extent={{52,-40},{76,-16}})));
  HeatTransfer.Windows.BaseClasses.ThermalConductor           Rgg(G=1)
    annotation (Placement(transformation(extent={{-12,-12},{12,12}},
        rotation=-90,
        origin={20,2})));

  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor capFil1(C=Co_fil/2, T(
        start=TFil_start)) "Heat capacity of the filling material" annotation (
      Placement(transformation(
        extent={{-90,36},{-70,16}},
        rotation=0,
        origin={72,2})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor capFil2(C=Co_fil/2, T(
        start=TFil_start)) "Heat capacity of the filling material" annotation (
      Placement(transformation(
        extent={{-90,-36},{-70,-16}},
        rotation=0,
        origin={72,8})));

protected
  final parameter Modelica.SIunits.SpecificHeatCapacity cpFil=matFil.c
    "Specific heat capacity of the filling material";
  final parameter Modelica.SIunits.ThermalConductivity kFil=matFil.k
    "Thermal conductivity of the filling material";
  final parameter Modelica.SIunits.Density dFil=matFil.d
    "Density of the filling material";
  parameter Modelica.SIunits.HeatCapacity Co_fil=dFil*cpFil*hSeg*Modelica.Constants.pi
      *(rBor^2 - 2*(rTub + eTub)^2) "Heat capacity of the filling material";
  parameter Modelica.SIunits.SpecificHeatCapacity cpFluid=
      Medium.specificHeatCapacityCp(Medium.setState_pTX(
      Medium.p_default,
      Medium.T_default,
      Medium.X_default)) "Specific heat capacity of the fluid";
  parameter Modelica.SIunits.ThermalConductivity kMed=
      Medium.thermalConductivity(Medium.setState_pTX(
      Medium.p_default,
      Medium.T_default,
      Medium.X_default)) "Thermal conductivity of the fluid";
  parameter Modelica.SIunits.DynamicViscosity mueMed=Medium.dynamicViscosity(
      Medium.setState_pTX(
      Medium.p_default,
      Medium.T_default,
      Medium.X_default)) "Dynamic viscosity of the fluid";
  parameter Real Rgb_val(fixed=false);
  parameter Real Rgg_val(fixed=false);
  parameter Real RCondGro_val(fixed=false);
  parameter Real x(fixed=false);
  parameter Real i(fixed=false);

initial equation
  (Rgb_val,Rgg_val,RCondGro_val,x,i) =
    singleUTubeResistances(
    hSeg=hSeg,
    rBor=rBor,
    rTub=rTub,
    eTub=eTub,
    sha=xC,
    kFil=matFil.k,
    kTub=kTub,
    kSoi=matSoi.k,
    kMed=kMed,
    mueMed=mueMed,
    cpFluid=cpFluid,
    m1_flow=m1_flow_nominal,
    m2_flow=m2_flow_nominal,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal);

equation
  Rpg2.u = 1/RCondGro_val;
  Rpg1.u = 1/RCondGro_val;
  Rgb1.u = 1/Rgb_val;
  Rgb2.u = 1/Rgb_val;
  Rgg.u = 1/Rgg_val;

  RConv1.u = 1/convectionResistance(
    hSeg=hSeg,
    rBor=rBor,
    rTub=rTub,
    kMed=kMed,
    mueMed=mueMed,
    cpFluid=cpFluid,
    m_flow=m1_flow,
    m_flow_nominal=m1_flow_nominal);
  RConv2.u = 1/convectionResistance(
    hSeg=hSeg,
    rBor=rBor,
    rTub=rTub,
    kMed=kMed,
    mueMed=mueMed,
    cpFluid=cpFluid,
    m_flow=m2_flow,
    m_flow_nominal=m2_flow_nominal);

  connect(vol1.heatPort, RConv1.port_a) annotation (Line(
      points={{-10,60},{-60,60},{-60,50},{-90,50},{-90,28},{-82,28}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(RConv1.port_b, Rpg1.port_a) annotation (Line(
      points={{-58,28},{-50,28}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Rpg1.port_b, capFil1.port) annotation (Line(
      points={{-26,28},{-20,28},{-20,38},{-8,38}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(capFil1.port, Rgb1.port_a) annotation (Line(
      points={{-8,38},{52,38}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(capFil1.port, Rgg.port_a) annotation (Line(
      points={{-8,38},{20,38},{20,14}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Rgb1.port_b, port) annotation (Line(
      points={{76,38},{86,38},{86,0},{100,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(RConv2.port_b, Rpg2.port_a) annotation (Line(
      points={{-56,-28},{-48,-28}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Rpg2.port_b, capFil2.port) annotation (Line(
      points={{-24,-28},{-8,-28}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(RConv2.port_a, vol2.heatPort) annotation (Line(
      points={{-80,-28},{-86,-28},{-86,-46},{20,-46},{20,-60},{12,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(capFil2.port, Rgb2.port_a) annotation (Line(
      points={{-8,-28},{52,-28}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Rgg.port_b, capFil2.port) annotation (Line(
      points={{20,-10},{20,-28},{-8,-28}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Rgb2.port_b, port) annotation (Line(
      points={{76,-28},{86,-28},{86,0},{100,0}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (
    Icon(graphics={Rectangle(
          extent={{88,54},{-88,64}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid), Rectangle(
          extent={{88,-66},{-88,-56}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>Model for the heat transfer between the fluid and within the borehole filling. This model computes the dynamic response of the fluid in the tubes, and the heat transfer between the fluid and the borehole filling, and the heat storage within the fluid and the borehole filling. </p>
<p>This model computes the different thermal resistances present in a single-U-tube borehole using the method of Bauer et al. [1] and computing explicitely the <i>fluid-to-ground</i> thermal resistance <i>Rb</i> and the <i>grout-to-grout </i>resistance <i>Ra</i> as defined by Hellstroem [2] using the multipole method (BaseClasses.singleUTubeResistances). The convection resistance is calculated using the Dittus-Boelter correlation (see BaseClasses.convectionResistance).</p>
<p>The following figure shows the thermal network set up by Bauer et al. [1]</p>
<p><img src=\"modelica://DaPModels/HeatHX/Boreholes/BaseClasses/Documentation/Bauer_singleUTube_small.PNG\"/></p>
<p><h4>References</h4></p>
<p>[1] G. Hellstr&ouml;m. <i>Ground heat storage: thermal analyses of duct storage systems (Theory)</i>. Dep. of Mathematical Physics, University of Lund, Sweden, 1991.</p>
<p>[2] D. Bauer, W. Heidemann, H. M&uuml;ller-Steinhagen, and H.-J. G. Diersch. <i>Thermal resistance and capacity models for borehole heat exchangers</i>. INTERNATIONAL JOURNAL OF ENERGY RESEARCH, 35:312&ndash;320, 2010.</p>
</html>", revisions="<html>
<p><ul>
<li>January 2014, Damien Picard<br/><i>First implementation</i></li>
</ul></p>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics));
end HexInternalElement;
