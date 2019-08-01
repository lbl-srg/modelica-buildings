within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.Validation;
model SupplyFan "Validate SupplyFan"

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.SupplyFan
    conSupFan(
    numZon=4,
    Td=1,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    maxSet=400,
    k=0.001,
    Ti=10) "Block outputs supply fan speed"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.SupplyFan
    conSupFan1(
    numZon=4,
    have_perZonRehBox=true,
    Td=1,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    maxSet=400,
    k=0.001,
    Ti=10) "Block outputs supply fan speed"
    annotation (Placement(transformation(extent={{160,20},{180,40}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.SupplyFan
    conSupFan2(
    numZon=4,
    have_duaDucBox=false,
    have_airFloMeaSta=true,
    Td=1,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    maxSet=400,
    k=0.001,
    Ti=10) "Block outputs supply fan speed"
    annotation (Placement(transformation(extent={{80,20},{100,40}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ram(
    duration=28800,
    height=6) "Ramp signal for generating operation mode"
    annotation (Placement(transformation(extent={{-200,100},{-180,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp vavBoxFlo1(
    duration=28800,
    height=1.5,
    offset=1) "Ramp signal for generating VAV box flow rate"
    annotation (Placement(transformation(extent={{-200,60},{-180,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp vavBoxFlo2(
    duration=28800,
    offset=1,
    height=0.5) "Ramp signal for generating VAV box flow rate"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp vavBoxFlo3(
    duration=28800,
    height=1,
    offset=0.3) "Ramp signal for generating VAV box flow rate"
    annotation (Placement(transformation(extent={{-200,30},{-180,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp vavBoxFlo4(
    duration=28800,
    height=1,
    offset=0) "Ramp signal for generating VAV box flow rate"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sine(
    freqHz=1/14400,
    offset=3,
    amplitude=2)    "Generate sine signal "
    annotation (Placement(transformation(extent={{-200,-10},{-180,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sine1(
    freqHz=1/14400,
    offset=200,
    amplitude=150) "Generate sine signal"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs
    "Block generates absolute value of input"
    annotation (Placement(transformation(extent={{-160,100},{-140,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs1
    "Block generates absolute value of input"
    annotation (Placement(transformation(extent={{-160,-10},{-140,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Round round2(n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-80,100},{-60,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Round round1(n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-120,100},{-100,120}})));

equation
  connect(vavBoxFlo1.y, conSupFan.VDis_flow[1]) annotation (Line(points={{-179,70},
          {-140,70},{-140,30},{-20,30},{-20,31.5},{-2,31.5}},   color={0,0,127}));
  connect(vavBoxFlo2.y, conSupFan.VDis_flow[2]) annotation (Line(points={{-99,70},
          {-30,70},{-30,32.5},{-2,32.5}}, color={0,0,127}));
  connect(vavBoxFlo3.y, conSupFan.VDis_flow[3]) annotation (Line(points={{-179,40},
          {-150,40},{-150,28},{-30,28},{-30,33.5},{-2,33.5}},   color={0,0,127}));
  connect(vavBoxFlo4.y, conSupFan.VDis_flow[4]) annotation (Line(points={{-59,50},
          {-40,50},{-40,34.5},{-2,34.5}},   color={0,0,127}));
  connect(sine1.y, conSupFan.ducStaPre)
    annotation (Line(points={{-99,-40},{-10,-40},{-10,22},{-2,22}},
      color={0,0,127}));
  connect(sine.y, abs1.u)
    annotation (Line(points={{-179,0},{-162,0}},
      color={0,0,127}));
  connect(ram.y, abs.u)
    annotation (Line(points={{-179,110},{-162,110}},
      color={0,0,127}));
  connect(abs1.y, round2.u)
    annotation (Line(points={{-139,0},{-122,0}},   color={0,0,127}));
  connect(round2.y, reaToInt1.u)
    annotation (Line(points={{-99,0},{-82,0}},  color={0,0,127}));
  connect(reaToInt1.y, conSupFan.uZonPreResReq)
    annotation (Line(points={{-59,0},{-20,0},{-20,27},{-2,27}},
      color={255,127,0}));
  connect(abs.y, round1.u)
    annotation (Line(points={{-139,110},{-122,110}},
                                                 color={0,0,127}));
  connect(round1.y, reaToInt2.u)
    annotation (Line(points={{-99,110},{-82,110}},
                                              color={0,0,127}));
  connect(reaToInt2.y, conSupFan.uOpeMod)
    annotation (Line(points={{-59,110},{-20,110},{-20,38},{-2,38}},
      color={255,127,0}));

  connect(reaToInt2.y, conSupFan2.uOpeMod) annotation (Line(points={{-59,110},{60,
          110},{60,38},{78,38}}, color={255,127,0}));
  connect(reaToInt1.y, conSupFan2.uZonPreResReq) annotation (Line(points={{-59,0},
          {60,0},{60,27},{78,27}}, color={255,127,0}));
  connect(sine1.y, conSupFan2.ducStaPre) annotation (Line(points={{-99,-40},{70,
          -40},{70,22},{78,22}}, color={0,0,127}));
  connect(reaToInt2.y, conSupFan1.uOpeMod) annotation (Line(points={{-59,110},{150,
          110},{150,38},{158,38}}, color={255,127,0}));
  connect(reaToInt1.y, conSupFan1.uZonPreResReq) annotation (Line(points={{-59,0},
          {150,0},{150,27},{158,27}}, color={255,127,0}));
  connect(sine1.y, conSupFan1.ducStaPre) annotation (Line(points={{-99,-40},{152,
          -40},{152,22},{158,22}}, color={0,0,127}));
  connect(vavBoxFlo1.y, conSupFan1.VDis_flow[1]) annotation (Line(points={{-179,
          70},{-140,70},{-140,90},{130,90},{130,31.5},{158,31.5}}, color={0,0,127}));
  connect(vavBoxFlo2.y, conSupFan1.VDis_flow[2]) annotation (Line(points={{-99,70},
          {130,70},{130,32.5},{158,32.5}}, color={0,0,127}));
  connect(vavBoxFlo3.y, conSupFan1.VDis_flow[3]) annotation (Line(points={{-179,
          40},{-150,40},{-150,20},{-40,20},{-40,10},{130,10},{130,33.5},{158,33.5}},
        color={0,0,127}));
  connect(vavBoxFlo4.y, conSupFan1.VDis_flow[4]) annotation (Line(points={{-59,50},
          {-40,50},{-40,60},{130,60},{130,34.5},{158,34.5}}, color={0,0,127}));
annotation (experiment(StopTime=28800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36_PR1/AHUs/MultiZone/VAV/SetPoints/Validation/SupplyFan.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.SupplyFan\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.SupplyFan</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 19, 2019, by Milica Grahovac:<br/>
Added test cases.
</li>
<li>
August 24, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(extent={{-220,-80},{220,140}})));
end SupplyFan;
