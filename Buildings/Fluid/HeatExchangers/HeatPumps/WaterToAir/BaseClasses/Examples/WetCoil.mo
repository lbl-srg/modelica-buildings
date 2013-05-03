within Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.BaseClasses.Examples;
model WetCoil "Test model for WetCoil"
 extends Modelica.Icons.Example;
 package Medium =
      Buildings.Media.GasesConstantDensity.MoistAirUnsaturated;
  Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.BaseClasses.WetCoil wetCoi(
      redeclare package Medium = Medium, datHP=datHP)
    "Performs calculation for wet coil condition"
    annotation (Placement(transformation(extent={{70,0},{90,20}})));
  Modelica.Blocks.Sources.Constant p(
    k=101325)
    annotation (Placement(transformation(extent={{-30,-50},{-10,-30}})));
  Modelica.Blocks.Sources.IntegerStep onOff(
    startTime=1200, height=2) "Compressor on-off signal"
    annotation (Placement(transformation(extent={{32,40},{52,60}})));
  Modelica.Blocks.Sources.Ramp XIn(
    duration=600,
    startTime=2400,
    height=-0.002,
    offset=0.006) "Inlet mass-fraction"
    annotation (Placement(transformation(extent={{-30,-80},{-10,-60}})));
  Modelica.Blocks.Sources.Ramp hIn(
    duration=600,
    startTime=2400,
    height=-10000,
    offset=45000) "Specific enthalpy of air entring the coil"
    annotation (Placement(transformation(extent={{26,-78},{46,-58}})));
  Modelica.Blocks.Sources.TimeTable speRat(table=[0.0,0.0; 900,0.25; 1800,0.50;
        2700,0.95]) "Speed ratio "
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Modelica.Blocks.Sources.Ramp T1(
    startTime=600,
    duration=1200,
    height=15,
    offset=273.15 + 5) "Medium1 inlet temperature"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Sources.Ramp m1_flow(
    offset=0,
    duration=2400,
    startTime=900,
    height=0.2) "Medium1 mass flow rate"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Modelica.Blocks.Sources.Ramp T2(
    startTime=600,
    duration=1200,
    offset=273.15 + 20,
    height=15) "Medium2 inlet temperature"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Modelica.Blocks.Sources.Ramp m2_flow(
    startTime=600,
    offset=0,
    duration=2400,
    height=0.00038) "Medium2 mass flow rate"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Data.HPData datHP(
    nHeaSta=1,
    nCooSta=2,
    heaSta={Data.BaseClasses.HeatingStage(
              spe=1800,
              nomVal=Data.BaseClasses.HeatingNominalValues(
                Q_flow_nominal=1838.7,
                COP_nominal=5,
                m1_flow_nominal=0.1661088,
                m2_flow_nominal=0.000381695,
                wasHeaRecFra_nominal=0.1),
              perCur=Data.BaseClasses.PerformanceCurve(
                capFunT={0.617474,-0.00245669,-1.87E-05,0.0254921,-1.01E-04,
            -1.09E-04},
                capFunFF1={1},
                capFunFF2={1},
                EIRFunT={0.993257,0.0201512,7.72E-05,-0.0317207,0.000740649,
            -3.04E-04},
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
    cooSta={Data.BaseClasses.CoolingStage(
              spe=1800,
              nomVal=Data.BaseClasses.CoolingNominalValues(
                Q_flow_nominal=-1524.1,
                COP_nominal=4,
                m1_flow_nominal=0.1359072,
                m2_flow_nominal=0.000381695,
                wasHeaRecFra_nominal=0.1,
                SHR_nominal=0.75),
              perCur=Data.BaseClasses.PerformanceCurve(
                capFunT={1.43085,-0.0453653,0.00199378,-0.00805944,3.93E-05,
            -1.81E-04},
                capFunFF1={1},
                capFunFF2={1},
                EIRFunT={1.43085,-0.0453653,0.00199378,-0.00805944,3.93E-05,
            -1.81E-04},
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
                ff2Max=1.2)),Data.BaseClasses.CoolingStage(
              spe=2200,
              nomVal=Data.BaseClasses.CoolingNominalValues(
                Q_flow_nominal=-1877.9,
                COP_nominal=4,
                m1_flow_nominal=0.151008,
                m2_flow_nominal=0.000381695,
                wasHeaRecFra_nominal=0.1,
                SHR_nominal=0.75),
              perCur=Data.BaseClasses.PerformanceCurve(
                capFunT={1.43085,-0.0453653,0.00199378,-0.00805944,3.93E-05,
            -1.81E-04},
                capFunFF1={1},
                capFunFF2={1},
                EIRFunT={1.43085,-0.0453653,0.00199378,-0.00805944,3.93E-05,
            -1.81E-04},
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
  connect(p.y, wetCoi.p)  annotation (Line(
      points={{-9,-40},{10,-40},{10,7.6},{69,7.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(XIn.y, wetCoi.XIn)     annotation (Line(
      points={{-9,-70},{16,-70},{16,5},{69,5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hIn.y, wetCoi.hIn)     annotation (Line(
      points={{47,-68},{62,-68},{62,2.3},{69,2.3}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRat.y, wetCoi.speRat)     annotation (Line(
      points={{-59,90},{16,90},{16,17.6},{69,17.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T1.y, wetCoi.T[1]) annotation (Line(
      points={{-59,50},{6,50},{6,14.5},{69,14.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T2.y, wetCoi.T[2]) annotation (Line(
      points={{-59,10},{6,10},{6,15.5},{69,15.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m1_flow.y, wetCoi.m_flow[1]) annotation (Line(
      points={{-59,-30},{-34,-30},{-34,11.9},{69,11.9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m2_flow.y, wetCoi.m_flow[2]) annotation (Line(
      points={{-59,-70},{-34,-70},{-34,12.9},{69,12.9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(onOff.y, wetCoi.mode) annotation (Line(
      points={{53,50},{60,50},{60,20},{69,20}},
      color={255,127,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics),__Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/HeatPumps/WaterToAir/BaseClasses/Examples/WetCoil.mos"
        "Simulate and plot"),
          Documentation(info="<html>
<p>
This example illustrates working of WetCoil block 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.BaseClasses.WetCoil\">
Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.BaseClasses.WetCoil</a>. 
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
end WetCoil;
