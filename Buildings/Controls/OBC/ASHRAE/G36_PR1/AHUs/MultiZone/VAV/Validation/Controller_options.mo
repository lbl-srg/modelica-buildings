within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Validation;
model Controller_options "Validation controller model"

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller conAHU(
    numZon=2,
    AFlo={50,50},
    have_winSen=true,
    controllerTypeMinOut=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    controllerTypeFre=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    controllerTypeFanSpe=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    minZonPriFlo={(50*3/3600)*6,(50*3/3600)*6},
    VPriSysMax_flow=0.7*(50*3/3600)*6*2,
    have_occSen=true,
    controllerTypeTSup=Buildings.Controls.OBC.CDL.Types.SimpleController.PI)
                      "Multiple zone AHU controller"
    annotation (Placement(transformation(extent={{-100,216},{-20,320}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetRooCooOn(
    final k=273.15 + 24)
    "Cooling on setpoint"
    annotation (Placement(transformation(extent={{-220,380},{-200,400}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetRooHeaOn(
    final k=273.15 + 20)
    "Heating on setpoint"
    annotation (Placement(transformation(extent={{-300,380},{-280,400}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOutCut(
    final k=297.15) "Outdoor temperature high limit cutoff"
    annotation (Placement(transformation(extent={{-220,290},{-200,310}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant opeMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.occupied)
    "AHU operation mode is occupied"
    annotation (Placement(transformation(extent={{-80,170},{-60,190}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TZon[2](
    each height=6,
    each offset=273.15 + 17,
    each duration=3600) "Measured zone temperature"
    annotation (Placement(transformation(extent={{-220,330},{-200,350}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TDis[2](
    each height=4,
    each duration=3600,
    each offset=273.15 + 18) "Terminal unit discharge air temperature"
    annotation (Placement(transformation(extent={{-300,290},{-280,310}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp numOfOcc1(
    height=2,
    duration=3600)
    "Occupant number in zone 1"
    annotation (Placement(transformation(extent={{-220,220},{-200,240}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp numOfOcc2(
    duration=3600,
    height=3)
    "Occupant number in zone 2"
    annotation (Placement(transformation(extent={{-200,190},{-180,210}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TSup(
    height=4,
    duration=3600,
    offset=273.15 + 14) "AHU supply air temperature"
    annotation (Placement(transformation(extent={{-300,250},{-280,270}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp VOut_flow(
    duration=1800,
    offset=0.02,
    height=0.0168)
    "Measured outdoor airflow rate"
    annotation (Placement(transformation(extent={{-300,150},{-280,170}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp vavBoxFlo1(
    height=1.5,
    offset=1,
    duration=3600)
    "Ramp signal for generating VAV box flow rate"
    annotation (Placement(transformation(extent={{-300,110},{-280,130}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp vavBoxFlo2(
    offset=1,
    height=0.5,
    duration=3600)
    "Ramp signal for generating VAV box flow rate"
    annotation (Placement(transformation(extent={{-250,110},{-230,130}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TMixMea(
    height=4,
    duration=1,
    offset=273.15 + 2,
    startTime=0)
    "Measured mixed air temperature"
    annotation (Placement(transformation(extent={{-200,110},{-180,130}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TOut(
    amplitude=5,
    offset=18 + 273.15,
    freqHz=1/3600) "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-300,330},{-280,350}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine ducStaPre(
    offset=200,
    amplitude=150,
    freqHz=1/3600) "Duct static pressure"
    annotation (Placement(transformation(extent={{-220,150},{-200,170}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sine(
    offset=3,
    amplitude=2,
    freqHz=1/9600) "Duct static pressure setpoint reset requests"
    annotation (Placement(transformation(extent={{-300,20},{-280,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sine1(
    amplitude=6,
    freqHz=1/9600)
    "Maximum supply temperature setpoint reset"
    annotation (Placement(transformation(extent={{-300,60},{-280,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Abs abs
    "Block generates absolute value of input"
    annotation (Placement(transformation(extent={{-260,60},{-240,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Abs abs1
    "Block generates absolute value of input"
    annotation (Placement(transformation(extent={{-260,20},{-240,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Round round1(n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-220,60},{-200,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Round round2(n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-220,20},{-200,40}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger ducPreResReq
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-180,20},{-160,40}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger maxSupResReq
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-180,60},{-160,80}})));

  CDL.Logical.Sources.Constant winSta[2](final k={true,true})
    "Window status for each zone"
    annotation (Placement(transformation(extent={{-260,220},{-240,240}})));
equation
  connect(sine.y,abs1. u)
    annotation (Line(points={{-279,30},{-262,30}},     color={0,0,127}));
  connect(abs1.y,round2. u)
    annotation (Line(points={{-239,30},{-222,30}},    color={0,0,127}));
  connect(round2.y, ducPreResReq.u)
    annotation (Line(points={{-199,30},{-182,30}},   color={0,0,127}));
  connect(sine1.y, abs.u)
    annotation (Line(points={{-279,70},{-262,70}},     color={0,0,127}));
  connect(abs.y,round1. u)
    annotation (Line(points={{-239,70},{-222,70}},    color={0,0,127}));
  connect(round1.y, maxSupResReq.u)
    annotation (Line(points={{-199,70},{-182,70}},   color={0,0,127}));
  connect(TZon.y, conAHU.TZon)
    annotation (Line(points={{-199,340},{-170,340},{-170,302.667},{-102,302.667}},
      color={0,0,127}));
  connect(TOutCut.y, conAHU.TOutCut)
    annotation (Line(points={{-199,300},{-148,300},{-148,287.259},{-102,287.259}},
      color={0,0,127}));
  connect(TSup.y, conAHU.TSup)
    annotation (Line(points={{-279,260},{-260,260},{-260,273.778},{-102,273.778}},
                                    color={0,0,127}));
  connect(numOfOcc1.y, conAHU.nOcc[1])
    annotation (Line(points={{-199,230},{-170,230},{-170,265.111},{-102,265.111}},
                     color={0,0,127}));
  connect(numOfOcc2.y, conAHU.nOcc[2])
    annotation (Line(points={{-179,200},{-138,200},{-138,267.037},{-102,267.037}},
      color={0,0,127}));
  connect(VOut_flow.y, conAHU.VOut_flow)
    annotation (Line(points={{-279,160},{-260,160},{-260,182},{-154,182},{-154,
          262.222},{-102,262.222}},
                      color={0,0,127}));
  connect(ducStaPre.y, conAHU.ducStaPre)
    annotation (Line(points={{-199,160},{-150,160},{-150,258.37},{-102,258.37}},
      color={0,0,127}));
  connect(vavBoxFlo1.y, conAHU.VDis_flow[1])
    annotation (Line(points={{-279,120},{-260,120},{-260,140},{-160,140},{-160,
          251.63},{-102,251.63}},  color={0,0,127}));
  connect(vavBoxFlo2.y, conAHU.VDis_flow[2])
    annotation (Line(points={{-229,120},{-218,120},{-218,138},{-166,138},{-166,
          253.556},{-102,253.556}},color={0,0,127}));
  connect(TMixMea.y, conAHU.TMix)
    annotation (Line(points={{-179,120},{-142,120},{-142,248.741},{-102,248.741}},
      color={0,0,127}));
  connect(opeMod.y, conAHU.uOpeMod)
    annotation (Line(points={{-59,180},{-40,180},{-40,200},{-120,200},{-120,
          241.037},{-102,241.037}},
                    color={255,127,0}));
  connect(maxSupResReq.y, conAHU.uZonTemResReq)
    annotation (Line(points={{-159,70},{-134,70},{-134,231.407},{-102,231.407}},
      color={255,127,0}));
  connect(ducPreResReq.y, conAHU.uZonPreResReq)
    annotation (Line(points={{-159,30},{-130,30},{-130,225.63},{-102,225.63}},
      color={255,127,0}));
  connect(TOut.y, conAHU.TOut)
    annotation (Line(points={{-279,340},{-260,340},{-260,360},{-164,360},{-164,
          306.519},{-102,306.519}},color={0,0,127}));
  connect(TDis.y, conAHU.TDis)
    annotation (Line(points={{-279,300},{-260,300},{-260,280},{-160,280},{-160,
          294.963},{-102,294.963}},color={0,0,127}));
  connect(TSetRooHeaOn.y, conAHU.TZonHeaSet)
    annotation (Line(points={{-279,390},{-260,390},{-260,370},{-140,370},{-140,
          318.074},{-102,318.074}},color={0,0,127}));

  connect(TSetRooCooOn.y, conAHU.TZonCooSet) annotation (Line(points={{-199,390},
          {-160,390},{-160,314.222},{-102,314.222}}, color={0,0,127}));
  connect(winSta.y, conAHU.uWin) annotation (Line(points={{-239,230},{-230,230},
          {-230,269.926},{-102,269.926}},                       color={255,0,
          255}));
annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36_PR1/AHUs/MultiZone/VAV/Validation/Controller.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 12, 2019, by Michael Wetter:<br/>
Removed wrong use of <code>each</code>.
</li>
<li>
October 30, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
Diagram(coordinateSystem(extent={{-320,-380},{320,420}})),
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
end Controller_options;
