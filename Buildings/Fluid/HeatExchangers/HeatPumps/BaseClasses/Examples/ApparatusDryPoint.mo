within Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.Examples;
model ApparatusDryPoint "Test model for ApparatusDryPoint"
  extends Modelica.Icons.Example;
  parameter Integer nSta=4;
  package Medium =
      Buildings.Media.Air;
  parameter Real minSpeRat(min=0,max=1) = 0.2 "Minimum speed ratio";
  parameter Real speRatDeaBan= 0.05 "Deadband for minimum speed ratio";
  Modelica.Blocks.Sources.Constant p(
    k=101325) "Pressure"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Modelica.Blocks.Sources.Constant hEvaIn(k=Medium.specificEnthalpy(
        Medium.setState_pTX(
        p=101325,
        T=30 + 273.15,
        X={0.015}))) "Air enthalpy at inlet"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.ApparatusDryPoint appDryPt(
    redeclare package Medium = Medium,
    datHP=datHP,
    variableSpeedCoil=true) "Dry point condition"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Sources.Ramp m_flow(
    duration=600,
    height=1.35,
    startTime=900) "Mass flow rate of air"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Modelica.Blocks.Sources.Ramp Q_flow(
    duration=600,
    height=-20000,
    startTime=900,
    offset=0) "Heat extracted from air"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Sources.TimeTable speRat(
    table=[0.0,0.0; 900,0.25; 1800,0.50; 2700,0.75],
    offset=0.25,
    startTime=900) "Speed ratio "
    annotation (Placement(transformation(extent={{-80,72},{-60,92}})));
protected
  Modelica.Blocks.Logical.Hysteresis deaBan(
     uLow=minSpeRat,
     uHigh=minSpeRat + speRatDeaBan) "Speed ratio deadband"
    annotation (Placement(transformation(extent={{-6,76},{6,88}})));
  Modelica.Blocks.Math.BooleanToInteger onSwi(
    final integerTrue=1,
    final integerFalse=0) "On/off switch"
    annotation (Placement(transformation(extent={{20,76},{32,88}})));
public
  Modelica.Blocks.Sources.Ramp XEvaIn(
    duration=600,
    height=0.004,
    startTime=1800,
    offset=0.011) "Inlet air mass fraction"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.Data.HPData   datHP(
    nHeaSta=1,
    nCooSta=1,
    cooSta={
        Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.Data.BaseClasses.CoolingStage(
        spe=1800,
        nomVal=
          Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.Data.BaseClasses.CoolingNominalValues(
          Q_flow_nominal=-1877.9,
          COP_nominal=4,
          m1_flow_nominal=0.151008,
          m2_flow_nominal=0.000381695,
          wasHeaRecFra_nominal=0.1,
          SHR_nominal=0.75),
        perCur=
          Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.Data.BaseClasses.PerformanceCurve(
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
          ff2Max=1.2))},
    heaSta={
        Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.Data.BaseClasses.HeatingStage(
        spe=1800,
        nomVal=
          Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.Data.BaseClasses.HeatingNominalValues(
          Q_flow_nominal=1838.7,
          COP_nominal=5,
          m1_flow_nominal=0.1661088,
          m2_flow_nominal=0.000381695,
          wasHeaRecFra_nominal=0.1),
        perCur=
          Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.Data.BaseClasses.PerformanceCurve(
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
          ff2Max=1.2))})
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
equation
  connect(p.y, appDryPt.p) annotation (Line(
      points={{-59,-20},{-30,-20},{-30,-2},{59,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hEvaIn.y, appDryPt.hIn) annotation (Line(
      points={{-59,-80},{-24,-80},{-24,-8},{59,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_flow.y, appDryPt.m_flow) annotation (Line(
      points={{-59,10},{-30,10},{-30,1},{59,1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Q_flow.y, appDryPt.Q_flow) annotation (Line(
      points={{-59,50},{-24,50},{-24,3.9},{59,3.9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRat.y, appDryPt.speRat)    annotation (Line(
      points={{-59,82},{-14,82},{-14,7},{59,7}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRat.y,deaBan. u) annotation (Line(
      points={{-59,82},{-7.2,82}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(deaBan.y,onSwi. u) annotation (Line(
      points={{6.6,82},{18.8,82}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(XEvaIn.y, appDryPt.XIn) annotation (Line(
      points={{-59,-50},{-28,-50},{-28,-5},{59,-5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(onSwi.y, appDryPt.mode) annotation (Line(
      points={{32.6,82},{46,82},{46,10},{59,10}},
      color={255,127,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics),__Dymola_Commands(
file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/HeatPumps/BaseClasses/Examples/ApparatusDryPoint.mos"
        "Simulate and plot"),
          Documentation(info="<html>
<p>
This example illustrates working of ApparatusDryPoint block 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.ApparatusDryPoint\">
Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.ApparatusDryPoint</a>. 
</p>
</html>",
revisions="<html>
<ul>
<li>
April 10, 2012 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>
</html>"));
end ApparatusDryPoint;
