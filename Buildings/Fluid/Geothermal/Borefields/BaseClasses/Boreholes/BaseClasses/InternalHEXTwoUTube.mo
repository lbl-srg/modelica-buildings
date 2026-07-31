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
      final massDynamics=energyDynamics,
      final prescribedHeatFlowRate=false,
      final allowFlowReversal=allowFlowReversal1,
      final m_flow_small=m1_flow_small,
      final V=VTubSeg,
      final mSenFac=mSenFac),
    vol2(
      final energyDynamics=energyDynamics,
      final massDynamics=energyDynamics,
      final prescribedHeatFlowRate=false,
      final m_flow_small=m2_flow_small,
      final V=VTubSeg,
      final mSenFac=mSenFac),
    vol3(
      final energyDynamics=energyDynamics,
      final massDynamics=energyDynamics,
      final prescribedHeatFlowRate=false,
      final allowFlowReversal=allowFlowReversal3,
      final m_flow_small=m3_flow_small,
      final V=VTubSeg,
      final mSenFac=mSenFac),
    vol4(
      final energyDynamics=energyDynamics,
      final massDynamics=energyDynamics,
      final prescribedHeatFlowRate=false,
      final m_flow_small=m4_flow_small,
      final V=VTubSeg,
      final mSenFac=mSenFac),
    redeclare final Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.PressureDropPipe preDro1(
      final use_DarcyPressureDrop=borFieDat.conDat.use_DarcyPressureDrop,
      final use_TDepPressureDrop=borFieDat.conDat.use_TDepPressureDrop,
      final fluidPropertyEvaluation=borFieDat.conDat.fluidPropertyEvaluation,
      final X_a=borFieDat.conDat.X_a,
      final length=hSeg,
      final rTub=borFieDat.conDat.rTub,
      final eTub=borFieDat.conDat.eTub,
      final roughness=borFieDat.conDat.roughness,
      final nUBend=nUBend1,
      final from_dp=from_dp1,
      final linearized=linearizeFlowResistance1,
      final n=n1,
      final deltaM=deltaM1,
      final dp_nominal=dp1_nominal),
    redeclare final Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.PressureDropPipe preDro2(
      final use_DarcyPressureDrop=borFieDat.conDat.use_DarcyPressureDrop,
      final use_TDepPressureDrop=borFieDat.conDat.use_TDepPressureDrop,
      final fluidPropertyEvaluation=borFieDat.conDat.fluidPropertyEvaluation,
      final X_a=borFieDat.conDat.X_a,
      final length=hSeg,
      final rTub=borFieDat.conDat.rTub,
      final eTub=borFieDat.conDat.eTub,
      final roughness=borFieDat.conDat.roughness,
      final nUBend=nUBend2,
      final from_dp=from_dp2,
      final linearized=linearizeFlowResistance2,
      final n=n2,
      final deltaM=deltaM2,
      final dp_nominal=dp2_nominal),
    redeclare final Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.PressureDropPipe preDro3(
      final use_DarcyPressureDrop=borFieDat.conDat.use_DarcyPressureDrop,
      final use_TDepPressureDrop=borFieDat.conDat.use_TDepPressureDrop,
      final fluidPropertyEvaluation=borFieDat.conDat.fluidPropertyEvaluation,
      final X_a=borFieDat.conDat.X_a,
      final length=hSeg,
      final rTub=borFieDat.conDat.rTub,
      final eTub=borFieDat.conDat.eTub,
      final roughness=borFieDat.conDat.roughness,
      final nUBend=nUBend3,
      final from_dp=from_dp3,
      final linearized=linearizeFlowResistance3,
      final n=n3,
      final deltaM=deltaM3,
      final dp_nominal=dp3_nominal),
    redeclare final Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.PressureDropPipe preDro4(
      final use_DarcyPressureDrop=borFieDat.conDat.use_DarcyPressureDrop,
      final use_TDepPressureDrop=borFieDat.conDat.use_TDepPressureDrop,
      final fluidPropertyEvaluation=borFieDat.conDat.fluidPropertyEvaluation,
      final X_a=borFieDat.conDat.X_a,
      final length=hSeg,
      final rTub=borFieDat.conDat.rTub,
      final eTub=borFieDat.conDat.eTub,
      final roughness=borFieDat.conDat.roughness,
      final nUBend=nUBend4,
      final from_dp=from_dp4,
      final linearized=linearizeFlowResistance4,
      final n=n4,
      final deltaM=deltaM4,
      final dp_nominal=dp4_nominal));
  
  parameter Integer nUBend1(min=0) = 0
    "Number of U-bends represented by pressure-drop model for pipe 1";

  parameter Integer nUBend2(min=0) = 0
    "Number of U-bends represented by pressure-drop model for pipe 2";

  parameter Integer nUBend3(min=0) = 0
    "Number of U-bends represented by pressure-drop model for pipe 3";

  parameter Integer nUBend4(min=0) = 0
    "Number of U-bends represented by pressure-drop model for pipe 4";
  
  Modelica.Units.SI.ThermalResistance RVol1_val
    "Convective and thermal resistance at fluid 1";
  Modelica.Units.SI.ThermalResistance RVol2_val
    "Convective and thermal resistance at fluid 2";
  Modelica.Units.SI.ThermalResistance RVol3_val
    "Convective and thermal resistance at fluid 3";
  Modelica.Units.SI.ThermalResistance RVol4_val
    "Convective and thermal resistance at fluid 4";
  Real Re1(unit="1")
    "Reynolds number in pipe 1";
  Real Re2(unit="1")
    "Reynolds number in pipe 2";
  Real Re3(unit="1")
    "Reynolds number in pipe 3";
  Real Re4(unit="1")
    "Reynolds number in pipe 4";

  Modelica.Blocks.Sources.RealExpression RVol1(y=RVol1_val)
    "Convective and thermal resistance at fluid 1"
    annotation (Placement(transformation(extent={{-16,56},{-30,72}})));

  Modelica.Blocks.Sources.RealExpression RVol2(y=RVol2_val)
    "Convective and thermal resistance at fluid 2"
    annotation (Placement(transformation(extent={{88.0,-8.0},{72.0,-26.0}},rotation = 0.0,origin = {0.0,0.0})));

  Modelica.Blocks.Sources.RealExpression RVol3(y=RVol3_val)
    "Convective and thermal resistance at fluid 3"
    annotation (Placement(transformation(extent={{-12,-60},{-26,-76}})));

  Modelica.Blocks.Sources.RealExpression RVol4(y=RVol4_val)
    "Convective and thermal resistance at fluid 4"
    annotation (Placement(transformation(extent={{-68,12},{-54,28}})));

  Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.InternalResistancesTwoUTube intRes2UTub(
    hSeg=hSeg,
    borFieDat=borFieDat,
    Rgb_val=Rgb_val,
    Rgg1_val=Rgg1_val,
    Rgg2_val=Rgg2_val,
    RCondGro_val=RCondGro_val,
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
    annotation (Placement(transformation(extent={{-10.0,90.0},{10.0,110.0}},rotation = 0.0,origin = {0.0,0.0})));

protected
  parameter Real Rgg1_val(fixed=false);
  parameter Real Rgg2_val(fixed=false);

  Medium.MassFraction X1[Medium.nX]
    "Mass fractions used to evaluate medium properties in volume 1";
  Medium.MassFraction X2[Medium.nX]
    "Mass fractions used to evaluate medium properties in volume 2";
  Medium.MassFraction X3[Medium.nX]
    "Mass fractions used to evaluate medium properties in volume 3";
  Medium.MassFraction X4[Medium.nX]
    "Mass fractions used to evaluate medium properties in volume 4";

  Medium.ThermodynamicState sta1
    "Medium state used to evaluate temperature-dependent properties in volume 1";
  Medium.ThermodynamicState sta2
    "Medium state used to evaluate temperature-dependent properties in volume 2";
  Medium.ThermodynamicState sta3
    "Medium state used to evaluate temperature-dependent properties in volume 3";
  Medium.ThermodynamicState sta4
    "Medium state used to evaluate temperature-dependent properties in volume 4";

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

  Modelica.Units.SI.SpecificHeatCapacity cpMed3Act
    "Specific heat capacity used for convection resistance in volume 3";
  Modelica.Units.SI.ThermalConductivity kMed3Act
    "Thermal conductivity used for convection resistance in volume 3";
  Modelica.Units.SI.DynamicViscosity muMed3Act
    "Dynamic viscosity used for convection resistance in volume 3";
  Modelica.Units.SI.Density rhoMed3Act
    "Density used for correlations in volume 3";

  Modelica.Units.SI.SpecificHeatCapacity cpMed4Act
    "Specific heat capacity used for convection resistance in volume 4";
  Modelica.Units.SI.ThermalConductivity kMed4Act
    "Thermal conductivity used for convection resistance in volume 4";
  Modelica.Units.SI.DynamicViscosity muMed4Act
    "Dynamic viscosity used for convection resistance in volume 4";
  Modelica.Units.SI.Density rhoMed4Act
    "Density used for correlations in volume 4";

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
      kMed=kMed_default,
      muMed=muMed_default,
      cpMed=cpMed_default,
      m_flow_nominal=m1_flow_nominal,
      instanceName=getInstanceName());

