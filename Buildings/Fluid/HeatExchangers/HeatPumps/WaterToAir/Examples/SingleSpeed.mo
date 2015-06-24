within Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.Examples;
model SingleSpeed "Test model for single speed water to air heat pump"
  extends Modelica.Icons.Example;
  package Medium1 =
      Buildings.Media.Air;
  package Medium2 = Buildings.Media.Water;
  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal = datHP.heaSta[1].nomVal.m1_flow_nominal
    "Medium1 nominal mass flow rate";
  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal = datHP.heaSta[1].nomVal.m2_flow_nominal
    "Medium2 nominal mass flow rate";
  parameter Modelica.SIunits.Pressure dp1_nominal = 1000
    "Pressure drop at m1_flow_nominal";
  parameter Modelica.SIunits.Pressure dp2_nominal = 8000
    "Pressure drop at m2_flow_nominal";
  Buildings.Fluid.Sources.Boundary_pT sin1(
    redeclare package Medium = Medium1,
    p(displayUnit="Pa") = 101325,
    nPorts=1,
    T=300.15) "Sink"
    annotation (Placement(transformation(extent={{60,0},{40,20}})));
  Buildings.Fluid.Sources.Boundary_pT sou2(
    use_p_in=true,
    redeclare package Medium = Medium2,
    nPorts=1,
    T=303.15)
    annotation (Placement(transformation(extent={{60,-40},{40,-20}})));
  Buildings.Fluid.Sources.Boundary_pT sin2(
    redeclare package Medium = Medium2,
    p(displayUnit="Pa") = 101325,
    nPorts=1,
    T=298.15) "Sink"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.Fluid.Sources.Boundary_pT sou1(
    use_p_in=true,
    redeclare package Medium = Medium1,
    nPorts=1,
    T=293.15)
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
      inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

  Modelica.Blocks.Sources.Ramp p1(
    duration=600,
    offset=101325,
    height=2000,
    startTime=60) "Pressure"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Modelica.Blocks.Sources.Ramp p2(
    duration=600,
    offset=101325,
    startTime=60,
    height=3000) "Pressure"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=0,
        origin={90,-30})));
  Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.SingleSpeed sinSpe(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    datHP=datHP,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    dp1_nominal=dp1_nominal,
    dp2_nominal=dp2_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
    computeReevaporation=false,
    calRecoverableWasteHeat=true) "Single speed water to air heat pump"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Modelica.Blocks.Sources.IntegerTable intTab(table=[0,0; 900,1; 1800,2; 2700,
        1]) "Mode change"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Data.HPData                                                       datHP(
    nHeaSta=1,
    nCooSta=1,
    heaSta={
        Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.Data.BaseClasses.HeatingStage(
        spe=1800,
        nomVal=Data.BaseClasses.HeatingNominalValues(
          Q_flow_nominal=1838.7,
          COP_nominal=5,
          m1_flow_nominal=1.2*0.1661088,
          m2_flow_nominal=982*0.000381695,
          wasHeaRecFra_nominal=0.1),
        perCur=Data.BaseClasses.PerformanceCurve(
          capFunT={0.617474,-0.00245669,-1.87E-05,0.0254921,-1.01E-04,-1.09E-04},
          capFunFF1={1},
          capFunFF2={1},
          EIRFunT={0.993257,0.0201512,7.72E-05,-0.0317207,0.000740649,-3.04E-04},
          EIRFunFF1={1},
          EIRFunFF2={1},
          wasHeaFunT={1,0,0,0,0,0},
          T1InMin=273.15 + 7,
          T1InMax=273.15 + 27,
          T2InMin=273.15 + 10,
          T2InMax=273.15 + 30,
          ff1Min=0.6,
          ff1Max=1.2,
          ff2Min=0.6,
          ff2Max=1.2))},
    cooSta={
        Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.Data.BaseClasses.CoolingStage(
        spe=1800,
        nomVal=Data.BaseClasses.CoolingNominalValues(
          Q_flow_nominal=-1524.1,
          COP_nominal=4,
          m1_flow_nominal=1.2*0.1359072,
          m2_flow_nominal=982*0.000381695,
          wasHeaRecFra_nominal=0.1,
          SHR_nominal=0.75,
          gamma=1),
        perCur=Data.BaseClasses.PerformanceCurve(
          capFunT={1.43085,-0.0453653,0.00199378,-0.00805944,3.93E-05,-1.81E-04},
          capFunFF1={1},
          capFunFF2={1},
          EIRFunT={1.43085,-0.0453653,0.00199378,-0.00805944,3.93E-05,-1.81E-04},
          EIRFunFF1={1},
          EIRFunFF2={1},
          wasHeaFunT={1,0,0,0,0,0},
          T1InMin=283.15,
          T1InMax=298.75,
          T2InMin=280.35,
          T2InMax=322.05,
          ff1Min=0.6,
          ff1Max=1.2,
          ff2Min=0.6,
          ff2Max=1.2))})
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
equation
  connect(p1.y, sou1.p_in) annotation (Line(
      points={{-79,10},{-72,10},{-72,18},{-62,18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(p2.y, sou2.p_in) annotation (Line(
      points={{79,-30},{72,-30},{72,-22},{62,-22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou1.ports[1], sinSpe.port_a1) annotation (Line(
      points={{-40,10},{-26,10},{-26,6},{-10,6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sin2.ports[1], sinSpe.port_b2) annotation (Line(
      points={{-40,-30},{-26,-30},{-26,-6},{-10,-6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sin1.ports[1], sinSpe.port_b1) annotation (Line(
      points={{40,10},{28,10},{28,6},{10,6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sinSpe.port_a2, sou2.ports[1]) annotation (Line(
      points={{10,-6},{26,-6},{26,-30},{40,-30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(intTab.y, sinSpe.mode) annotation (Line(
      points={{-59,50},{-20,50},{-20,10},{-12,10}},
      color={255,127,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics),__Dymola_Commands(file=
"modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/HeatPumps/WaterToAir/Examples/SingleSpeed.mos"
        "Simulate and plot"),
          Documentation(info="<html>
<p>
This is a test model for  
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.Examples.SingleSpeed\">
Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.Examples.SingleSpeed</a>. 
The model has open-loop control and time-varying input conditions. 
Pressure difference across both sides of heat pump is ramped up from zero to 2000 Pa and 3000 Pa respectively thus, this example tests zero mass flow rate condition. 
Also the control input i.e. the mode of coil is changed to heating and then cooling condition from off state.
</p>
</html>",
revisions="<html>
<ul>
<li>
Jan 12, 2013 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul></html>"));
end SingleSpeed;
