within Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.Examples;
model DXCooling "Test model for DXCooling"
  extends Modelica.Icons.Example;
  package Medium =
      Buildings.Media.Air;
  Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.DXCooling dxCoo(
    redeclare package Medium = Medium,
    variableSpeedCoil=true,
    datHP=datHP,
    calRecoverableWasteHeat=false)
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Sources.Constant p(
    k=101325)
    annotation (Placement(transformation(extent={{-52,-50},{-32,-30}})));
  Modelica.Blocks.Sources.IntegerStep onOff(
    startTime=1200, height=2) "Compressor on-off signal"
    annotation (Placement(transformation(extent={{10,20},{30,40}})));
  Modelica.Blocks.Sources.Ramp XIn(
    duration=600,
    startTime=2400,
    height=-0.002,
    offset=0.008) "Inlet mass-fraction"
    annotation (Placement(transformation(extent={{-52,-90},{-32,-70}})));
  Modelica.Blocks.Sources.Ramp hIn(
    duration=600,
    startTime=2400,
    height=-10000,
    offset=45000) "Specific enthalpy of air entring the coil"
    annotation (Placement(transformation(extent={{10,-40},{30,-20}})));
  Modelica.Blocks.Sources.TimeTable speRat(table=[0.0,0.0; 900,0.25; 1800,0.50;
        2700,0.95]) "Speed ratio "
    annotation (Placement(transformation(extent={{-92,66},{-72,86}})));
  Modelica.Blocks.Sources.Ramp T1(
    startTime=600,
    duration=1200,
    height=15,
    offset=273.15 + 5) "Medium1 inlet temperature"
    annotation (Placement(transformation(extent={{-92,34},{-72,54}})));
  Modelica.Blocks.Sources.Ramp m1_flow(
    offset=0,
    duration=2400,
    startTime=900,
    height=0.2) "Medium1 mass flow rate"
    annotation (Placement(transformation(extent={{-92,-42},{-72,-22}})));
  Modelica.Blocks.Sources.Ramp T2(
    startTime=600,
    duration=1200,
    offset=273.15 + 20,
    height=15) "Medium2 inlet temperature"
    annotation (Placement(transformation(extent={{-92,0},{-72,20}})));
  Modelica.Blocks.Sources.Ramp m2_flow(
    startTime=600,
    offset=0,
    duration=2400,
    height=0.00038) "Medium2 mass flow rate"
    annotation (Placement(transformation(extent={{-92,-76},{-72,-56}})));
  Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.Data.HPData   datHP(
    nHeaSta=1,
    nCooSta=2,
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
          ff2Max=1.2))},
    cooSta={
        Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.Data.BaseClasses.CoolingStage(
        spe=1800,
        nomVal=
          Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.Data.BaseClasses.CoolingNominalValues(
          Q_flow_nominal=-1524.1,
          COP_nominal=4,
          m1_flow_nominal=0.1359072,
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
          ff2Max=1.2)),
        Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.Data.BaseClasses.CoolingStage(
         spe=2200,
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
          ff2Max=1.2))})
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
equation
  connect(p.y, dxCoo.p)  annotation (Line(
      points={{-31,-40},{-12,-40},{-12,-2.4},{59,-2.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(XIn.y, dxCoo.X1In)     annotation (Line(
      points={{-31,-80},{-6,-80},{-6,-5},{59,-5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hIn.y, dxCoo.h1In)     annotation (Line(
      points={{31,-30},{40,-30},{40,-7.7},{59,-7.7}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRat.y, dxCoo.speRat)     annotation (Line(
      points={{-71,76},{-6,76},{-6,7.6},{59,7.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T1.y, dxCoo.T[1]) annotation (Line(
      points={{-71,44},{-16,44},{-16,4.5},{59,4.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T2.y, dxCoo.T[2]) annotation (Line(
      points={{-71,10},{-16,10},{-16,5.5},{59,5.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m1_flow.y, dxCoo.m_flow[1]) annotation (Line(
      points={{-71,-32},{-56,-32},{-56,1.9},{59,1.9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m2_flow.y, dxCoo.m_flow[2]) annotation (Line(
      points={{-71,-66},{-56,-66},{-56,2.9},{59,2.9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(onOff.y, dxCoo.mode) annotation (Line(
      points={{31,30},{38,30},{38,10},{59,10}},
      color={255,127,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics),__Dymola_Commands(
file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/HeatPumps/BaseClasses/Examples/DXCooling.mos"
        "Simulate and plot"),
          Documentation(info="<html>
<p>
This example illustrates working of DXCooling block 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.DXCooling\">
Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.DXCooling</a>. 
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
end DXCooling;
