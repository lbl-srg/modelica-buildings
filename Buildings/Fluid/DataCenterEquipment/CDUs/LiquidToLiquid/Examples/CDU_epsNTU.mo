within Buildings.Fluid.DataCenterEquipment.CDUs.LiquidToLiquid.Examples;
model CDU_epsNTU "Example model of a CDU with varying load on the IT side"
  extends Modelica.Icons.Example;

  package MediumChi = Buildings.Media.Water "Medium for chilled water loop";
  package MediumRac = Buildings.Media.Antifreeze.PropyleneGlycolWater(
    T_default=303.15,
    property_T=303.15,
    X_a=Buildings.Media.Antifreeze.Functions.PropyleneGlycolWater.volumeToMassFraction(
        phi=0.25,
        T=293.15))
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
  parameter Modelica.Units.SI.PressureDifference dpRac_nominal(
    displayUnit="Pa") = 60000
    "Rack design pressure drop";
  parameter Modelica.Units.SI.PressureDifference dpHexChi_nominal(
    displayUnit="Pa")=80000
    "Heat exchanger design pressure drop on chiller side";

  parameter Buildings.Fluid.DataCenterEquipment.CDUs.LiquidToLiquid.Data.Generic_epsNTU datCDU(
    Q_flow_nominal=-PRac,
    TRacOut_nominal=TRac_a,
    mPla_flow_nominal=mChi_flow_nominal,
    mRac_flow_nominal=mRac_flow_nominal,
    dpHexPla_nominal=dpHexChi_nominal,
    medPla=Buildings.Fluid.DataCenterEquipment.CDUs.Types.Media.Water,
    phiGlyPla=0,
    medRac=Buildings.Fluid.DataCenterEquipment.CDUs.Types.Media.PropyleneGlycol,
    phiGlyRac=0.25,
    TApp_nominal=6,
    dpPumpExt_nominal(displayUnit="Pa") = dpRac_nominal,
    pumpExtHead(
      V_flow=mRac_flow_nominal/1010*{0.000, 0.250, 0.500, 0.750, 1.000},
      dp=dpRac_nominal*({11.90, 11.61, 9.810, 6.202, 1.0})))
    "Data performance record for CDU"
    annotation (Placement(transformation(extent={{80,60},{100,80}})));
  parameter
    Buildings.Fluid.DataCenterEquipment.Racks.LiquidCooledSinglePhase.Data.OCP_1kW_OAM_PG25
    datRac(
    PIT_nominal=PRac,
    m_flow_nominal=mRac_flow_nominal,
    dp_nominal=dpRac_nominal) "Rack performance data"
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse uti(
    amplitude=0.4,
    width=0.5,
    period=3600,
    shift=900,
    offset=0.6)
    "Utilization of hardware"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Fluid.DataCenterEquipment.Racks.LiquidCooledSinglePhase.ColdPlateR_P
    rac(
    redeclare package Medium = MediumRac,
    allowFlowReversal=false,
    dat=datRac,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Rack with cold plate heat exchangers, modeled for simplicity as one large rack"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Buildings.Fluid.Sources.Boundary_pT bou(
    redeclare package Medium = MediumChi,
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

  Buildings.Fluid.DataCenterEquipment.CDUs.LiquidToLiquid.CDU_epsNTU cdu(
    redeclare package MediumPla = MediumChi,
    redeclare package MediumRac = MediumRac,
    allowFlowReversalRac=false,
    final dat=datCDU,
    allowFlowReversalPla=false,
    yPum_start=1) "CDU, modelled for simplicity as one large CDU"
    annotation (Placement(transformation(extent={{-10,16},{10,36}})));
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
    annotation (Placement(transformation(extent={{-70,10},{-90,30}})));
  Fluid.Sensors.TemperatureTwoPort senTRac_b(
    redeclare package Medium = MediumRac,
    allowFlowReversal=false,
    m_flow_nominal=mRac_flow_nominal,
    tau=0) "Rack outlet temperature"
    annotation (Placement(transformation(extent={{80,10},{60,30}})));
  Controls.OBC.CDL.Reals.Sources.Constant dpSet(k=50000) "Set point for head"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Controls.OBC.CDL.Reals.Sources.Constant TSetRacIn(k=TRac_a)
    "Set point for rack inlet temperature"
    annotation (Placement(transformation(extent={{-60,72},{-40,92}})));


  Modelica.Blocks.Math.Gain PITAir(
    k(final unit="W",
      min=0) = datRac.PIT_nominal,
    u(final unit="1"),
    y(final unit="W"))
    "Power consumption by the air-cooled IT equipment"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
equation
  connect(sou.ports[1], senTCDU_a.port_a)
    annotation (Line(points={{-80,120},{-50,120}},
                                                 color={0,127,255}));
  connect(senTCDU_a.port_b, cdu.port_aPla) annotation (Line(points={{-30,120},{
          -20,120},{-20,32},{-10,32}},
                                    color={0,127,255}));
  connect(cdu.port_bPla, senTCDU_b.port_a) annotation (Line(points={{10,32},{20,
          32},{20,120},{30,120}},
                            color={0,127,255}));
  connect(senTCDU_b.port_b, bou.ports[1])
    annotation (Line(points={{50,120},{90,120}},
                                               color={0,127,255}));
  connect(cdu.port_bRac, senTRac_a.port_a)
    annotation (Line(points={{-10,20},{-70,20}}, color={0,127,255}));
  connect(senTRac_a.port_b, rac.port_a) annotation (Line(points={{-90,20},{-100,
          20},{-100,-60},{-10,-60}},
                              color={0,127,255}));
  connect(rac.port_b, senTRac_b.port_a) annotation (Line(points={{10,-60},{86,
          -60},{86,20},{80,20}},
                            color={0,127,255}));
  connect(senTRac_b.port_b, cdu.port_aRac) annotation (Line(points={{60,20},{10,
          20}},             color={0,127,255}));
  connect(dpSet.y, cdu.dpSet) annotation (Line(points={{-38,40},{-28,40},{-28,
          24},{-12,24}},
                     color={0,0,127}));
  connect(cdu.TSet, TSetRacIn.y) annotation (Line(points={{-12,28},{-24,28},{
          -24,82},{-38,82}}, color={0,0,127}));
  connect(uti.y, PITAir.u)
    annotation (Line(points={{-58,-30},{-42,-30}}, color={0,0,127}));
  connect(PITAir.y, rac.P) annotation (Line(points={{-19,-30},{-16,-30},{-16,
          -54},{-11,-54}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-120,-120},{120,140}})), Icon(
        coordinateSystem(extent={{-100,-100},{100,100}})),
    experiment(
      StopTime=7200,
      Tolerance=1e-06),
      __Dymola_Commands(
       file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/DataCenterEquipment/CDUs/LiquidToLiquid/Examples/CDU_epsNTU.mos" "Simulate and plot"),
    Documentation(info="<html>
<p>
Example model of a CDU that serves liquid cooled racks.
</p>
<p>
The IT load is specified using a periodic pulse input.
This load is cooled by a propylene glycol loop, which exchanges
heat through the CDU with a chilled water supply.
The chilled water is assumed to be delivered at constant temperature.
A PI controller regulates the chilled water flow rate through the control
valve in the CDU in order to track the propylene glycol temperature that is sent
to the IT rack.
</p>
</html>", revisions="<html>
<ul>
<li>
December 23, 2025, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end CDU_epsNTU;