equation
  if borFieDat.conDat.use_TDepRConv and
     borFieDat.conDat.fluidPropertyEvaluation ==
       Buildings.Fluid.Geothermal.Borefields.Types.FluidPropertyEvaluation.use_MediaFunctions then

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

    X3 =
      if Medium.reducedX then
        cat(1, vol3.Xi, {1 - sum(vol3.Xi)})
      else
        vol3.Xi;

    X4 =
      if Medium.reducedX then
        cat(1, vol4.Xi, {1 - sum(vol4.Xi)})
      else
        vol4.Xi;

    sta1 = Medium.setState_pTX(
      p=vol1.p,
      T=vol1.T,
      X=X1);

    sta2 = Medium.setState_pTX(
      p=vol2.p,
      T=vol2.T,
      X=X2);

    sta3 = Medium.setState_pTX(
      p=vol3.p,
      T=vol3.T,
      X=X3);

    sta4 = Medium.setState_pTX(
      p=vol4.p,
      T=vol4.T,
      X=X4);

    cpMed1Act = Medium.specificHeatCapacityCp(sta1);
    kMed1Act = Medium.thermalConductivity(sta1);
    muMed1Act = Medium.dynamicViscosity(sta1);
    rhoMed1Act = Medium.density(sta1);

    cpMed2Act = Medium.specificHeatCapacityCp(sta2);
    kMed2Act = Medium.thermalConductivity(sta2);
    muMed2Act = Medium.dynamicViscosity(sta2);
    rhoMed2Act = Medium.density(sta2);

    cpMed3Act = Medium.specificHeatCapacityCp(sta3);
    kMed3Act = Medium.thermalConductivity(sta3);
    muMed3Act = Medium.dynamicViscosity(sta3);
    rhoMed3Act = Medium.density(sta3);

    cpMed4Act = Medium.specificHeatCapacityCp(sta4);
    kMed4Act = Medium.thermalConductivity(sta4);
    muMed4Act = Medium.dynamicViscosity(sta4);
    rhoMed4Act = Medium.density(sta4);

  elseif borFieDat.conDat.use_TDepRConv then

    X1 = zeros(Medium.nX);
    X2 = zeros(Medium.nX);
    X3 = zeros(Medium.nX);
    X4 = zeros(Medium.nX);

    sta1 = Medium.setState_pTX(
      p=Medium.p_default,
      T=Medium.T_default,
      X=Medium.X_default);

    sta2 = Medium.setState_pTX(
      p=Medium.p_default,
      T=Medium.T_default,
      X=Medium.X_default);

    sta3 = Medium.setState_pTX(
      p=Medium.p_default,
      T=Medium.T_default,
      X=Medium.X_default);

    sta4 = Medium.setState_pTX(
      p=Medium.p_default,
      T=Medium.T_default,
      X=Medium.X_default);

    (cpMed1Act, kMed1Act, muMed1Act, rhoMed1Act) =
      Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.fluidProperties_T(
        fluidPropertyEvaluation=borFieDat.conDat.fluidPropertyEvaluation,
        T=vol1.T,
        p=vol1.p,
        X_a=borFieDat.conDat.X_a);

    (cpMed2Act, kMed2Act, muMed2Act, rhoMed2Act) =
      Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.fluidProperties_T(
        fluidPropertyEvaluation=borFieDat.conDat.fluidPropertyEvaluation,
        T=vol2.T,
        p=vol2.p,
        X_a=borFieDat.conDat.X_a);

    (cpMed3Act, kMed3Act, muMed3Act, rhoMed3Act) =
      Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.fluidProperties_T(
        fluidPropertyEvaluation=borFieDat.conDat.fluidPropertyEvaluation,
        T=vol3.T,
        p=vol3.p,
        X_a=borFieDat.conDat.X_a);

    (cpMed4Act, kMed4Act, muMed4Act, rhoMed4Act) =
      Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.fluidProperties_T(
        fluidPropertyEvaluation=borFieDat.conDat.fluidPropertyEvaluation,
        T=vol4.T,
        p=vol4.p,
        X_a=borFieDat.conDat.X_a);

  else

    X1 = zeros(Medium.nX);
    X2 = zeros(Medium.nX);
    X3 = zeros(Medium.nX);
    X4 = zeros(Medium.nX);

    sta1 = Medium.setState_pTX(
      p=Medium.p_default,
      T=Medium.T_default,
      X=Medium.X_default);

    sta2 = Medium.setState_pTX(
      p=Medium.p_default,
      T=Medium.T_default,
      X=Medium.X_default);

    sta3 = Medium.setState_pTX(
      p=Medium.p_default,
      T=Medium.T_default,
      X=Medium.X_default);

    sta4 = Medium.setState_pTX(
      p=Medium.p_default,
      T=Medium.T_default,
      X=Medium.X_default);

    cpMed1Act = cpMed_default;
    kMed1Act = kMed_default;
    muMed1Act = muMed_default;
    rhoMed1Act = rhoMed_default;

    cpMed2Act = cpMed_default;
    kMed2Act = kMed_default;
    muMed2Act = muMed_default;
    rhoMed2Act = rhoMed_default;

    cpMed3Act = cpMed_default;
    kMed3Act = kMed_default;
    muMed3Act = muMed_default;
    rhoMed3Act = rhoMed_default;

    cpMed4Act = cpMed_default;
    kMed4Act = kMed_default;
    muMed4Act = muMed_default;
    rhoMed4Act = rhoMed_default;

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

  (RVol3_val, Re3) =
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.convectionResistanceCircularPipe(
      hSeg=hSeg,
      rTub=borFieDat.conDat.rTub,
      eTub=borFieDat.conDat.eTub,
      roughness=borFieDat.conDat.roughness,
      kMed=kMed3Act,
      muMed=muMed3Act,
      cpMed=cpMed3Act,
      m_flow=m3_flow,
      m_flow_nominal=m3_flow_nominal);

  (RVol4_val, Re4) =
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.convectionResistanceCircularPipe(
      hSeg=hSeg,
      rTub=borFieDat.conDat.rTub,
      eTub=borFieDat.conDat.eTub,
      roughness=borFieDat.conDat.roughness,
      kMed=kMed4Act,
      muMed=muMed4Act,
      cpMed=cpMed4Act,
      m_flow=m4_flow,
      m_flow_nominal=m4_flow_nominal);

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
  connect(intRes2UTub.port_wall, port_wall) annotation (Line(points={{0,0},{6,0},{6,20},{20,20},{20,100},{0,100}}, color={191,0,0}));
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
July 27, 2026, by Lone Meertens:<br/>
Propagated optional temperature-dependent fluid-property evaluation to all four
pipe convection resistances.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4483\">Buildings, #4483</a>.
</li>
<li>
July 22, 2026, by Lone Meertens:<br/>
Propagated pipe roughness from the borefield configuration data to the
convective resistance calculation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4656\">Buildings, #4656</a>.
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
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.internalResistancesTwoUTube\">
Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.internalResistancesTwoUTube</a>.<br/>
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
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics));
end InternalHEXTwoUTube;
