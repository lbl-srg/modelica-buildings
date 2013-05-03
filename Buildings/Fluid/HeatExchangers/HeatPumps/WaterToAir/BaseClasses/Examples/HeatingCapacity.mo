within Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.BaseClasses.Examples;
model HeatingCapacity "Test model for HeatingCapacity"
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.Ramp T1(
    startTime=600,
    duration=1200,
    height=15,
    offset=273.15 + 5) "Medium1 inlet temperature"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.Ramp m1_flow(
    offset=0,
    duration=2400,
    startTime=900,
    height=0.15) "Medium1 mass flow rate"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Sources.Ramp T2(
    startTime=600,
    duration=1200,
    offset=273.15 + 20,
    height=15) "Medium2 inlet temperature"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Modelica.Blocks.Sources.Ramp m2_flow(
    startTime=600,
    offset=0,
    duration=2400,
    height=0.00038) "Medium2 mass flow rate"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Modelica.Blocks.Sources.IntegerStep intSte(
    height=1,
    startTime=60,
    offset=0) "Stage change"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));

  Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.BaseClasses.HeatingCapacity
    heaCap(
    m1_flow_small=datHP.m1_flow_small,
    m2_flow_small=datHP.m2_flow_small,
    heaSta=datHP.heaSta,
    nSta=datHP.nHeaSta) "Calculates heating capacity"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));

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
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
equation
  connect(intSte.y,heaCap. mode) annotation (Line(
      points={{1,70},{10,70},{10,20},{19,20}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(T1.y, heaCap.T1In)      annotation (Line(
      points={{-59,70},{-30,70},{-30,16},{19,16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m1_flow.y, heaCap.m1_flow)    annotation (Line(
      points={{-59,30},{-34,30},{-34,12},{19,12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T2.y, heaCap.T2In)      annotation (Line(
      points={{-59,-10},{-24,-10},{-24,8},{19,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m2_flow.y, heaCap.m2_flow)    annotation (Line(
      points={{-59,-50},{-20,-50},{-20,4},{19,4}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics),__Dymola_Commands(file=
"modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/HeatPumps/WaterToAir/BaseClasses/Examples/HeatingCapacity.mos"
        "Simulate and plot"),
          Documentation(info="<html>
<p>
This example illustrates working of  
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.BaseClasses.HeatingCapacity\">
Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.BaseClasses.HeatingCapacity</a>. 
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
end HeatingCapacity;
