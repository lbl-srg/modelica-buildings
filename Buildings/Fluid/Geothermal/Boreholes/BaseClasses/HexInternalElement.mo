within Buildings.Fluid.Geothermal.Boreholes.BaseClasses;
model HexInternalElement "Internal part of a borehole"
  extends Buildings.Fluid.Interfaces.FourPortHeatMassExchanger(
    redeclare final package Medium1 = Medium,
    redeclare final package Medium2 = Medium,
    T1_start=TFil_start,
    T2_start=TFil_start,
    final tau1=Modelica.Constants.pi*rTub^2*hSeg*rho1_nominal/m1_flow_nominal,
    final tau2=Modelica.Constants.pi*rTub^2*hSeg*rho2_nominal/m2_flow_nominal,
    vol1(final energyDynamics=energyDynamics,
         final massDynamics=energyDynamics,
         final prescribedHeatFlowRate=false,
         final V=m2_flow_nominal*tau2/rho2_nominal,
         final m_flow_small=m1_flow_small),
    final vol2(final energyDynamics=energyDynamics,
         final massDynamics=energyDynamics,
         final prescribedHeatFlowRate=false,
         final V=m1_flow_nominal*tau1/rho1_nominal,
         final m_flow_small=m2_flow_small));

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium in the component" annotation (choicesAllMatching=true);

  replaceable parameter Buildings.HeatTransfer.Data.BoreholeFillings.Generic
    matFil "Thermal properties of the filling material"
    annotation (choicesAllMatching=true, Dialog(group="Filling material"),
                Placement(transformation(extent={{34,74},{54,94}})));
  replaceable parameter Buildings.HeatTransfer.Data.Soil.Generic matSoi
    "Thermal properties of soil"
    annotation (choicesAllMatching=true, Dialog(group="Soil"),
    Placement(transformation(extent={{66,74},{86,94}})));

  parameter Modelica.Units.SI.Radius rTub=0.02 "Radius of the tubes"
    annotation (Dialog(group="Pipes"));
  parameter Modelica.Units.SI.ThermalConductivity kTub=0.5
    "Thermal conductivity of the tubes" annotation (Dialog(group="Pipes"));
  parameter Modelica.Units.SI.Length eTub=0.002 "Thickness of the tubes"
    annotation (Dialog(group="Pipes"));
  parameter Modelica.Units.SI.ThermalConductivity kSoi
    "Thermal conductivity of the soil used for the calculation of the internal interference resistance";

  parameter Modelica.Units.SI.Temperature TFil_start=283.15
    "Initial temperature of the filling material"
    annotation (Dialog(group="Filling material"));

  parameter Modelica.Units.SI.Height hSeg "Height of the element";
  parameter Modelica.Units.SI.Radius rBor "Radius of the borehole";

  parameter Modelica.Units.SI.Length xC=0.05
    "Shank spacing, defined as half the center-to-center distance between the two pipes";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port
    "Heat port that connects to filling material"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor capFil1(
    final C=Co_fil/2,
    T(final start=TFil_start,
      fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial)),
    der_T(fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial)))
    "Heat capacity of the filling material"  annotation (
      Placement(transformation(
        extent={{-90,36},{-70,16}},
        origin={72,2})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor capFil2(
    final C=Co_fil/2,
    T(final start=TFil_start,
      fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial)),
    der_T(fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial)))
    "Heat capacity of the filling material" annotation (
      Placement(transformation(
        extent={{-90,-36},{-70,-16}},
        origin={72,8})));

