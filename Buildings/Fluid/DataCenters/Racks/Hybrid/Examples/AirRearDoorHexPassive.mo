within Buildings.Fluid.DataCenters.Racks.Hybrid.Examples;
model AirRearDoorHexPassive
  "Example model for air-cooled rack with passive rear door heat exchanger"
  extends Modelica.Icons.Example;

  package MediumAir = Buildings.Media.Air
    "Medium for air cooling loop";

  package MediumReaDooHex = Buildings.Media.Water
    "Water for rear door heat exchanger loop";

  parameter Modelica.Units.SI.Power PAir_nominal=48*1320
    "Design power for air-cooled IT";

  parameter Modelica.Units.SI.Temperature TAirDatHal = 303.15
    "Air temperature in data hall";

  final parameter Modelica.Units.SI.SpecificHeatCapacity cpAir_default=
    MediumAir.specificHeatCapacityCp(
      MediumAir.setState_pTX(
        T=MediumAir.T_default,
        p=MediumAir.p_default,
        X=MediumAir.X_default[1:MediumAir.nXi]))
    "Specific heat capacity of air";

  parameter Buildings.Fluid.DataCenters.Racks.Air.Data.Generic datAir(
    PIT_nominal=PAir_nominal, cpAir_nominal=cpAir_default)
                                 "Air-cooled rack performance data"
    annotation (Placement(transformation(extent={{160,80},{180,100}})));

  parameter Modelica.Units.SI.Temperature TReaDooCooIn_nominal=273.15 + 25
    "Rear door heat exchanger coolant supply temperature";

  parameter Modelica.Units.SI.Temperature TReaDooCooOut_nominal=273.15 + 35
    "Rear door heat exchanger coolant return temperature";

  parameter Modelica.Units.SI.Temperature TAirReaDooIn_nominal=
      TAirDatHal + (datAir.TOut_nominal - datAir.TIn_nominal)
    "Nominal air temperature entering the rear door heat exchanger";

  final parameter Modelica.Units.SI.MassFlowRate mReaDoo_flow_nominal=
    (PAir_nominal + datAir.PFan_nominal)/((TReaDooCooOut_nominal - TReaDooCooIn_nominal)*Buildings.Utilities.Psychrometrics.Constants.cpWatLiq)
    "Nominal mass flow rate for rear door heat exchanger at design conditions";

  replaceable parameter
    Buildings.Fluid.DataCenters.Racks.RearDoorHeatExchangers.Data.Passive.Generic datReaDooHex
    constrainedby
    Buildings.Fluid.DataCenters.Racks.RearDoorHeatExchangers.Data.Passive.Generic(
      mAir_flow_nominal=datAir.m_flow_nominal,
      mCoo_flow_nominal=mReaDoo_flow_nominal,
      Q_flow_nominal=-PAir_nominal - datAir.PFan_nominal,
      TCooIn_nominal=TReaDooCooIn_nominal,
      TAirIn_nominal=TAirReaDooIn_nominal)
    "Rear door heat exchanger performance data"
    annotation (Placement(transformation(extent={{120,140},{140,160}})));

  replaceable parameter Buildings.Fluid.DataCenters.Racks.Hybrid.Data.AirRearDoorHexPassive.Generic dat
    constrainedby Buildings.Fluid.DataCenters.Racks.Hybrid.Data.AirRearDoorHexPassive.Generic(
      air=datAir,
      reaDooHex=datReaDooHex) "Hybrid rack performance data"
    annotation (Placement(transformation(extent={{160,140},{180,160}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant utiAir(k=1)
    "Utilization of air-cooled hardware"
    annotation (Placement(transformation(extent={{-120,-32},{-100,-12}})));

  Modelica.Blocks.Math.Gain PITAir(
    k(final unit="W",
      min=0) = datAir.PIT_nominal,
    u(final unit="1"),
    y(final unit="W"))
    "Power consumption by the air-cooled IT equipment"
    annotation (Placement(transformation(extent={{-80,-32},{-60,-12}})));

  replaceable Buildings.Fluid.DataCenters.Racks.Hybrid.AirRearDoorHexPassive rac
    constrainedby Buildings.Fluid.DataCenters.Racks.Hybrid.BaseClasses.PartialAirRearDoorHex(
    redeclare package MediumAir = MediumAir,
    redeclare package MediumReaDooHex = MediumReaDooHex,
    dat=dat,
    energyDynamicsAir=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Air-cooled rack with passive rear door heat exchanger"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  Buildings.Fluid.Sources.Boundary_pT datHal(
    redeclare package Medium = MediumAir,
    T=TAirDatHal,
    nPorts=2) "Temperature and pressure of air in data hall"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,-100})));

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
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));

  Buildings.Fluid.Sources.Boundary_pT souReaDoo(
    redeclare package Medium = MediumReaDooHex,
    T=TReaDooCooIn_nominal,
    p=MediumReaDooHex.p_default + datReaDooHex.dpCoo_nominal,
    nPorts=1) "Rear door heat exchanger coolant supply at elevated pressure"
    annotation (Placement(transformation(extent={{-120,8},{-100,28}})));

  Sources.Boundary_pT sinReaDoo(
    redeclare package Medium = MediumReaDooHex,
    p=MediumReaDooHex.p_default,
    nPorts=1) "Sink rear door heat exchanger coolant"
    annotation (Placement(transformation(extent={{182,-10},{162,10}})));

  Sensors.TemperatureTwoPort senTReaDooLvg(
    redeclare package Medium = MediumReaDooHex,
    allowFlowReversal=false,
    m_flow_nominal=mReaDoo_flow_nominal,
    tau=0) "Coolant outlet temperature from rear door heat exchanger"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  connect(senTAir_a.port_b, rac.portAir_a)
    annotation (Line(points={{-10,-40},{0,-40},{0,-4},{40,-4}},
                                                color={0,127,255}));
  connect(rac.portAir_b, senTAir_b.port_a)
    annotation (Line(points={{60.2,-4},{80,-4},{80,-40},{100,-40}},
                                                                 color={0,127,255}));
  connect(senTAir_a.port_a,datHal. ports[1]) annotation (Line(points={{-30,-40},
          {-40,-40},{-40,-80},{21,-80},{21,-90}}, color={0,127,255}));
  connect(senTAir_b.port_b,datHal. ports[2]) annotation (Line(points={{120,-40},
          {140,-40},{140,-80},{19,-80},{19,-90}},
                                                color={0,127,255}));
  connect(utiAir.y, PITAir.u)
    annotation (Line(points={{-98,-22},{-82,-22}}, color={0,0,127}));
  connect(PITAir.y, rac.PAir) annotation (Line(points={{-59,-22},{-40,-22},{
          -40,-8},{39,-8}},
                       color={0,0,127}));
  connect(rac.portReaDooHex_a, souReaDoo.ports[1]) annotation (Line(points={{40,0},{
          -40,0},{-40,18},{-100,18}},    color={0,127,255}));
  connect(rac.portReaDooHex_b, senTReaDooLvg.port_a)
    annotation (Line(points={{60,0},{100,0}}, color={0,127,255}));
  connect(senTReaDooLvg.port_b, sinReaDoo.ports[1]) annotation (Line(points={{120,
          0},{142,0},{142,0},{162,0}}, color={0,127,255}));
  annotation (
    Diagram(coordinateSystem(extent={{-140,-120},{200,180}})),
    experiment(
      StopTime=7200,
      Tolerance=1e-06),
      __Dymola_Commands(
       file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/DataCenters/Racks/Hybrid/Examples/AirRearDoorHexPassive.mos" "Simulate and plot"),
    Documentation(info="<html>
<p>
Example model of an air-cooled IT rack with a passive rear door
heat exchanger.
</p>
<p>
The room inlet air temperature is set to <i>30</i>&deg;C.
The air-cooled rack raises the air temperature around <i>11.7</i> K, so the air
entering the rear door heat exchanger is at approximately <i>41.7</i>&deg;C.
The rear door heat exchanger is passive, i.e., it does not have fans.
Due to its air-side flow resistance, the air flow rate through the rack is
slightly lower than when no rear door heat exchanger is present,
leading to a higher rack outlet temperature, which is upstream of the rear door heat exchanger.
</p>
<p>
Water at <i>25</i>&deg;C is supplied to the rear door heat exchanger.
In this simplified model, the water flow rate is uncontrolled, leading to
a leaving water temperature above the design temperature
due to the reduced air flow rate that causes
the air inlet temperature into the rear door heat exchanger to be slightly warmer
than the design temperature.
</p>
<p>
The air-cooled utilization is kept constant at 100%
throughout the simulation.
</p>
</html>", revisions="<html>
<ul>
<li>
September 29, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end AirRearDoorHexPassive;
