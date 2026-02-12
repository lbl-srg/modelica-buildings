within Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Staging.Processes.Subsequences.Validation;
model CHWIsoVal_new
  "Validate isolation valve enable and disable sequence"

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Staging.Processes.Subsequences.CHWIsoVal_New enaChiIsoVal(
    final nChi=2,
    final chaChiWatIsoTim=300) "Enable isolation valve"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Staging.Processes.Subsequences.CHWIsoVal_New disChiIsoVal(
    final nChi=2,
    final chaChiWatIsoTim=300)
    "Disable isolation valve"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Staging.Processes.Subsequences.CHWIsoVal_New enaChiIsoVal1(
    final have_isoValEndSwi=true,
    final nChi=2)
    "Enable isolation valve, with end switch feedback"
    annotation (Placement(transformation(extent={{140,-60},{160,-40}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.15,
    final period=4000)
    "Boolean pulse"
    annotation (Placement(transformation(extent={{-200,-80},{-180,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Not staCha "Stage change command"
    annotation (Placement(transformation(extent={{-160,-80},{-140,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    final width=0.20,
    final period=4000) "Boolean pulse"
    annotation (Placement(transformation(extent={{-200,-40},{-180,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Not upsDevSta "Upstream device status"
    annotation (Placement(transformation(extent={{-160,-40},{-140,-20}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant chaChi(
    final k=2) "Changing chiller index"
    annotation (Placement(transformation(extent={{-160,70},{-140,90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con[2](
    k={true,false}) "Chiller status"
    annotation (Placement(transformation(extent={{-160,30},{-140,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1[2](
    k={true,true}) "Chiller status"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant chaChi1(
    final k=2)
    "Changing chiller index"
    annotation (Placement(transformation(extent={{20,90},{40,110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2[2](
    k={true,false}) "Chiller status"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con3[2](
    k={false,true}) "Closed valves"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(
    final nout=2)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Buildings.Controls.OBC.CDL.Logical.Not cloVal[2] "Closed valve"
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
  Buildings.Templates.Components.Controls.StatusEmulator valSta[2](
    delayTime=fill(120, 2))
    "Valve status"
    annotation (Placement(transformation(extent={{180,-66},{200,-46}})));
  Buildings.Controls.OBC.CDL.Logical.Switch opeEnd[2] "Full open end"
    annotation (Placement(transformation(extent={{80,20},{100,40}})));
  Buildings.Controls.OBC.CDL.Logical.Switch cloEnd[2] "Full closed end"
    annotation (Placement(transformation(extent={{80,-30},{100,-10}})));

equation
  connect(booPul.y, staCha.u)
    annotation (Line(points={{-178,-70},{-162,-70}}, color={255,0,255}));
  connect(booPul1.y, upsDevSta.u)
    annotation (Line(points={{-178,-30},{-162,-30}}, color={255,0,255}));
  connect(chaChi.y, enaChiIsoVal.nexChaChi)
    annotation (Line(points={{-138,80},{-120,80},{-120,8},{-102,8}},
      color={255,127,0}));
  connect(upsDevSta.y, enaChiIsoVal.uUpsDevSta)
    annotation (Line(points={{-138,-30},{-120,-30},{-120,-5},{-102,-5}},
      color={255,0,255}));
  connect(staCha.y, enaChiIsoVal.uStaPro) annotation (Line(points={{-138,-70},{-110,
          -70},{-110,-8},{-102,-8}}, color={255,0,255}));
  connect(con.y, enaChiIsoVal.uChi) annotation (Line(points={{-138,40},{-130,40},
          {-130,5},{-102,5}}, color={255,0,255}));
  connect(con1.y, disChiIsoVal.uChi) annotation (Line(points={{-78,40},{-70,40},
          {-70,5},{-42,5}}, color={255,0,255}));
  connect(chaChi.y, disChiIsoVal.nexChaChi) annotation (Line(points={{-138,80},{
          -60,80},{-60,8},{-42,8}}, color={255,127,0}));
  connect(upsDevSta.y, disChiIsoVal.uUpsDevSta) annotation (Line(points={{-138,-30},
          {-60,-30},{-60,-5},{-42,-5}}, color={255,0,255}));
  connect(staCha.y, disChiIsoVal.uStaPro) annotation (Line(points={{-138,-70},{-50,
          -70},{-50,-8},{-42,-8}}, color={255,0,255}));
  connect(upsDevSta.y, enaChiIsoVal1.uUpsDevSta) annotation (Line(points={{-138,
          -30},{-20,-30},{-20,-55},{138,-55}}, color={255,0,255}));
  connect(staCha.y, enaChiIsoVal1.uStaPro) annotation (Line(points={{-138,-70},{
          -50,-70},{-50,-58},{138,-58}}, color={255,0,255}));
  connect(con2.y, enaChiIsoVal1.uChi) annotation (Line(points={{22,70},{30,70},{
          30,-45},{138,-45}}, color={255,0,255}));
  connect(chaChi1.y, enaChiIsoVal1.nexChaChi) annotation (Line(points={{42,100},
          {130,100},{130,-42},{138,-42}}, color={255,127,0}));
  connect(enaChiIsoVal1.y1ChiWatIsoVal, valSta.y1)
    annotation (Line(points={{162,-56},{178,-56}}, color={255,0,255}));
  connect(valSta.y1_actual,opeEnd. u1) annotation (Line(points={{202,-56},{210,-56},
          {210,50},{70,50},{70,38},{78,38}}, color={255,0,255}));
  connect(con2.y,opeEnd. u3) annotation (Line(points={{22,70},{30,70},{30,22},{78,
          22}}, color={255,0,255}));
  connect(opeEnd.y, enaChiIsoVal1.u1ChiIsoOpe) annotation (Line(points={{102,30},
          {120,30},{120,-48},{138,-48}}, color={255,0,255}));
  connect(booRep.y,opeEnd. u2)
    annotation (Line(points={{22,30},{78,30}}, color={255,0,255}));
  connect(staCha.y, booRep.u) annotation (Line(points={{-138,-70},{-50,-70},{-50,
          30},{-2,30}}, color={255,0,255}));
  connect(con3.y, cloEnd.u3) annotation (Line(points={{22,0},{40,0},{40,-28},{78,
          -28}}, color={255,0,255}));
  connect(booRep.y, cloEnd.u2) annotation (Line(points={{22,30},{50,30},{50,-20},
          {78,-20}}, color={255,0,255}));
  connect(cloVal.y, cloEnd.u1) annotation (Line(points={{62,-80},{70,-80},{70,-12},
          {78,-12}}, color={255,0,255}));
  connect(cloEnd.y, enaChiIsoVal1.u1ChiIsoClo) annotation (Line(points={{102,-20},
          {110,-20},{110,-51},{138,-51}}, color={255,0,255}));
  connect(enaChiIsoVal1.y1ChiWatIsoVal, cloVal.u) annotation (Line(points={{162,
          -56},{170,-56},{170,-100},{30,-100},{30,-80},{38,-80}}, color={255,0,255}));
annotation (
 experiment(StopTime=3600, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/Plants/Chillers/Staging/Processes/Subsequences/Validation/CHWIsoVal_new.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Staging.Processes.Subsequences.CHWIsoVal\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Staging.Processes.Subsequences.CHWIsoVal</a>.
</p>
<p>
It has two instances <code>enaChiIsoVal</code> and <code>disChiIsoVal</code> that
shows the process of controlling chiller chilled water isolation valves during the
chiller staging process.
</p>
<p>
Note that when using the subsequences, 
</p>
<ul>
<li>
specify the parameter <code>iniValPos=0</code> and <code>endValPos=1</code>
if instantiating the class in the staging up process controller, and
</li>
<li>
specify the parameter <code>iniValPos=1</code> and <code>endValPos=0</code>
if instantiating the class in the staging down process controller.
</li>
</ul>
<p>
For the instance <code>enaChiIsoVal</code>,
</p>
<ul>
<li>
Before 540 seconds, the plant is not in the staging up process. The isolation value 1
is fully open (<code>yChiWatIsoVal[1]=1</code>) and the valve 2 is closed
(<code>yChiWatIsoVal[2]=0</code>).
</li>
<li>
Between 540 seconds and 720 seconds, the plant is in the staging process. However, the
process is not yet requiring the chilled water isolation values to change their
status, as the <code>uUpsDevSta=false</code>.
</li>
<li>
Since 720 seconds, the plant staging process requires the isolation valve to change
their status (<code>uUpsDevSta=true</code>), and the chiller 2 is being enabled.
Thus, the process starts opening the isolation valve 2. As specified by
<code>chaChiWatIsoTim=300 seconds</code>, it takes 5 minutes to fully open isolation
valve 2 at 1020 seconds, and <code>yEnaChiWatIsoVal</code> becomes <code>true</code>.
</li>
</ul>
<p>
For the instance <code>disChiIsoVal</code>,
</p>
<ul>
<li>
Before 540 seconds, the plant is not in the staging down process. Both the isolation
value 1 and 2 are fully open (<code>yChiWatIsoVal[1]=1</code>,
<code>yChiWatIsoVal[2]=1</code>).
</li>
<li>
Between 540 seconds and 720 seconds, the plant is in the staging process. However,
the process is not yet requiring the chilled water isolation values to change their
status, as the <code>uUpsDevSta=false</code>.
</li>
<li>
Since 720 seconds, the plant staging process requires the isolation valve to change
their status (<code>uUpsDevSta=true</code>), and the chiller 2 is being disabled.
Thus, the process starts closing the isolation valve 2. As specified by
<code>chaChiWatIsoTim=300 seconds</code>, it takes 5 minutes to fully close isolation
valve 2 at 1020 seconds, and <code>yEnaChiWatIsoVal</code> becomes <code>true</code>.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
September 24, by Jianjun Hu:<br/>
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
        coordinateSystem(preserveAspectRatio=false, extent={{-220,-120},{220,120}})));
end CHWIsoVal_new;
