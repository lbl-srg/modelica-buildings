within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Validation;
model WithoutWSE
  "Validation sequence of controlling tower of a plant without waterside economizer"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Controller
    towCon(
    nChi=2,
    totSta=3,
    nTowCel=2,
    nConWatPum=2,
    have_WSE=false,
    kWSE=0.5,
    TiWSE=10,
    staVec={0,1,2},
    towCelOnSet={0,1,2})
    "Cooling tower controller"
    annotation (Placement(transformation(extent={{200,340},{220,380}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse wseSta(
    final width=0.15,
    final period=3600)
    "Waterside economizer enabling status"
    annotation (Placement(transformation(extent={{-360,200},{-340,220}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp plaCap(
    final height=8e5,
    final duration=3600,
    final offset=1e5) "Real operating chiller plant capacity"
    annotation (Placement(transformation(extent={{-360,70},{-340,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin conSup(
    final amplitude=2,
    final freqHz=1/1800,
    final offset=273.15 + 29) "Condenser water supply temperature"
    annotation (Placement(transformation(extent={{-360,-190},{-340,-170}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp ram2(
    final height=3,
    final duration=3600,
    final startTime=1500) "Ramp"
    annotation (Placement(transformation(extent={{-360,-230},{-340,-210}})));
  Buildings.Controls.OBC.CDL.Reals.Add conWatSupTem
    "Condenser water supply temperature"
    annotation (Placement(transformation(extent={{-300,-210},{-280,-190}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp ram3(
    final height=3,
    final duration=3600,
    final startTime=1500) "Ramp"
    annotation (Placement(transformation(extent={{-360,-150},{-340,-130}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin conRet2(
    final amplitude=2,
    final freqHz=1/1800,
    final offset=273.15 + 28) "Condenser water return temperature"
    annotation (Placement(transformation(extent={{-360,-110},{-340,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Add conWatRetTem
    "Condenser water return temperature"
    annotation (Placement(transformation(extent={{-300,-130},{-280,-110}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp conWatPumSpe1[2](
    final height=fill(0.5, 2),
    final duration=fill(3600, 2),
    final startTime=fill(300, 2)) "Measured condenser water pump speed"
    annotation (Placement(transformation(extent={{-300,-170},{-280,-150}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant hpTowSpe1(final k=0.5)
    "Head pressure control maximum tower speed"
    annotation (Placement(transformation(extent={{-320,50},{-300,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant hpTowSpe2(final k=0)
    "Head pressure control maximum tower speed"
    annotation (Placement(transformation(extent={{-360,-10},{-340,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant towFanSpe3(final k=0.2)
    "Measured tower fan speed"
    annotation (Placement(transformation(extent={{-320,170},{-300,190}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant chiWatSupSet(
    final k=273.15 + 6.5)
    "Chilled water supply setpoint"
    annotation (Placement(transformation(extent={{-360,-50},{-340,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse chiSta1(
    final width=0.4,
    final period=3600) "Chiller one enabling status"
    annotation (Placement(transformation(extent={{-360,260},{-340,280}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant chiTwoSta(final k=false)
    "Chiller two enabling status"
    annotation (Placement(transformation(extent={{-360,230},{-340,250}})));
  Buildings.Controls.OBC.CDL.Logical.Or or3 "Logical or"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Or or4 "Logical or"
    annotation (Placement(transformation(extent={{-160,-30},{-140,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Not chiOneSta "Chiller one status"
    annotation (Placement(transformation(extent={{-320,260},{-300,280}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer(
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-320,10},{-300,30}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1 "Logical switch"
    annotation (Placement(transformation(extent={{-240,30},{-220,50}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger chiSta "Chiller stage "
    annotation (Placement(transformation(extent={{-140,-240},{-120,-220}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay towStaUp(
    final delayTime=30) "Cooling tower stage up"
    annotation (Placement(transformation(extent={{-140,-330},{-120,-310}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol[2](final
      samplePeriod=fill(5, 2))
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{280,320},{300,340}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre1[2] "Break algebraic"
    annotation (Placement(transformation(extent={{280,370},{300,390}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp watLev(
    final height=1.2,
    final duration=3600,
    final offset=0.5) "Water level in cooling tower"
    annotation (Placement(transformation(extent={{140,50},{160,70}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant chiStaSet(
    final k=1) "Chiller stage setpoint"
    annotation (Placement(transformation(extent={{-140,-270},{-120,-250}})));
  Buildings.Controls.OBC.CDL.Logical.Not wseSta1 "Water side economizer status"
    annotation (Placement(transformation(extent={{-320,200},{-300,220}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con3(final k=false)
    "Constant false"
    annotation (Placement(transformation(extent={{-80,-150},{-60,-130}})));
equation
  connect(ram2.y, conWatSupTem.u2) annotation (Line(points={{-338,-220},{-320,-220},
          {-320,-206},{-302,-206}}, color={0,0,127}));
  connect(conSup.y, conWatSupTem.u1) annotation (Line(points={{-338,-180},{-320,
          -180},{-320,-194},{-302,-194}}, color={0,0,127}));
  connect(conRet2.y, conWatRetTem.u1) annotation (Line(points={{-338,-100},{-320,
          -100},{-320,-114},{-302,-114}}, color={0,0,127}));
  connect(ram3.y, conWatRetTem.u2) annotation (Line(points={{-338,-140},{-320,-140},
          {-320,-126},{-302,-126}}, color={0,0,127}));
  connect(chiSta1.y, chiOneSta.u)
    annotation (Line(points={{-338,270},{-322,270}}, color={255,0,255}));
  connect(chiOneSta.y, swi1.u2) annotation (Line(points={{-298,270},{-280,270},{
          -280,40},{-242,40}}, color={255,0,255}));
  connect(hpTowSpe1.y, swi1.u1)
    annotation (Line(points={{-298,60},{-260,60},{-260,48},{-242,48}},
      color={0,0,127}));
  connect(zer.y, swi1.u3)
    annotation (Line(points={{-298,20},{-260,20},{-260,32},{-242,32}},
      color={0,0,127}));
  connect(chiOneSta.y, towCon.uChi[1]) annotation (Line(points={{-298,270},{-30,
          270},{-30,376.5},{198,376.5}}, color={255,0,255}));
  connect(chiTwoSta.y, towCon.uChi[2]) annotation (Line(points={{-338,240},{-30,
          240},{-30,377.5},{198,377.5}}, color={255,0,255}));
  connect(towFanSpe3.y,towCon.uFanSpe)  annotation (Line(points={{-298,180},{
          -10,180},{-10,373},{198,373}}, color={0,0,127}));
  connect(chiWatSupSet.y, towCon.TChiWatSupSet) annotation (Line(points={{-338,
          -40},{10,-40},{10,369},{198,369}}, color={0,0,127}));
  connect(plaCap.y, towCon.reqPlaCap) annotation (Line(points={{-338,80},{20,80},
          {20,367},{198,367}}, color={0,0,127}));
  connect(swi1.y, towCon.uMaxTowSpeSet[1]) annotation (Line(points={{-218,40},{
          30,40},{30,364.5},{198,364.5}}, color={0,0,127}));
  connect(hpTowSpe2.y, towCon.uMaxTowSpeSet[2]) annotation (Line(points={{-338,0},
          {40,0},{40,365.5},{198,365.5}}, color={0,0,127}));
  connect(or3.y, towCon.uPla) annotation (Line(points={{-58,-70},{60,-70},{60,361},
          {198,361}},      color={255,0,255}));
  connect(conWatRetTem.y, towCon.TConWatRet) annotation (Line(points={{-278,
          -120},{70,-120},{70,359},{198,359}}, color={0,0,127}));
  connect(conWatPumSpe1.y, towCon.uConWatPumSpe) annotation (Line(points={{-278,
          -160},{80,-160},{80,357},{198,357}}, color={0,0,127}));
  connect(conWatSupTem.y, towCon.TConWatSup) annotation (Line(points={{-278,
          -200},{90,-200},{90,355},{198,355}}, color={0,0,127}));
  connect(chiOneSta.y, chiSta.u) annotation (Line(points={{-298,270},{-188,270},
          {-188,-230},{-142,-230}}, color={255,0,255}));
  connect(chiSta.y, towCon.uChiSta) annotation (Line(points={{-118,-230},{100,
          -230},{100,351},{198,351}}, color={255,127,0}));
  connect(chiOneSta.y, towStaUp.u) annotation (Line(points={{-298,270},{-188,270},
          {-188,-320},{-142,-320}}, color={255,0,255}));
  connect(towCon.yIsoVal, zerOrdHol.u) annotation (Line(points={{222,365},{260,365},
          {260,330},{278,330}}, color={0,0,127}));
  connect(zerOrdHol.y, towCon.uIsoVal) annotation (Line(points={{302,330},{320,
          330},{320,300},{150,300},{150,343},{198,343}}, color={0,0,127}));
  connect(watLev.y, towCon.watLev) annotation (Line(points={{162,60},{170,60},{
          170,341},{198,341}}, color={0,0,127}));
  connect(towCon.yTowSta, pre1.u) annotation (Line(points={{222,355},{250,355},{
          250,380},{278,380}}, color={255,0,255}));
  connect(pre1.y, towCon.uTowSta) annotation (Line(points={{302,380},{340,380},
          {340,280},{50,280},{50,363},{198,363}},color={255,0,255}));
  connect(towStaUp.y, towCon.uTowStaCha) annotation (Line(points={{-118,-320},{
          120,-320},{120,347},{198,347}}, color={255,0,255}));
  connect(chiStaSet.y, towCon.uChiStaSet) annotation (Line(points={{-118,-260},
          {108,-260},{108,349},{198,349}},color={255,127,0}));
  connect(wseSta.y, wseSta1.u)
    annotation (Line(points={{-338,210},{-322,210}}, color={255,0,255}));
  connect(con3.y, towCon.uEnaPla) annotation (Line(points={{-58,-140},{94,-140},
          {94,353},{198,353}}, color={255,0,255}));
  connect(chiOneSta.y, or4.u1) annotation (Line(points={{-298,270},{-188,270},{-188,
          -20},{-162,-20}}, color={255,0,255}));
  connect(chiTwoSta.y, or4.u2) annotation (Line(points={{-338,240},{-194,240},{-194,
          -28},{-162,-28}}, color={255,0,255}));
  connect(wseSta1.y, or3.u2) annotation (Line(points={{-298,210},{-200,210},{-200,
          -78},{-82,-78}}, color={255,0,255}));
  connect(or4.y, or3.u1) annotation (Line(points={{-138,-20},{-120,-20},{-120,-70},
          {-82,-70}}, color={255,0,255}));
annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Towers/Validation/WithoutWSE.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Controller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Controller</a>.
It demonstates the cooling tower control of a close coupled chiller plant that has
two chillers with waterside economizer.
</p>
<ul>
<li>
At begining, the water level is lower than the minimum thus the tower starts to
adding water (<code>yMakUp</code>). When the water level becomes greater than the
maximum, it stops adding water at 1500 seconds.
</li>
<li>
The plant is enabled to waterside economizer mode at 540 seconds. The lead tower
cell becomes enabled when there is any condenser water pump enabled.
</li>
<li>
After 300 seconds (<code>chaTowCelIsoTim</code>) at 840 seconds, the leading cell
turns on.
</li>
<li>
The tower fan speed is controlled under the waterside economizer only mode. The
direct-acting PID controls the chilled water supply temperature at setpoint. 
</li>
<li>
At 1440 seconds, the chiller 1 becomes enabled. Thus, the tower fan speed is then
controlled under the integrated operation mode. However, before switching to the
integrated operation mode, the fan hold speed at the maximum speed. According to
the vector <code>towCelOnSet</code>, which specifies number of cells at each plant
stage (<code>staVec</code>), two tower cell should be enabled. Thus, after chiller
1 being enabled at 1440 seconds, when the 300 seconds is passed
(<code>chaTowCelIsoTim</code>), the cell 2 become enabled at 1740 seconds.
</li>
<li>
Both cells run at the maximum speed till 2040 seconds, the fan speed is then
controlled under integrated mode.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
September 16, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
 Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-400,-420},{400,420}})));
end WithoutWSE;
