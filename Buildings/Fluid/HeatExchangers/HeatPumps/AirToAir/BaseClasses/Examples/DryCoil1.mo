within Buildings.Fluid.HeatExchangers.HeatPumps.AirToAir.BaseClasses.Examples;
model DryCoil1 "Test model for DryCoil"
extends Modelica.Icons.Example;
  package Medium =
      Buildings.Media.Air;
  Modelica.Blocks.Sources.Constant p(
    k=101325)
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Buildings.Fluid.HeatExchangers.HeatPumps.AirToAir.BaseClasses.DryCoil1 dryCoi(
    cooCap(nSta=datHP.nCooSta,
    cooSta=datHP.cooSta,
    m1_flow_small=datHP.m1_flow_small),
    redeclare package Medium = Medium,
    datHP=datHP,
    calRecoverableWasteHeat=true,
    nm_flow=1) "Performs calculation for dry coil condition"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Modelica.Blocks.Sources.IntegerStep onOff(
    startTime=1200, height=2) "Compressor on-off signal"
    annotation (Placement(transformation(extent={{22,30},{42,50}})));
  Modelica.Blocks.Sources.Ramp XIn(
    duration=600,
    startTime=2400,
    height=-0.002,
    offset=0.006) "Inlet mass-fraction"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  Modelica.Blocks.Sources.Ramp hIn(
    duration=600,
    startTime=2400,
    height=-10000,
    offset=45000) "Specific enthalpy of air entring the coil"
    annotation (Placement(transformation(extent={{22,-30},{42,-10}})));
  Modelica.Blocks.Sources.TimeTable speRat(table=[0.0,0.0; 900,0.25; 1800,0.50;
        2700,0.95]) "Speed ratio "
    annotation (Placement(transformation(extent={{-80,76},{-60,96}})));
  Modelica.Blocks.Sources.Ramp T1(
    startTime=600,
    duration=1200,
    height=15,
    offset=273.15 + 5) "Medium1 inlet temperature"
    annotation (Placement(transformation(extent={{-80,44},{-60,64}})));
  Modelica.Blocks.Sources.Ramp m1_flow(
    offset=0,
    duration=2400,
    startTime=900,
    height=0.2) "Medium1 mass flow rate"
    annotation (Placement(transformation(extent={{-80,-32},{-60,-12}})));
  Modelica.Blocks.Sources.Ramp T2(
    startTime=600,
    duration=1200,
    offset=273.15 + 20,
    height=15) "Medium2 inlet temperature"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Data.HPData                                                   datHP(
    nCooSta=1,
    heaSta={AirToAir.Data.BaseClasses.HeatingStage(
        spe=1800,
        nomVal=AirToAir.Data.BaseClasses.HeatingNominalValues(
          Q_flow_nominal=1838.7,
          COP_nominal=5,
          m1_flow_nominal=0.1661088),
        perCur=AirToAir.Data.BaseClasses.PerformanceCurve(
          capFunT={0.617474,-0.00245669,-1.87E-05,0.0254921,-1.01E-04,-1.09E-04},
          capFunFF1={1},
          EIRFunT={0.993257,0.0201512,7.72E-05,-0.0317207,0.000740649,-3.04E-04},
          EIRFunFF1={1},
          T1InMin=273.15 + 7,
          T1InMax=273.15 + 27,
          T2InMin=273.15 + 10,
          T2InMax=273.15 + 30,
          ff1Min=0,
          ff1Max=1))},
    nHeaSta=1,
    cooSta={AirToAir.Data.BaseClasses.CoolingStage(
        spe=1800,
        nomVal=AirToAir.Data.BaseClasses.CoolingNominalValues(
          Q_flow_nominal=-1877.9,
          COP_nominal=4,
          m1_flow_nominal=0.151008,
          SHR_nominal=0.75),
        perCur=AirToAir.Data.BaseClasses.PerformanceCurve(
          capFunT={1.43085,-0.0453653,0.00199378,-0.00805944,3.93E-05,-1.81E-04},
          capFunFF1={1},
          EIRFunT={1.43085,-0.0453653,0.00199378,-0.00805944,3.93E-05,-1.81E-04},
          EIRFunFF1={1},
          T1InMin=283.15,
          T1InMax=298.75,
          T2InMin=280.35,
          T2InMax=322.05,
          ff1Min=0.6,
          ff1Max=1.2))})
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
equation
  connect(p.y, dryCoi.p)  annotation (Line(
      points={{-19,-30},{0,-30},{0,7.6},{59,7.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(XIn.y, dryCoi.XIn)     annotation (Line(
      points={{-19,-70},{6,-70},{6,5},{59,5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hIn.y, dryCoi.hIn)     annotation (Line(
      points={{43,-20},{52,-20},{52,2.3},{59,2.3}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRat.y, dryCoi.speRat)     annotation (Line(
      points={{-59,86},{6,86},{6,17.6},{59,17.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T1.y, dryCoi.T[1]) annotation (Line(
      points={{-59,54},{-4,54},{-4,14.5},{59,14.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T2.y, dryCoi.T[2]) annotation (Line(
      points={{-59,20},{-4,20},{-4,15.5},{59,15.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(onOff.y, dryCoi.mode) annotation (Line(
      points={{43,40},{50,40},{50,20},{59,20}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(m1_flow.y, dryCoi.m_flow[1]) annotation (Line(
      points={{-59,-22},{-40,-22},{-40,12.4},{59,12.4}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics),__Dymola_Commands(
file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/HeatPumps/BaseClasses/Examples/DryCoil.mos"
        "Simulate and plot"),
          Documentation(info="<html>
<p>
This example illustrates working of DryCoil block 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.DryCoil\">
Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.DryCoil</a>. 
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
end DryCoil1;
