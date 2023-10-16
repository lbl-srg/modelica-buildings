within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.Validation;
model DownStartWithoutOn
  "Validate sequence of starting the staging down process which does not require enabling a chiller"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.DownStart
    staStaDow(
    final nChi=2,
    need_reduceChillerDemand=true,
    final byPasSetTim=300,
    final minFloSet={1,1},
    final maxFloSet={1.5,1.5},
    final chaChiWatIsoTim=300)
    "Chiller stage down when the process does not require one chiller on and another chiller off"
    annotation (Placement(transformation(extent={{60,190},{80,210}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.15,
    final period=1200) "Boolean pulse"
    annotation (Placement(transformation(extent={{-120,210},{-100,230}})));
  Buildings.Controls.OBC.CDL.Logical.Not staDow "Stage down command"
    annotation (Placement(transformation(extent={{-80,210},{-60,230}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant chiOn[2](
    final k=fill(true,2))
    "Operating chiller one"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi "Logical switch"
    annotation (Placement(transformation(extent={{-40,-250},{-20,-230}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant chiLoa[2](
    final k=fill(1000,2)) "Chiller load"
    annotation (Placement(transformation(extent={{-120,130},{-100,150}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant nexEnaChi(
    final k=0) "Next enabling chiller"
    annotation (Placement(transformation(extent={{-120,-110},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant yOpeParLoaRatMin(
    final k=0.7)
    "Minimum cycling operative partial load ratio"
    annotation (Placement(transformation(extent={{-120,170},{-100,190}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant onOff(
    final k=false) "Chiller on-off command"
    annotation (Placement(transformation(extent={{-120,-70},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant chiFlo(
    final k=2) "Chilled water flow"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant chiHea[2](
    final k=fill(true,2))
    "Chiller head pressure control"
    annotation (Placement(transformation(extent={{-120,-150},{-100,-130}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant chiIsoVal[2](
    final k=fill(1,2)) "Chilled water isolation valve"
    annotation (Placement(transformation(extent={{-120,-190},{-100,-170}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant nexDisChi(
    final k=2) "Next disable chiller"
    annotation (Placement(transformation(extent={{-120,-230},{-100,-210}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer(
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-120,-270},{-100,-250}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer1[2](
    final k=fill(0,2)) "Constant zero"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fal[2](
    final k=fill(false,2)) "Constant false"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt "Convert real input to integer output"
    annotation (Placement(transformation(extent={{0,-250},{20,-230}})));
  Buildings.Controls.OBC.CDL.Logical.Pre chiStaRet[2](final pre_u_start=fill(
        true, 2)) "Chiller status return value"
    annotation (Placement(transformation(extent={{100,170},{120,190}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi[2] "Logical switch"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1[2] "Logical switch"
    annotation (Placement(transformation(extent={{-40,130},{-20,150}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul2(
    final width=0.95,
    final period=1200) "Boolean pulse"
    annotation (Placement(transformation(extent={{60,90},{80,110}})));
  Buildings.Controls.OBC.CDL.Logical.Not staDow2 "Stage down command"
    annotation (Placement(transformation(extent={{100,90},{120,110}})));

equation
  connect(booPul.y,staDow. u)
    annotation (Line(points={{-98,220},{-82,220}},   color={255,0,255}));
  connect(staDow.y, swi.u2)
    annotation (Line(points={{-58,220},{-50,220},{-50,-240},{-42,-240}},
      color={255,0,255}));
  connect(nexDisChi.y, swi.u1)
    annotation (Line(points={{-98,-220},{-60,-220},{-60,-232},{-42,-232}},
      color={0,0,127}));
  connect(zer.y, swi.u3)
    annotation (Line(points={{-98,-260},{-60,-260},{-60,-248},{-42,-248}},
      color={0,0,127}));
  connect(staDow.y, staStaDow.uStaDow)
    annotation (Line(points={{-58,220},{-50,220},{-50,210},{58,210}},
      color={255,0,255}));
  connect(yOpeParLoaRatMin.y, staStaDow.yOpeParLoaRatMin)
    annotation (Line(points={{-98,180},{12,180},{12,208},{58,208}},
      color={0,0,127}));
  connect(chiFlo.y, staStaDow.VChiWat_flow)
    annotation (Line(points={{-98,-20},{24,-20},{24,202},{58,202}},
      color={0,0,127}));
  connect(onOff.y, staStaDow.uOnOff)
    annotation (Line(points={{-98,-60},{32,-60},{32,198},{58,198}},
      color={255,0,255}));
  connect(nexEnaChi.y, staStaDow.nexEnaChi)
    annotation (Line(points={{-98,-100},{36,-100},{36,196},{58,196}},
      color={255,127,0}));
  connect(swi.y, reaToInt.u)
    annotation (Line(points={{-18,-240},{-2,-240}}, color={0,0,127}));
  connect(reaToInt.y, staStaDow.nexDisChi)
    annotation (Line(points={{22,-240},{48,-240},{48,190},{58,190}},
      color={255,127,0}));
  connect(staStaDow.yChi, chiStaRet.u) annotation (Line(points={{82,194},{90,
          194},{90,180},{98,180}}, color={255,0,255}));
  connect(chiStaRet.y, swi1.u2) annotation (Line(points={{122,180},{130,180},{
          130,160},{-60,160},{-60,140},{-42,140}}, color={255,0,255}));
  connect(chiLoa.y, swi1.u1)
    annotation (Line(points={{-98,140},{-90,140},{-90,148},{-42,148}},
      color={0,0,127}));
  connect(zer1.y, swi1.u3)
    annotation (Line(points={{-98,100},{-80,100},{-80,132},{-42,132}},
      color={0,0,127}));
  connect(chiStaRet.y, logSwi.u2) annotation (Line(points={{122,180},{130,180},
          {130,160},{-60,160},{-60,60},{-42,60}}, color={255,0,255}));
  connect(chiOn.y, logSwi.u1)
    annotation (Line(points={{-98,60},{-90,60},{-90,68},{-42,68}},
      color={255,0,255}));
  connect(fal.y, logSwi.u3)
    annotation (Line(points={{-98,20},{-70,20},{-70,52},{-42,52}},
      color={255,0,255}));
  connect(swi1.y, staStaDow.uChiLoa)
    annotation (Line(points={{-18,140},{16,140},{16,206},{58,206}},
      color={0,0,127}));
  connect(logSwi.y, staStaDow.uChi)
    annotation (Line(points={{-18,60},{20,60},{20,204},{58,204}},
      color={255,0,255}));
  connect(chiHea.y, staStaDow.uChiHeaCon)
    annotation (Line(points={{-98,-140},{40,-140},{40,194},{58,194}},
      color={255,0,255}));
  connect(chiIsoVal.y, staStaDow.uChiWatIsoVal)
    annotation (Line(points={{-98,-180},{44,-180},{44,192},{58,192}},
      color={0,0,127}));
  connect(booPul2.y, staDow2.u)
    annotation (Line(points={{82,100},{98,100}}, color={255,0,255}));
  connect(staDow2.y, staStaDow.clr)
    annotation (Line(points={{122,100},{130,100},{130,150},{28,150},{28,200},
      {58,200}}, color={255,0,255}));

annotation (
 experiment(StopTime=1200, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Processes/Subsequences/Validation/DownStartWithoutOn.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.DownStart\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.DownStart</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 26, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
     graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-300},{140,300}}),
        graphics={
        Text(
          extent={{-122,288},{-74,280}},
          textColor={0,0,127},
          textString="Stage down:"),
        Text(
          extent={{-114,276},{46,266}},
          textColor={0,0,127},
          textString="from stage 2 which has chiller one and two enabled, "),
        Text(
          extent={{-116,264},{-14,250}},
          textColor={0,0,127},
          textString="to stage 1 which only has chiller 1.")}));
end DownStartWithoutOn;
