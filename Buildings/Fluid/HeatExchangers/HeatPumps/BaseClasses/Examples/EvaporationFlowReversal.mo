within Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.Examples;
model EvaporationFlowReversal
  "Test model for evaporation with zero flow and flow reversal"
  extends Modelica.Icons.Example;
  package Medium =Buildings.Media.GasesConstantDensity.MoistAirUnsaturated;

  final parameter Integer nCooSta= 1;

   Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.Data.BaseClasses.CoolingNominalValues
                                                                                               nomVal= datHP.cooSta[1].nomVal;

  parameter Modelica.SIunits.MassFraction X1In_nominal=
    Buildings.Utilities.Psychrometrics.Functions.X_pSatpphi(
     pSat=Medium.saturationPressure(datHP.cooSta[nCooSta].nomVal.T1In_nominal),
     p=nomVal.p1_nominal,
     phi=datHP.cooSta[nCooSta].nomVal.phi1In_nominal)
    "Mass fraction at nominal inlet conditions";

  parameter Modelica.SIunits.MassFraction X1Out_nominal = X1In_nominal +
   (1-datHP.cooSta[nCooSta].nomVal.SHR_nominal) * nomVal.Q_flow_nominal/nomVal.m1_flow_nominal/Medium.enthalpyOfVaporization(293.15)
    "Nominal air outlet humidity";

  Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.Evaporation eva(
    redeclare package Medium = Medium,
    m(start=0.55),
    datHP=datHP,
    m_flow_nominal=datHP.cooSta[nCooSta].nomVal.m1_flow_nominal,
    SHR_nominal=datHP.cooSta[nCooSta].nomVal.SHR_nominal,
    Q_flow_nominal=datHP.cooSta[nCooSta].nomVal.Q_flow_nominal)
    "Evaporation model"
    annotation (Placement(transformation(extent={{40,6},{60,26}})));
  Modelica.Blocks.Sources.BooleanConstant offSignal(k=false)
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Modelica.Blocks.Sources.Constant TWat(k=293.15)
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Modelica.Blocks.Sources.TimeTable mAir_flow(table=[0,1; 300,1; 900,-1; 1200,-1;
        1500,0; 1800,0]) "Air flow rate"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Modelica.Blocks.Sources.Constant T1(k=nomVal.T1In_nominal)
    "Inlet Temperature"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Modelica.Blocks.Continuous.Integrator int
    "Mass of water that evaporates into air stream"
    annotation (Placement(transformation(extent={{80,6},{100,26}})));
  Modelica.Blocks.Sources.Constant mWat_flow(k=0)
    "Water flow rate added into the medium from the coil model (without reevaporation flow rate)"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Math.Gain gain(k=nomVal.m1_flow_nominal)
    annotation (Placement(transformation(extent={{-48,0},{-28,20}})));
  Modelica.Blocks.Sources.Constant X1In(k=X1In_nominal)
    "Inlet water vapor mass fraction"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
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
          SHR_nominal=0.6),
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
    annotation (Placement(transformation(extent={{80,60},{100,80}})));
equation

  connect(offSignal.y, eva.on)        annotation (Line(
      points={{1,70},{20,70},{20,24},{38,24}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(eva.TWat, TWat.y)    annotation (Line(
      points={{38,14},{-34,14},{-34,40},{-59,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mWat_flow.y, eva.mWat_flow) annotation (Line(
      points={{-59,70},{-30,70},{-30,20},{38,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mAir_flow.y, gain.u) annotation (Line(
      points={{-59,10},{-50,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.y, eva.mAir_flow) annotation (Line(
      points={{-27,10},{3.5,10},{3.5,8},{38,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(eva.mTotWat_flow, int.u) annotation (Line(
      points={{61,16},{78,16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(X1In.y, eva.XOut) annotation (Line(
      points={{-59,-30},{-6,-30},{-6,-26},{44,-26},{44,4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T1.y, eva.TOut) annotation (Line(
      points={{-59,-70},{0,-70},{0,-66},{56,-66},{56,4}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-100,-120},{120,100}},
          preserveAspectRatio=true),
                      graphics),
  __Dymola_Commands(file=
"modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/HeatPumps/BaseClasses/Examples/EvaporationFlowReversal.mos"
        "Simulate and plot"),
          Documentation(info="<html>
<p>
This example illustrates the evaporation of water vapor that 
accumulated on the coil.
Input to the model is an air mass flow rate that is first positive, then
ramps down to a negative value, and eventually ramps up to zero where
it remains for a while.
</p>
</html>",
revisions="<html>
<ul>
<li>
August 25, 2012 by Michael Wetter:<br>
First implementation. 
</li>
</ul>
</html>"),
    experiment(
      StopTime=2400,
      Tolerance=1e-05,
      Algorithm="Radau"),
    __Dymola_experimentSetupOutput);
end EvaporationFlowReversal;
