within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.Validation;
model ReduceDemand
  "Validate sequence of reducing chiller demand when there is stage up command"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.ReduceDemand
    chiDemRed(
    final nChi=2)
    "Reduce operaing chiller load as the first step of stage up process"
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.ReduceDemand
    chiDemRed1(
    final nChi=2)
    "Reduce operaing chiller load as the first step of stage down process when it requires another chiller on"
    annotation (Placement(transformation(extent={{200,50},{220,70}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.15, final period=600) "Boolean pulse"
    annotation (Placement(transformation(extent={{-260,90},{-240,110}})));
  Buildings.Controls.OBC.CDL.Logical.Not limDem "Limit demand command"
    annotation (Placement(transformation(extent={{-220,90},{-200,110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant chiOn(
    final k=true) "Operating chiller one"
    annotation (Placement(transformation(extent={{-260,-150},{-240,-130}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi "Logical switch"
    annotation (Placement(transformation(extent={{-160,50},{-140,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant chiLoa(final k=50)
                  "Chiller load"
    annotation (Placement(transformation(extent={{-260,50},{-240,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zerLoa(
    final k=0) "Zero chiller load"
    annotation (Placement(transformation(extent={{-260,10},{-240,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant yOpeParLoaRatMin(
    final k=0.7)
    "Minimum cycling operative partial load ratio"
    annotation (Placement(transformation(extent={{-260,-30},{-240,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant staDow(
    final k=false) "Stage down command"
    annotation (Placement(transformation(extent={{-260,-70},{-240,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant onOff(
    final k=false) "Chiller on-off command"
    annotation (Placement(transformation(extent={{-260,-110},{-240,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    final width=0.15, final period=600)
    "Boolean pulse"
    annotation (Placement(transformation(extent={{40,90},{60,110}})));
  Buildings.Controls.OBC.CDL.Logical.Not limDem1 "Limit demand command"
    annotation (Placement(transformation(extent={{80,90},{100,110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant chiOn1[2](
    final k=fill(true,2)) "Operating chiller one"
    annotation (Placement(transformation(extent={{40,-150},{60,-130}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1[2] "Logical switch"
    annotation (Placement(transformation(extent={{140,-50},{160,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant chiLoa1(final k=50)
                  "Chiller load"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant yOpeParLoaRatMin1(
    final k=0.7)
    "Minimum cycling operative partial load ratio"
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol(
    final samplePeriod=20)
    "Output the input signal with zero order hold"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol1[2](
    final samplePeriod=fill(20,2))
    "Output the input signal with zero order hold"
    annotation (Placement(transformation(extent={{240,40},{260,60}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(
    final nout=2) "Replicate boolean input"
    annotation (Placement(transformation(extent={{140,20},{160,40}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep(
    final nout=2) "Replicate real input"
    annotation (Placement(transformation(extent={{80,-50},{100,-30}})));

equation
  connect(booPul.y, limDem.u)
    annotation (Line(points={{-238,100},{-222,100}}, color={255,0,255}));
  connect(limDem.y, chiDemRed.uDemLim)
    annotation (Line(points={{-198,100},{-180,100},{-180,119},{-102,119}},
      color={255,0,255}));
  connect(chiDemRed.yChiDem[1], zerOrdHol.u)
    annotation (Line(points={{-78,113.5},{-70,113.5},{-70,100},{-62,100}},
      color={0,0,127}));
  connect(limDem.y, swi.u2)
    annotation (Line(points={{-198,100},{-180,100},{-180,60},{-162,60}},
      color={255,0,255}));
  connect(chiLoa.y, swi.u3)
    annotation (Line(points={{-238,60},{-190,60},{-190,52},{-162,52}},
      color={0,0,127}));
  connect(zerOrdHol.y, swi.u1)
    annotation (Line(points={{-38,100},{-30,100},{-30,80},{-170,80},{-170,68},
      {-162,68}}, color={0,0,127}));
  connect(swi.y, chiDemRed.uChiLoa[1])
    annotation (Line(points={{-138,60},{-130,60},{-130,114.5},{-102,114.5}},
      color={0,0,127}));
  connect(zerLoa.y, chiDemRed.uChiLoa[2])
    annotation (Line(points={{-238,20},{-126,20},{-126,115.5},{-102,115.5}},
      color={0,0,127}));
  connect(yOpeParLoaRatMin.y, chiDemRed.yOpeParLoaRatMin)
    annotation (Line(points={{-238,-20},{-122,-20},{-122,111},{-102,111}},
      color={0,0,127}));
  connect(staDow.y, chiDemRed.uStaDow)
    annotation (Line(points={{-238,-60},{-118,-60},{-118,108},{-102,108}},
      color={255,0,255}));
  connect(onOff.y, chiDemRed.uOnOff)
    annotation (Line(points={{-238,-100},{-114,-100},{-114,105},{-102,105}},
      color={255,0,255}));
  connect(chiOn.y, chiDemRed.uChi[1])
    annotation (Line(points={{-238,-140},{-110,-140},{-110,100.5},{-102,100.5}},
      color={255,0,255}));
  connect(onOff.y, chiDemRed.uChi[2])
    annotation (Line(points={{-238,-100},{-106,-100},{-106,101.5},{-102,101.5}},
      color={255,0,255}));
  connect(booPul1.y, limDem1.u)
    annotation (Line(points={{62,100},{78,100}}, color={255,0,255}));
  connect(limDem1.y, chiDemRed1.uDemLim)
    annotation (Line(points={{102,100},{120,100},{120,69},{198,69}},
      color={255,0,255}));
  connect(yOpeParLoaRatMin1.y, chiDemRed1.yOpeParLoaRatMin)
    annotation (Line(points={{62,-90},{178,-90},{178,61},{198,61}},
      color={0,0,127}));
  connect(chiDemRed1.yChiDem, zerOrdHol1.u)
    annotation (Line(points={{222,64},{230,64},{230,50},{238,50}},
      color={0,0,127}));
  connect(chiLoa1.y, reaRep.u)
    annotation (Line(points={{62,-40},{78,-40}}, color={0,0,127}));
  connect(booRep.y, swi1.u2)
    annotation (Line(points={{162,30},{170,30},{170,10},{120,10},{120,-40},
      {138,-40}},  color={255,0,255}));
  connect(reaRep.y, swi1.u3)
    annotation (Line(points={{102,-40},{110,-40},{110,-48},{138,-48}},
      color={0,0,127}));
  connect(zerOrdHol1.y, swi1.u1)
    annotation (Line(points={{262,50},{270,50},{270,-10},{130,-10},{130,-32},
      {138,-32}},  color={0,0,127}));
  connect(swi1.y, chiDemRed1.uChiLoa)
    annotation (Line(points={{162,-40},{174,-40},{174,65},{198,65}},
      color={0,0,127}));
  connect(limDem1.y, booRep.u)
    annotation (Line(points={{102,100},{120,100},{120,30},{138,30}},
      color={255,0,255}));
  connect(limDem1.y, chiDemRed1.uStaDow)
    annotation (Line(points={{102,100},{120,100},{120,58},{198,58}},
      color={255,0,255}));
  connect(limDem1.y, chiDemRed1.uOnOff)
    annotation (Line(points={{102,100},{120,100},{120,55},{198,55}},
      color={255,0,255}));
  connect(chiOn1.y, chiDemRed1.uChi)
    annotation (Line(points={{62,-140},{182,-140},{182,51},{198,51}},
      color={255,0,255}));

annotation (
 experiment(StopTime=600, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Processes/Subsequences/Validation/ReduceDemand.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.ReduceDemand\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.ReduceDemand</a>.
</p>
<p>
It has two instances as below to demonstrate the process of reducing chiller demand
when the plant is in staging process.
</p>
<p>
The instance <code>chiDemRed</code> shows the process of reducing the chiller
demand when the plant starts staging up.
</p>
<ul>
<li>
Before 90 seconds, the plant is not in staging process. There is no change to the
chiller demand and it is not requiring demand reduction (<code>yChiDemRed=true</code>)).
</li>
<li>
At 90 seconds, the staging process starts and it requires reducing the chiller
demand (<code>uDemLim=true</code>, <code>yChiDemRed=false</code>). It requires
reducing the demand by the larger value between <code>chiDemRedFac</code> (75%)
and <code>yOpeParLoaRatMin</code> (which is 0.7 in this case), which reduces from
50 A to 37.5 A (<code>yChiDem</code>).
</li>
<li>
At 100 seconds, the chiller load becomes 37.5 A, which is less than 80% of the
value before the staging (50 A). The demand reducing process is done
(<code>yChiDemRed=true</code>).
</li>
</ul>

<p>
The instance <code>chiDemRed1</code> shows the process of reducing the chiller
demand when the plant starts staging up. The process requires enabling a large
chiller and disabling a small chiller.
</p>
<ul>
<li>
Before 90 seconds, the plant is not in staging process. There is no change to
the chiller demand and it is not requiring demand reduction (<code>yChiDemRed=true</code>)).
</li>
<li>
At 90 seconds, the staging process starts and it requires reducing the chiller
demand (<code>uDemLim=true</code>, <code>yChiDemRed=false</code>). It requires
reducing the demand by the larger value between <code>chiDemRedFac</code> (75%)
and <code>yOpeParLoaRatMin</code> (which is 0.7 in this case). It requires reducing
both chillers demand from 50 A to 37.5 A (<code>yChiDem</code>).
</li>
<li>
At 100 seconds, both chillers load becomes 37.5 A, which is less than 80% of the
value before the staging (50 A). The demand reducing process is done
(<code>yChiDemRed=true</code>).
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
September 26, 2019, by Jianjun Hu:<br/>
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
        coordinateSystem(preserveAspectRatio=false, extent={{-280,-160},{280,160}}),
        graphics={
        Text(
          extent={{-258,152},{-184,142}},
          textColor={0,0,127},
          textString="In stage up process,"),
        Text(
          extent={{-258,138},{-166,128}},
          textColor={0,0,127},
          textString="enable one more chiller."),
        Text(
          extent={{38,136},{130,126}},
          textColor={0,0,127},
          textString="enable enabling chiller."),
        Text(
          extent={{42,152},{244,140}},
          textColor={0,0,127},
          textString="In stage down process that requires chiller on and off,")}));
end ReduceDemand;
