within Buildings.Templates.Plants.Controls.HeatRecoveryChillers;
block Enable
  "Heat recovery chiller enable/disable"
  parameter Real TChiWatSup_min(
    final min=273.15,
    start=4 + 273.15,
    final unit="K",
    displayUnit="degC")
    "Minimum allowable CHW supply temperature"
    annotation (Dialog(group="Information provided by designer"));
  parameter Real THeaWatSup_max(
    final min=273.15,
    start=60 + 273.15,
    final unit="K",
    displayUnit="degC")
    "Maximum allowable HW supply temperature"
    annotation (Dialog(group="Information provided by designer"));
  parameter Real capCoo_min(
    final min=0,
    final unit="W")
    "Minimum cooling capacity below which cycling occurs"
    annotation (Dialog(group="Information provided by designer"));
  parameter Real capHea_min(
    final min=0,
    final unit="W")
    "Minimum heating capacity below which cycling occurs"
    annotation (Dialog(group="Information provided by designer"));
  parameter Real dtRun(
    final min=0,
    final unit="s")=15 * 60
    "Minimum runtime of enable and disable states";
  parameter Real dtLoa(
    final min=0,
    final unit="s")=10 * 60
    "Runtime with sufficient load before enabling";
  parameter Real dtTem1(
    final min=0,
    final unit="s")=3 * 60
    "Runtime with first temperature threshold exceeded before disabling";
  parameter Real dtTem2(
    final min=0,
    final unit="s")=1 * 60
    "Runtime with second temperature threshold exceeded before disabling";
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Coo
    "Cooling plant enable"
    annotation (Placement(transformation(extent={{-240,140},{-200,180}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Hea
    "Heating plant enable"
    annotation (Placement(transformation(extent={{-240,80},{-200,120}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Hrc_actual
    "HRC status"
    annotation (Placement(transformation(extent={{-240,40},{-200,80}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput QChiWatReq_flow(
    final unit="W")
    "CHW load"
    annotation (Placement(transformation(extent={{-240,-60},{-200,-20}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput QHeaWatReq_flow(
    final unit="W")
    "HW load"
    annotation (Placement(transformation(extent={{-240,-100},{-200,-60}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatHrcLvg(
    final unit="K",
    displayUnit="degC")
    "HRC leaving CHW temperature"
    annotation (Placement(transformation(extent={{-240,-160},{-200,-120}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatHrcLvg(
    final unit="K",
    displayUnit="degC")
    "HRC leaving HW temperature"
    annotation (Placement(transformation(extent={{-240,-220},{-200,-180}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1CooHrc
    "HRC control mode command: true for cooling, false for heating"
    annotation (Placement(transformation(extent={{-240,0},{-200,40}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1
    "Enable command"
    annotation (Placement(transformation(extent={{200,-20},{240,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Logical.Pre preEna
    "Left limit (in discrete-time) of enable signal"
    annotation (Placement(transformation(extent={{-150,190},{-130,210}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timCooEna(
    final t=dtRun)
    "Return true if cooling plant has been enabled for specified duration"
    annotation (Placement(transformation(extent={{-180,158},{-160,178}})));
  Buildings.Controls.OBC.CDL.Logical.Not dis
    "Return true if disabled"
    annotation (Placement(transformation(extent={{-70,190},{-50,210}})));
  Buildings.Controls.OBC.CDL.Logical.Timer runDis(
    final t=dtRun)
    "Return true if system has been disabled for specified duration"
    annotation (Placement(transformation(extent={{-30,190},{-10,210}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timHeaEna(
    final t=dtRun)
    "Return true if heating plant has been enabled for specified duration"
    annotation (Placement(transformation(extent={{-180,98},{-160,118}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold higLoaCoo(
    final t=capCoo_min,
    h=1E-4 * capCoo_min)
    "Compare CHW load to cycling limit (hysteresis is to avoid chattering with some simulators)"
    annotation (Placement(transformation(extent={{-180,-50},{-160,-30}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold higLoaHea(
    final t=capHea_min,
    h=1E-4 * capHea_min)
    "Compare HW load to cycling limit (hysteresis is to avoid chattering with some simulators)"
    annotation (Placement(transformation(extent={{-180,-90},{-160,-70}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold lowTChiWatLvg1(
    final t=TChiWatSup_min + 1)
    "Return true if first temperature limit exceeded"
    annotation (Placement(transformation(extent={{-180,-150},{-160,-130}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold higTHeaWatLvg1(
    final t=THeaWatSup_max - 1.5)
    "Return true if first temperature limit exceeded"
    annotation (Placement(transformation(extent={{-180,-210},{-160,-190}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold higTHeaWatLvg2(
    final t=THeaWatSup_max)
    "Return true if second temperature limit exceeded"
    annotation (Placement(transformation(extent={{-140,-230},{-120,-210}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold lowTChiWatLvg2(
    final t=TChiWatSup_min)
    "Return true if second temperature limit exceeded"
    annotation (Placement(transformation(extent={{-140,-170},{-120,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timTHeaWatLvg1(
    final t=dtTem1)
    "Return true if threshold exceeded for specified duration"
    annotation (Placement(transformation(extent={{-90,-202},{-70,-182}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timTHeaWatLvg2(
    final t=dtTem2)
    "Return true if threshold exceeded for specified duration"
    annotation (Placement(transformation(extent={{-50,-230},{-30,-210}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timTChiWatLvg1(
    final t=dtTem1)
    "Return true if threshold exceeded for specified duration"
    annotation (Placement(transformation(extent={{-90,-142},{-70,-122}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timTChiWatLvg2(
    final t=dtTem2)
    "Return true if threshold exceeded for specified duration"
    annotation (Placement(transformation(extent={{-50,-170},{-30,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timLoaCoo(
    final t=dtLoa)
    "Return true if threshold exceeded for specified duration"
    annotation (Placement(transformation(extent={{-32,-50},{-12,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timLoaHea(
    final t=dtLoa)
    "Return true if threshold exceeded for specified duration"
    annotation (Placement(transformation(extent={{-32,-90},{-12,-70}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd allEna(
    nin=5)
    "All enable conditions met"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyDis(
    nin=5)
    "Any disable condition met"
    annotation (Placement(transformation(extent={{70,-110},{90,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Not disCoo
    "Return true if cooling plant disabled"
    annotation (Placement(transformation(extent={{-180,130},{-160,150}})));
  Buildings.Controls.OBC.CDL.Logical.Not disHea
    "Return true if heating plant disabled"
    annotation (Placement(transformation(extent={{-180,70},{-160,90}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold lowLoaCoo(
    final t=capCoo_min,
    h=1E-4 * capCoo_min)
    "Compare CHW load to cycling limit (hysteresis is to avoid chattering with some simulators)"
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold lowLoaHea(
    final t=capHea_min,
    h=1E-4 * capHea_min)
    "Compare HW load to cycling limit (hysteresis is to avoid chattering with some simulators)"
    annotation (Placement(transformation(extent={{-110,-110},{-90,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Or anyLowLoa
    "Any low load condition met"
    annotation (Placement(transformation(extent={{-70,-70},{-50,-50}})));
  Buildings.Controls.OBC.CDL.Logical.FallingEdge off
    "Return true when HRC cycles off"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}})));
  Buildings.Controls.OBC.CDL.Logical.And anyLowLoaAndOff
    "Any low load condition met and HRC cycles off"
    annotation (Placement(transformation(extent={{-30,50},{-10,70}})));
  Buildings.Controls.OBC.CDL.Logical.And enaAndCoo
    "HRC enabled in cooling mode"
    annotation (Placement(transformation(extent={{-110,10},{-90,30}})));
  Buildings.Controls.OBC.CDL.Logical.And enaAndHea
    "HRC enabled in heating mode"
    annotation (Placement(transformation(extent={{-110,-30},{-90,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Not hea
    "True if heating control mode"
    annotation (Placement(transformation(extent={{-180,-10},{-160,10}})));
  Buildings.Controls.OBC.CDL.Logical.Or anyTChiWatLvg
    "Any leaving CHW temperature condition met"
    annotation (Placement(transformation(extent={{-10,-150},{10,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Or anyTHeaWatLvg
    "Any leaving HW temperature condition met"
    annotation (Placement(transformation(extent={{-10,-210},{10,-190}})));
  Buildings.Controls.OBC.CDL.Logical.And anyTChiWatLvgAndHea
    "Any leaving CHW temperature condition met and HRC enabled in heating mode"
    annotation (Placement(transformation(extent={{32,-150},{52,-130}})));
  Buildings.Controls.OBC.CDL.Logical.And anyTHeaWatLvgAndCoo
    "Any leaving HW temperature condition met and HRC enabled in cooling mode"
    annotation (Placement(transformation(extent={{30,-210},{50,-190}})));
  Buildings.Controls.OBC.CDL.Logical.Latch enaDis
    "Maintain true signal until disable condition met"
    annotation (Placement(transformation(extent={{110,-50},{130,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1SetMod
    "Enable mode setting"
    annotation (Placement(transformation(extent={{200,-60},{240,-20}}),
      iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    delayTime=5)
    "Delay so that mode setting is enabled prior to enabling the HRC"
    annotation (Placement(transformation(extent={{150,-10},{170,10}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Enable mode setting just before enabling the HRC"
    annotation (Placement(transformation(extent={{150,-50},{170,-30}})));
equation
  connect(preEna.y, dis.u)
    annotation (Line(points={{-128,200},{-72,200}},color={255,0,255}));
  connect(dis.y, runDis.u)
    annotation (Line(points={{-48,200},{-32,200}},color={255,0,255}));
  connect(u1Coo, timCooEna.u)
    annotation (Line(points={{-220,160},{-190,160},{-190,168},{-182,168}},color={255,0,255}));
  connect(u1Hea, timHeaEna.u)
    annotation (Line(points={{-220,100},{-190,100},{-190,108},{-182,108}},color={255,0,255}));
  connect(y1, preEna.u)
    annotation (Line(points={{220,0},{180,0},{180,220},{-160,220},{-160,200},{-152,200}},
      color={255,0,255}));
  connect(QChiWatReq_flow, higLoaCoo.u)
    annotation (Line(points={{-220,-40},{-182,-40}},color={0,0,127}));
  connect(QHeaWatReq_flow, higLoaHea.u)
    annotation (Line(points={{-220,-80},{-182,-80}},color={0,0,127}));
  connect(TChiWatHrcLvg, lowTChiWatLvg1.u)
    annotation (Line(points={{-220,-140},{-182,-140}},color={0,0,127}));
  connect(THeaWatHrcLvg, higTHeaWatLvg1.u)
    annotation (Line(points={{-220,-200},{-182,-200}},color={0,0,127}));
  connect(TChiWatHrcLvg, lowTChiWatLvg2.u)
    annotation (Line(points={{-220,-140},{-190,-140},{-190,-160},{-142,-160}},
      color={0,0,127}));
  connect(THeaWatHrcLvg, higTHeaWatLvg2.u)
    annotation (Line(points={{-220,-200},{-190,-200},{-190,-220},{-142,-220}},
      color={0,0,127}));
  connect(higTHeaWatLvg1.y, timTHeaWatLvg1.u)
    annotation (Line(points={{-158,-200},{-100,-200},{-100,-192},{-92,-192}},
      color={255,0,255}));
  connect(higTHeaWatLvg2.y, timTHeaWatLvg2.u)
    annotation (Line(points={{-118,-220},{-52,-220}},color={255,0,255}));
  connect(lowTChiWatLvg1.y, timTChiWatLvg1.u)
    annotation (Line(points={{-158,-140},{-100,-140},{-100,-132},{-92,-132}},
      color={255,0,255}));
  connect(lowTChiWatLvg2.y, timTChiWatLvg2.u)
    annotation (Line(points={{-118,-160},{-52,-160}},color={255,0,255}));
  connect(higLoaCoo.y, timLoaCoo.u)
    annotation (Line(points={{-158,-40},{-34,-40}},color={255,0,255}));
  connect(higLoaHea.y, timLoaHea.u)
    annotation (Line(points={{-158,-80},{-34,-80}},color={255,0,255}));
  connect(timCooEna.passed, allEna.u[1])
    annotation (Line(points={{-158,160},{0,160},{0,-2.8},{28,-2.8}},color={255,0,255}));
  connect(timHeaEna.passed, allEna.u[2])
    annotation (Line(points={{-158,100},{-2,100},{-2,-1.4},{28,-1.4}},color={255,0,255}));
  connect(runDis.passed, allEna.u[3])
    annotation (Line(points={{-8,192},{2,192},{2,0},{28,0}},color={255,0,255}));
  connect(timLoaCoo.passed, allEna.u[4])
    annotation (Line(points={{-10,-48},{-2,-48},{-2,1.4},{28,1.4}},color={255,0,255}));
  connect(timLoaHea.passed, allEna.u[5])
    annotation (Line(points={{-10,-88},{0,-88},{0,2.8},{28,2.8}},color={255,0,255}));
  connect(u1Coo, disCoo.u)
    annotation (Line(points={{-220,160},{-190,160},{-190,140},{-182,140}},color={255,0,255}));
  connect(u1Hea, disHea.u)
    annotation (Line(points={{-220,100},{-190,100},{-190,80},{-182,80}},color={255,0,255}));
  connect(disCoo.y, anyDis.u[1])
    annotation (Line(points={{-158,140},{60,140},{60,-102.8},{68,-102.8}},color={255,0,255}));
  connect(disHea.y, anyDis.u[2])
    annotation (Line(points={{-158,80},{58,80},{58,-101.4},{68,-101.4}},color={255,0,255}));
  connect(QChiWatReq_flow, lowLoaCoo.u)
    annotation (Line(points={{-220,-40},{-190,-40},{-190,-60},{-112,-60}},color={0,0,127}));
  connect(QChiWatReq_flow, lowLoaHea.u)
    annotation (Line(points={{-220,-40},{-190,-40},{-190,-100},{-112,-100}},
      color={0,0,127}));
  connect(lowLoaCoo.y, anyLowLoa.u1)
    annotation (Line(points={{-88,-60},{-72,-60}},color={255,0,255}));
  connect(lowLoaHea.y, anyLowLoa.u2)
    annotation (Line(points={{-88,-100},{-80,-100},{-80,-68},{-72,-68}},color={255,0,255}));
  connect(off.y, anyLowLoaAndOff.u1)
    annotation (Line(points={{-88,60},{-32,60}},color={255,0,255}));
  connect(anyLowLoa.y, anyLowLoaAndOff.u2)
    annotation (Line(points={{-48,-60},{-40,-60},{-40,52},{-32,52}},color={255,0,255}));
  connect(anyLowLoaAndOff.y, anyDis.u[3])
    annotation (Line(points={{-8,60},{56,60},{56,-100},{68,-100}},color={255,0,255}));
  connect(u1CooHrc, hea.u)
    annotation (Line(points={{-220,20},{-190,20},{-190,0},{-182,0}},color={255,0,255}));
  connect(u1CooHrc, enaAndCoo.u2)
    annotation (Line(points={{-220,20},{-150,20},{-150,12},{-112,12}},color={255,0,255}));
  connect(hea.y, enaAndHea.u2)
    annotation (Line(points={{-158,0},{-130,0},{-130,-28},{-112,-28}},color={255,0,255}));
  connect(timTHeaWatLvg1.passed, anyTHeaWatLvg.u1)
    annotation (Line(points={{-68,-200},{-12,-200}},color={255,0,255}));
  connect(timTChiWatLvg1.passed, anyTChiWatLvg.u1)
    annotation (Line(points={{-68,-140},{-12,-140}},color={255,0,255}));
  connect(timTChiWatLvg2.passed, anyTChiWatLvg.u2)
    annotation (Line(points={{-28,-168},{-20,-168},{-20,-148},{-12,-148}},color={255,0,255}));
  connect(timTHeaWatLvg2.passed, anyTHeaWatLvg.u2)
    annotation (Line(points={{-28,-228},{-20,-228},{-20,-208},{-12,-208}},color={255,0,255}));
  connect(anyTChiWatLvg.y, anyTChiWatLvgAndHea.u2)
    annotation (Line(points={{12,-140},{16,-140},{16,-148},{30,-148}},color={255,0,255}));
  connect(anyTChiWatLvgAndHea.y, anyDis.u[4])
    annotation (Line(points={{54,-140},{58,-140},{58,-98.6},{68,-98.6}},color={255,0,255}));
  connect(anyTHeaWatLvgAndCoo.y, anyDis.u[5])
    annotation (Line(points={{52,-200},{60,-200},{60,-97.2},{68,-97.2}},color={255,0,255}));
  connect(allEna.y, enaDis.u)
    annotation (Line(points={{52,0},{100,0},{100,-40},{108,-40}},color={255,0,255}));
  connect(anyDis.y, enaDis.clr)
    annotation (Line(points={{92,-100},{100,-100},{100,-46},{108,-46}},color={255,0,255}));
  connect(enaDis.y, truDel.u)
    annotation (Line(points={{132,-40},{140,-40},{140,0},{148,0}},color={255,0,255}));
  connect(truDel.y, y1)
    annotation (Line(points={{172,0},{190,0},{190,0},{220,0}},color={255,0,255}));
  connect(enaDis.y, edg.u)
    annotation (Line(points={{132,-40},{148,-40}},color={255,0,255}));
  connect(edg.y, y1SetMod)
    annotation (Line(points={{172,-40},{220,-40}},color={255,0,255}));
  connect(u1Hrc_actual, off.u)
    annotation (Line(points={{-220,60},{-112,60}},color={255,0,255}));
  connect(preEna.y, enaAndCoo.u1)
    annotation (Line(points={{-128,200},{-120,200},{-120,20},{-112,20}},color={255,0,255}));
  connect(preEna.y, enaAndHea.u1)
    annotation (Line(points={{-128,200},{-120,200},{-120,-20},{-112,-20}},color={255,0,255}));
  connect(enaAndCoo.y, anyTHeaWatLvgAndCoo.u1)
    annotation (Line(points={{-88,20},{22,20},{22,-200},{28,-200}},color={255,0,255}));
  connect(anyTHeaWatLvg.y, anyTHeaWatLvgAndCoo.u2)
    annotation (Line(points={{12,-200},{20,-200},{20,-208},{28,-208}},color={255,0,255}));
  connect(enaAndHea.y, anyTChiWatLvgAndHea.u1)
    annotation (Line(points={{-88,-20},{20,-20},{20,-140},{30,-140}},color={255,0,255}));
  annotation (
    defaultComponentName="ena",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255})}),
    Documentation(
      info="<html>
<p>
The available CHW load <code>QChiWatReq_flow</code> is calculated based on secondary
CHW temperature immediately upstream of the heat recovery chiller, 
active CHW supply temperature setpoint and secondary CHW loop flow. 
</p>
<p>
The available HW load <code>QHeaWatReq_flow</code> is calculated based on secondary
HW temperature immediately upstream of the heat recovery chiller, 
active HW supply temperature setpoint and secondary HW loop flow. 
</p>
<p>
The available CHW and HW loads used in logic are rolling averages 
over a period of <code>dtMea</code>
of instantaneous values sampled at minimum once every <i>30</i>&nbsp;s.
</p>
<p>
The heat recovery chiller is enabled when all of the following are true:
</p>
<ul>
<li>CHW plant has been enabled for <code>dtRun</code>.</li>
<li><code>QChiWatReq_flow &gt;&nbsp;capCooHrc_min</code> for <code>dtLoa</code>.</li>
<li>HW plant has been enabled for <code>dtRun</code>.</li>
<li><code>QHeaWatReq_flow &gt;&nbsp;capHeaHrc_min</code> for <code>dtLoa</code>.</li>
<li>HRC has been disabled for at least <code>dtRun</code>.</li>
</ul>
<p>
The heat recovery chiller is disabled when any of the following are true:
</p>
<ul>
<li>CHW plant is disabled.</li>
<li>HW plant is disabled.</li>
<li>
The heat recovery chiller cycles off (chiller is enabled but status changes from Run to Off) 
under low load conditions and either <code>QChiWatReq_flow&nbsp;&lt;&nbsp;capCooHrc_min</code> 
or <code>QHeaWatReq_flow&nbsp;&lt;&nbsp;capHeaHrc_min</code>.
</li>
<li>
If the HRC is in heating mode and CHW supply temperature leaving the 
heat recovery chiller as measured either through the chiller’s network interface 
or immediately downstream of the chiller is <code>&lt;&nbsp;TChiWatSupSet_min&nbsp;+&nbsp;1</code> 
for <code>dtTem1</code> or <code>&lt;&nbsp;TChiWatSupSet_min</code> for <code>dtTem2</code>.
</li>
<li>
If the HRC is in cooling mode and HW supply temperature leaving the 
heat recovery chiller as measured either through the chiller’s network interface 
or immediately downstream of the chiller is <code>&gt;&nbsp;THeaWatSupSet_max&nbsp;-&nbsp;1.5</code> 
for <code>dtTem1</code> or <code>&gt;&nbsp;THeaWatSupSet_max</code> for <code>dtTem2</code>.
</li>
</ul>
<h4>Pump control</h4>
<p>
Sidestream HRC HW and CHW pumps are enabled when the heat recovery chiller is enabled.
</p>
</html>",
      revisions="<html>
<ul>
<li>
May 31, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(
      coordinateSystem(
        extent={{-200,-240},{200,240}})));
end Enable;
