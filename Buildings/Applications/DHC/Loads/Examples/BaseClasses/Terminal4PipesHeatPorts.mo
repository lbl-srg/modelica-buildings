within Buildings.Applications.DHC.Loads.Examples.BaseClasses;
model Terminal4PipesHeatPorts
  extends Buildings.Applications.DHC.Loads.BaseClasses.PartialTerminalUnit(
    final nPorts1=2,
    final haveHeaPor=true,
    final haveFluPor=false,
    final haveFanPum=false,
    final haveEleHeaCoo=false,
    final hexCon=fill(
      Buildings.Fluid.Types.HeatExchangerConfiguration.ConstantTemperaturePhaseChange,
      2),
    final m_flow1_nominal=abs(Q_flow_nominal ./ cp1_nominal ./ (T_a1_nominal - T_b1_nominal)));
  // TODO: assign HX flow regime based on HX configuration.
  parameter Buildings.Fluid.Types.HeatExchangerFlowRegime hexReg[nPorts1]=
    fill(Buildings.Fluid.Types.HeatExchangerFlowRegime.ConstantTemperaturePhaseChange,
      nPorts1);
  parameter Real fraCon[nPorts1] = fill(0., nPorts1)
    "Convective fraction of heat transfer (constant)"
    annotation(Dialog(tab="Advanced"));
  parameter Real ratUAIntToUAExt[nPorts1](each min=1) = fill(2, nPorts1)
    "Ratio of UA internal to UA external values at nominal conditions"
    annotation(Dialog(tab="Advanced", group="Nominal condition"));
  parameter Real expUA[nPorts1] = fill(4/5, nPorts1)
    "Exponent of Reynolds number in the flow correlation used for computing UA internal value"
    annotation(Dialog(tab="Advanced"));
  // TODO: Update for all HX configurations.
  final parameter Modelica.SIunits.ThermalConductance CMin_nominal[nPorts1]=
    m_flow1_nominal .* cp1_nominal
    "Minimum capacity flow rate at nominal conditions";
    // min(m_flow1_nominal * cp1_nominal, m_flow2_nominal * cp2_nominal)
  final parameter Modelica.SIunits.ThermalConductance CMax_nominal[nPorts1]=
    fill(Modelica.Constants.inf, nPorts1)
    "Maximum capacity flow rate at nominal conditions";
  final parameter Real Z = 0
    "Ratio of capacity flow rates (CMin/CMax) at nominal conditions";
    // CMin_nominal / CMax_nominal
  final parameter Modelica.SIunits.ThermalConductance UA_nominal[nPorts1]=
    Buildings.Fluid.HeatExchangers.BaseClasses.ntu_epsilonZ(
      eps=Q_flow_nominal ./ abs(CMin_nominal .* (T_a1_nominal .- T_a2_nominal)),
      Z=0,
      flowRegime=Integer(hexCon)) .* CMin_nominal
    "Thermal conductance at nominal conditions";
  final parameter Modelica.SIunits.ThermalConductance UAExt_nominal[nPorts1]=
    (1 .+ ratUAIntToUAExt) ./ ratUAIntToUAExt .* UA_nominal
    "External thermal conductance at nominal conditions";
  final parameter Modelica.SIunits.ThermalConductance UAInt_nominal[nPorts1]=
    ratUAIntToUAExt .* UAExt_nominal
    "Internal thermal conductance at nominal conditions";
  Buildings.Controls.OBC.CDL.Continuous.LimPID conTInd[nPorts1](
    each Ti=120,
    each yMax=1,
    each controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    reverseAction={false,true},
    each yMin=0) "PI controller for indoor temperature"
    annotation (Placement(transformation(extent={{-10,210},{10,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gaiFloNom1[nPorts1](
    k=m_flow1_nominal)
    annotation (Placement(transformation(extent={{160,210},{180,230}})));
  Buildings.Applications.DHC.Loads.BaseClasses.HeatFlowEffectiveness hexHeaCoo[nPorts1](
    final flowRegime=hexReg,
    final m_flow1_nominal=m_flow1_nominal,
    final m_flow2_nominal=fill(0, nPorts1),
    final cp1_nominal=cp1_nominal,
    final cp2_nominal=cp2_nominal)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor T2Mes
    "Load side temperature sensor"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={150,0})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow heaFloHeaCon
    "Convective heat flow rate to load"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={152,80})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow heaFloCooCon
    "Convective heat flow rate to load"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={152,60})));
  Modelica.Blocks.Sources.RealExpression UAAct[nPorts1](y=1 ./ (1 ./ (
        UAInt_nominal .* Buildings.Utilities.Math.Functions.regNonZeroPower(
        senMasFlo.m_flow ./ m_flow1_nominal, expUA)) .+ 1 ./ UAExt_nominal))
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo[nPorts1](
    redeclare package Medium=Medium1)
    annotation (Placement(transformation(extent={{-150,-210},{-130,-190}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort T1InlMes[nPorts1](redeclare final
      package
      Medium = Medium1, final m_flow_nominal=m_flow1_nominal)
    annotation (Placement(transformation(extent={{-110,-210},{-90,-190}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator T2InlVec(nout=nPorts1)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={120,0})));
  Modelica.Blocks.Sources.RealExpression m_flow2Act[nPorts1](y=fill(0, nPorts1))
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Buildings.Fluid.HeatExchangers.HeaterCooler_u heaCoo[nPorts1](
    redeclare each final package Medium = Medium1,
    final dp_nominal=dp1_nominal,
    final m_flow_nominal=m_flow1_nominal,
    each energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    each final Q_flow_nominal=-1) "Heat exchange with water stream"
    annotation (Placement(transformation(extent={{60,-210},{80,-190}})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow heaFloCooRad
    "Radiative heat flow rate to load"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={152,-80})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow heaFloHeaRad
    "Radiative heat flow rate to load"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={152,-60})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gaiConHea[nPorts1](k=fraCon)
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gaiRadHea[nPorts1](k=1 .- fraCon)
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
equation
  connect(gaiFloNom1.y, m_flow1Req)
    annotation (Line(points={{182,220},{220,220}}, color={0,0,127}));
  connect(hexHeaCoo.UA, UAAct.y)
    annotation (Line(points={{-12,8},{-20,8},{-20,20}, {-39,20}}, color={0,0,127}));
  connect(ports_a1, senMasFlo.port_a)
    annotation (Line(points={{-200,-200},{-150,-200}}, color={0,127,255}));
  connect(senMasFlo.m_flow, hexHeaCoo.m_flow1)
    annotation (Line(points={{-140,-189},{-140,4},{-12,4}}, color={0,0,127}));
  connect(senMasFlo.port_b, T1InlMes.port_a)
    annotation (Line(points={{-130,-200},{-110,-200}}, color={0,127,255}));
  connect(T1InlMes.T, hexHeaCoo.T1Inl)
    annotation (Line(points={{-100,-189},{-100,0},{-12,0}}, color={0,0,127}));
  connect(T2Mes.T, T2InlVec.u)
    annotation (Line(points={{140,0},{92,0},{92,-1.55431e-15},{132,-1.55431e-15}},
                                                  color={0,0,127}));
  connect(T2InlVec.y, hexHeaCoo.T2Inl)
    annotation (Line(points={{108, 1.33227e-15},{60,1.33227e-15},{60,-20},{-20,-20},{-20,-8},{-12,-8}},
                              color={0,0,127}));
  connect(m_flow2Act.y, hexHeaCoo.m_flow2) annotation (Line(points={{-39,-20},{-26,
          -20},{-26,-4},{-12,-4}}, color={0,0,127}));
  connect(T1InlMes.port_b, heaCoo.port_a)
    annotation (Line(points={{-90,-200},{60,-200}}, color={0,127,255}));
  connect(heaCoo.port_b, ports_b1)
    annotation (Line(points={{80,-200},{200,-200}}, color={0,127,255}));
  connect(hexHeaCoo.Q_flow, heaCoo.u) annotation (Line(points={{12,0},{20,0},{
          20,-194},{58,-194}},
                            color={0,0,127}));
  connect(heaFloHeaRad.port, heaPorRad) annotation (Line(points={{162,-60},{180,
          -60},{180,-40},{200,-40}}, color={191,0,0}));
  connect(heaFloCooRad.port, heaPorRad) annotation (Line(points={{162,-80},{180,
          -80},{180,-40},{200,-40}}, color={191,0,0}));
  connect(heaFloHeaCon.port, heaPorCon) annotation (Line(points={{162,80},{180,
          80},{180,40},{200,40}}, color={191,0,0}));
  connect(heaFloCooCon.port, heaPorCon) annotation (Line(points={{162,60},{180,
          60},{180,40},{200,40}}, color={191,0,0}));
  connect(heaPorCon, T2Mes.port) annotation (Line(points={{200,40},{180,40},{
          180,0},{160,0}}, color={191,0,0}));
  connect(hexHeaCoo.Q_flow, gaiConHea.u)
    annotation (Line(points={{12,0},{40,0},{40,60},{58,60}}, color={0,0,127}));
  connect(gaiConHea[1].y, heaFloHeaCon.Q_flow) annotation (Line(points={{82,60},
          {120,60},{120,80},{142,80}}, color={0,0,127}));
  connect(gaiConHea[2].y, heaFloCooCon.Q_flow)
    annotation (Line(points={{82,60},{142,60}}, color={0,0,127}));
  connect(gaiRadHea[1].y, heaFloHeaRad.Q_flow)
    annotation (Line(points={{82,-60},{142,-60}}, color={0,0,127}));
  connect(gaiRadHea[2].y, heaFloCooRad.Q_flow) annotation (Line(points={{82,-60},
          {120,-60},{120,-80},{142,-80}}, color={0,0,127}));
  connect(hexHeaCoo.Q_flow, gaiRadHea.u) annotation (Line(points={{12,0},{40,0},
          {40,-60},{58,-60}}, color={0,0,127}));
  connect(T2InlVec.y, conTInd.u_m) annotation (Line(points={{108,0},{100,0},{
          100,140},{0,140},{0,208}}, color={0,0,127}));
  connect(uSet, conTInd.u_s)
    annotation (Line(points={{-220,220},{-12,220}}, color={0,0,127}));
  connect(conTInd.y, gaiFloNom1.u)
    annotation (Line(points={{12,220},{158,220}}, color={0,0,127}));
  connect(hexHeaCoo.Q_flow, Q_flow2Act) annotation (Line(points={{12,0},{20,0},
          {20,180},{220,180}}, color={0,0,127}));
end Terminal4PipesHeatPorts;
