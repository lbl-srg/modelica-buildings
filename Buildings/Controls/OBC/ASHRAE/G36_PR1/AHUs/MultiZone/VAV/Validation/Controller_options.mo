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
    annotation (Placement(transformation(extent={{-100,196},{-20,300}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetRooCooOn(
    final k=273.15 + 24)
    "Cooling on setpoint"
    annotation (Placement(transformation(extent={{-220,360},{-200,380}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetRooHeaOn(
    final k=273.15 + 20)
    "Heating on setpoint"
    annotation (Placement(transformation(extent={{-300,360},{-280,380}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOutCut(
    final k=297.15) "Outdoor temperature high limit cutoff"
    annotation (Placement(transformation(extent={{-220,270},{-200,290}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant opeMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.occupied)
    "AHU operation mode is occupied"
    annotation (Placement(transformation(extent={{-80,150},{-60,170}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TZon[2](
    each height=6,
    each offset=273.15 + 17,
    each duration=3600) "Measured zone temperature"
    annotation (Placement(transformation(extent={{-220,310},{-200,330}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TDis[2](
    each height=4,
    each duration=3600,
    each offset=273.15 + 18) "Terminal unit discharge air temperature"
    annotation (Placement(transformation(extent={{-300,270},{-280,290}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp numOfOcc1(
    height=2,
    duration=3600)
    "Occupant number in zone 1"
    annotation (Placement(transformation(extent={{-220,200},{-200,220}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp numOfOcc2(
    duration=3600,
    height=3)
    "Occupant number in zone 2"
    annotation (Placement(transformation(extent={{-200,170},{-180,190}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TSup(
    height=4,
    duration=3600,
    offset=273.15 + 14) "AHU supply air temperature"
    annotation (Placement(transformation(extent={{-300,230},{-280,250}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp VOut_flow(
    duration=1800,
    offset=0.02,
    height=0.0168)
    "Measured outdoor airflow rate"
    annotation (Placement(transformation(extent={{-300,130},{-280,150}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp vavBoxFlo1(
    height=1.5,
    offset=1,
    duration=3600)
    "Ramp signal for generating VAV box flow rate"
    annotation (Placement(transformation(extent={{-300,90},{-280,110}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp vavBoxFlo2(
    offset=1,
    height=0.5,
    duration=3600)
    "Ramp signal for generating VAV box flow rate"
    annotation (Placement(transformation(extent={{-250,90},{-230,110}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TMixMea(
    height=4,
    duration=1,
    offset=273.15 + 2,
    startTime=0)
    "Measured mixed air temperature"
    annotation (Placement(transformation(extent={{-200,90},{-180,110}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TOut(
    amplitude=5,
    offset=18 + 273.15,
    freqHz=1/3600) "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-300,310},{-280,330}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine ducStaPre(
    offset=200,
    amplitude=150,
    freqHz=1/3600) "Duct static pressure"
    annotation (Placement(transformation(extent={{-220,130},{-200,150}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sine(
    offset=3,
    amplitude=2,
    freqHz=1/9600) "Duct static pressure setpoint reset requests"
    annotation (Placement(transformation(extent={{-300,0},{-280,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sine1(
    amplitude=6,
    freqHz=1/9600)
    "Maximum supply temperature setpoint reset"
    annotation (Placement(transformation(extent={{-300,40},{-280,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Abs abs
    "Block generates absolute value of input"
    annotation (Placement(transformation(extent={{-260,40},{-240,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Abs abs1
    "Block generates absolute value of input"
    annotation (Placement(transformation(extent={{-260,0},{-240,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Round round1(n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-220,40},{-200,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Round round2(n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-220,0},{-200,20}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger ducPreResReq
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-180,0},{-160,20}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger maxSupResReq
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-180,40},{-160,60}})));

  CDL.Logical.Sources.Constant winSta[2](final k={true,true})
    "Window status for each zone"
    annotation (Placement(transformation(extent={{-260,200},{-240,220}})));
equation
  connect(sine.y,abs1. u)
    annotation (Line(points={{-279,10},{-262,10}},     color={0,0,127}));
  connect(abs1.y,round2. u)
    annotation (Line(points={{-239,10},{-222,10}},    color={0,0,127}));
  connect(round2.y, ducPreResReq.u)
    annotation (Line(points={{-199,10},{-182,10}},   color={0,0,127}));
  connect(sine1.y, abs.u)
    annotation (Line(points={{-279,50},{-262,50}},     color={0,0,127}));
  connect(abs.y,round1. u)
    annotation (Line(points={{-239,50},{-222,50}},    color={0,0,127}));
  connect(round1.y, maxSupResReq.u)
    annotation (Line(points={{-199,50},{-182,50}},   color={0,0,127}));
  connect(TZon.y, conAHU.TZon)
    annotation (Line(points={{-199,320},{-170,320},{-170,282.667},{-102,282.667}},
      color={0,0,127}));
  connect(TOutCut.y, conAHU.TOutCut)
    annotation (Line(points={{-199,280},{-148,280},{-148,267.259},{-102,267.259}},
      color={0,0,127}));
  connect(TSup.y, conAHU.TSup)
    annotation (Line(points={{-279,240},{-260,240},{-260,253.778},{-102,253.778}},
                                    color={0,0,127}));
  connect(numOfOcc1.y, conAHU.nOcc[1])
    annotation (Line(points={{-199,210},{-170,210},{-170,245.111},{-102,245.111}},
                     color={0,0,127}));
  connect(numOfOcc2.y, conAHU.nOcc[2])
    annotation (Line(points={{-179,180},{-138,180},{-138,247.037},{-102,247.037}},
      color={0,0,127}));
  connect(VOut_flow.y, conAHU.VOut_flow)
    annotation (Line(points={{-279,140},{-260,140},{-260,162},{-154,162},{-154,
          242.222},{-102,242.222}},
                      color={0,0,127}));
  connect(ducStaPre.y, conAHU.ducStaPre)
    annotation (Line(points={{-199,140},{-150,140},{-150,238.37},{-102,238.37}},
      color={0,0,127}));
  connect(vavBoxFlo1.y, conAHU.VDis_flow[1])
    annotation (Line(points={{-279,100},{-260,100},{-260,120},{-160,120},{-160,
          231.63},{-102,231.63}},  color={0,0,127}));
  connect(vavBoxFlo2.y, conAHU.VDis_flow[2])
    annotation (Line(points={{-229,100},{-218,100},{-218,118},{-166,118},{-166,
          233.556},{-102,233.556}},color={0,0,127}));
  connect(TMixMea.y, conAHU.TMix)
    annotation (Line(points={{-179,100},{-142,100},{-142,228.741},{-102,228.741}},
      color={0,0,127}));
  connect(opeMod.y, conAHU.uOpeMod)
    annotation (Line(points={{-59,160},{-40,160},{-40,180},{-120,180},{-120,
          221.037},{-102,221.037}},
                    color={255,127,0}));
  connect(maxSupResReq.y, conAHU.uZonTemResReq)
    annotation (Line(points={{-159,50},{-134,50},{-134,211.407},{-102,211.407}},
      color={255,127,0}));
  connect(ducPreResReq.y, conAHU.uZonPreResReq)
    annotation (Line(points={{-159,10},{-130,10},{-130,205.63},{-102,205.63}},
      color={255,127,0}));
  connect(TOut.y, conAHU.TOut)
    annotation (Line(points={{-279,320},{-260,320},{-260,340},{-164,340},{-164,
          286.519},{-102,286.519}},color={0,0,127}));
  connect(TDis.y, conAHU.TDis)
    annotation (Line(points={{-279,280},{-260,280},{-260,260},{-160,260},{-160,
          274.963},{-102,274.963}},color={0,0,127}));
  connect(TSetRooHeaOn.y, conAHU.TZonHeaSet)
    annotation (Line(points={{-279,370},{-260,370},{-260,350},{-140,350},{-140,
          298.074},{-102,298.074}},color={0,0,127}));

  connect(TSetRooCooOn.y, conAHU.TZonCooSet) annotation (Line(points={{-199,370},
          {-160,370},{-160,294.222},{-102,294.222}}, color={0,0,127}));
  connect(winSta.y, conAHU.uWin) annotation (Line(points={{-239,210},{-230,210},
          {-230,249.926},{-102,249.926}},                       color={255,0,
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
Diagram(coordinateSystem(extent={{-320,-360},{320,400}})),
    Icon(coordinateSystem(extent={{-320,-360},{320,400}}),
         graphics={
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
