within Buildings.Applications.DHC.EnergyTransferStations.Cooling.Examples;
model CoolingDirectControlledReturn
  "Example model for direct cooling energy transfer station with in-building 
  pumping and controlled district return temperature"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water "Water medium";

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
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));

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
    annotation (Placement(transformation(extent={{-10,-52},{10,-32}})));

  Modelica.Blocks.Sources.Constant TSetDisRet_min(k=273.15 + 16)
    "Minimum setpoint temperature for district return"
    annotation (Placement(transformation(extent={{-100,-64},{-80,-44}})));

  Buildings.Fluid.Sources.Boundary_pT sinDis(
    redeclare package Medium = Medium,
    p=300000,
    nPorts=1)
    "District sink"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

  Modelica.Blocks.Sources.RealExpression TDisSupNoi(
    y=(273.15 + 7) + 2*sin(time*4*3.14/86400))
    "Sinusoidal noise signal for district supply temperature"
    annotation (Placement(transformation(extent={{-140,4},{-120,24}})));

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
    annotation (Placement(transformation(extent={{120,0},{140,20}})));

  Buildings.Fluid.Movers.FlowControlled_m_flow pum(
    redeclare replaceable package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mBui_flow_nominal,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    constantMassFlowRate=mBui_flow_nominal)
    "Building primary pump"
    annotation (Placement(transformation(extent={{80,0},{100,20}})));

  Modelica.Blocks.Math.Gain gai(k=-1/(cp*(16-7)))
    "Multiplier gain for calculating m_flow"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));

  Modelica.Blocks.Sources.Ramp ram(
    height=1,
    duration(displayUnit="h") = 3600,
    startTime(displayUnit="h") = 0)
    "Ramp load from zero"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));

  Modelica.Blocks.Math.Product pro
    "Multiplyer to ramp load from zero"
    annotation (Placement(transformation(extent={{0,74},{20,94}})));

  Buildings.Fluid.Sources.Boundary_pT souDis(
    redeclare package Medium = Medium,
    p=350000,
    use_T_in=true,
    T=280.15,
    nPorts=1)
    "District source"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));

  Modelica.Blocks.Sources.CombiTimeTable QCoo(
    table=[0,-100E3; 6,-80E3; 6,-50E3; 12,-20E3; 18,-150E3; 24,-100E3],
    timeScale=3600,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Cooling demand"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));

equation
  connect(TSetDisRet_min.y, coo.TSetDisRet)
    annotation (Line(points={{-79,-54},{-12,-54}}, color={0,0,127}));
  connect(pum.port_b, loa.port_a)
    annotation (Line(points={{100,10},{120,10}}, color={0,127,255}));
  connect(gai.y, pum.m_flow_in)
    annotation (Line(points={{61,50},{90,50},{90,22}}, color={0,0,127}));
  connect(ram.y, pro.u1)
    annotation (Line(points={{-19,90},{-2,90}}, color={0,0,127}));
  connect(pro.y, loa.u)
    annotation (Line(points={{21,84},{110,84},{110,16},{118,16}},
      color={0,0,127}));
  connect(QCoo.y[1], pro.u2)
    annotation (Line(points={{-19,50},{-10,50},{-10,78},{-2,78}},
      color={0,0,127}));
  connect(pro.y, gai.u)
    annotation (Line(points={{21,84},{30,84},{30,50},{38,50}},
      color={0,0,127}));
  connect(TDisSupNoi.y, souDis.T_in)
    annotation (Line(points={{-119,14},{-102,14}}, color={0,0,127}));
  connect(coo.port_a1, souDis.ports[1])
    annotation (Line(points={{-10,-36},{-20,-36},{-20,10},{-80,10}},
      color={0,127,255}));
  connect(coo.port_b1, pum.port_a)
    annotation (Line(points={{10,-36},{20,-36},{20,10},{80,10}},
      color={0,127,255}));
  connect(sinDis.ports[1], coo.port_b2)
    annotation (Line(points={{-80,-90},{-20,-90},{-20,-48},{-10,-48}},
      color={0,127,255}));
  connect(coo.port_a2, loa.port_b)
    annotation (Line(points={{10,-48},{20,-48},{20,-90},{150,-90},{150,10},
      {140,10}}, color={0,127,255}));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false,
        extent={{-160,-120},{160,120}})),
    __Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Applications/DHC/EnergyTransferStations/Examples/CoolingDirectControlledReturn.mos"
    "Simulate and plot"),
    experiment(
        StartTime=0,
        StopTime=86400,
        Tolerance=1e-06),
    Documentation(info="<html>
<p>
This model provides an example for the direct cooling energy transfer station 
model, which contains in-building pumping and controls the district return 
temperature. The building's primary variable speed pump is modulated depending 
on the total cooling load and prescribed deltaT. Variation in the district 
supply temperature is modeled as sinusoidal to test the system's response. 
</p>
</html>", revisions="<html>
<ul>
<li>December 12, 2019, by Kathryn Hinkelman:<br/>First implementation. </li>
</ul>
</html>"));
end CoolingDirectControlledReturn;
