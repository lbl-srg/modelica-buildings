within Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses;
model InternalHEXTwoUTube
  "Internal heat exchanger of a borehole for a double U-tube configuration. In loop 1, fluid 1 streams from a1 to b1 and comes back from a2 to b2. In loop 2: fluid 2 streams from a3 to b3 and comes back from a4 to b4."

  extends
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.PartialInternalHEX;
  extends Buildings.Fluid.Interfaces.EightPortHeatMassExchanger(
    redeclare final package Medium1 = Medium,
    redeclare final package Medium2 = Medium,
    redeclare final package Medium3 = Medium,
    redeclare final package Medium4 = Medium,
    T1_start=TFlu_start,
    T2_start=TFlu_start,
    T3_start=TFlu_start,
    T4_start=TFlu_start,
    final tau1=VTubSeg*rho1_nominal/m1_flow_nominal,
    final tau2=VTubSeg*rho2_nominal/m2_flow_nominal,
    final tau3=VTubSeg*rho3_nominal/m3_flow_nominal,
    final tau4=VTubSeg*rho4_nominal/m4_flow_nominal,
    vol1(
      final energyDynamics=energyDynamics,
      final massDynamics=massDynamics,
      final prescribedHeatFlowRate=false,
      final allowFlowReversal=allowFlowReversal1,
      final m_flow_small=m1_flow_small,
      final V=VTubSeg,
      final mSenFac=mSenFac),
    vol2(
      final energyDynamics=energyDynamics,
      final massDynamics=massDynamics,
      final prescribedHeatFlowRate=false,
      final m_flow_small=m2_flow_small,
      final V=VTubSeg,
      final mSenFac=mSenFac),
    vol3(
      final energyDynamics=energyDynamics,
      final massDynamics=massDynamics,
      final prescribedHeatFlowRate=false,
      final allowFlowReversal=allowFlowReversal3,
      final m_flow_small=m3_flow_small,
      final V=VTubSeg,
      final mSenFac=mSenFac),
    vol4(
      final energyDynamics=energyDynamics,
      final massDynamics=massDynamics,
      final prescribedHeatFlowRate=false,
      final m_flow_small=m4_flow_small,
      final V=VTubSeg,
      final mSenFac=mSenFac));

  Modelica.Blocks.Sources.RealExpression RVol1(y=
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.convectionResistanceCircularPipe(
      hSeg=hSeg,
      rTub=borFieDat.conDat.rTub,
      eTub=borFieDat.conDat.eTub,
      kMed=kMed,
      muMed=muMed,
      cpMed=cpMed,
      m_flow=m1_flow,
      m_flow_nominal=m1_flow_nominal))
    "Convective and thermal resistance at fluid 1"
    annotation (Placement(transformation(extent={{-16,56},{-30,72}})));
  Modelica.Blocks.Sources.RealExpression RVol2(y=
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.convectionResistanceCircularPipe(
      hSeg=hSeg,
      rTub=borFieDat.conDat.rTub,
      eTub=borFieDat.conDat.eTub,
      kMed=kMed,
      muMed=muMed,
      cpMed=cpMed,
      m_flow=m2_flow,
      m_flow_nominal=m2_flow_nominal))
    "Convective and thermal resistance at fluid 2"
    annotation (Placement(transformation(extent={{88,-8},{72,-26}})));
  Modelica.Blocks.Sources.RealExpression RVol3(y=
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.convectionResistanceCircularPipe(
      hSeg=hSeg,
      rTub=borFieDat.conDat.rTub,
      eTub=borFieDat.conDat.eTub,
      kMed=kMed,
      muMed=muMed,
      cpMed=cpMed,
      m_flow=m3_flow,
      m_flow_nominal=m3_flow_nominal))
    "Convective and thermal resistance at fluid 1"
    annotation (Placement(transformation(extent={{-12,-60},{-26,-76}})));

  Modelica.Blocks.Sources.RealExpression RVol4(y=
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.convectionResistanceCircularPipe(
      hSeg=hSeg,
      rTub=borFieDat.conDat.rTub,
      eTub=borFieDat.conDat.eTub,
      kMed=kMed,
      muMed=muMed,
      cpMed=cpMed,
      m_flow=m1_flow,
      m_flow_nominal=m4_flow_nominal))
    "Convective and thermal resistance at fluid 1"
    annotation (Placement(transformation(extent={{-68,12},{-54,28}})));
  Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.InternalResistancesTwoUTube intRes2UTub(
    hSeg=hSeg,
    borFieDat=borFieDat,
    Rgb_val=Rgb_val,
    Rgg1_val=Rgg1_val,
    Rgg2_val=Rgg2_val,
    RCondGro_val=RCondGro_val,
    dynFil=dynFil,
    energyDynamics=energyDynamics,
    T_start=TGro_start)
                   "Internal resistances for a double U-tube configuration"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Thermal.HeatTransfer.Components.ConvectiveResistor RConv1
    "Pipe convective resistance" annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=90,
        origin={0,46})));

  Modelica.Thermal.HeatTransfer.Components.ConvectiveResistor RConv2
    "Pipe convective resistance" annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=180,
        origin={34,0})));
  Modelica.Thermal.HeatTransfer.Components.ConvectiveResistor RConv3
    "Pipe convective resistance" annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=90,
        origin={0,-32})));
  Modelica.Thermal.HeatTransfer.Components.ConvectiveResistor RConv4
    "Pipe convective resistance" annotation (Placement(transformation(
        extent={{-8,8},{8,-8}},
        rotation=180,
        origin={-34,0})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_wall
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));

