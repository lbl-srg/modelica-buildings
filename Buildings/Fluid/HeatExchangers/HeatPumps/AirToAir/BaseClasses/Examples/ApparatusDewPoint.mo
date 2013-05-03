within Buildings.Fluid.HeatExchangers.HeatPumps.AirToAir.BaseClasses.Examples;
model ApparatusDewPoint "Test model for ApparatusDewPoint"
  extends Modelica.Icons.Example;
  parameter Integer nSta=4 "Number of standard compressor speeds";
  package Medium =
      Buildings.Media.GasesConstantDensity.MoistAirUnsaturated;
  parameter Real minSpeRat(min=0,max=1) = 0.2 "Minimum speed ratio";
  parameter Real speRatDeaBan= 0.05 "Deadband for minimum speed ratio";
  Modelica.Blocks.Sources.Constant p(
    k=101325) "Pressure"
    annotation (Placement(transformation(extent={{-80,-26},{-60,-6}})));
  Buildings.Fluid.HeatExchangers.HeatPumps.AirToAir.BaseClasses.ApparatusDewPoint
                                                                                  adp(
    redeclare package Medium = Medium,
    datHP=datHP,
    variableSpeedCoil=true)
    "Calculates air properties at apparatus dew point condition"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Modelica.Blocks.Sources.Ramp m_flow(
    duration=600,
    height=1.35,
    startTime=600) "Mass flow rate of air"
    annotation (Placement(transformation(extent={{-80,6},{-60,26}})));
  Modelica.Blocks.Sources.Ramp XIn(
    duration=600,
    height=0.004,
    startTime=1800,
    offset=0.011) "Inlet air mass fraction"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Modelica.Blocks.Sources.Ramp Q_flow(
    duration=600,
    startTime=600,
    height=-20000) "Cooling rate"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Sources.TimeTable speRat(
    offset=0,
    startTime=0,
    table=[0.0,0.00; 600,0.25; 1800,0.5; 2700,0.75]) "Speed ratio "
    annotation (Placement(transformation(extent={{-80,72},{-60,92}})));
protected
  Modelica.Blocks.Logical.Hysteresis deaBan(uLow=minSpeRat, uHigh=minSpeRat +
        speRatDeaBan) "Speed ratio deadband"
    annotation (Placement(transformation(extent={{-32,76},{-20,88}})));
  Modelica.Blocks.Math.BooleanToInteger onSwi(
    final integerTrue=1,
    final integerFalse=0) "On/off switch"
    annotation (Placement(transformation(extent={{-6,76},{6,88}})));
public
  Modelica.Blocks.Sources.Constant hIn(k=Medium.specificEnthalpy(
        Medium.setState_pTX(
        p=101325,
        T=30 + 273.15,
        X={0.015}))) "Air enthalpy at inlet"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
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
  connect(Q_flow.y, adp.Q_flow) annotation (Line(
      points={{-59,50},{-46,50},{-46,13.9},{39,13.9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(p.y, adp.p) annotation (Line(
      points={{-59,-16},{-50,-16},{-50,8},{39,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(XIn.y, adp.XIn) annotation (Line(
      points={{-59,-50},{-46,-50},{-46,5},{39,5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRat.y, adp.speRat)    annotation (Line(
      points={{-59,82},{-40,82},{-40,17},{39,17}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRat.y, deaBan.u) annotation (Line(
      points={{-59,82},{-33.2,82}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(deaBan.y, onSwi.u) annotation (Line(
      points={{-19.4,82},{-7.2,82}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(hIn.y, adp.hIn) annotation (Line(
      points={{-59,-80},{-40,-80},{-40,2},{39,2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(onSwi.y, adp.mode) annotation (Line(
      points={{6.6,82},{22,82},{22,20},{39,20}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(m_flow.y, adp.m_flow) annotation (Line(
      points={{-59,16},{-50,16},{-50,11},{39,11}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics),__Dymola_Commands(
file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/HeatPumps/BaseClasses/Examples/ApparatusDewPoint.mos"
        "Simulate and plot"),
          Documentation(info="<html>
<p>
This example illustrates calculation of air properties at apparatus dew point:  
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.ApparatusDewPoint\">
Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.ApparatusDewPoint</a>. 
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
end ApparatusDewPoint;
