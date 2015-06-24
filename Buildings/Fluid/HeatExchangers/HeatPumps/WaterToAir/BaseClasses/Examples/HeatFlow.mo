within Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.BaseClasses.Examples;
model HeatFlow "Test model for HeatFlow"
  extends Modelica.Icons.Example;
  package Medium =
      Buildings.Media.Air;
  Modelica.Blocks.Sources.Ramp T1(
    startTime=600,
    duration=1200,
    height=15,
    offset=273.15 + 5) "Medium1 inlet temperature"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Modelica.Blocks.Sources.Ramp m1_flow(
    offset=0,
    duration=2400,
    height=0.15,
    startTime=300) "Medium1 mass flow rate"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Sources.Ramp T2(
    startTime=600,
    duration=1200,
    offset=273.15 + 20,
    height=15) "Medium2 inlet temperature"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Sources.Ramp m2_flow(
    offset=0,
    duration=2400,
    height=0.00038,
    startTime=450) "Medium2 mass flow rate"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));

  Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.Data.HPData datHP(
    nHeaSta=1,
    nCooSta=1,
    cooSta={Data.BaseClasses.CoolingStage(
        spe=1800,
        nomVal=Data.BaseClasses.CoolingNominalValues(
          Q_flow_nominal=-1877.9,
          COP_nominal=4,
          m1_flow_nominal=0.151008,
          m2_flow_nominal=0.000381695,
          wasHeaRecFra_nominal=0.1,
          SHR_nominal=0.75),
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
          ff2Max=1.2))},
    heaSta={Data.BaseClasses.HeatingStage(
        spe=1800,
        nomVal=Data.BaseClasses.HeatingNominalValues(
          Q_flow_nominal=1838.7,
          COP_nominal=5,
          m1_flow_nominal=0.1661088,
          m2_flow_nominal=0.000381695,
          wasHeaRecFra_nominal=0.1),
        perCur=Data.BaseClasses.PerformanceCurve(
          capFunT={0.617474,-0.00245669,-1.87E-05,0.0254921,-1.01E-04,-1.09E-04},
          capFunFF1={0.8,0.2,0.0},
          capFunFF2={1},
          EIRFunT={0.993257,0.0201512,7.72E-05,-0.0317207,0.000740649,-3.04E-04},
          EIRFunFF1={1.1552,-0.1808,0.0256,0},
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
    annotation (Placement(transformation(extent={{60,40},{80,60}})));

  Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.BaseClasses.HeatFlow heaFlo(
    variableSpeedCoil=true,
    datHP=datHP,
    redeclare package Medium1 = Medium)
              annotation (Placement(transformation(extent={{40,0},{60,20}})));

  Modelica.Blocks.Sources.TimeTable speRat(table=[0.0,0.0; 900,0.25; 1800,0.50;
        2700,0.75]) "Speed ratio "
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Modelica.Blocks.Sources.Constant p(
    k=101325) "Pressure"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Modelica.Blocks.Sources.Constant h1In(k=Medium.specificEnthalpy(
        Medium.setState_pTX(
        p=101325,
        T=30 + 273.15,
        X={0.015}))) "Air enthalpy at inlet"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
public
  Modelica.Blocks.Sources.Ramp X1In(
    duration=600,
    height=0.004,
    startTime=1800,
    offset=0.011) "Inlet air mass fraction"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  Modelica.Blocks.Sources.IntegerTable intTab(table=[0,0; 600,1; 1200,2; 1800,0;
        2400,2; 3000,1]) "Mode change"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
equation
  connect(speRat.y, heaFlo.speRat)  annotation (Line(
      points={{-59,90},{-34,90},{-34,17.6},{39,17.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T1.y, heaFlo.T[1])  annotation (Line(
      points={{-59,60},{-40,60},{-40,14.5},{39,14.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T2.y, heaFlo.T[2])  annotation (Line(
      points={{-59,30},{-40,30},{-40,15.5},{39,15.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m1_flow.y, heaFlo.m_flow[1])  annotation (Line(
      points={{-59,6.10623e-16},{-40,6.10623e-16},{-40,11.9},{39,11.9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m2_flow.y, heaFlo.m_flow[2])  annotation (Line(
      points={{-59,-30},{-40,-30},{-40,12.9},{39,12.9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(p.y, heaFlo.p)
                      annotation (Line(
      points={{-59,-60},{-34,-60},{-34,7.6},{39,7.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(X1In.y, heaFlo.X1In)
                            annotation (Line(
      points={{-59,-90},{-28,-90},{-28,5},{39,5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(h1In.y, heaFlo.h1In)
                            annotation (Line(
      points={{1,-70},{20,-70},{20,2.3},{39,2.3}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intTab.y, heaFlo.mode)
                              annotation (Line(
      points={{21,50},{30,50},{30,20},{39,20}},
      color={255,127,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics),__Dymola_Commands(file=
"modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/HeatPumps/WaterToAir/BaseClasses/Examples/HeatFlow.mos"
        "Simulate and plot"),
          Documentation(info="<html>
<p>
This example illustrates working of  
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.BaseClasses.HeatFlow\">
Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.BaseClasses.HeatFlow</a>. 
</p>
</html>",
revisions="<html>
<ul>
<li>
Jan 12, 2013 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>
</html>"));
end HeatFlow;
