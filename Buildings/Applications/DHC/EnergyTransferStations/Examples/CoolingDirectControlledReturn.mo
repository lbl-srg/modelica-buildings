within Buildings.Applications.DHC.EnergyTransferStations.Examples;
model CoolingDirectControlledReturn
  "Example model for direct cooling energy transfer station with in-building pump and controlled district return temperature"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water;

  parameter Modelica.SIunits.MassFlowRate mDis_flow_nominal=0.5
    "Nominal mass flow rate of district cooling supply";

  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal=18000
    "Nominal cooling load";

  parameter Modelica.SIunits.MassFlowRate mBui_flow_nominal=
    Q_flow_nominal/(cp*(18 - 7))
    "Nominal mass flow rate";

 parameter Modelica.SIunits.SpecificHeatCapacity cp=
   Medium.specificHeatCapacityCp(
      Medium.setState_pTX(Medium.p_default, Medium.T_default, Medium.X_default))
    "Default specific heat capacity of medium";

  inner Modelica.Fluid.System system
    "System properties and default values"
    annotation (Placement(transformation(extent={{-120,100},{-100,120}})));

  Buildings.Applications.DHC.EnergyTransferStations.CoolingDirectControlledReturn coo(
    redeclare package Medium = Medium,
    mDis_flow_nominal=mDis_flow_nominal,
    mBui_flow_nominal=mBui_flow_nominal,
    mByp_flow_nominal=0.01,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.5,
    Ti=200,
    yMax=0,
    yMin=-1,
    yCon_start=0)
    annotation (Placement(transformation(extent={{-10,-72},{10,-52}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TDisSup(
    redeclare package Medium = Medium,
    m_flow_nominal=mDis_flow_nominal)
    "District-side (primary) supply temperature sensor"
    annotation (Placement(transformation(extent={{-50,-20},{-30,0}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TBuiSup(
    redeclare package Medium = Medium,
    m_flow_nominal=mBui_flow_nominal)
    "Building-side (secondary) supply temperature sensor"
    annotation (Placement(transformation(extent={{50,-20},{70,0}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TBuiRet(
    redeclare package Medium = Medium,
    m_flow_nominal=mBui_flow_nominal)
    "Building-side (secondary) return temperature sensor"
    annotation (Placement(transformation(extent={{50,-120},{30,-100}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TDisRet(
    redeclare package Medium = Medium,
    m_flow_nominal=mDis_flow_nominal)
    "District-side (primary) return temperature sensor"
    annotation (Placement(transformation(extent={{-50,-120},{-70,-100}})));

  Modelica.Blocks.Sources.Constant TSetDisRet_min(k=273.15 + 16)
    "Minimum setpoint temperature for district return"
    annotation (Placement(transformation(extent={{-100,-84},{-80,-64}})));

  Buildings.Fluid.Sources.Boundary_pT sinDis(
    redeclare package Medium = Medium,
    p=300000,
    nPorts=1)
    "District sink"
    annotation (Placement(transformation(extent={{-100,-120},{-80,-100}})));

  Modelica.Blocks.Sources.RealExpression TDisSupNoi(
    y=(273.15 + 7) + 2*sin(time*4*3.14/86400))
    "Sinusoidal noise signal for district supply temperature"
    annotation (Placement(transformation(extent={{-140,-16},{-120,4}})));

  Buildings.Fluid.HeatExchangers.HeaterCooler_u loa(
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
    annotation (Placement(transformation(extent={{120,-20},{140,0}})));

  Buildings.Fluid.Movers.FlowControlled_m_flow pum(
    redeclare replaceable package Medium = Medium,
    m_flow_nominal=mBui_flow_nominal,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    constantMassFlowRate=mBui_flow_nominal)
    "Building primary pump"
    annotation (Placement(transformation(extent={{80,-20},{100,0}})));

  Modelica.Blocks.Math.Gain gai(k=-1/(cp*(16-7)))
    "Multiplier gain for calculating m_flow"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));

  Modelica.Blocks.Sources.Ramp ram(
    height=1,
    duration(displayUnit="h") = 3600,
    startTime(displayUnit="h") = 0)
    "Ramp load from zero"
    annotation (Placement(transformation(extent={{-40,100},{-20,120}})));

  Modelica.Blocks.Math.Product pro
    "Multiplyer to ramp load from zero"
    annotation (Placement(transformation(extent={{0,94},{20,114}})));

  Buildings.Fluid.Sources.Boundary_pT souDis(
    redeclare package Medium = Medium,
    p=350000,
    use_T_in=true,
    T=280.15,
    nPorts=1)
    "District source"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));

  Modelica.Blocks.Sources.CombiTimeTable QCoo(
    table=[0,-100E3; 6,-80E3; 6,-50E3; 12,-20E3; 18,-150E3; 24,-100E3],
    timeScale=3600,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Cooling demand"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));

  Modelica.Blocks.Math.Add dTDis(final k1=+1, final k2=-1)
    "Change in temperature on the district side"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));

  Modelica.Blocks.Math.Add dTBui(final k1=+1, final k2=-1)
    "Change in temperature on the building side"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));

equation
  connect(TSetDisRet_min.y, coo.TSetDisRet)
    annotation (Line(points={{-79,-74},{-12,-74}}, color={0,0,127}));
  connect(TDisSup.port_b, coo.port_a1)
    annotation (Line(points={{-30,-10},{-20,-10},{-20,-56},{-10,-56}},
      color={0,127,255}));
  connect(coo.port_b1, TBuiSup.port_a)
    annotation (Line(points={{10,-56},{20,-56},{20,-10},{50,-10}},
      color={0,127,255}));
  connect(TBuiRet.port_b, coo.port_a2)
    annotation (Line(points={{30,-110},{20,-110},{20,-68},{10,-68}},
      color={0,127,255}));
  connect(TBuiSup.port_b, pum.port_a)
    annotation (Line(points={{70,-10},{80,-10}},
                                               color={0,127,255}));
  connect(pum.port_b, loa.port_a)
    annotation (Line(points={{100,-10},{120,-10}},
                                                color={0,127,255}));
  connect(souDis.ports[1], TDisSup.port_a)
    annotation (Line(points={{-80,-10},{-50,-10}},
                                                 color={0,127,255}));
  connect(coo.port_b2, TDisRet.port_a)
    annotation (Line(points={{-10,-68},{-20,-68},{-20,-110},{-50,-110}},
      color={0,127,255}));
  connect(TDisRet.port_b, sinDis.ports[1])
    annotation (Line(points={{-70,-110},{-80,-110}},
                                                   color={0,127,255}));
  connect(TBuiRet.port_a, loa.port_b)
    annotation (Line(points={{50,-110},{150,-110},{150,-10},{140,-10}},
      color={0,127,255}));
  connect(gai.y, pum.m_flow_in)
    annotation (Line(points={{61,70},{90,70},{90,2}},  color={0,0,127}));
  connect(ram.y, pro.u1)
    annotation (Line(points={{-19,110},{-2,110}},
                                             color={0,0,127}));
  connect(pro.y, loa.u)
    annotation (Line(points={{21,104},{110,104},{110,-4},{118,-4}},
      color={0,0,127}));
  connect(QCoo.y[1], pro.u2)
    annotation (Line(points={{-19,70},{-10,70},{-10,98},{-2,98}},
      color={0,0,127}));
  connect(pro.y, gai.u)
    annotation (Line(points={{21,104},{30,104},{30,70},{38,70}},
      color={0,0,127}));
  connect(TDisSupNoi.y, souDis.T_in)
    annotation (Line(points={{-119,-6},{-102,-6}},
                                                 color={0,0,127}));
  connect(TDisRet.T, dTDis.u1)
    annotation (Line(points={{-60,-99},{-60,36},{-22,36}}, color={0,0,127}));
  connect(TDisSup.T, dTDis.u2)
    annotation (Line(points={{-40,1},{-40,24},{-22,24}}, color={0,0,127}));
  connect(TBuiRet.T, dTBui.u1)
    annotation (Line(points={{40,-99},{40,36},{58,36}}, color={0,0,127}));
  connect(TBuiSup.T, dTBui.u2)
    annotation (Line(points={{60,1},{60,10},{50,10},{50,24},{58,24}},
      color={0,0,127}));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false,
        extent={{-160,-140},{160,140}})),
    __Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Applications/DHC/EnergyTransferStations/Examples/CoolingDirectControlledReturn.mos"
    "Simulate and plot"),
    experiment(
        StartTime=0,
        StopTime=86400,
        Tolerance=1e-06),
    Documentation(info="<html>
<p>This model provides an example for the direct cooling energy transfer station model, which
contains in-building pumping and controls the district return temperature. The building's
primary variable speed pump is modulated depending on the total cooling load and prescribed
deltaT. Variation in the district supply temperature is modeled as sinusoidal to test the 
system's response. 
</p>
</html>", revisions="<html>
<ul>
<li>December 12, 2019, by Kathryn Hinkelman:<br>First implementation. </li>
</ul>
</html>"));
end CoolingDirectControlledReturn;
