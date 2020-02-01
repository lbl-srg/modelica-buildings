within Buildings.Applications.DHC.Loads.Validation.BaseClasses;
model Terminal4PipesHeatPorts
  extends Buildings.Applications.DHC.Loads.BaseClasses.PartialTerminalUnit(
    redeclare package Medium1 = Buildings.Media.Water,
    redeclare package Medium2 = Buildings.Media.Air,
    final have_watHea=true,
    final have_watCoo=true,
    final have_heaPor=true,
    final mHeaWat_flow_nominal=abs(QHea_flow_nominal/cpHeaWat_nominal/(
      T_aHeaWat_nominal - T_bHeaWat_nominal)),
    final mChiWat_flow_nominal=abs(QCoo_flow_nominal/cpChiWat_nominal/(
      T_aChiWat_nominal - T_bChiWat_nominal)));
  import hexConfiguration = Buildings.Fluid.Types.HeatExchangerConfiguration;
  parameter hexConfiguration hexConHea=
    hexConfiguration.ConstantTemperaturePhaseChange
    "Heating heat exchanger configuration";
  parameter hexConfiguration hexConCoo=
    hexConfiguration.ConstantTemperaturePhaseChange
    "Cooling heat exchanger configuration";
  parameter Integer nPorts1 = 2
    "Number of inlet (or outlet) fluid ports on the source side";
  // TODO: assign HX flow regime based on HX configuration.
  parameter Buildings.Fluid.Types.HeatExchangerFlowRegime hexReg[nPorts1]=
    fill(Buildings.Fluid.Types.HeatExchangerFlowRegime.ConstantTemperaturePhaseChange,
      nPorts1);
  parameter Real fraCon[nPorts1] = fill(0.7, nPorts1)
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
    {mHeaWat_flow_nominal,mChiWat_flow_nominal} .* {cpHeaWat_nominal,cpChiWat_nominal}
    "Minimum capacity flow rate at nominal conditions";
  final parameter Modelica.SIunits.ThermalConductance CMax_nominal[nPorts1]=
    fill(Modelica.Constants.inf, nPorts1)
    "Maximum capacity flow rate at nominal conditions";
  final parameter Real Z = 0
    "Ratio of capacity flow rates (CMin/CMax) at nominal conditions";
    // CMin_nominal / CMax_nominal
  final parameter Modelica.SIunits.ThermalConductance UA_nominal[nPorts1]=
    Buildings.Fluid.HeatExchangers.BaseClasses.ntu_epsilonZ(
      eps={QHea_flow_nominal, QCoo_flow_nominal} ./ abs(CMin_nominal .*
        ({T_aHeaWat_nominal, T_aChiWat_nominal} .- {T_aLoaHea_nominal, T_aLoaCoo_nominal})),
      Z=0,
      flowRegime=Integer(hexReg)) .* CMin_nominal
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
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gaiFloNom1[nPorts1](
    k={mHeaWat_flow_nominal,mChiWat_flow_nominal})
    annotation (Placement(transformation(extent={{40,90},{60,110}})));
  Buildings.Applications.DHC.Loads.BaseClasses.EffectivenessNTUUniform hexHeaCoo[nPorts1](
    redeclare each final package Medium1 = Medium1,
    redeclare each final package Medium2 = Medium2,
    final Q_flow_nominal={QHea_flow_nominal,QCoo_flow_nominal},
    final T_a1_nominal={T_aHeaWat_nominal,T_aChiWat_nominal},
    final T_a2_nominal={T_aLoaHea_nominal,T_aLoaCoo_nominal},
    final m1_flow_nominal={mHeaWat_flow_nominal,mChiWat_flow_nominal})
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
        origin={152,60})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow heaFloCooCon
    "Convective heat flow rate to load"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={152,40})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo[nPorts1](
    redeclare each final package Medium=Medium1)
    annotation (Placement(transformation(extent={{-150,-210},{-130,-190}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator T2InlVec(nout=nPorts1)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={120,0})));
  Buildings.Fluid.HeatExchangers.HeaterCooler_u heaCoo[nPorts1](
    redeclare each final package Medium = Medium1,
    each final dp_nominal=0,
    final m_flow_nominal={mHeaWat_flow_nominal,mChiWat_flow_nominal},
    each energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    each final Q_flow_nominal=-1) "Heat exchange with water stream"
    annotation (Placement(transformation(extent={{60,-210},{80,-190}})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow heaFloCooRad
    "Radiative heat flow rate to load"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={152,-60})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow heaFloHeaRad
    "Radiative heat flow rate to load"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={152,-40})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gaiConHea[nPorts1](k=fraCon)
    annotation (Placement(transformation(extent={{60,30},{80,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gaiRadHea[nPorts1](k=1 .- fraCon)
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort T1HeaInl(
    redeclare final package Medium=Medium1,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final tau=0,
    final allowFlowReversal=allowFlowReversal)
    "Heating water inlet temperature (sensed, steady-state)"
    annotation (Placement(transformation(extent={{-190,-230},{-170,-210}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort T1CooInl(
    redeclare final package Medium=Medium1,
    final m_flow_nominal=mChiWat_flow_nominal,
    final tau=0,
    final allowFlowReversal=allowFlowReversal)
    "Chilled water inlet temperature (sensed, steady-state)"
    annotation (Placement(transformation(extent={{-190,-190},{-170,-170}})));
equation
  connect(senMasFlo.m_flow, hexHeaCoo.m1_flow)
    annotation (Line(points={{-140,-189},{-140,4},{-12,4}}, color={0,0,127}));
  connect(T2Mes.T, T2InlVec.u)
    annotation (Line(points={{140,0},{134,0},{134,-1.33227e-15},{132,-1.33227e-15}},
                                                  color={0,0,127}));
  connect(heaFloHeaRad.port, heaPorRad) annotation (Line(points={{162,-40},{200,
          -40}},                     color={191,0,0}));
  connect(heaFloCooRad.port, heaPorRad) annotation (Line(points={{162,-60},{180,
          -60},{180,-40},{200,-40}}, color={191,0,0}));
  connect(heaFloHeaCon.port, heaPorCon) annotation (Line(points={{162,60},{180,60},
          {180,40},{200,40}},     color={191,0,0}));
  connect(heaFloCooCon.port, heaPorCon) annotation (Line(points={{162,40},{200,40}},
                                  color={191,0,0}));
  connect(heaPorCon, T2Mes.port) annotation (Line(points={{200,40},{180,40},{180,
          0},{160,0}},     color={191,0,0}));
  connect(gaiConHea[1].y, heaFloHeaCon.Q_flow) annotation (Line(points={{82,40},
          {120,40},{120,60},{142,60}}, color={0,0,127}));
  connect(gaiConHea[2].y, heaFloCooCon.Q_flow)
    annotation (Line(points={{82,40},{142,40}}, color={0,0,127}));
  connect(gaiRadHea[1].y, heaFloHeaRad.Q_flow)
    annotation (Line(points={{82,-40},{142,-40}}, color={0,0,127}));
  connect(gaiRadHea[2].y, heaFloCooRad.Q_flow) annotation (Line(points={{82,-40},
          {120,-40},{120,-60},{142,-60}}, color={0,0,127}));
  connect(T2InlVec.y, conTInd.u_m) annotation (Line(points={{108,1.55431e-15},{100,
          1.55431e-15},{100,80},{0,80},{0,88}},
                                     color={0,0,127}));
  connect(conTInd.y, gaiFloNom1.u)
    annotation (Line(points={{12,100},{38,100}},  color={0,0,127}));
  connect(senMasFlo.port_b, heaCoo.port_a)
    annotation (Line(points={{-130,-200},{60,-200}}, color={0,127,255}));
  connect(heaCoo[1].port_b, port_bHeaWat) annotation (Line(points={{80,-200},{140,
          -200},{140,-220},{200,-220}}, color={0,127,255}));
  connect(heaCoo[2].port_b, port_bChiWat) annotation (Line(points={{80,-200},{140,
          -200},{140,-180},{200,-180}}, color={0,127,255}));
  connect(TSetHea, conTInd[1].u_s) annotation (Line(points={{-220,220},{-116,220},
          {-116,100},{-12,100}}, color={0,0,127}));
  connect(TSetCoo, conTInd[2].u_s) annotation (Line(points={{-220,180},{-116,180},
          {-116,100},{-12,100}}, color={0,0,127}));
  connect(port_aHeaWat, T1HeaInl.port_a)
    annotation (Line(points={{-200,-220},{-190,-220}}, color={0,127,255}));
  connect(T1HeaInl.T, hexHeaCoo[1].T_in1)
    annotation (Line(points={{-180,-209},{-180,-200},{-166,-200},{-166,0},{-12,0}},
                                                            color={0,0,127}));
  connect(T1HeaInl.port_b, senMasFlo[1].port_a) annotation (Line(points={{-170,-220},
          {-160,-220},{-160,-200},{-150,-200}}, color={0,127,255}));
  connect(port_aChiWat, T1CooInl.port_a)
    annotation (Line(points={{-200,-180},{-190,-180}}, color={0,127,255}));
  connect(T1CooInl.port_b, senMasFlo[2].port_a) annotation (Line(points={{-170,-180},
          {-160,-180},{-160,-200},{-150,-200}}, color={0,127,255}));
  connect(T1CooInl.T, hexHeaCoo[2].T_in1)
    annotation (Line(points={{-180,-169},{-180,0},{-12,0}}, color={0,0,127}));
  connect(gaiFloNom1[1].y,scaMasFloReqHeaWat.u)
    annotation (Line(points={{62,100},{158,100}}, color={0,0,127}));
  connect(gaiFloNom1[2].y, scaMasFloReqChiWat.u) annotation (Line(points={{62,
          100},{140,100},{140,80},{158,80}}, color={0,0,127}));
  connect(hexHeaCoo.Q2_flow, gaiConHea.u) annotation (Line(points={{12,-6},{20,-6},
          {20,40},{58,40}}, color={0,0,127}));
  connect(hexHeaCoo.Q2_flow, gaiRadHea.u) annotation (Line(points={{12,-6},{20,-6},
          {20,-40},{58,-40}}, color={0,0,127}));
  connect(hexHeaCoo[1].Q2_flow, scaQActHea_flow.u) annotation (Line(points={{12,
          -6},{20,-6},{20,220},{158,220}}, color={0,0,127}));
  connect(hexHeaCoo[2].Q2_flow, scaQActCoo_flow.u) annotation (Line(points={{12,
          -6},{20,-6},{20,200},{158,200}}, color={0,0,127}));
  connect(hexHeaCoo.Q2_flow, heaCoo.u) annotation (Line(points={{12,-6},{20,-6},
          {20,-194},{58,-194}}, color={0,0,127}));
  connect(T2InlVec.y, hexHeaCoo.T_in2) annotation (Line(points={{108,0},{100,0},
          {100,-20},{-20,-20},{-20,-4},{-12,-4}}, color={0,0,127}));
end Terminal4PipesHeatPorts;
