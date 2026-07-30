within Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses;
model InternalHEXOneUTube
  "Internal heat exchanger of a borehole for a single U-tube configuration"
  extends
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.PartialInternalHEX;
  extends Buildings.Fluid.Interfaces.FourPortHeatMassExchanger(
    redeclare final package Medium1 = Medium,
    redeclare final package Medium2 = Medium,
    T1_start=TFlu_start,
    T2_start=TFlu_start,
    final tau1=VTubSeg*rho1_nominal/m1_flow_nominal,
    final tau2=VTubSeg*rho2_nominal/m2_flow_nominal,
    redeclare final Buildings.Fluid.MixingVolumes.MixingVolume vol1(
      final energyDynamics=energyDynamics,
      final massDynamics=energyDynamics,
      final prescribedHeatFlowRate=false,
      final m_flow_small=m1_flow_small,
      final V=VTubSeg,
      final mSenFac=mSenFac),
    redeclare final Buildings.Fluid.MixingVolumes.MixingVolume vol2(
      final energyDynamics=energyDynamics,
      final massDynamics=energyDynamics,
      final prescribedHeatFlowRate=false,
      final m_flow_small=m2_flow_small,
      final V=VTubSeg,
      final mSenFac=mSenFac));

  Modelica.Units.SI.ThermalResistance RVol1_val
    "Convective and thermal resistance at fluid 1";

  Modelica.Units.SI.ThermalResistance RVol2_val
    "Convective and thermal resistance at fluid 2";

  Real Re1(unit="1")
    "Reynolds number in pipe 1";

  Real Re2(unit="1")
    "Reynolds number in pipe 2";

  Modelica.Blocks.Sources.RealExpression RVol1(y=RVol1_val)
    "Convective and thermal resistance at fluid 1"
    annotation (Placement(transformation(extent={{-100,-2},{-80,18}})));

  Modelica.Blocks.Sources.RealExpression RVol2(y=RVol2_val)
    "Convective and thermal resistance at fluid 2"
    annotation (Placement(transformation(extent={{-100,-18},{-80,2}})));

  Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.InternalResistancesOneUTube
    intResUTub(
      hSeg=hSeg,
      energyDynamics=energyDynamics,
      Rgb_val=Rgb_val,
      Rgg_val=Rgg_val,
      RCondGro_val=RCondGro_val,
      borFieDat=borFieDat,
      T_start=TGro_start)
    "Internal resistances for a single U-tube configuration"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Thermal.HeatTransfer.Components.ConvectiveResistor RConv2
    "Pipe convective resistance"
    annotation (Placement(transformation(extent={{-12,12},{12,-12}},
        rotation=270,
        origin={0,-28})));
  Modelica.Thermal.HeatTransfer.Components.ConvectiveResistor RConv1
    "Pipe convective resistance"
    annotation (Placement(transformation(extent={{-12,-12},{12,12}},
        rotation=90,
        origin={0,28})));

protected
  parameter Real Rgg_val(fixed=false)
    "Thermal resistance between the two grout zones";

  Medium.MassFraction X1[Medium.nX]
    "Mass fractions used to evaluate medium properties in volume 1";
  Medium.MassFraction X2[Medium.nX]
    "Mass fractions used to evaluate medium properties in volume 2";

  Medium.ThermodynamicState sta1
    "Medium state used to evaluate temperature-dependent properties in volume 1";
  Medium.ThermodynamicState sta2
    "Medium state used to evaluate temperature-dependent properties in volume 2";

  Modelica.Units.SI.SpecificHeatCapacity cpMed1Act
    "Specific heat capacity used for convection resistance in volume 1";
  Modelica.Units.SI.ThermalConductivity kMed1Act
    "Thermal conductivity used for convection resistance in volume 1";
  Modelica.Units.SI.DynamicViscosity muMed1Act
    "Dynamic viscosity used for convection resistance in volume 1";
  Modelica.Units.SI.Density rhoMed1Act
    "Density used for correlations in volume 1";

  Modelica.Units.SI.SpecificHeatCapacity cpMed2Act
    "Specific heat capacity used for convection resistance in volume 2";
  Modelica.Units.SI.ThermalConductivity kMed2Act
    "Thermal conductivity used for convection resistance in volume 2";
  Modelica.Units.SI.DynamicViscosity muMed2Act
    "Dynamic viscosity used for convection resistance in volume 2";
  Modelica.Units.SI.Density rhoMed2Act
    "Density used for correlations in volume 2";

initial equation
  (x, Rgb_val, Rgg_val, RCondGro_val) =
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.internalResistancesOneUTube(
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
      instanceName=getInstanceName());

