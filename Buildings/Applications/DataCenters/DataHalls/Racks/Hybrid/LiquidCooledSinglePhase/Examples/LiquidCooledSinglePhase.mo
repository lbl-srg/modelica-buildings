within Buildings.Applications.DataCenters.DataHalls.Racks.Hybrid.LiquidCooledSinglePhase.Examples;
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

  parameter Modelica.Units.SI.Power PLiq = 48*13200
    "Design power for liquid-cooled IT";
  parameter Modelica.Units.SI.Power PAir = 0.1*PLiq
    "Design power for air-cooled IT";

  parameter Modelica.Units.SI.TemperatureDifference dTLiq_nominal = 7
    "Design temperature difference of liquid coolant";

  parameter Modelica.Units.SI.Temperature TRac_a = 273.15+42
    "Supply coolant temperature to rack at design conditions";

  final parameter Modelica.Units.SI.MassFlowRate mLiq_flow_nominal=
    PLiq/dTLiq_nominal/cp_default
    "Nominal mass flow rate for liquid cooling at design conditions";

  parameter Modelica.Units.SI.SpecificHeatCapacity cp_default=
    MediumLiq.specificHeatCapacityCp(state=state_default)
    "Heat capacity of liquid coolant";

  parameter Buildings.Applications.DataCenters.DataHalls.Racks.LiquidCooledSinglePhase.Data.OCP_1kW_OAM_PG25 datLiq(
    PIT_nominal=PLiq,
    m_flow_nominal=mLiq_flow_nominal)
    "Liquid-cooled rack performance data"
    annotation (Placement(transformation(extent={{100,90},{120,110}})));

  parameter Buildings.Applications.DataCenters.DataHalls.Racks.AirCooled.Data.Generic
    datAir(PIT_nominal=PAir)
    "Air-cooled rack performance data"
    annotation (Placement(transformation(extent={{100,60},{120,80}})));

  parameter Buildings.Applications.DataCenters.DataHalls.Racks.Hybrid.Data.LiquidCooledSinglePhase.Generic
    dat(
    liq=datLiq,
    air=datAir)
    "Hybrid rack performance data"
    annotation (Placement(transformation(extent={{100,120},{120,140}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable utiLiq(
    table=[0,0;
           3600,0;
           4500,0.8;
           5400,0.8;
           5400,0.4;
           6300,0.4;
           6300,0.8], extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.HoldLastPoint)
    "Utilization of liquid-cooled hardware"
    annotation (Placement(transformation(extent={{-160,0},{-140,20}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant utiAir(k=1)
    "Utilization of air-cooled hardware"
    annotation (Placement(transformation(extent={{-160,-30},{-140,-10}})));

  Buildings.Applications.DataCenters.DataHalls.Racks.Hybrid.LiquidCooledSinglePhase.LiquidCooledSinglePhase
    rac(
    redeclare package MediumLiq = MediumLiq,
    redeclare package MediumAir = MediumAir,
    dat=dat,
    energyDynamicsLiq=Modelica.Fluid.Types.Dynamics.FixedInitial,
    energyDynamicsAir=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Liquid and air-cooled rack"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));

  Buildings.Fluid.Movers.Preconfigured.SpeedControlled_y pum(
    redeclare package Medium = MediumLiq,
    m_flow_nominal=mLiq_flow_nominal,
    dp_nominal=50000)
    "Pump for liquid cooling loop"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));

  Buildings.Fluid.Sources.Boundary_pT bouLiq(
    redeclare package Medium = MediumLiq,
    nPorts=1)
    "Pressure boundary condition for liquid loop"
    annotation (Placement(transformation(extent={{120,30},{100,50}})));

  Buildings.Fluid.Sources.Boundary_pT souAir(
    redeclare package Medium = MediumAir,
    nPorts=2)
    "Pressure boundary condition for air loop"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,-100})));

  Fluid.Sensors.TemperatureTwoPort senTLiq_a(
    redeclare package Medium = MediumLiq,
    allowFlowReversal=false,
    m_flow_nominal=mLiq_flow_nominal,
    tau=0)
    "Liquid inlet temperature to rack"
    annotation (Placement(transformation(extent={{-28,30},{-8,50}})));

  Fluid.Sensors.TemperatureTwoPort senTLiq_b(
    redeclare package Medium = MediumLiq,
    allowFlowReversal=false,
    m_flow_nominal=mLiq_flow_nominal,
    tau=0)
    "Liquid outlet temperature from rack"
    annotation (Placement(transformation(extent={{50,30},{70,50}})));

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
    tau=0)
    "Air outlet temperature"
    annotation (Placement(transformation(extent={{48,-50},{68,-30}})));

  Buildings.Controls.OBC.CDL.Reals.PID conPI(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    k=0.5,
    Ti=60,
    r=datLiq.dp_nominal,
    yMax=1,
    yMin=0.1)
    "PI controller for pump speed to maintain constant pressure across rack"
    annotation (Placement(transformation(extent={{-80,110},{-60,130}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dpSet(k=datLiq.dp_nominal)
    "Pressure drop setpoint across rack"
    annotation (Placement(transformation(extent={{-120,110},{-100,130}})));

  Buildings.Fluid.HeatExchangers.SensibleCooler_T coo(
    redeclare package Medium = MediumLiq,
    m_flow_nominal=mLiq_flow_nominal,
    dp_nominal=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Cooler to maintain supply temperature"
    annotation (Placement(transformation(extent={{-110,30},{-90,50}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSetCoo(k=TRac_a)
    "Temperature setpoint for cooler"
    annotation (Placement(transformation(extent={{-160,38},{-140,58}})));

  Fluid.Sensors.RelativePressure senRelPre(redeclare package Medium = MediumLiq)
    "Relative pressure sensor across rack"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={20,40})));

protected
  parameter MediumLiq.ThermodynamicState state_default = MediumLiq.setState_pTX(
    T=MediumLiq.T_default,
    p=MediumLiq.p_default,
    X=MediumLiq.X_default[1:MediumLiq.nXi]) "Medium state at default values";

equation
  connect(utiLiq.y[1], rac.uLiq) annotation (Line(points={{-138,10},{-20,10},{-20,
          8},{9,8}},
                  color={0,0,127}));
  connect(utiAir.y, rac.uAir) annotation (Line(points={{-138,-20},{-20,-20},{-20,
          -8},{9,-8}},
                   color={0,0,127}));
  connect(senTLiq_a.port_b, rac.portLiq_a)
    annotation (Line(points={{-8,40},{0,40},{0,4},{10,4}},
                                              color={0,127,255}));
  connect(rac.portLiq_b, senTLiq_b.port_a)
    annotation (Line(points={{30,4},{40,4},{40,40},{50,40}}, color={0,127,255}));
  connect(senTLiq_b.port_b, bouLiq.ports[1])
    annotation (Line(points={{70,40},{100,40}}, color={0,127,255}));
  connect(senTAir_a.port_b, rac.portAir_a)
    annotation (Line(points={{-10,-40},{0,-40},{0,-4},{10,-4}},
                                                color={0,127,255}));
  connect(rac.portAir_b, senTAir_b.port_a)
    annotation (Line(points={{30.2,-4},{40,-4},{40,-40},{48,-40}},
                                                                 color={0,127,255}));
  connect(senTAir_a.port_a, souAir.ports[1]) annotation (Line(points={{-30,-40},
          {-80,-40},{-80,-80},{21,-80},{21,-90}}, color={0,127,255}));
  connect(senTAir_b.port_b, souAir.ports[2]) annotation (Line(points={{68,-40},{
          80,-40},{80,-80},{19,-80},{19,-90}},  color={0,127,255}));
  connect(pum.port_b, senTLiq_a.port_a)
    annotation (Line(points={{-40,40},{-28,40}}, color={0,127,255}));
  connect(bouLiq.ports[1], coo.port_a) annotation (Line(points={{100,40},{80,40},
          {80,100},{-128,100},{-128,40},{-110,40}},color={0,127,255}));
  connect(dpSet.y, conPI.u_s)
    annotation (Line(points={{-98,120},{-82,120}}, color={0,0,127}));
  connect(conPI.y, pum.y) annotation (Line(points={{-58,120},{-50,120},{-50,52}},
          color={0,0,127}));
  connect(coo.port_b, pum.port_a)
    annotation (Line(points={{-90,40},{-60,40}}, color={0,127,255}));
  connect(TSetCoo.y, coo.TSet) annotation (Line(points={{-138,48},{-112,48}},
                              color={0,0,127}));
  connect(senTLiq_b.port_a, senRelPre.port_b) annotation (Line(points={{50,40},{
          30,40}},                           color={0,127,255}));
  connect(senRelPre.p_rel, conPI.u_m) annotation (Line(points={{20,49},{20,90},{
          -70,90},{-70,108}},
                           color={0,0,127}));
  connect(senRelPre.port_a, senTLiq_a.port_b)
    annotation (Line(points={{10,40},{-8,40}}, color={0,127,255}));
  annotation (
    Diagram(coordinateSystem(extent={{-190,-120},{140,150}})),
    experiment(
      StopTime=7200,
      Tolerance=1e-06),
      __Dymola_Commands(
       file="modelica://Buildings/Resources/Scripts/Dymola/Applications/DataCenters/DataHalls/Racks/Hybrid/LiquidCooledSinglePhase/Examples/LiquidCooledSinglePhase.mos" "Simulate and plot"),
    Documentation(info="<html>
<p>
Example model of a hybrid IT rack with both liquid-cooled and air-cooled components.
The model demonstrates the operation of a rack that combines liquid cooling for
high-power IT equipment (633.6 kW) using propylene glycol water (25% mass fraction)
as the coolant, and air cooling for lower-power IT equipment (63.36 kW, which is 10%
of the liquid-cooled load).
</p>
<p>
The liquid cooling loop uses a cooler upstream of a variable speed pump.
The cooler maintains a constant supply temperature to the rack at 42°C (315.15 K).
The pump is controlled by a PI controller that maintains a constant pressure drop
across the rack equal to the design pressure drop.
The controller adjusts the pump speed between 10% and 100% to maintain the setpoint.
The pump has a nominal pressure rise of 50 kPa at the design flow rate.
</p>
<p>
The IT loads for both cooling systems are specified using different control strategies.
The liquid-cooled utilization (<code>utiLiq</code>) follows a time-based schedule
that simulates a realistic data center load profile.
Starting from zero utilization, the load ramps up to 80% over 15 minutes (from t=3600s to t=4500s),
remains at 80% for 15 minutes, then drops to 40%, holds for 15 minutes,
increases back to 80%, and holds for another 15 minutes.
The air-cooled utilization (<code>utiAir</code>) is kept constant at 100%
throughout the simulation.
This load pattern is representative of workload variations in modern data centers
running batch processing jobs or machine learning training tasks.
</p>
<p>
The air cooling loop uses simple pressure boundary conditions that allow
free circulation of air through the rack component.
Temperature sensors are placed at both the inlet and outlet of each cooling loop
to monitor the thermal performance of the system.
A relative pressure sensor measures the pressure drop across the rack,
which is used as feedback for the pump controller.
</p>
</html>", revisions="<html>
<ul>
<li>
July 14, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end LiquidCooledSinglePhase;
