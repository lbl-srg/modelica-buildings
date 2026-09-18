within Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.LiquidCooledSinglePhaseRearDoorHex.Examples;
model LiquidCooledSinglePhaseRearDoorHex
  "Example model for hybrid liquid-cooled and air-cooled rack with rear door heat exchanger"
  extends Modelica.Icons.Example;

  package MediumLiq = Buildings.Media.Antifreeze.PropyleneGlycolWater(
    T_default=303.15,
    property_T=303.15,
    X_a=0.25)
    "Propylene glycol for liquid cooling loop";

  package MediumAir = Buildings.Media.Air
    "Medium for air cooling loop";

  package MediumReaDooHex = Buildings.Media.Water
    "Water for rear door heat exchanger loop";

  parameter Modelica.Units.SI.Power PLiq = 48*13200
    "Design power for liquid-cooled IT";
  parameter Modelica.Units.SI.Power PAir = 0.1*PLiq
    "Design power for air-cooled IT";

  parameter Modelica.Units.SI.TemperatureDifference dTLiq_nominal = 7
    "Design temperature difference of liquid coolant";

  parameter Modelica.Units.SI.Temperature TRac_a = 273.15+42
    "Supply coolant temperature to rack at design conditions";

  parameter Modelica.Units.SI.Temperature TAirIn = 273.15+40
    "Air inlet temperature (hot room air entering the rack)";

  parameter Modelica.Units.SI.Temperature TReaDoo_a = 273.15+25
    "Rear door heat exchanger coolant supply temperature";

  parameter Modelica.Units.SI.Temperature TReaDoo_b_set = 273.15+35
    "Rear door heat exchanger coolant outlet temperature setpoint";

  final parameter Modelica.Units.SI.MassFlowRate mLiq_flow_nominal=
    PLiq/dTLiq_nominal/cp_default
    "Nominal mass flow rate for liquid cooling at design conditions";

  final parameter Modelica.Units.SI.MassFlowRate mReaDoo_flow_nominal=
    PAir/((TReaDoo_b_set - TReaDoo_a)*Buildings.Utilities.Psychrometrics.Constants.cpWatLiq)
    "Nominal mass flow rate for rear door heat exchanger at design conditions";

  parameter Modelica.Units.SI.SpecificHeatCapacity cp_default=
    MediumLiq.specificHeatCapacityCp(state=state_default)
    "Heat capacity of liquid coolant";

  parameter Buildings.Fluid.DataCenterEquipment.Racks.LiquidCooledSinglePhase.Data.OCP_1kW_OAM_PG25 datLiq(
    PIT_nominal=PLiq,
    m_flow_nominal=mLiq_flow_nominal)
    "Liquid-cooled rack performance data"
    annotation (Placement(transformation(extent={{100,130},{120,150}})));

  parameter Buildings.Fluid.DataCenterEquipment.Racks.AirCooled.Data.Generic
    datAir(PIT_nominal=PAir)
    "Air-cooled rack performance data"
    annotation (Placement(transformation(extent={{100,100},{120,120}})));

  parameter
    Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.Data.LiquidCooledSinglePhaseRearDoorHex.BaseClasses.RearDoorHex
    datReaDooHex(
    mAir_flow_nominal=datAir.m_flow_nominal,
    mCoo_flow_nominal=PAir/10/Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    cpCoo_flow_nominal=Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    Q_flow_nominal=-PAir,
    TCooIn_nominal=TReaDoo_a,
    TAirIn_nominal=TAirIn + datAir.dTAir_nominal,
    PFan_nominal=0.04*PAir) "Rear door heat exchanger performance data"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));

  parameter Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.Data.LiquidCooledSinglePhaseRearDoorHex.Generic dat(
    liq=datLiq,
    air=datAir,
    reaDooHex=datReaDooHex)
    "Hybrid rack performance data"
    annotation (Placement(transformation(extent={{100,160},{120,180}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable utiLiq(
    table=[0,0;
           3600,0;
           4500,0.8;
           5400,0.8;
           5400,0.4;
           6300,0.4;
           6300,0.8],
    extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.HoldLastPoint)
    "Utilization of liquid-cooled hardware"
    annotation (Placement(transformation(extent={{-180,20},{-160,40}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant utiAir(k=1)
    "Utilization of air-cooled hardware"
    annotation (Placement(transformation(extent={{-180,-50},{-160,-30}})));

  Modelica.Blocks.Math.Gain PITLiq(
    k(final unit="W",
      min=0) = datLiq.PIT_nominal,
    u(final unit="1"),
    y(final unit="W"))
    "Power consumption by the liquid-cooled IT equipment"
    annotation (Placement(transformation(extent={{-140,20},{-120,40}})));

  Modelica.Blocks.Math.Gain PITAir(
    k(final unit="W",
      min=0) = datAir.PIT_nominal,
    u(final unit="1"),
    y(final unit="W"))
    "Power consumption by the air-cooled IT equipment"
    annotation (Placement(transformation(extent={{-140,-50},{-120,-30}})));

  Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.LiquidCooledSinglePhaseRearDoorHex.LiquidCooledSinglePhaseRearDoorHex
    rac(
    redeclare package MediumLiq = MediumLiq,
    redeclare package MediumAir = MediumAir,
    redeclare package MediumReaDooHex = MediumReaDooHex,
    dat=dat,
    energyDynamicsLiq=Modelica.Fluid.Types.Dynamics.FixedInitial,
    energyDynamicsAir=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Liquid and air-cooled rack with rear door heat exchanger"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));

  Buildings.Fluid.Movers.Preconfigured.SpeedControlled_y pum(
    redeclare package Medium = MediumLiq,
    m_flow_nominal=mLiq_flow_nominal,
    dp_nominal=50000)
    "Pump for liquid cooling loop"
    annotation (Placement(transformation(extent={{-60,100},{-40,120}})));

  Buildings.Fluid.Sources.Boundary_pT bouLiq(
    redeclare package Medium = MediumLiq,
    nPorts=1)
    "Pressure boundary condition for liquid loop"
    annotation (Placement(transformation(extent={{140,30},{120,50}})));

  Buildings.Fluid.Sources.Boundary_pT souAir(
    redeclare package Medium = MediumAir,
    T=TAirIn,
    nPorts=2)
    "Air source and sink for air cooling loop"
    annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=90,
      origin={0,-100})));

  Buildings.Fluid.Sources.Boundary_pT souReaDoo(
    redeclare package Medium = MediumReaDooHex,
    T=TReaDoo_a,
    p=Buildings.Media.Water.p_default + 100000,
    nPorts=1) "Rear door heat exchanger coolant supply at elevated pressure"
    annotation (Placement(transformation(extent={{-102,-10},{-82,10}})));

  Fluid.Sensors.TemperatureTwoPort senTLiq_a(
    redeclare package Medium = MediumLiq,
    allowFlowReversal=false,
    m_flow_nominal=mLiq_flow_nominal,
    tau=0)
    "Liquid inlet temperature to rack"
    annotation (Placement(transformation(extent={{-30,100},{-10,120}})));

  Fluid.Sensors.TemperatureTwoPort senTLiq_b(
    redeclare package Medium = MediumLiq,
    allowFlowReversal=false,
    m_flow_nominal=mLiq_flow_nominal,
    tau=0)
    "Liquid outlet temperature from rack"
    annotation (Placement(transformation(extent={{48,100},{68,120}})));

  Fluid.Sensors.TemperatureTwoPort senTAir_a(
    redeclare package Medium = MediumAir,
    allowFlowReversal=false,
    m_flow_nominal=datAir.m_flow_nominal,
    tau=0)
    "Air inlet temperature"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-30,-80})));

  Fluid.Sensors.TemperatureTwoPort senTAir_b(
    redeclare package Medium = MediumAir,
    allowFlowReversal=false,
    m_flow_nominal=datAir.m_flow_nominal,
    tau=0)
    "Air outlet temperature after rear door heat exchanger"
    annotation (Placement(transformation(extent={{40,-90},{20,-70}})));

  Fluid.Sensors.TemperatureTwoPort senTReaDoo_b(
    redeclare package Medium = MediumReaDooHex,
    allowFlowReversal=false,
    m_flow_nominal=mReaDoo_flow_nominal,
    tau=0)
    "Rear door heat exchanger coolant outlet temperature"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

  Buildings.Controls.OBC.CDL.Reals.PID conPI(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    k=0.5,
    Ti=60,
    r=datLiq.dp_nominal,
    yMax=1,
    yMin=0.1)
    "PI controller for pump speed to maintain constant pressure across rack"
    annotation (Placement(transformation(extent={{-80,160},{-60,180}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dpSet(k=datLiq.dp_nominal)
    "Pressure drop setpoint across rack"
    annotation (Placement(transformation(extent={{-120,160},{-100,180}})));

  Buildings.Fluid.HeatExchangers.SensibleCooler_T coo(
    redeclare package Medium = MediumLiq,
    m_flow_nominal=mLiq_flow_nominal,
    dp_nominal=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Cooler to maintain supply temperature"
    annotation (Placement(transformation(extent={{-110,100},{-90,120}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSetCoo(k=TRac_a)
    "Temperature setpoint for cooler"
    annotation (Placement(transformation(extent={{-180,108},{-160,128}})));

  Fluid.Sensors.RelativePressure senRelPre(redeclare package Medium = MediumLiq)
    "Relative pressure sensor across rack"
    annotation (Placement(transformation(
      extent={{10,-10},{-10,10}},
      rotation=180,
      origin={18,80})));

protected
  parameter MediumLiq.ThermodynamicState state_default = MediumLiq.setState_pTX(
    T=MediumLiq.T_default,
    p=MediumLiq.p_default,
    X=MediumLiq.X_default[1:MediumLiq.nXi])
    "Medium state at default values";

public
  Sources.Boundary_pT sinReaDoo(
    redeclare package Medium = MediumReaDooHex,
    p=Buildings.Media.Water.p_default,
    nPorts=1) "Sink rear door heat exchanger coolant"
    annotation (Placement(transformation(extent={{138,-10},{118,10}})));
equation
  connect(senTLiq_a.port_b, rac.portLiq_a)
    annotation (Line(points={{-10,110},{0,110},{0,4},{10,4}},
                                                            color={0,127,255}));
  connect(rac.portLiq_b, senTLiq_b.port_a)
    annotation (Line(points={{30,4},{40,4},{40,110},{48,110}},
                                                             color={0,127,255}));
  connect(senTLiq_b.port_b, bouLiq.ports[1])
    annotation (Line(points={{68,110},{82,110},{82,40},{120,40}},
                                                color={0,127,255}));
  connect(senTAir_a.port_b, rac.portAir_a)
    annotation (Line(points={{-40,-80},{-60,-80},{-60,-60},{0,-60},{0,-4},{10,
          -4}},                                                 color={0,127,255}));
  connect(rac.portAir_b, senTAir_b.port_a)
    annotation (Line(points={{30.2,-4},{48,-4},{48,-80},{40,-80}},
                                                                 color={0,127,255}));
  connect(senTAir_a.port_a, souAir.ports[1])
    annotation (Line(points={{-20,-80},{1,-80},{1,-90}},                       color={0,127,255}));
  connect(senTAir_b.port_b, souAir.ports[2])
    annotation (Line(points={{20,-80},{-1,-80},{-1,-90}},                   color={0,127,255}));
  connect(pum.port_b, senTLiq_a.port_a)
    annotation (Line(points={{-40,110},{-30,110}},
                                                 color={0,127,255}));
  connect(bouLiq.ports[1], coo.port_a)
    annotation (Line(points={{120,40},{82,40},{82,150},{-126,150},{-126,110},{
          -110,110}},                                                                   color={0,127,255}));
  connect(dpSet.y, conPI.u_s)
    annotation (Line(points={{-98,170},{-82,170}}, color={0,0,127}));
  connect(conPI.y, pum.y)
    annotation (Line(points={{-58,170},{-50,170},{-50,122}},color={0,0,127}));
  connect(coo.port_b, pum.port_a)
    annotation (Line(points={{-90,110},{-60,110}},
                                                 color={0,127,255}));
  connect(TSetCoo.y, coo.TSet)
    annotation (Line(points={{-158,118},{-112,118}},
                                                   color={0,0,127}));
  connect(senTLiq_b.port_a, senRelPre.port_b)
    annotation (Line(points={{48,110},{40,110},{40,80},{28,80}},
                                               color={0,127,255}));
  connect(senRelPre.p_rel, conPI.u_m)
    annotation (Line(points={{18,89},{18,140},{-70,140},{-70,158}},
                                                                  color={0,0,127}));
  connect(senRelPre.port_a, senTLiq_a.port_b)
    annotation (Line(points={{8,80},{0,80},{0,110},{-10,110}},
                                                color={0,127,255}));
  connect(utiLiq.y[1], PITLiq.u)
    annotation (Line(points={{-158,30},{-142,30}}, color={0,0,127}));
  connect(PITLiq.y, rac.PLiq)
    annotation (Line(points={{-119,30},{-40,30},{-40,8.2},{9,8.2}},
                                                                color={0,0,127}));
  connect(utiAir.y, PITAir.u)
    annotation (Line(points={{-158,-40},{-142,-40}}, color={0,0,127}));
  connect(PITAir.y, rac.PAir)
    annotation (Line(points={{-119,-40},{-40,-40},{-40,-8},{9,-8}}, color={0,0,127}));
  connect(rac.portReaDooHex_b, senTReaDoo_b.port_a)
    annotation (Line(points={{30,0},{60,0}}, color={0,127,255}));
  connect(rac.portReaDooHex_a, souReaDoo.ports[1]) annotation (Line(points={{10,
          0},{-36,0},{-36,0},{-82,0}}, color={0,127,255}));
  connect(senTReaDoo_b.port_b, sinReaDoo.ports[1]) annotation (Line(points={{80,
          0},{100,0},{100,0},{118,0}}, color={0,127,255}));
  annotation (
    Diagram(coordinateSystem(extent={{-200,-120},{150,200}})),
    experiment(
      StopTime=7200,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/DataCenterEquipment/Racks/Hybrid/LiquidCooledSinglePhaseRearDoorHex/Examples/LiquidCooledSinglePhaseRearDoorHex.mos"
          "Simulate and plot"),
    Documentation(info="<html>
<p>
Example model of a hybrid IT rack with liquid-cooled, air-cooled, and rear door
heat exchanger components.
This model extends the structure of
<a href=\"modelica://Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.LiquidCooledSinglePhase.Examples.LiquidCooledSinglePhase\">
Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.LiquidCooledSinglePhase.Examples.LiquidCooledSinglePhase</a>
by adding a rear door heat exchanger cooling loop.
</p>
<p>
The room inlet air temperature is set to <i>40</i> &deg;C (hot room).
The air-cooled rack raises the air temperature by <i>10</i> K, so the air
entering the rear door heat exchanger is at approximately <i>50</i> &deg;C.
</p>
<p>
Water at <i>25</i> &deg;C is supplied to the rear door heat exchanger.
A PI controller maintains the coolant outlet temperature at <i>35</i> &deg;C
by adjusting the position of a two-way linear valve on the supply side.
When the coolant outlet temperature falls below the setpoint, the controller
opens the valve further to increase the coolant flow rate until the setpoint
is reached.
At nominal IT load, the water flow rate is approximately
<i>1.5</i> kg/s.
</p>
<p>
The liquid cooling and pump control loops operate identically to the
base example, with a supply temperature of <i>42</i> &deg;C maintained
by a sensible cooler upstream of the variable-speed pump.
</p>
</html>", revisions="<html>
<ul>
<li>
September 13, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end LiquidCooledSinglePhaseRearDoorHex;
