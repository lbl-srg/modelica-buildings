within Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.LiquidCooledSinglePhase.Examples;
model LiquidCooledSinglePhase
  "Example model for hybrid liquid-cooled and air-cooled rack"
  extends Modelica.Icons.Example;

  package MediumLiq = Buildings.Media.Antifreeze.PropyleneGlycolWater(
    T_default=303.15,
    property_T=303.15,
    X_a=0.25)
    "Propylene glycol";

  package MediumAir = Buildings.Media.Air
    "Medium for air cooling loop";

  parameter Modelica.Units.SI.Power PLiq_nominal=48*13200
    "Design power for liquid-cooled IT";
  parameter Modelica.Units.SI.Power PAir_nominal=0.1*PLiq_nominal
    "Design power for air-cooled IT";

  parameter Modelica.Units.SI.TemperatureDifference dTLiq_nominal = 7
    "Design temperature difference of liquid coolant";

  parameter Modelica.Units.SI.Temperature TLiqIn_nominal=273.15 + 42
    "Supply coolant temperature to rack at design conditions";

  final parameter Modelica.Units.SI.MassFlowRate mLiq_flow_nominal=
    PLiq_nominal/dTLiq_nominal/cpLiq_default
    "Nominal mass flow rate for liquid cooling at design conditions";

  parameter Modelica.Units.SI.SpecificHeatCapacity cpLiq_default=
      MediumLiq.specificHeatCapacityCp(
        state=MediumLiq.setState_pTX(
          T=MediumLiq.T_default,
          p=MediumLiq.p_default,
        X=MediumLiq.X_default[1:MediumLiq.nXi]))
   "Heat capacity of liquid coolant";

  parameter Modelica.Units.SI.PressureDifference dpValve_nominal=5000
    "Nominal pressure drop of fully open valve";

  parameter Buildings.Fluid.DataCenterEquipment.Racks.LiquidCooledSinglePhase.Data.OCP_1kW_OAM_PG25 datLiq(
      PIT_nominal=PLiq_nominal,
      m_flow_nominal=mLiq_flow_nominal)
    "Liquid-cooled rack performance data"
    annotation (Placement(transformation(extent={{160,110},{180,130}})));

  parameter Buildings.Fluid.DataCenterEquipment.Racks.AirCooled.Data.Generic datAir(
    PIT_nominal=PAir_nominal) "Air-cooled rack performance data"
    annotation (Placement(transformation(extent={{160,80},{180,100}})));

  replaceable parameter Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.Data.LiquidCooledSinglePhase.Generic dat
    constrainedby Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.Data.LiquidCooledSinglePhase.Generic(
      liq=datLiq,
      air=datAir) "Hybrid rack performance data"
    annotation (Placement(transformation(extent={{160,140},{180,160}})));

  parameter Modelica.Units.SI.Temperature TAirDatHal = 303.15
    "Air temperature in data hall";
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable utiLiq(
    table=[0,0;
            900,0;
           1800,0.5;
           5400,0.5;
           6300,1;
           7200,1],
    extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.HoldLastPoint)
    "Utilization of liquid-cooled hardware"
    annotation (Placement(transformation(extent={{-220,0},{-200,20}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant utiAir(k=0.8)
    "Utilization of air-cooled hardware"
    annotation (Placement(transformation(extent={{-220,-30},{-200,-10}})));

  Modelica.Blocks.Math.Gain PITLiq(
    k(final unit="W",
      min=0) = datLiq.PIT_nominal,
    u(final unit="1"),
    y(final unit="W"))
    "Power consumption by the liquid-cooled IT equipment"
    annotation (Placement(transformation(extent={{-180,0},{-160,20}})));

  Modelica.Blocks.Math.Gain PITAir(
    k(final unit="W",
      min=0) = datAir.PIT_nominal,
    u(final unit="1"),
    y(final unit="W"))
    "Power consumption by the air-cooled IT equipment"
    annotation (Placement(transformation(extent={{-180,-30},{-160,-10}})));

  replaceable Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.LiquidCooledSinglePhase.LiquidCooledSinglePhase rac
    constrainedby Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.LiquidCooledSinglePhase.LiquidCooledSinglePhase(
    redeclare package MediumLiq = MediumLiq,
    redeclare package MediumAir = MediumAir,
    dat=dat,
    energyDynamicsLiq=Modelica.Fluid.Types.Dynamics.FixedInitial,
    energyDynamicsAir=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Liquid and air-cooled rack"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  Buildings.Fluid.Movers.Preconfigured.SpeedControlled_y pum(
    redeclare package Medium = MediumLiq,
    m_flow_nominal=mLiq_flow_nominal,
    dp_nominal=datLiq.dp_nominal + dpValve_nominal)
    "Pump for liquid cooling loop"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));

  Buildings.Fluid.Sources.Boundary_pT bouLiq(
    redeclare package Medium = MediumLiq,
    nPorts=1)
    "Pressure boundary condition for liquid loop"
    annotation (Placement(transformation(extent={{180,50},{160,70}})));

  Buildings.Fluid.Sources.Boundary_pT datHal(
    redeclare package Medium = MediumAir,
    T=TAirDatHal,
    nPorts=2) "Temperature and pressure of air in data hall"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,-100})));

  Fluid.Sensors.TemperatureTwoPort senTLiq_a(
    redeclare package Medium = MediumLiq,
    allowFlowReversal=false,
    m_flow_nominal=mLiq_flow_nominal,
    tau=0)
    "Liquid inlet temperature to rack"
    annotation (Placement(transformation(extent={{-30,50},{-10,70}})));

  Fluid.Sensors.TemperatureTwoPort senTLiq_b(
    redeclare package Medium = MediumLiq,
    allowFlowReversal=false,
    m_flow_nominal=mLiq_flow_nominal,
    tau=0)
    "Liquid outlet temperature from rack"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));

  Fluid.Sensors.TemperatureTwoPort senTAir_a(
    redeclare package Medium = MediumAir,
    allowFlowReversal=false,
    m_flow_nominal=datAir.m_flow_nominal,
    tau=0)
    "Air inlet temperature"
    annotation (Placement(transformation(extent={{-30,-50},{-10,-30}})));

  Fluid.Sensors.TemperatureTwoPort senTAir_b(
    redeclare package Medium = MediumAir,
    allowFlowReversal=false,
    m_flow_nominal=datAir.m_flow_nominal,
    tau=0) "Air outlet temperature"
    annotation (Placement(transformation(extent={{98,-50},{118,-30}})));

  Buildings.Controls.OBC.CDL.Reals.PID conPI(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    k=0.5,
    Ti=60,
    r=datLiq.dp_nominal,
    yMax=1,
    yMin=0.1)
    "PI controller for pump speed to maintain constant pressure across rack"
    annotation (Placement(transformation(extent={{-80,110},{-60,130}})));

  Actuators.Valves.TwoWayLinear val(
    redeclare package Medium = MediumLiq,
    m_flow_nominal=mLiq_flow_nominal,
    dpValve_nominal=dpValve_nominal) "Valve"
                                    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,30})));
  Controls.OBC.CDL.Reals.Sources.Constant TSetRet(k=TLiqIn_nominal +
        dTLiq_nominal) "Temperature setpoint for return water"
    annotation (Placement(transformation(extent={{-120,150},{-100,170}})));

  Controls.OBC.CDL.Reals.PID conVal(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    Ti=30,
    yMax=1,
    yMin=0.1,
    reverseActing=false,
    u_s(final unit="K", displayUnit="degC"),
    u_m(final unit="K", displayUnit="degC"))
              "PI controller for valve to control return temperature"
    annotation (Placement(transformation(extent={{-80,150},{-60,170}})));


  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dpSet(k=datLiq.dp_nominal +
        dpValve_nominal)
    "Pressure drop setpoint across rack"
    annotation (Placement(transformation(extent={{-120,110},{-100,130}})));

  Buildings.Fluid.HeatExchangers.SensibleCooler_T coo(
    redeclare package Medium = MediumLiq,
    m_flow_nominal=mLiq_flow_nominal,
    dp_nominal=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Cooler to maintain supply temperature"
    annotation (Placement(transformation(extent={{-170,50},{-150,70}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSetCoo(k=TLiqIn_nominal)
    "Temperature setpoint for cooler"
    annotation (Placement(transformation(extent={{-220,58},{-200,78}})));

  Fluid.Sensors.RelativePressure senRelPre(redeclare package Medium = MediumLiq)
    "Relative pressure sensor across rack"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={50,60})));

equation
  connect(rac.portLiq_b, senTLiq_b.port_a)
    annotation (Line(points={{60,4},{80,4},{80,60},{100,60}},color={0,127,255}));
  connect(senTLiq_b.port_b, bouLiq.ports[1])
    annotation (Line(points={{120,60},{160,60}},color={0,127,255}));
  connect(senTAir_a.port_b, rac.portAir_a)
    annotation (Line(points={{-10,-40},{0,-40},{0,-4},{40,-4}},
                                                color={0,127,255}));
  connect(rac.portAir_b, senTAir_b.port_a)
    annotation (Line(points={{60.2,-4},{80,-4},{80,-40},{98,-40}},
                                                                 color={0,127,255}));
  connect(senTAir_a.port_a,datHal. ports[1]) annotation (Line(points={{-30,-40},
          {-80,-40},{-80,-80},{21,-80},{21,-90}}, color={0,127,255}));
  connect(senTAir_b.port_b,datHal. ports[2]) annotation (Line(points={{118,-40},
          {140,-40},{140,-80},{19,-80},{19,-90}},
                                                color={0,127,255}));
  connect(pum.port_b, senTLiq_a.port_a)
    annotation (Line(points={{-100,60},{-30,60}},color={0,127,255}));
  connect(bouLiq.ports[1], coo.port_a) annotation (Line(points={{160,60},{140,60},
          {140,88},{-180,88},{-180,60},{-170,60}}, color={0,127,255}));
  connect(dpSet.y, conPI.u_s)
    annotation (Line(points={{-98,120},{-82,120}}, color={0,0,127}));
  connect(conPI.y, pum.y) annotation (Line(points={{-58,120},{-50,120},{-50,94},
          {-110,94},{-110,72}},
          color={0,0,127}));
  connect(coo.port_b, pum.port_a)
    annotation (Line(points={{-150,60},{-120,60}},
                                                 color={0,127,255}));
  connect(TSetCoo.y, coo.TSet) annotation (Line(points={{-198,68},{-172,68}},
                              color={0,0,127}));
  connect(senTLiq_b.port_a, senRelPre.port_b) annotation (Line(points={{100,60},
          {60,60}},                          color={0,127,255}));
  connect(senRelPre.p_rel, conPI.u_m) annotation (Line(points={{50,69},{50,100},
          {-70,100},{-70,108}},
                           color={0,0,127}));
  connect(senRelPre.port_a, senTLiq_a.port_b)
    annotation (Line(points={{40,60},{-10,60}},color={0,127,255}));
  connect(utiLiq.y[1], PITLiq.u)
    annotation (Line(points={{-198,10},{-182,10}}, color={0,0,127}));
  connect(PITLiq.y, rac.PLiq) annotation (Line(points={{-159,10},{-40,10},{-40,8.2},
          {39,8.2}},
                  color={0,0,127}));
  connect(utiAir.y, PITAir.u)
    annotation (Line(points={{-198,-20},{-182,-20}}, color={0,0,127}));
  connect(PITAir.y, rac.PAir) annotation (Line(points={{-159,-20},{-40,-20},{-40,
          -8},{39,-8}},color={0,0,127}));
  connect(val.port_b, rac.portLiq_a)
    annotation (Line(points={{0,20},{0,4},{40,4}}, color={0,127,255}));
  connect(val.port_a, senTLiq_a.port_b)
    annotation (Line(points={{0,40},{0,60},{-10,60}}, color={0,127,255}));
  connect(conVal.u_m, senTLiq_b.T) annotation (Line(points={{-70,148},{-70,140},
          {110,140},{110,71}},
                          color={0,0,127}));
  connect(TSetRet.y, conVal.u_s)
    annotation (Line(points={{-98,160},{-82,160}},color={0,0,127}));
  connect(conVal.y, val.y) annotation (Line(points={{-58,160},{30,160},{30,30},{
          12,30}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(extent={{-240,-120},{200,180}})),
    experiment(
      StopTime=7200,
      Tolerance=1e-06),
      __Dymola_Commands(
       file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/DataCenterEquipment/Racks/Hybrid/LiquidCooledSinglePhase/Examples/LiquidCooledSinglePhase.mos" "Simulate and plot"),
    Documentation(info="<html>
<p>
Example model of a hybrid IT rack with both liquid-cooled and air-cooled components.
The model demonstrates the operation of a rack that combines liquid cooling for
high-power IT equipment of 633.6 kW using propylene glycol water with 25% mass fraction
as the coolant, and air cooling for lower-power IT equipment of 63.36 kW, which is 10%
of the liquid-cooled load.
</p>
<p>
The liquid cooling loop uses a cooler upstream of a variable speed pump.
The cooler maintains a constant supply temperature to the rack at 42&deg;C.
A control valve regulates the coolant mass flow rate to track a leaving coolant
temperature setpoint.
The pump is controlled by a PI controller that maintains a constant pressure drop
across the rack equal to the design pressure drop.
The controller adjusts the pump speed between 10% and 100% to maintain the pressure setpoint.
</p>
<p>
The IT loads for both cooling systems are specified using different control strategies.
The liquid-cooled utilization follows a time-based schedule.
The air-cooled utilization is kept constant at 100%
throughout the simulation.
</p>
<p>
The air cooling loop uses simple pressure boundary conditions that allow
free circulation of air through the rack component.
The air inlet temperature is <i>30</i>&deg;C
and the fan is sized to have a temperature difference across the
rack of <i>10</i> K, leading a <i>40</i>&deg;C outlet air temperature.
</p>
</html>", revisions="<html>
<ul>
<li>
July 14, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end LiquidCooledSinglePhase;
