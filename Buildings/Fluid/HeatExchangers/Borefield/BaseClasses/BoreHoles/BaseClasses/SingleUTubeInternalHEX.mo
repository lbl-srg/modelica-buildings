within Buildings.Fluid.HeatExchangers.Borefield.BaseClasses.BoreHoles.BaseClasses;
model SingleUTubeInternalHEX
  "Internal part of a borehole for a U-Tube configuration"
  extends Interface.PartialBoreHoleInternalHEX;

  extends Buildings.Fluid.Interfaces.FourPortHeatMassExchanger(
    redeclare final package Medium1 = Medium,
    redeclare final package Medium2 = Medium,
    T1_start=TFil_start,
    T2_start=TFil_start,
    final tau1=Modelica.Constants.pi*gen.rTub^2*gen.hSeg*rho1_nominal/
        m1_flow_nominal,
    final tau2=Modelica.Constants.pi*gen.rTub^2*gen.hSeg*rho2_nominal/
        m2_flow_nominal,
    final show_T=true,
    vol1(
      final energyDynamics=energyDynamics,
      final massDynamics=massDynamics,
      final prescribedHeatFlowRate=false,
      final allowFlowReversal=allowFlowReversal1,
      final m_flow_small=m1_flow_small,
      V=gen.volOneLegSeg),
    redeclare Buildings.Fluid.MixingVolumes.MixingVolume vol2(
      final energyDynamics=energyDynamics,
      final massDynamics=massDynamics,
      final prescribedHeatFlowRate=false,
      final m_flow_small=m2_flow_small,
      V=gen.volOneLegSeg));

  parameter Modelica.SIunits.Temperature TFil_start=gen.TFil0_start
    "Initial temperature of the filling material"
    annotation (Dialog(group="Filling material"));

  Modelica.Thermal.HeatTransfer.Components.ConvectiveResistor RConv1
    "Pipe convective resistance"
    annotation (Placement(transformation(extent={{-58,40},{-82,16}})));
  Modelica.Thermal.HeatTransfer.Components.ConvectiveResistor RConv2
    "Pipe convective resistance"
    annotation (Placement(transformation(extent={{-56,-40},{-80,-16}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rpg1(
    R=RCondGro_val/scaSeg) "Grout thermal resistance"
    annotation (Placement(transformation(extent={{-50,16},{-26,40}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rpg2(
    R=RCondGro_val/scaSeg) "Grout thermal resistance"
    annotation (Placement(transformation(extent={{-48,-40},{-24,-16}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgb1(
    R=Rgb_val/scaSeg) "Grout thermal resistance"
    annotation (Placement(transformation(extent={{52,26},{76,50}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgb2(
    R=Rgb_val/scaSeg) "Grout thermal resistance"
    annotation (Placement(transformation(extent={{52,-40},{76,-16}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgg(
    R=Rgg_val/scaSeg) "Grout thermal resistance"
    annotation (Placement(transformation(extent={{-12,-12},{12,12}},
        rotation=-90,
        origin={20,2})));

  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor capFil1(C=Co_fil/2*scaSeg, T(
        start=TFil_start, fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial)),
        der_T(fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial)))
    "Heat capacity of the filling material"
                                         annotation (
      Placement(transformation(
        extent={{-90,36},{-70,16}},
        rotation=0,
        origin={80,0})));

  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor capFil2(C=Co_fil/2*scaSeg, T(
        start=TFil_start, fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial)),
        der_T(fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial)))
    "Heat capacity of the filling material"                                                                                        annotation (
      Placement(transformation(
        extent={{-90,-36},{-70,-16}},
        rotation=0,
        origin={80,6})));

  parameter Real scaSeg = 1
    "scaling factor used by Borefield.MultipleBoreHoles to represent the whole borefield by one single segment"
                                                                                                        annotation (Dialog(group="Advanced"));
protected
  final parameter Modelica.SIunits.SpecificHeatCapacity cpFil=fil.c
    "Specific heat capacity of the filling material";
  final parameter Modelica.SIunits.ThermalConductivity kFil=fil.k
    "Thermal conductivity of the filling material";
  final parameter Modelica.SIunits.Density dFil=fil.d
    "Density of the filling material";

  parameter Modelica.SIunits.HeatCapacity Co_fil=dFil*cpFil*gen.hSeg*Modelica.Constants.pi
      *(gen.rBor^2 - 2*(gen.rTub + gen.eTub)^2)
    "Heat capacity of the whole filling material";

  parameter Modelica.SIunits.SpecificHeatCapacity cpMed=
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

public
  Modelica.Blocks.Sources.RealExpression RVol1(y=
    convectionResistance(
    hSeg=gen.hSeg,
    rBor=gen.rBor,
    rTub=gen.rTub,
    kMed=kMed,
    mueMed=mueMed,
    cpMed=cpMed,
    m_flow=m1_flow,
    m_flow_nominal=gen.m_flow_nominal_bh)/scaSeg)
    "Convective and thermal resistance at fluid 1"
    annotation (Placement(transformation(extent={{-100,-2},{-80,18}})));
  Modelica.Blocks.Sources.RealExpression RVol2(y=
    convectionResistance(hSeg=gen.hSeg,
    rBor=gen.rBor,
    rTub=gen.rTub,
    kMed=kMed,
    mueMed=mueMed,
    cpMed=cpMed,
    m_flow=m2_flow,
    m_flow_nominal=gen.m_flow_nominal_bh)/scaSeg)
    "Convective and thermal resistance at fluid 2"
     annotation (Placement(transformation(extent={{-100,-18},{-80,2}})));

initial equation
  (Rgb_val, Rgg_val, RCondGro_val, x) =
    singleUTubeResistances(hSeg=gen.hSeg,
    rBor=gen.rBor,
    rTub=gen.rTub,
    eTub=gen.eTub,
    sha=gen.xC,
    kFil=fil.k,
    kSoi=soi.k,
    kTub=gen.kTub);

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
      points={{-26,28},{-20,28},{-20,36},{0,36}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(capFil1.port, Rgb1.port_a) annotation (Line(
      points={{0,36},{26,36},{26,38},{52,38}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(capFil1.port, Rgg.port_a) annotation (Line(
      points={{0,36},{20,36},{20,14}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Rgb1.port_b, port) annotation (Line(
      points={{76,38},{86,38},{86,100},{0,100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(RConv2.solid, Rpg2.port_a) annotation (Line(
      points={{-56,-28},{-48,-28}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Rpg2.port_b, capFil2.port) annotation (Line(
      points={{-24,-28},{-12,-28},{-12,-30},{0,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(RConv2.fluid, vol2.heatPort) annotation (Line(
      points={{-80,-28},{-86,-28},{-86,-46},{20,-46},{20,-60},{12,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(capFil2.port, Rgb2.port_a) annotation (Line(
      points={{0,-30},{26,-30},{26,-28},{52,-28}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Rgg.port_b, capFil2.port) annotation (Line(
      points={{20,-10},{20,-30},{0,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Rgb2.port_b, port) annotation (Line(
      points={{76,-28},{86,-28},{86,100},{0,100}},
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
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -120},{100,100}}),
                        graphics),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},{100,
            100}}), graphics={Rectangle(
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
and computing explicitely the fluid-to-ground thermal resistance 
<i>R<sub>b</sub></i> and the 
grout-to-grout resistance
<i>R<sub>a</sub></i> as defined by Hellstroem (1991)
using the multipole method.
The multipole method is implemented in
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses.singleUTubeResistances\">
Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses.singleUTubeResistances</a>. 
The convection resistance is calculated using the 
Dittus-Boelter correlation
as implemented in
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses.convectionResistance\">
Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses.convectionResistance</a>. 
</p>
<p>
The figure below shows the thermal network set up by Bauer et al. (2010).
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/HeatExchangers/Boreholes/BaseClasses/Bauer_singleUTube.png\"/>
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
<p>
<ul>
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
</p>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics));

end SingleUTubeInternalHEX;
