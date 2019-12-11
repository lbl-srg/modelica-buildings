within Buildings.Applications.DHC.EnergyTransferStations.Examples;
model CoolingDirectControlledReturn
  "Example model for direct cooling energy transfer station with in-building pump and controlled district return temperature"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water;

  parameter Modelica.SIunits.MassFlowRate mDis_flow_nominal = 0.5
    "Nominal mass flow rate of district cooling supply";

//   parameter Modelica.SIunits.MassFlowRate mBui_flow_nominal = 0.5
//     "Nominal mass flow rate of building chilled water supply";

  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal = 18000
    "Nominal cooling load";

  parameter Modelica.SIunits.MassFlowRate mBui_flow_nominal = Q_flow_nominal/(cp*(18 - 7))
    "Nominal mass flow rate";

 parameter Modelica.SIunits.SpecificHeatCapacity cp=
   Medium.specificHeatCapacityCp(
      Medium.setState_pTX(Medium.p_default, Medium.T_default, Medium.X_default))
    "Default specific heat capacity of medium";

  Buildings.Applications.DHC.EnergyTransferStations.CoolingDirectControlledReturn
    coo(
    redeclare package Medium = Medium,
    mDis_flow_nominal=mDis_flow_nominal,
    mBui_flow_nominal=mBui_flow_nominal,
    mByp_flow_nominal=0.01,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.1,
    Ti=40,
    yMax=0,
    yMin=-1,
    initType=Modelica.Blocks.Types.InitPID.InitialOutput,
    yCon_start=0)
        annotation (Placement(transformation(extent={{-12,-12},{8,8}})));
  Fluid.Sensors.TemperatureTwoPort           TDisSup(
    redeclare package Medium = Medium,
    m_flow_nominal=mDis_flow_nominal,
    T_start=280.15)
    "District-side (primary) supply temperature sensor"
    annotation (Placement(transformation(extent={{-50,40},{-30,60}})));
  Fluid.Sensors.TemperatureTwoPort           TBuiSup(
    redeclare package Medium = Medium,
    m_flow_nominal=mBui_flow_nominal,
    T_start=280.15)
    "Building-side (secondary) supply temperature sensor"
    annotation (Placement(transformation(extent={{30,40},{50,60}})));
  Fluid.Sensors.TemperatureTwoPort           TBuiRet(
    redeclare package Medium = Medium,
    m_flow_nominal=mBui_flow_nominal,
    T_start=287.15)
    "Building-side (secondary) return temperature sensor"
    annotation (Placement(transformation(extent={{50,-60},{30,-40}})));
  Fluid.Sensors.TemperatureTwoPort           TDisRet(
    redeclare package Medium = Medium,
    m_flow_nominal=mDis_flow_nominal)
    "District-side (primary) return temperature sensor"
    annotation (Placement(transformation(extent={{-30,-60},{-50,-40}})));
  Modelica.Blocks.Sources.Constant TSet(k=273.15 + 16)
    "Setpoint temperature for district return"
    annotation (Placement(transformation(extent={{-80,-24},{-60,-4}})));
  Fluid.Sources.Boundary_pT sinDis(redeclare package Medium = Medium,
    p=300000,
    nPorts=1) "District sink"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Fluid.HeatExchangers.HeaterCooler_u           loa(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=mBui_flow_nominal,
    from_dp=false,
    linearizeFlowResistance=true,
    show_T=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    Q_flow_nominal=-1,
    dp_nominal=100)
    "Aggregate building cooling load"
    annotation (Placement(transformation(extent={{100,40},{120,60}})));
  Fluid.Movers.FlowControlled_m_flow pum(
    redeclare replaceable package Medium = Medium,
    m_flow_nominal=mBui_flow_nominal,
    inputType=Buildings.Fluid.Types.InputType.Constant,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    constantMassFlowRate=mBui_flow_nominal)       "Building primary pump"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Modelica.Blocks.Sources.Ramp QCoo(
    height=-Q_flow_nominal,
    duration(displayUnit="h") = 21600,
    startTime(displayUnit="h") = 3600)  "Cooling load"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  inner Modelica.Fluid.System sys "System properties and default values"
    annotation (Placement(transformation(extent={{100,-80},{120,-60}})));
  Fluid.Sources.Boundary_pT souDis(
    redeclare package Medium = Medium,
    p=350000,
    T=280.15,
    nPorts=1) "District source"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
equation
  connect(TSet.y, coo.TSetDisRet)
    annotation (Line(points={{-59,-14},{-36,-14},{-36,-14},{-14,-14}},
                                                   color={0,0,127}));
  connect(TDisSup.port_b, coo.port_a1) annotation (Line(points={{-30,50},{-22,
          50},{-22,4},{-12,4}},
                            color={0,127,255}));
  connect(coo.port_b1, TBuiSup.port_a) annotation (Line(points={{8,4},{20,4},{
          20,50},{30,50}}, color={0,127,255}));
  connect(TBuiRet.port_b, coo.port_a2) annotation (Line(points={{30,-50},{20,
          -50},{20,-8},{8,-8}}, color={0,127,255}));
  connect(TBuiSup.port_b, pum.port_a)
    annotation (Line(points={{50,50},{60,50}}, color={0,127,255}));
  connect(pum.port_b, loa.port_a)
    annotation (Line(points={{80,50},{100,50}}, color={0,127,255}));
  connect(loa.port_b, TBuiRet.port_a) annotation (Line(points={{120,50},{130,50},
          {130,-50},{50,-50}}, color={0,127,255}));
  connect(QCoo.y, loa.u) annotation (Line(points={{41,80},{90,80},{90,56},{98,56}},
        color={0,0,127}));
  connect(souDis.ports[1], TDisSup.port_a)
    annotation (Line(points={{-60,50},{-50,50}}, color={0,127,255}));
  connect(coo.port_b2, TDisRet.port_a) annotation (Line(points={{-12,-8},{-20,
          -8},{-20,-50},{-30,-50}}, color={0,127,255}));
  connect(TDisRet.port_b, sinDis.ports[1])
    annotation (Line(points={{-50,-50},{-60,-50}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{140,100}})),
    __Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Applications/DHC/EnergyTransferStations/Examples/CoolingDirectControlledReturn.mos"
    "Simulate and plot"),
  experiment(
    StartTime=0,
    StopTime=86400,
    Tolerance=1e-06),
    Documentation(info="<html>
<p>This model provides an example for the direct cooling energy transfer station model, which
contains in-building pumping and controls the district return temperature. The control valve is 
modulated proportionally to the instantaneous cooling load with respect to the maxiumum load.
</p>
</html>", revisions="<html>
<ul>
<li>November 13, 2019, by Kathryn Hinkelman:<br>First implementation. </li>
</ul>
</html>"));
end CoolingDirectControlledReturn;
