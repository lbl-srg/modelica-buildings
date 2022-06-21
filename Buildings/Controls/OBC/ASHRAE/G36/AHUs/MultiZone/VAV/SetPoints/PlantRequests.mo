within Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints;
block PlantRequests "Output plant requests for multizone air handling unit"

  parameter Boolean have_hotWatCoi = true
    "True: the AHU has hot water coil";
  parameter Real Thys = 0.1
    "Hysteresis for checking temperature difference"
    annotation(Dialog(tab="Advanced"));
  parameter Real posHys = 0.05
    "Hysteresis for checking valve position difference"
    annotation(Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TAirSup(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-240,180},{-200,220}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TAirSupSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Setpoint for supply air temperature"
    annotation (Placement(transformation(extent={{-240,140},{-200,180}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCooCoi_actual(
    final unit="1",
    final min=0,
    final max=1)
    "Actual cooling coil valve position"
    annotation (Placement(transformation(extent={{-240,80},{-200,120}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHeaCoi_actual(
    final unit="1",
    final min=0,
    final max=1) if have_hotWatCoi "Actual heating coil valve position"
    annotation (Placement(transformation(extent={{-240,-160},{-200,-120}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yChiWatResReq
    "Chilled water reset request"
    annotation (Placement(transformation(extent={{200,180},{240,220}}),
        iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yChiPlaReq
    "Chiller plant request"
    annotation (Placement(transformation(extent={{200,0},{240,40}}),
        iconTransformation(extent={{100,10},{140,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHotWatResReq if have_hotWatCoi
    "Hot water reset request"
    annotation (Placement(transformation(extent={{200,-60},{240,-20}}),
        iconTransformation(extent={{100,-50},{140,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHotWatPlaReq if have_hotWatCoi
    "Hot water plant request"
    annotation (Placement(transformation(extent={{200,-240},{240,-200}}),
        iconTransformation(extent={{100,-100},{140,-60}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Subtract cooSupTemDif
    "Find the cooling supply temperature difference to the setpoint"
    annotation (Placement(transformation(extent={{-170,190},{-150,210}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final t=3,
    final h=Thys)
    "Check if the supply temperature is greater than the setpoint by a threshold value"
    annotation (Placement(transformation(extent={{-80,190},{-60,210}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr1(
    final t=2,
    final h=Thys)
    "Check if the supply temperature is greater than the setpoint by a threshold value"
    annotation (Placement(transformation(extent={{-80,140},{-60,160}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=120)
    "Check if the input has been true for a certain time"
    annotation (Placement(transformation(extent={{-40,190},{-20,210}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1(
    final delayTime=120)
    "Check if the input has been true for a certain time"
    annotation (Placement(transformation(extent={{-40,140},{-20,160}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr2(
    final t=0.95,
    final h=posHys)
    "Check if the chilled water valve position is greater than a threshold value"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant thr(
    final k=3) "Constant 3"
    annotation (Placement(transformation(extent={{0,222},{20,242}})));
  Buildings.Controls.OBC.CDL.Integers.Switch chiWatRes3
    "Send 3 chilled water reset request"
    annotation (Placement(transformation(extent={{160,190},{180,210}})));
  Buildings.Controls.OBC.CDL.Integers.Switch chiWatRes2
    "Send 2 chilled water reset request"
    annotation (Placement(transformation(extent={{120,140},{140,160}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant two(
    final k=2)
    "Constant 2"
    annotation (Placement(transformation(extent={{0,170},{20,190}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr(
    final t=0.85,
    final h=posHys)
    "Check if the chilled water valve position is less than a threshold value"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Keep true signal until other condition becomes true"
    annotation (Placement(transformation(extent={{-40,90},{-20,110}})));
  Buildings.Controls.OBC.CDL.Integers.Switch chiWatRes1
    "Send 1 chilled water reset request"
    annotation (Placement(transformation(extent={{80,90},{100,110}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant one(
    final k=1) "Constant 1"
    annotation (Placement(transformation(extent={{0,110},{20,130}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant zer(
    final k=0) "Constant 0"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat1
    "Keep true signal until other condition becomes true"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr1(
    final t=0.1,
    final h=posHys)
    "Check if the chilled water valve position is less than a threshold value"
    annotation (Placement(transformation(extent={{-120,4},{-100,24}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi3
    "Send 1 chiller plant request"
    annotation (Placement(transformation(extent={{80,10},{100,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract heaSupTemDif if have_hotWatCoi
    "Find the heating supply temperature difference to the setpoint"
    annotation (Placement(transformation(extent={{-150,-50},{-130,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr3(
    final t=17,
    final h=Thys)
    if have_hotWatCoi
    "Check if the supply temperature is less than the setpoint by a threshold value"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr4(
    final t=8,
    final h=Thys)
    if have_hotWatCoi
    "Check if the supply temperature is less than the setpoint by a threshold value"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel2(
    final delayTime=300) if have_hotWatCoi
    "Check if the input has been true for a certain time"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel3(
    final delayTime=300) if have_hotWatCoi
    "Check if the input has been true for a certain time"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));
  Buildings.Controls.OBC.CDL.Integers.Switch hotWatRes3 if have_hotWatCoi
    "Send 3 hot water reset request"
    annotation (Placement(transformation(extent={{160,-50},{180,-30}})));
  Buildings.Controls.OBC.CDL.Integers.Switch hotWatRes2 if have_hotWatCoi
    "Send 2 hot water reset request"
    annotation (Placement(transformation(extent={{120,-100},{140,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr2(
    final t=0.85,
    final h=posHys)
    if have_hotWatCoi
    "Check if the hot water valve position is less than a threshold value"
    annotation (Placement(transformation(extent={{-120,-190},{-100,-170}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr5(
    final t=0.95,
    final h=posHys)
    if have_hotWatCoi
    "Check if the hot water valve position is greater than a threshold value"
    annotation (Placement(transformation(extent={{-120,-150},{-100,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat2 if have_hotWatCoi
    "Keep true signal until other condition becomes true"
    annotation (Placement(transformation(extent={{-40,-150},{-20,-130}})));
  Buildings.Controls.OBC.CDL.Integers.Switch hotWatRes1 if have_hotWatCoi
    "Send 1 hot water reset request"
    annotation (Placement(transformation(extent={{80,-150},{100,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr3(
    final t=0.1,
    final h=posHys)
    if have_hotWatCoi
    "Check if the hot water valve position is less than a threshold value"
    annotation (Placement(transformation(extent={{-120,-236},{-100,-216}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat3 if have_hotWatCoi
    "Keep true signal until other condition becomes true"
    annotation (Placement(transformation(extent={{-40,-230},{-20,-210}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi1 if have_hotWatCoi
    "Send 1 hot water plant request"
    annotation (Placement(transformation(extent={{80,-230},{100,-210}})));

equation
  connect(TAirSup, cooSupTemDif.u1) annotation (Line(points={{-220,200},{-180,200},
          {-180,206},{-172,206}}, color={0,0,127}));
  connect(TAirSupSet, cooSupTemDif.u2) annotation (Line(points={{-220,160},{-190,
          160},{-190,194},{-172,194}}, color={0,0,127}));
  connect(cooSupTemDif.y, greThr.u)
    annotation (Line(points={{-148,200},{-82,200}}, color={0,0,127}));
  connect(greThr.y, truDel.u)
    annotation (Line(points={{-58,200},{-42,200}}, color={255,0,255}));
  connect(greThr1.y, truDel1.u)
    annotation (Line(points={{-58,150},{-42,150}}, color={255,0,255}));
  connect(cooSupTemDif.y, greThr1.u) annotation (Line(points={{-148,200},{-100,200},
          {-100,150},{-82,150}}, color={0,0,127}));
  connect(uCooCoi_actual, greThr2.u)
    annotation (Line(points={{-220,100},{-122,100}}, color={0,0,127}));
  connect(truDel.y, chiWatRes3.u2)
    annotation (Line(points={{-18,200},{158,200}}, color={255,0,255}));
  connect(thr.y, chiWatRes3.u1) annotation (Line(points={{22,232},{60,232},{60,208},
          {158,208}}, color={255,127,0}));
  connect(truDel1.y, chiWatRes2.u2)
    annotation (Line(points={{-18,150},{118,150}}, color={255,0,255}));
  connect(two.y, chiWatRes2.u1) annotation (Line(points={{22,180},{50,180},{50,158},
          {118,158}}, color={255,127,0}));
  connect(greThr2.y, lat.u)
    annotation (Line(points={{-98,100},{-42,100}}, color={255,0,255}));
  connect(uCooCoi_actual, lesThr.u) annotation (Line(points={{-220,100},{-140,100},
          {-140,60},{-122,60}}, color={0,0,127}));
  connect(lesThr.y, lat.clr) annotation (Line(points={{-98,60},{-60,60},{-60,94},
          {-42,94}}, color={255,0,255}));
  connect(one.y, chiWatRes1.u1) annotation (Line(points={{22,120},{40,120},{40,108},
          {78,108}}, color={255,127,0}));
  connect(lat.y, chiWatRes1.u2)
    annotation (Line(points={{-18,100},{78,100}}, color={255,0,255}));
  connect(chiWatRes1.y, chiWatRes2.u3) annotation (Line(points={{102,100},{110,100},
          {110,142},{118,142}}, color={255,127,0}));
  connect(chiWatRes2.y, chiWatRes3.u3) annotation (Line(points={{142,150},{150,150},
          {150,192},{158,192}}, color={255,127,0}));
  connect(zer.y, chiWatRes1.u3) annotation (Line(points={{22,60},{30,60},{30,92},
          {78,92}}, color={255,127,0}));
  connect(chiWatRes3.y, yChiWatResReq)
    annotation (Line(points={{182,200},{220,200}}, color={255,127,0}));
  connect(greThr2.y, lat1.u) annotation (Line(points={{-98,100},{-80,100},{-80,20},
          {-42,20}}, color={255,0,255}));
  connect(uCooCoi_actual, lesThr1.u) annotation (Line(points={{-220,100},{-140,100},
          {-140,14},{-122,14}}, color={0,0,127}));
  connect(lesThr1.y, lat1.clr)
    annotation (Line(points={{-98,14},{-42,14}}, color={255,0,255}));
  connect(lat1.y, intSwi3.u2)
    annotation (Line(points={{-18,20},{78,20}}, color={255,0,255}));
  connect(one.y, intSwi3.u1) annotation (Line(points={{22,120},{40,120},{40,28},
          {78,28}}, color={255,127,0}));
  connect(zer.y, intSwi3.u3) annotation (Line(points={{22,60},{30,60},{30,12},{78,
          12}}, color={255,127,0}));
  connect(intSwi3.y, yChiPlaReq)
    annotation (Line(points={{102,20},{220,20}}, color={255,127,0}));
  connect(TAirSupSet, heaSupTemDif.u1) annotation (Line(points={{-220,160},{-190,
          160},{-190,-34},{-152,-34}}, color={0,0,127}));
  connect(TAirSup, heaSupTemDif.u2) annotation (Line(points={{-220,200},{-180,200},
          {-180,-46},{-152,-46}}, color={0,0,127}));
  connect(greThr3.y, truDel2.u)
    annotation (Line(points={{-58,-40},{-42,-40}}, color={255,0,255}));
  connect(greThr4.y, truDel3.u)
    annotation (Line(points={{-58,-90},{-42,-90}}, color={255,0,255}));
  connect(heaSupTemDif.y, greThr3.u)
    annotation (Line(points={{-128,-40},{-82,-40}}, color={0,0,127}));
  connect(heaSupTemDif.y, greThr4.u) annotation (Line(points={{-128,-40},{-100,-40},
          {-100,-90},{-82,-90}}, color={0,0,127}));
  connect(truDel2.y, hotWatRes3.u2)
    annotation (Line(points={{-18,-40},{158,-40}}, color={255,0,255}));
  connect(thr.y, hotWatRes3.u1) annotation (Line(points={{22,232},{60,232},{60,-32},
          {158,-32}}, color={255,127,0}));
  connect(hotWatRes2.y, hotWatRes3.u3) annotation (Line(points={{142,-90},{150,-90},
          {150,-48},{158,-48}}, color={255,127,0}));
  connect(two.y, hotWatRes2.u1) annotation (Line(points={{22,180},{50,180},{50,-82},
          {118,-82}}, color={255,127,0}));
  connect(truDel3.y, hotWatRes2.u2)
    annotation (Line(points={{-18,-90},{118,-90}}, color={255,0,255}));
  connect(hotWatRes3.y, yHotWatResReq)
    annotation (Line(points={{182,-40},{220,-40}}, color={255,127,0}));
  connect(uHeaCoi_actual, greThr5.u)
    annotation (Line(points={{-220,-140},{-122,-140}}, color={0,0,127}));
  connect(greThr5.y, lat2.u)
    annotation (Line(points={{-98,-140},{-42,-140}}, color={255,0,255}));
  connect(uHeaCoi_actual, lesThr2.u) annotation (Line(points={{-220,-140},{-140,
          -140},{-140,-180},{-122,-180}}, color={0,0,127}));
  connect(lesThr2.y, lat2.clr) annotation (Line(points={{-98,-180},{-60,-180},{-60,
          -146},{-42,-146}}, color={255,0,255}));
  connect(lat2.y, hotWatRes1.u2)
    annotation (Line(points={{-18,-140},{78,-140}}, color={255,0,255}));
  connect(one.y, hotWatRes1.u1) annotation (Line(points={{22,120},{40,120},{40,-132},
          {78,-132}}, color={255,127,0}));
  connect(zer.y, hotWatRes1.u3) annotation (Line(points={{22,60},{30,60},{30,-148},
          {78,-148}}, color={255,127,0}));
  connect(hotWatRes1.y, hotWatRes2.u3) annotation (Line(points={{102,-140},{110,
          -140},{110,-98},{118,-98}}, color={255,127,0}));
  connect(uHeaCoi_actual, lesThr3.u) annotation (Line(points={{-220,-140},{-140,
          -140},{-140,-226},{-122,-226}}, color={0,0,127}));
  connect(lesThr3.y, lat3.clr)
    annotation (Line(points={{-98,-226},{-42,-226}}, color={255,0,255}));
  connect(greThr5.y, lat3.u) annotation (Line(points={{-98,-140},{-80,-140},{-80,
          -220},{-42,-220}}, color={255,0,255}));
  connect(lat3.y, intSwi1.u2)
    annotation (Line(points={{-18,-220},{78,-220}}, color={255,0,255}));
  connect(one.y, intSwi1.u1) annotation (Line(points={{22,120},{40,120},{40,-212},
          {78,-212}}, color={255,127,0}));
  connect(zer.y, intSwi1.u3) annotation (Line(points={{22,60},{30,60},{30,-228},
          {78,-228}}, color={255,127,0}));
  connect(intSwi1.y, yHotWatPlaReq)
    annotation (Line(points={{102,-220},{220,-220}}, color={255,127,0}));

annotation (
  defaultComponentName="mulAHUPlaReq",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
    graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-98,88},{-70,72}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TAirSup"),
        Text(
          extent={{-100,140},{100,100}},
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-98,40},{-52,20}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TAirSupSet"),
        Text(
          extent={{-98,-22},{-38,-38}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uCooCoi_actual"),
        Text(
          extent={{-98,-72},{-36,-88}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          visible=have_hotWatCoi,
          textString="uHeaCoi_actual"),
        Text(
          extent={{34,92},{98,70}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yChiWatResReq"),
        Text(
          extent={{52,42},{98,20}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yChiPlaReq"),
        Text(
          extent={{34,-18},{98,-40}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yHotWatResReq",
          visible=have_hotWatCoi),
        Text(
          extent={{38,-66},{98,-88}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yHotWatPlaReq",
          visible=have_hotWatCoi)}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-260},{200,260}})),
  Documentation(info="<html>
<p>
This sequence outputs the system reset requests for multiple zone air handling unit. The
implementation is according to the Section 5.16.16 of ASHRAE Guideline 36, May 2020. 
</p>
<h4>chilled water reset request <code>yChiWatResReq</code></h4>
<ol>
<li>
If the supply air temperature <code>TAirSup</code> exceeds the supply air temperature
set point <code>TAirSupSet</code> by 3 &deg;C (5 &deg;F) for 2 minutes, send 3 requests.
</li>
<li>
If the supply air temperature <code>TAirSup</code> exceeds the supply air temperature
set point <code>TAirSupSet</code> by 2 &deg;C (3 &deg;F) for 2 minutes, send 2 requests.
</li>
<li>
Else if the chilled water valve position <code>uCooCoi_actual</code> is greater than
95%, send 1 request until the <code>uCooCoi_actual</code> is less than 85%.
</li>
<li>
Else if the chilled water valve position <code>uCooCoi_actual</code> is less than 95%,
send 0 request.
</li>
</ol>
<h4>Chiller plant request <code>yChiPlaReq</code></h4>
<p>
Send the chiller plant that serves the system a chiller plant request as follows:
</p>
<ol>
<li>
If the chilled water valve position <code>uCooCoi_actual</code> is greater than
95%, send 1 request until the <code>uCooCoi_actual</code> is less than 10%.
</li>
<li>
Else if the chilled water valve position <code>uCooCoi_actual</code> is less than 95%,
send 0 request.
</li>
</ol>
<h4>If there is a hot-water coil (<code>have_hotWatCoi=true</code>), hot-water
reset requests <code>yHotWatResReq</code></h4>
<ol>
<li>
If the supply air temperature <code>TAirSup</code> is 17 &deg;C (30 &deg;F) less than
the supply air temperature set point <code>TAirSupSet</code> for 5 minutes, send 3
requests.
</li>
<li>
Else if the supply air temperature <code>TAirSup</code> is 8 &deg;C (15 &deg;F) less than
the supply air temperature set point <code>TAirSupSet</code> for 5 minutes, send 2
requests.
</li>
<li>
Else if the hot water valve position <code>uHeaCoi_actual</code> is greater than
95%, send 1 request until the <code>uHeaCoi_actual</code> is less than 85%.
</li>
<li>
Else if the hot water valve position <code>uHeaCoi_actual</code> is less than 95%,
send 0 request.
</li>
</ol>
<h4>If there is a hot-water coil and heating hot-water plant, heating hot-water
plant reqeusts <code>yHotWatPlaReq</code></h4>
<p>
Send the heating hot-water plant that serves the air handling unit a heating hot-water
plant request as follows:
</p>
<ol>
<li>
If the hot water valve position <code>uHeaCoi_actual</code> is greater than 95%, send 1
request until the hot water valve position is less than 10%.
</li>
<li>
If the hot water valve position <code>uHeaCoi_actual</code> is less than 95%, send 0 requests.
</li>
</ol>
</html>", revisions="<html>
<ul>
<li>
December 1, 2021, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end PlantRequests;
