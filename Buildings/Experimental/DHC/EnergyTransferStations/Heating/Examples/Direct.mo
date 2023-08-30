within Buildings.Experimental.DHC.EnergyTransferStations.Heating.Examples;
model Direct "Example model for direct heating energy transfer station 
  with in-building pumping and controlled district return temperature"
  extends Modelica.Icons.Example;
  package Medium=Buildings.Media.Water
    "Water medium";
  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal=18000
    "Nominal heating load"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mBui_flow_nominal=Q_flow_nominal/(cp*(50-40))
    "Nominal mass flow rate of building heating supply"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.SpecificHeatCapacity cp=Medium.specificHeatCapacityCp(
    Medium.setState_pTX(
      Medium.p_default,
      Medium.T_default,
      Medium.X_default))
    "Default specific heat capacity of medium";
  Buildings.Experimental.DHC.EnergyTransferStations.Heating.Direct heaETS(
    mBui_flow_nominal=mBui_flow_nominal,
    QHeaWat_flow_nominal=Q_flow_nominal,
    dpConVal_nominal=50,
    dpCheVal_nominal=6000,
    nPorts_bHeaWat=1,
    nPorts_aHeaWat=1) "Energy transfer station"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Modelica.Blocks.Sources.Constant TSetDisRet_max(k=273.15 + 40)
    "Maximum setpoint temperature for district return"
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));
  Buildings.Fluid.Sources.Boundary_pT sinDis(
    redeclare package Medium = Medium,
    p=340000,
    nPorts=1)
    "District-side sink"
    annotation (Placement(transformation(extent={{80,-80},{60,-60}})));
  Buildings.Fluid.Sources.Boundary_pT souDis(
    redeclare package Medium = Medium,
    p=350000,
    use_T_in=true,
    T=280.15,
    nPorts=1)
    "District-side source"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Modelica.Blocks.Sources.RealExpression TDisSupNoi(y=(273.15 + 50) + 2*sin(
        time*4*3.14/86400))
    "Sinusoidal noise signal for district supply temperature"
    annotation (Placement(transformation(extent={{-120,-76},{-100,-56}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pum(
    redeclare replaceable package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mBui_flow_nominal,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    constantMassFlowRate=mBui_flow_nominal)
    "Building primary pump"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Buildings.Fluid.HeatExchangers.HeaterCooler_u loa(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=mBui_flow_nominal,
    show_T=true,
    from_dp=false,
    dp_nominal=100,
    linearizeFlowResistance=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    Q_flow_nominal=-1)
    "Aggregate building heating load"
    annotation (Placement(transformation(extent={{20,40},{0,60}})));
  Modelica.Blocks.Sources.Ramp ram(
    height=1,
    duration(displayUnit="h") = 3600,
    startTime(displayUnit="h"))
    "Ramp load from zero"
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));
  Modelica.Blocks.Sources.CombiTimeTable QHea(
    table=[0,100E3; 6,80E3; 6,50E3; 12,20E3; 18,150E3; 24,100E3],
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    timeScale=3600) "Heating demand"
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));
  Modelica.Blocks.Math.Product pro
    "Multiplier to ramp load from zero"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Math.Gain gai(k=1/(cp*(50 - 40)))
    "Multiplier gain for calculating m_flow"
    annotation (Placement(transformation(extent={{0,80},{20,100}})));
equation
  connect(TSetDisRet_max.y,heaETS. TSetDisRet)
    annotation (Line(points={{-99,-10},{-0.6,-10}}, color={0,0,127}));
  connect(TDisSupNoi.y, souDis.T_in)
    annotation (Line(points={{-99,-66},{-62,-66}}, color={0,0,127}));
  connect(pum.port_b, loa.port_a)
    annotation (Line(points={{60,30},{80,30},{80,50},{20,50}},
      color={0,127,255}));
  connect(ram.y, pro.u1)
    annotation (Line(points={{-99,90},{-92,90},{-92,76},{-82,76}},
      color={0,0,127}));
  connect(QHea.y[1], pro.u2)
    annotation (Line(points={{-99,50},{-92,50},{-92,64},{-82,64}},
      color={0,0,127}));
  connect(pro.y, loa.u)
    annotation (Line(points={{-59,70},{32,70},{32,56},{22,56}},
      color={0,0,127}));
  connect(pro.y, gai.u)
    annotation (Line(points={{-59,70},{-40,70},{-40,90},{-2,90}},
      color={0,0,127}));
  connect(gai.y, pum.m_flow_in)
    annotation (Line(points={{21,90},{50,90},{50,42}}, color={0,0,127}));
  connect(heaETS.ports_bHeaWat[1], pum.port_a) annotation (Line(points={{20,-1.33333},
          {34,-1.33333},{34,30},{40,30}}, color={0,127,255}));
  connect(heaETS.ports_aHeaWat[1], loa.port_b) annotation (Line(points={{0,-1.33333},
          {-26,-1.33333},{-26,0},{-40,0},{-40,50},{0,50}}, color={0,127,255}));
  connect(heaETS.port_aSerHea, souDis.ports[1]) annotation (Line(points={{0,-18},
          {-20,-18},{-20,-70},{-40,-70}}, color={0,127,255}));
  connect(sinDis.ports[1], heaETS.port_bSerHea) annotation (Line(points={{60,-70},
          {40,-70},{40,-18},{20,-18}}, color={0,127,255}));
  annotation (
    Icon(
      coordinateSystem(
        preserveAspectRatio=false)),
    Diagram(
        coordinateSystem(
        preserveAspectRatio=false,
        extent={{-160,-120},{160,120}})),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/EnergyTransferStations/Heating/Examples/Direct.mos" "Simulate and plot"),
    experiment(
      StartTime=0,
      StopTime=86400,
      Tolerance=1e-06),
    Documentation(info="<html>
<p>This model provides an example for the direct heating energy transfer station 
model, which contains in-building pumping and controls the district return 
temperature. The building's primary variable speed pump is modulated depending 
on the total heating load and prescribed deltaT. Variation in the district 
supply temperature is modeled as a sinusoidal signal to test the response of system.
</p>
</html>",
      revisions="<html>
<ul>
<li>
April 7, 2023, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"));
end Direct;