protected
  final parameter Modelica.Units.SI.SpecificHeatCapacity cpFil=matFil.c
    "Specific heat capacity of the filling material";
  final parameter Modelica.Units.SI.ThermalConductivity kFil=matFil.k
    "Thermal conductivity of the filling material";
  final parameter Modelica.Units.SI.Density dFil=matFil.d
    "Density of the filling material";
  parameter Modelica.Units.SI.HeatCapacity Co_fil=dFil*cpFil*hSeg*Modelica.Constants.pi
      *(rBor^2 - 2*(rTub + eTub)^2) "Heat capacity of the filling material";
  parameter Modelica.Units.SI.SpecificHeatCapacity cpMed=
      Medium.specificHeatCapacityCp(Medium.setState_pTX(
      Medium.p_default,
      Medium.T_default,
      Medium.X_default)) "Specific heat capacity of the fluid";
  parameter Modelica.Units.SI.ThermalConductivity kMed=
      Medium.thermalConductivity(Medium.setState_pTX(
      Medium.p_default,
      Medium.T_default,
      Medium.X_default)) "Thermal conductivity of the fluid";
  parameter Modelica.Units.SI.DynamicViscosity mueMed=Medium.dynamicViscosity(
      Medium.setState_pTX(
      Medium.p_default,
      Medium.T_default,
      Medium.X_default)) "Dynamic viscosity of the fluid";
  parameter Modelica.Units.SI.ThermalResistance Rgb_val(fixed=false)
    "Thermal resistance between grout zone and borehole wall";
  parameter Modelica.Units.SI.ThermalResistance Rgg_val(fixed=false)
    "Thermal resistance between the two grout zones";
  parameter Modelica.Units.SI.ThermalResistance RCondGro_val(fixed=false)
    "Thermal resistance of the pipe wall";
  parameter Real x(fixed=false) "Capacity location";

  Modelica.Thermal.HeatTransfer.Components.ConvectiveResistor RConv1
    "Pipe convective resistance"
    annotation (Placement(transformation(extent={{-58,40},{-82,16}})));
  Modelica.Thermal.HeatTransfer.Components.ConvectiveResistor RConv2
    "Pipe convective resistance"
    annotation (Placement(transformation(extent={{-56,-40},{-80,-16}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rpg1(
    final R=RCondGro_val) "Grout thermal resistance"
    annotation (Placement(transformation(extent={{-50,16},{-26,40}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rpg2(
    final R=RCondGro_val) "Grout thermal resistance"
    annotation (Placement(transformation(extent={{-48,-40},{-24,-16}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgb1(
    final R=Rgb_val) "Grout thermal resistance"
    annotation (Placement(transformation(extent={{52,26},{76,50}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgb2(
    final R=Rgb_val) "Grout thermal resistance"
    annotation (Placement(transformation(extent={{52,-40},{76,-16}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgg(
    final R=Rgg_val) "Grout thermal resistance"
    annotation (Placement(transformation(extent={{-12,-12},{12,12}},
        rotation=-90,
        origin={20,2})));
  Modelica.Blocks.Sources.RealExpression RVol1(y=
    convectionResistance(
      hSeg=hSeg,
      rTub=rTub,
      kMed=kMed,
      mueMed=mueMed,
      cpMed=cpMed,
      m_flow=m1_flow,
      m_flow_nominal=m1_flow_nominal))
    "Convective and thermal resistance at fluid 1"
    annotation (Placement(transformation(extent={{-100,-2},{-80,18}})));
  Modelica.Blocks.Sources.RealExpression RVol2(y=
    convectionResistance(
      hSeg=hSeg,
      rTub=rTub,
      kMed=kMed,
      mueMed=mueMed,
      cpMed=cpMed,
      m_flow=m2_flow,
      m_flow_nominal=m2_flow_nominal))
    "Convective and thermal resistance at fluid 2"
    annotation (Placement(transformation(extent={{-100,-18},{-80,2}})));
initial equation
  (Rgb_val, Rgg_val, RCondGro_val, x) =
    singleUTubeResistances(
    hSeg=hSeg,
    rBor=rBor,
    rTub=rTub,
    eTub=eTub,
    xC=xC,
    kSoi=matSoi.k,
    kFil=matFil.k,
    kTub=kTub);

equation
  connect(vol1.heatPort, RConv1.fluid) annotation (Line(
      points={{-10,60},{-60,60},{-60,50},{-90,50},{-90,28},{-82,28}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(RConv1.solid, Rpg1.port_a) annotation (Line(
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
  connect(RConv2.solid, Rpg2.port_a) annotation (Line(
      points={{-56,-28},{-48,-28}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Rpg2.port_b, capFil2.port) annotation (Line(
      points={{-24,-28},{-8,-28}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(RConv2.fluid, vol2.heatPort) annotation (Line(
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
  connect(RVol1.y, RConv1.Rc) annotation (Line(
      points={{-79,8},{-70,8},{-70,16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(RVol2.y, RConv2.Rc) annotation (Line(
      points={{-79,-8},{-68,-8},{-68,-16}},
      color={0,0,127},
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
<p>
Model for the heat transfer between the fluid and within the borehole filling.
This model computes the dynamic response of the fluid in the tubes,
the heat transfer between the fluid and the borehole filling,
and the heat storage within the fluid and the borehole filling.
</p>
<p>
This model computes the different thermal resistances present
in a single-U-tube borehole using the method of Bauer et al. (2011)
and computing explicitly the fluid-to-ground thermal resistance
<i>R<sub>b</sub></i> and the
grout-to-grout resistance
<i>R<sub>a</sub></i> as defined by Hellstroem (1991)
using the multipole method.
The multipole method is implemented in
<a href=\"modelica://Buildings.Fluid.Geothermal.Boreholes.BaseClasses.singleUTubeResistances\">
Buildings.Fluid.Geothermal.Boreholes.BaseClasses.singleUTubeResistances</a>.
The convection resistance is calculated using the
Dittus-Boelter correlation
as implemented in
<a href=\"modelica://Buildings.Fluid.Geothermal.Boreholes.BaseClasses.convectionResistance\">
Buildings.Fluid.Geothermal.Boreholes.BaseClasses.convectionResistance</a>.
</p>
<p>
The figure below shows the thermal network set up by Bauer et al. (2010).
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Geothermal/Boreholes/BaseClasses/Bauer_singleUTube.png\"/>
</p>
<h4>References</h4>
<p>
G. Hellstr&ouml;m.
<i>Ground heat storage: thermal analyses of duct storage systems (Theory)</i>.
Dept. of Mathematical Physics, University of Lund, Sweden, 1991.
</p>
<p>
D. Bauer, W. Heidemann, H. M&uuml;ller-Steinhagen, and H.-J. G. Diersch.
<i>
<a href=\"http://dx.doi.org/10.1002/er.1689\">
Thermal resistance and capacity models for borehole heat exchangers
</a>
</i>.
International Journal Of Energy Research, 35:312&ndash;320, 2011.
</p>
</html>", revisions="<html>
<ul>
<li>
May 6, 2015, by Michael Wetter:<br/>
Removed assignement of <code>vol.allowFlowReversal</code> as this is
done in the base class.
</li>
<li>
June 18, 2014, by Michael Wetter:<br/>
Added initialization for temperatures and derivatives of <code>capFil1</code>
and <code>capFil2</code> to avoid a warning during translation.
</li>
<li>
February 14, 2014, by Michael Wetter:<br/>
Removed unused parameters <code>B0</code> and <code>B1</code>.
</li>
<li>
January 24, 2014, by Michael Wetter:<br/>
Revised implementation, added comments, replaced
<code>HeatTransfer.Windows.BaseClasses.ThermalConductor</code>
with resistance models from the Modelica Standard Library.
</li>
<li>
January 23, 2014, by Damien Picard:<br/>
First implementation.
</li>
</ul>
</html>"));
end HexInternalElement;