equation
  if borFieDat.conDat.use_TDepRConv and
     borFieDat.conDat.fluidPropertyEvaluation ==
       Buildings.Fluid.Geothermal.Borefields.Types.FluidPropertyEvaluation.GenericMedium then

    X1 =
      if Medium.reducedX then
        cat(1, vol1.Xi, {1 - sum(vol1.Xi)})
      else
        vol1.Xi;

    X2 =
      if Medium.reducedX then
        cat(1, vol2.Xi, {1 - sum(vol2.Xi)})
      else
        vol2.Xi;

    sta1 = Medium.setState_pTX(
      p=vol1.p,
      T=vol1.T,
      X=X1);

    sta2 = Medium.setState_pTX(
      p=vol2.p,
      T=vol2.T,
      X=X2);

    cpMed1Act = Medium.specificHeatCapacityCp(sta1);
    kMed1Act = Medium.thermalConductivity(sta1);
    muMed1Act = Medium.dynamicViscosity(sta1);
    rhoMed1Act = Medium.density(sta1);

    cpMed2Act = Medium.specificHeatCapacityCp(sta2);
    kMed2Act = Medium.thermalConductivity(sta2);
    muMed2Act = Medium.dynamicViscosity(sta2);
    rhoMed2Act = Medium.density(sta2);

  else

    X1 = zeros(Medium.nX);
    X2 = zeros(Medium.nX);

    /*
      Dummy assignments only to keep the protected state records assigned.
      These states are not used in this branch.
    */
    sta1 = Medium.setState_pTX(
      p=Medium.p_default,
      T=Medium.T_default,
      X=Medium.X_default);

    sta2 = Medium.setState_pTX(
      p=Medium.p_default,
      T=Medium.T_default,
      X=Medium.X_default);

    (cpMed1Act, kMed1Act, muMed1Act, rhoMed1Act) =
      Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.fluidProperties_T(
        use_TDep=borFieDat.conDat.use_TDepRConv,
        fluidPropertyEvaluation=borFieDat.conDat.fluidPropertyEvaluation,
        T=vol1.T,
        p=vol1.p,
        X_a=borFieDat.conDat.X_a,
        cp_default=cpMed,
        k_default=kMed,
        mu_default=muMed,
        rho_default=rhoMed);

    (cpMed2Act, kMed2Act, muMed2Act, rhoMed2Act) =
      Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.fluidProperties_T(
        use_TDep=borFieDat.conDat.use_TDepRConv,
        fluidPropertyEvaluation=borFieDat.conDat.fluidPropertyEvaluation,
        T=vol2.T,
        p=vol2.p,
        X_a=borFieDat.conDat.X_a,
        cp_default=cpMed,
        k_default=kMed,
        mu_default=muMed,
        rho_default=rhoMed);

  end if;

  (RVol1_val, Re1) =
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.convectionResistanceCircularPipe(
      hSeg=hSeg,
      rTub=borFieDat.conDat.rTub,
      eTub=borFieDat.conDat.eTub,
      roughness=borFieDat.conDat.roughness,
      kMed=kMed1Act,
      muMed=muMed1Act,
      cpMed=cpMed1Act,
      m_flow=m1_flow,
      m_flow_nominal=m1_flow_nominal);

  (RVol2_val, Re2) =
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.convectionResistanceCircularPipe(
      hSeg=hSeg,
      rTub=borFieDat.conDat.rTub,
      eTub=borFieDat.conDat.eTub,
      roughness=borFieDat.conDat.roughness,
      kMed=kMed2Act,
      muMed=muMed2Act,
      cpMed=cpMed2Act,
      m_flow=m2_flow,
      m_flow_nominal=m2_flow_nominal);

    assert(borFieDat.conDat.borCon == Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.SingleUTube,
  "This model should be used for single U-type borefield, not double U-type.
  Check that the conDat record has been correctly parametrized");
  connect(RVol2.y, RConv2.Rc) annotation (Line(points={{-79,-8},{-60,-8},{-40,
          -8},{-40,-28},{-12,-28}},
                                color={0,0,127}));
  connect(RVol1.y, RConv1.Rc) annotation (Line(points={{-79,8},{-40,8},{-40,28},
          {-12,28}}, color={0,0,127}));
  connect(vol1.heatPort, RConv1.fluid) annotation (Line(points={{-10,60},{-20,
          60},{-20,40},{6.66134e-016,40}}, color={191,0,0}));
  connect(RConv1.solid, intResUTub.port_1)
    annotation (Line(points={{0,16},{0,16},{0,10}}, color={191,0,0}));
  connect(RConv2.fluid, vol2.heatPort) annotation (Line(points={{0,-40},{20,-40},
          {20,-60},{12,-60}}, color={191,0,0}));
  connect(RConv2.solid, intResUTub.port_2) annotation (Line(points={{0,-16},{0,
          -12},{16,-12},{16,0},{10,0}}, color={191,0,0}));
  connect(intResUTub.port_wall, port_wall) annotation (Line(points={{0,0},{0,0},
          {0,6},{-28,6},{-28,86},{0,86},{0,100}},             color={191,0,0}));
    annotation (
    Icon(coordinateSystem(preserveAspectRatio=false),
    graphics={Rectangle(
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
Model for the heat transfer between the fluid and within the borehole filling
for a single borehole segment.
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
July 27, 2026, by Lone Meertens:<br/>
Added optional temperature-dependent fluid-property evaluation for the pipe
convection resistance, including water and propylene-glycol/water correlation
modes.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4483\">Buildings, #4483</a>.
</li>
<li>
July 18, 2026, by Lone Meertens:<br/>
Propagated pipe roughness from the borefield configuration data to the
convective resistance calculation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4656\">Buildings, #4656</a>.
</li>
<li>
June 17, 2026, by Michael Wetter:<br/>
Removed stray annotation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/2139\">IBPSA, #2139</a>.
</li>
<li>
May 17, 2024, by Michael Wetter:<br/>
Updated model due to removal of parameter <code>dynFil</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1885\">IBPSA, #1885</a>.
</li>
<li>
November 22, 2023, by Michael Wetter:<br/>
Corrected use of <code>getInstanceName()</code> which was called inside a function which
is not allowed.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1814\">IBPSA, #1814</a>.
</li>
<li>
March 7, 2022, by Michael Wetter:<br/>
Removed <code>massDynamics</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1542\">#1542</a>.
</li>
<li>
February 28, 2022, by Massimo Cimmino:<br/>
Removed <code>printDebug</code> parameter from call to
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.internalResistancesOneUTube\">
Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.internalResistancesOneUTube</a>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1582\">IBPSA, #1582</a>.
</li>
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
</html>"));
end InternalHEXOneUTube;
