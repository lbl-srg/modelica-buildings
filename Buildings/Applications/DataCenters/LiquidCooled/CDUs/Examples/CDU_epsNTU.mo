within Buildings.Applications.DataCenters.LiquidCooled.CDUs.Examples;
model CDU_epsNTU "Example model of a CDU with varying load on the IT side"
  extends Modelica.Icons.Example;

  package MediumChi = Buildings.Media.Water "Medium for chilled water loop";
  package MediumRac = Buildings.Media.Antifreeze.PropyleneGlycolWater(
    T_default=303.15,
    property_T=303.15,
    X_a=0.25)
    "Medium for rack";
  parameter Modelica.Units.SI.Power PRac = 48*132000
    "Total rack design power";
  parameter Modelica.Units.SI.Temperature TRac_a = 273.15+42
    "Supply coolant temperature to rack at design conditions";
  parameter Modelica.Units.SI.Temperature TRac_b = 273.15+47
    "Return coolant temperature from rack at design conditions";
  parameter Modelica.Units.SI.Temperature TChi_a = 273.15+36
    "Supply chilled water temperature to CDU at design conditions";
  parameter Modelica.Units.SI.Temperature TChi_b = 273.15+41
    "Return chilled temperature from CDU at design conditions";

  parameter Modelica.Units.SI.MassFlowRate mRac_flow_nominal =
    PRac/(TRac_b-TRac_a)/MediumRac.cp_const
    "Rack mass flow rate at design conditions";
  parameter Modelica.Units.SI.MassFlowRate mChi_flow_nominal =
    PRac/(TChi_b-TChi_a)/MediumChi.cp_const
    "Chilled water mass flow rate at design conditions";
  parameter Modelica.Units.SI.PressureDifference dPRac_nominal = 60000
    "Rack design pressure drop";
  parameter Buildings.Applications.DataCenters.LiquidCooled.Racks.Data.OCP_1kW_OAM_PG25 datTheRes
    "Thermal resistance data"
    annotation (Placement(transformation(extent={{60,-108},{80,-88}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse uti(
    amplitude=0.4,
    width=0.5,
    period=3600,
    shift=900,
    offset=0.62)
    "Utilization of hardware"
    annotation (Placement(transformation(extent={{-50,-40},{-30,-20}})));
  Buildings.Applications.DataCenters.LiquidCooled.Racks.ColdPlateR_P rac(
    redeclare package Medium = MediumRac,
    allowFlowReversal=false,
    Q_flow_nominal=PRac,
    m_flow_nominal=mRac_flow_nominal,
    datTheRes=datTheRes,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Rack with cold plate heat exchangers, modeled for simplicity as one large rack"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
  Buildings.Fluid.Sources.Boundary_pT bou(redeclare package Medium = MediumChi,
    p(displayUnit="Pa") = 300000,
    T=TChi_b,
      nPorts=1) "Pressure boundary condition"
    annotation (Placement(transformation(extent={{110,110},{90,130}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTCDU_a(
    redeclare package Medium = MediumChi,
    allowFlowReversal=false,
    m_flow_nominal=mChi_flow_nominal,
    tau=0) "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-50,110},{-30,130}})));

  Buildings.Applications.DataCenters.LiquidCooled.CDUs.CDU_epsNTU cdu(
    redeclare package Medium1 = MediumChi,
    redeclare package Medium2 = MediumRac,
    allowFlowReversal1=false,
    allowFlowReversal2=false,
    m1_flow_nominal=mChi_flow_nominal,
    m2_flow_nominal=mRac_flow_nominal,
    Q_flow_nominal=-PRac,
    T_a1_nominal=TChi_a,
    T_a2_nominal=TRac_a,
    dpHex1_nominal=dpHexChi_nominal,
    dpPum_nominal=dPRac_nominal,
    yPum_start=1)
    "CDU, modeled for simplicity as one large CDU"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Fluid.Sources.Boundary_pT sou(redeclare package Medium = MediumChi,
    p=300000 + 2*dpHexChi_nominal,
    T=TChi_a,
    nPorts=1)
    "Pressure boundary condition" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,120})));
  Fluid.Sensors.TemperatureTwoPort senTCDU_b(
    redeclare package Medium = MediumChi,
    allowFlowReversal=false,
    m_flow_nominal=mChi_flow_nominal,
    tau=0) "Outlet temperature"
    annotation (Placement(transformation(extent={{30,110},{50,130}})));
  Fluid.Sensors.TemperatureTwoPort senTRac_a(
    redeclare package Medium = MediumRac,
    allowFlowReversal=false,
    m_flow_nominal=mRac_flow_nominal,
    tau=0) "Rack inlet temperature"
    annotation (Placement(transformation(extent={{-30,24},{-50,44}})));
  Fluid.Sensors.TemperatureTwoPort senTRac_b(
    redeclare package Medium = MediumRac,
    allowFlowReversal=false,
    m_flow_nominal=mRac_flow_nominal,
    tau=0) "Rack outlet temperature"
    annotation (Placement(transformation(extent={{50,24},{30,44}})));
  Fluid.Sources.Boundary_pT preSou(redeclare package Medium = MediumRac, nPorts=1)
          "Pressure boundary condition"
    annotation (Placement(transformation(extent={{110,-70},{90,-50}})));
  Controls.OBC.CDL.Reals.Sources.Constant        yPum(k=1)
    "Pump control signal"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Controls.OBC.CDL.Reals.PID conVal(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    Ti=120,
    r=10,
    xi_start=1,
    reverseActing=false)
          "Controller for valve"
    annotation (Placement(transformation(extent={{-50,60},{-30,80}})));
  Controls.OBC.CDL.Reals.Sources.Constant TSetRacIn(k=TRac_a)
    "Set point for rack inlet temperature"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  parameter Modelica.Units.SI.PressureDifference dpHexChi_nominal=80000
    "Heat exchanger design pressure drop on chiller side";
equation
  connect(uti.y, rac.u) annotation (Line(points={{-28,-30},{-20,-30},{-20,-54},{
          -1,-54}},  color={0,0,127}));
  connect(sou.ports[1], senTCDU_a.port_a)
    annotation (Line(points={{-80,120},{-50,120}},
                                                 color={0,127,255}));
  connect(senTCDU_a.port_b, cdu.port_a1) annotation (Line(points={{-30,120},{-20,
          120},{-20,46},{-10,46}},color={0,127,255}));
  connect(cdu.port_b1, senTCDU_b.port_a) annotation (Line(points={{10,46},{20,46},
          {20,120},{30,120}},
                            color={0,127,255}));
  connect(senTCDU_b.port_b, bou.ports[1])
    annotation (Line(points={{50,120},{90,120}},
                                               color={0,127,255}));
  connect(yPum.y, cdu.yPum) annotation (Line(points={{-28,0},{-20,0},{-20,31},{-12,
          31}},      color={0,0,127}));
  connect(TSetRacIn.y, conVal.u_s)
    annotation (Line(points={{-78,70},{-52,70}}, color={0,0,127}));
  connect(senTRac_a.T, conVal.u_m)
    annotation (Line(points={{-40,45},{-40,58}},  color={0,0,127}));
  connect(conVal.y, cdu.yVal) annotation (Line(points={{-28,70},{-16,70},{-16,49},
          {-12,49}}, color={0,0,127}));
  connect(cdu.port_b2, senTRac_a.port_a)
    annotation (Line(points={{-10,34},{-30,34}}, color={0,127,255}));
  connect(senTRac_a.port_b, rac.port_a) annotation (Line(points={{-50,34},{-72,34},
          {-72,-60},{0,-60}}, color={0,127,255}));
  connect(rac.port_b, senTRac_b.port_a) annotation (Line(points={{20,-60},{70,-60},
          {70,34},{50,34}}, color={0,127,255}));
  connect(senTRac_b.port_b, cdu.port_a2) annotation (Line(points={{30,34},{22,34},
          {22,34},{10,34}}, color={0,127,255}));
  connect(rac.port_b, preSou.ports[1])
    annotation (Line(points={{20,-60},{90,-60}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(extent={{-120,-120},{120,140}})), Icon(
        coordinateSystem(extent={{-100,-100},{100,100}})),
    experiment(
      StopTime=7200,
      Tolerance=1e-05,
      __Dymola_Algorithm="Cvode"));
end CDU_epsNTU;
