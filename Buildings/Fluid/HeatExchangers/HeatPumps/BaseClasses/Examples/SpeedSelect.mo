within Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.Examples;
model SpeedSelect "Test model for SpeedSelect"
  import Buildings;
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.IntegerTable mod(table=[0,0; 1,1; 2,0; 3,2; 4,2; 5,0])
    "Mode change"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Modelica.Blocks.Sources.IntegerTable stage(table=[0,0; 1,1; 2,0; 3,1; 4,2; 5,0])
    "Stage change"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.SpeedSelect speSel(
    nHeaSta=datHP.nHeaSta,
    heaSpeSet=datHP.heaSta.spe,
    nCooSta=datHP.nCooSta,
    cooSpeSet=datHP.cooSta.spe)                                           annotation (Placement(transformation(extent={{0,-10},{20,10}})));
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
    annotation (Placement(transformation(extent={{60,38},{80,58}})));
equation

  connect(mod.y, speSel.mode) annotation (Line(
      points={{-19,30},{-10,30},{-10,4},{-1,4}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(stage.y, speSel.stage) annotation (Line(
      points={{-19,-30},{-10,-30},{-10,-4},{-1,-4}},
      color={255,127,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics),__Dymola_Commands(file=
"modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/HeatPumps/BaseClasses/Examples/SpeedSelect.mos"
        "Simulate and plot"),
          Documentation(info="<html>
<p>
This example illustrates working of  
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.SpeedSelect\">
Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.SpeedSelect</a>. 
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
end SpeedSelect;
