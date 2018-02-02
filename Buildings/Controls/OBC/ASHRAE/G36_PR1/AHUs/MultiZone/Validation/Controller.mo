within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Validation;
model Controller "Validation controller model"

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Controller conAHU(
    numZon=2,
    AFlo={50,50},
    minZonPriFlo={(50*3/3600)*6,(50*3/3600)*6},
    maxSysPriFlo=0.7*(50*3/3600)*6*2,
    have_occSen=true) "Multiple zone AHU controller"
    annotation (Placement(transformation(extent={{22,48},{102,152}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetRooCooOn(
    final k=273.15 + 24)
    "Cooling on setpoint"
    annotation (Placement(transformation(extent={{-100,133},{-80,154}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetRooHeaOn(
    final k=273.15 + 20)
    "Heating on setpoint"
    annotation (Placement(transformation(extent={{-170,133},{-150,153}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOutCut(
    final k=297.15)
    "Outdoor temperature high limit cutoff"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant opeMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.occupied)
    "AHU operation mode is occupied"
    annotation (Placement(transformation(extent={{48,0},{68,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TZon[2](
    each height=6,
    each offset=273.15 + 17,
    each duration=3600) "Measured zone temperature"
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TDis[2](
    each height=4,
    each duration=3600,
    each offset=273.15 + 18) "Terminal unit discharge air temperature"
    annotation (Placement(transformation(extent={{-170,60},{-150,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp numOfOcc1(
    height=2,
    duration=3600)
    "Occupant number in zone 1"
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp numOfOcc2(
    duration=3600,
    height=3)
    "Occupant number in zone 2"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TSup(
    each height=4,
    each duration=3600,
    each offset=273.15 + 14) "AHU supply air temperature"
    annotation (Placement(transformation(extent={{-170,20},{-150,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp VOut_flow(
    duration=1800,
    offset=0.02,
    height=0.0168)
    "Measured outdoor airflow rate"
    annotation (Placement(transformation(extent={{-170,-20},{-150,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp vavBoxFlo1(
    height=1.5,
    offset=1,
    duration=3600)
    "Ramp signal for generating VAV box flow rate"
    annotation (Placement(transformation(extent={{-170,-60},{-150,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp vavBoxFlo2(
    offset=1,
    height=0.5,
    duration=3600)
    "Ramp signal for generating VAV box flow rate"
    annotation (Placement(transformation(extent={{-130,-60},{-110,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TMixMea(
    height=4,
    duration=1,
    offset=273.15 + 2,
    startTime=0)
    "Measured mixed air temperature"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TOut(
    amplitude=5,
    offset=18 + 273.15,
    freqHz=1/3600) "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-170,100},{-150,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine ducStaPre(
    offset=200,
    amplitude=150,
    freqHz=1/3600) "Duct static pressure"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sine(
    offset=3,
    amplitude=2,
    freqHz=1/9600) "Duct static pressure setpoint reset requests"
    annotation (Placement(transformation(extent={{-170,-150},{-150,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sine1(
    amplitude=6,
    freqHz=1/9600)
    "Maximum supply temperature setpoint reset"
    annotation (Placement(transformation(extent={{-170,-110},{-150,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs
    "Block generates absolute value of input"
    annotation (Placement(transformation(extent={{-130,-110},{-110,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs1
    "Block generates absolute value of input"
    annotation (Placement(transformation(extent={{-130,-150},{-110,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.Round round1(n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-94,-110},{-74,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Round round2(n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-94,-150},{-74,-130}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger ducPreResReq "Convert real to integer"
    annotation (Placement(transformation(extent={{-60,-150},{-40,-130}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger maxSupResReq "Convert real to integer"
    annotation (Placement(transformation(extent={{-60,-110},{-40,-90}})));

equation
  connect(sine.y,abs1. u)
    annotation (Line(points={{-149,-140},{-132,-140}}, color={0,0,127}));
  connect(abs1.y,round2. u)
    annotation (Line(points={{-109,-140},{-96,-140}}, color={0,0,127}));
  connect(round2.y, ducPreResReq.u)
    annotation (Line(points={{-73,-140},{-62,-140}}, color={0,0,127}));
  connect(sine1.y, abs.u)
    annotation (Line(points={{-149,-100},{-132,-100}}, color={0,0,127}));
  connect(abs.y,round1. u)
    annotation (Line(points={{-109,-100},{-96,-100}}, color={0,0,127}));
  connect(round1.y, maxSupResReq.u)
    annotation (Line(points={{-73,-100},{-62,-100}}, color={0,0,127}));
  connect(TSetRooHeaOn.y, conAHU.THeaSet)
    annotation (Line(points={{-149,143},{-144,143},{-144,144},{-140,144},{-140,
          160},{-16,160},{-16,150.074},{20,150.074}},
                                                  color={0,0,127}));
  connect(TSetRooCooOn.y, conAHU.TCooSet)
    annotation (Line(points={{-79,143.5},{-18,143.5},{-18,146.222},{20,146.222}},
      color={0,0,127}));
  connect(TOut.y, conAHU.TOut)
    annotation (Line(points={{-149,110},{-140,110},{-140,126},{-18,126},{-18,
          138.519},{20,138.519}},
                          color={0,0,127}));
  connect(TZon.y, conAHU.TZon)
    annotation (Line(points={{-79,110},{-20,110},{-20,134.667},{20,134.667}},
      color={0,0,127}));
  connect(TDis.y, conAHU.TDis)
    annotation (Line(points={{-149,70},{-140,70},{-140,94},{-22,94},{-22,
          126.963},{20,126.963}},
                          color={0,0,127}));
  connect(TOutCut.y, conAHU.TOutCut)
    annotation (Line(points={{-79,70},{-26,70},{-26,119.259},{20,119.259}},
      color={0,0,127}));
  connect(TSup.y, conAHU.TSup)
    annotation (Line(points={{-149,30},{-140,30},{-140,54},{-60,54},{-60,
          105.778},{20,105.778}},
                          color={0,0,127}));
  connect(numOfOcc1.y, conAHU.nOcc[1])
    annotation (Line(points={{-99,30},{-90,30},{-90,52},{-18,52},{-18,97.1111},
          {20,97.1111}},  color={0,0,127}));
  connect(numOfOcc2.y, conAHU.nOcc[2])
    annotation (Line(points={{-59,30},{-50,30},{-50,52},{-18,52},{-18,99.037},{
          20,99.037}},    color={0,0,127}));
  connect(VOut_flow.y, conAHU.VOut_flow)
    annotation (Line(points={{-149,-10},{-140,-10},{-140,12},{-34,12},{-34,
          94.2222},{20,94.2222}},
                          color={0,0,127}));
  connect(ducStaPre.y, conAHU.ducStaPre)
    annotation (Line(points={{-79,-10},{-30,-10},{-30,90.3704},{20,90.3704}},
      color={0,0,127}));
  connect(vavBoxFlo1.y, conAHU.VBox_flow[1])
    annotation (Line(points={{-149,-50},{-140,-50},{-140,-30},{-40,-30},{-40,
          83.6296},{20,83.6296}},
                          color={0,0,127}));
  connect(vavBoxFlo2.y, conAHU.VBox_flow[2])
    annotation (Line(points={{-109,-50},{-100,-50},{-100,-30},{-40,-30},{-40,
          85.5556},{20,85.5556}},
                          color={0,0,127}));
  connect(TMixMea.y, conAHU.TMix)
    annotation (Line(points={{-59,-50},{-22,-50},{-22,80.7407},{20,80.7407}},
      color={0,0,127}));
  connect(opeMod.y, conAHU.uOpeMod)
    annotation (Line(points={{69,10},{80,10},{80,30},{0,30},{0,73.037},{20,
          73.037}},       color={255,127,0}));
  connect(maxSupResReq.y, conAHU.uZonTemResReq)
    annotation (Line(points={{-39,-100},{-16,-100},{-16,63.4074},{20,63.4074}},
      color={255,127,0}));
  connect(ducPreResReq.y, conAHU.uZonPreResReq)
    annotation (Line(points={{-39,-140},{-12,-140},{-12,57.6296},{20,57.6296}},
      color={255,127,0}));

annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36_PR1/AHUs/MultiZone/Validation/Controller.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Controller\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Controller</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 30, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
Diagram(coordinateSystem(extent={{-180,-160},{120,180}})),
    Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}));
end Controller;