protected
  parameter Real Rgg1_val(fixed=false);
  parameter Real Rgg2_val(fixed=false);

initial equation
  (x,Rgb_val,Rgg1_val,Rgg2_val,RCondGro_val) =
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.internalResistancesTwoUTube(
      hSeg=hSeg,
      rBor=borFieDat.conDat.rBor,
      rTub=borFieDat.conDat.rTub,
      eTub=borFieDat.conDat.eTub,
      sha=borFieDat.conDat.xC,
      kFil=borFieDat.filDat.kFil,
      kSoi=borFieDat.soiDat.kSoi,
      kTub=borFieDat.conDat.kTub,
      use_Rb=borFieDat.conDat.use_Rb,
      Rb=borFieDat.conDat.Rb,
      kMed=kMed,
      muMed=muMed,
      cpMed=cpMed,
      m_flow_nominal=m1_flow_nominal,
      printDebug=false);

equation
  assert(borFieDat.conDat.borCon == Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel
     or borFieDat.conDat.borCon == Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeSeries,
    "This model should be used for double U-type borefield, not single U-type.
  Check that the conDat record has been correctly parametrized");
  connect(RVol1.y, RConv1.Rc) annotation (Line(
      points={{-30.7,64},{-34,64},{-34,46},{-8,46}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(RConv1.fluid, vol1.heatPort) annotation (Line(
      points={{4.44089e-016,54},{-14,54},{-14,70},{-10,70}},
      color={191,0,0},
      smooth=Smooth.None));


  connect(RConv1.solid, intRes2UTub.port_1)
    annotation (Line(points={{0,38},{0,24},{0,10}}, color={191,0,0}));
  connect(RConv2.fluid, vol2.heatPort)
    annotation (Line(points={{42,0},{46,0},{50,0}}, color={191,0,0}));
  connect(RConv2.solid, intRes2UTub.port_2)
    annotation (Line(points={{26,0},{18,0},{10,0}}, color={191,0,0}));
  connect(RConv3.fluid, vol3.heatPort) annotation (Line(points={{0,-40},{-14,-40},
          {-14,-60},{-10,-60}}, color={191,0,0}));
  connect(RConv3.solid, intRes2UTub.port_3)
    annotation (Line(points={{0,-24},{0,-10}}, color={191,0,0}));
  connect(RConv4.fluid, vol4.heatPort)
    annotation (Line(points={{-42,0},{-46,0},{-50,0}}, color={191,0,0}));
  connect(RConv4.solid, intRes2UTub.port_4)
    annotation (Line(points={{-26,0},{-18,0},{-10,0}}, color={191,0,0}));
  connect(RVol4.y, RConv4.Rc)
    annotation (Line(points={{-53.3,20},{-34,20},{-34,8}}, color={0,0,127}));
  connect(RVol3.y, RConv3.Rc) annotation (Line(points={{-26.7,-68},{-30,-68},{-30,
          -32},{-8,-32}}, color={0,0,127}));
  connect(RVol2.y, RConv2.Rc)
    annotation (Line(points={{71.2,-17},{34,-17},{34,-8}}, color={0,0,127}));
  connect(intRes2UTub.port_wall, port_wall) annotation (Line(points={{0,0},{6,0},
          {6,20},{20,20},{20,100},{0,100}}, color={191,0,0}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, initialScale=0.1)),
    Icon(coordinateSystem(preserveAspectRatio=false, initialScale=0.1),
        graphics={
        Rectangle(
          extent={{98,74},{-94,86}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{96,24},{-96,36}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{100,-38},{-92,-26}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{94,-88},{-98,-76}},
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
<i>R<sub>a</sub></i> as defined by Claesson and Hellstrom (2011)
using the multipole method.
</p>
<h4>References</h4>
<p>J. Claesson and G. Hellstrom.
<i>Multipole method to calculate borehole thermal resistances in a borehole heat exchanger.
</i>
HVAC&amp;R Research,
17(6): 895-911, 2011.</p>
<p>
D. Bauer, W. Heidemann, H. M&uuml;ller-Steinhagen, and H.-J. G. Diersch.
<i>
Thermal resistance and capacity models for borehole heat exchangers
</i>.
International Journal Of Energy Research, 35:312-320, 2011.
</p>
</html>", revisions="<html>
<ul>
<li>
July 10, 2018, by Alex Laferri&egrave;re:<br/>
Updated documentation following major changes to the Buildings.Fluid.HeatExchangers.Ground package.
Additionally, implemented a partial InternalHex model.
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
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics));
end InternalHEXTwoUTube;
