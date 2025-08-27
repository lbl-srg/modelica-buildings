within Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.Processes.Subsequences.Validation;
model NextBoiler
    "Validate sequence of identifying next enable or disable boilers"

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.Processes.Subsequences.NextBoiler
    nexBoi(
    final nBoi=2)
    "Identify next enabling and disabling boiler during the staging up process"
    annotation (Placement(transformation(extent={{-60,170},{-40,190}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.Processes.Subsequences.NextBoiler
    nexBoi1(
    final nBoi=2)
    "Identify next enabling during the staging up process"
    annotation (Placement(transformation(extent={{240,170},{260,190}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.Processes.Subsequences.NextBoiler
    nexBoi2(
    final nBoi=2)
    "Identify next enabling and disabling boiler during the staging down process"
    annotation (Placement(transformation(extent={{-60,-150},{-40,-130}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.Processes.Subsequences.NextBoiler
    nexBoi3(
    final nBoi=2)
    "Identify next disabling boiler during the staging down process"
    annotation (Placement(transformation(extent={{240,-150},{260,-130}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Switch boiSet[2]
    "Boiler status setpoint"
    annotation (Placement(transformation(extent={{-140,90},{-120,110}})));

  Buildings.Controls.OBC.CDL.Logical.Switch boiSet1[2]
    "Boiler status setpoint"
    annotation (Placement(transformation(extent={{160,90},{180,110}})));

  Buildings.Controls.OBC.CDL.Logical.Switch boiSet2[2]
    "Boiler status setpoint"
    annotation (Placement(transformation(extent={{-140,-230},{-120,-210}})));

  Buildings.Controls.OBC.CDL.Logical.Switch boiSet3[2]
    "Boiler status setpoint"
    annotation (Placement(transformation(extent={{160,-230},{180,-210}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.15,
    final period=120)
    "Boolean pulse"
    annotation (Placement(transformation(extent={{-260,150},{-240,170}})));

  Buildings.Controls.OBC.CDL.Logical.Not staUp
    "Stage up command"
    annotation (Placement(transformation(extent={{-220,150},{-200,170}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant staOneBoi[2](
    final k={true,false})
    "Vector of boilers status setpoint at stage one"
    annotation (Placement(transformation(extent={{-260,70},{-240,90}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant upSta(
    final k=2)
    "Stage two"
    annotation (Placement(transformation(extent={{-260,230},{-240,250}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dowSta(
    final k=1)
    "Stage one"
    annotation (Placement(transformation(extent={{-260,190},{-240,210}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swi
    "Logical switch"
    annotation (Placement(transformation(extent={{-180,210},{-160,230}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger staSet
    "Stage setpoint index"
    annotation (Placement(transformation(extent={{-140,210},{-120,230}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant staTwoBoi[2](
    final k={false,true})
    "Vector of boilers status setpoint at stage two"
    annotation (Placement(transformation(extent={{-260,110},{-240,130}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(
    final nout=2)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-180,90},{-160,110}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    final width=0.15,
    final period=120)
    "Boolean pulse"
    annotation (Placement(transformation(extent={{40,150},{60,170}})));

  Buildings.Controls.OBC.CDL.Logical.Not staUp1
    "Stage up command"
    annotation (Placement(transformation(extent={{80,150},{100,170}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant staOneBoi1[2](
    final k={true,false})
    "Vector of boilers status setpoint at stage one"
    annotation (Placement(transformation(extent={{40,70},{60,90}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant upSta1(
    final k=2)
    "Stage two"
    annotation (Placement(transformation(extent={{40,230},{60,250}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dowSta1(
    final k=1)
    "Stage one"
    annotation (Placement(transformation(extent={{40,190},{60,210}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swi1
    "Logical switch"
    annotation (Placement(transformation(extent={{120,210},{140,230}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger staSet1
    "Stage setpoint index"
    annotation (Placement(transformation(extent={{160,210},{180,230}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant staTwoBoi1[2](
    final k={true,true})
    "Vector of boilers status setpoint at stage two"
    annotation (Placement(transformation(extent={{40,110},{60,130}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep1(
    final nout=2)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{120,90},{140,110}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul2(
    final width=0.15,
    final period=120)
    "Boolean pulse"
    annotation (Placement(transformation(extent={{-260,-170},{-240,-150}})));

  Buildings.Controls.OBC.CDL.Logical.Not staDow
    "Stage down command"
    annotation (Placement(transformation(extent={{-220,-170},{-200,-150}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant staOneBoi2[2](
    final k={true,false})
    "Vector of boilers status setpoint at stage one"
    annotation (Placement(transformation(extent={{-260,-210},{-240,-190}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant upSta2(
    final k=2)
    "Stage two"
    annotation (Placement(transformation(extent={{-260,-130},{-240,-110}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dowSta2(
    final k=1)
    "Stage one"
    annotation (Placement(transformation(extent={{-260,-90},{-240,-70}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swi2
    "Logical switch"
    annotation (Placement(transformation(extent={{-180,-110},{-160,-90}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger staSet2
    "Stage setpoint index"
    annotation (Placement(transformation(extent={{-140,-110},{-120,-90}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant staTwoBoi2[2](
    final k={false,true})
    "Vector of boilers status setpoint at stage two"
    annotation (Placement(transformation(extent={{-260,-250},{-240,-230}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep2(
    final nout=2)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-180,-230},{-160,-210}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul3(
    final width=0.15,
    final period=120)
    "Boolean pulse"
    annotation (Placement(transformation(extent={{40,-170},{60,-150}})));

  Buildings.Controls.OBC.CDL.Logical.Not staDow1
    "Stage down command"
    annotation (Placement(transformation(extent={{80,-170},{100,-150}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant staOneBoi3[2](
    final k={true,false})
    "Vector of boilers status setpoint at stage one"
    annotation (Placement(transformation(extent={{40,-210},{60,-190}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant upSta3(
    final k=2)
    "Stage two"
    annotation (Placement(transformation(extent={{40,-130},{60,-110}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dowSta3(
    final k=1)
    "Stage one"
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swi3
    "Logical switch"
    annotation (Placement(transformation(extent={{120,-110},{140,-90}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger staSet3
    "Stage setpoint index"
    annotation (Placement(transformation(extent={{160,-110},{180,-90}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant staTwoBoi3[2](
    final k={true,true})
    "Vector of boilers status setpoint at stage two"
    annotation (Placement(transformation(extent={{40,-250},{60,-230}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep3(
    final nout=2)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{120,-230},{140,-210}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=30)
    "Generate stage change completion signal after it is initiated with short delay"
    annotation (Placement(transformation(extent={{-180,40},{-160,60}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1(
    final delayTime=30)
    "Generate stage change completion signal after it is initiated with short delay"
    annotation (Placement(transformation(extent={{160,50},{180,70}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel2(
    final delayTime=30)
    "Generate stage change completion signal after it is initiated with short delay"
    annotation (Placement(transformation(extent={{-140,-270},{-120,-250}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel3(
    final delayTime=30)
    "Generate stage change completion signal after it is initiated with short delay"
    annotation (Placement(transformation(extent={{120,-280},{140,-260}})));

equation
  connect(booPul.y, staUp.u)
    annotation (Line(points={{-238,160},{-222,160}}, color={255,0,255}));

  connect(staUp.y, swi.u2)
    annotation (Line(points={{-198,160},{-190,160},{-190,220},{-182,220}},
      color={255,0,255}));

  connect(dowSta.y, swi.u3)
    annotation (Line(points={{-238,200},{-220,200},{-220,212},{-182,212}},
      color={0,0,127}));

  connect(upSta.y, swi.u1)
    annotation (Line(points={{-238,240},{-220,240},{-220,228},{-182,228}},
      color={0,0,127}));

  connect(swi.y, staSet.u)
    annotation (Line(points={{-158,220},{-142,220}}, color={0,0,127}));

  connect(staUp.y, booRep.u) annotation (Line(points={{-198,160},{-190,160},{-190,
          100},{-182,100}}, color={255,0,255}));

  connect(booRep.y,boiSet. u2)
    annotation (Line(points={{-158,100},{-142,100}}, color={255,0,255}));

  connect(booPul1.y, staUp1.u)
    annotation (Line(points={{62,160},{78,160}}, color={255,0,255}));

  connect(staUp1.y, swi1.u2) annotation (Line(points={{102,160},{110,160},{110,220},
          {118,220}}, color={255,0,255}));

  connect(dowSta1.y, swi1.u3) annotation (Line(points={{62,200},{80,200},{80,212},
          {118,212}}, color={0,0,127}));

  connect(upSta1.y, swi1.u1) annotation (Line(points={{62,240},{80,240},{80,228},
          {118,228}}, color={0,0,127}));

  connect(swi1.y, staSet1.u)
    annotation (Line(points={{142,220},{158,220}}, color={0,0,127}));

  connect(staUp1.y, booRep1.u) annotation (Line(points={{102,160},{110,160},{110,
          100},{118,100}}, color={255,0,255}));

  connect(booRep1.y,boiSet1. u2)
    annotation (Line(points={{142,100},{158,100}}, color={255,0,255}));

  connect(booPul2.y, staDow.u)
    annotation (Line(points={{-238,-160},{-222,-160}}, color={255,0,255}));

  connect(staDow.y, swi2.u2) annotation (Line(points={{-198,-160},{-190,-160},{-190,
          -100},{-182,-100}}, color={255,0,255}));

  connect(swi2.y, staSet2.u)
    annotation (Line(points={{-158,-100},{-142,-100}}, color={0,0,127}));

  connect(staDow.y, booRep2.u) annotation (Line(points={{-198,-160},{-190,-160},
          {-190,-220},{-182,-220}}, color={255,0,255}));

  connect(staOneBoi2.y,boiSet2. u1) annotation (Line(points={{-238,-200},{-150,-200},
          {-150,-212},{-142,-212}}, color={255,0,255}));

  connect(booRep2.y,boiSet2. u2)
    annotation (Line(points={{-158,-220},{-142,-220}}, color={255,0,255}));

  connect(staTwoBoi2.y,boiSet2. u3) annotation (Line(points={{-238,-240},{-148,-240},
          {-148,-228},{-142,-228}}, color={255,0,255}));

  connect(dowSta2.y, swi2.u1) annotation (Line(points={{-238,-80},{-200,-80},{-200,
          -92},{-182,-92}}, color={0,0,127}));

  connect(upSta2.y, swi2.u3) annotation (Line(points={{-238,-120},{-200,-120},{-200,
          -108},{-182,-108}}, color={0,0,127}));

  connect(staTwoBoi.y,boiSet. u1) annotation (Line(points={{-238,120},{-150,120},
          {-150,108},{-142,108}}, color={255,0,255}));

  connect(staOneBoi.y,boiSet. u3) annotation (Line(points={{-238,80},{-150,80},{
          -150,92},{-142,92}}, color={255,0,255}));

  connect(staTwoBoi1.y,boiSet1. u1) annotation (Line(points={{62,120},{150,120},
          {150,108},{158,108}}, color={255,0,255}));

  connect(staOneBoi1.y,boiSet1. u3) annotation (Line(points={{62,80},{150,80},{150,
          92},{158,92}}, color={255,0,255}));

  connect(booPul3.y, staDow1.u)
    annotation (Line(points={{62,-160},{78,-160}}, color={255,0,255}));

  connect(staDow1.y, swi3.u2) annotation (Line(points={{102,-160},{110,-160},{110,
          -100},{118,-100}}, color={255,0,255}));

  connect(swi3.y, staSet3.u)
    annotation (Line(points={{142,-100},{158,-100}}, color={0,0,127}));

  connect(staDow1.y, booRep3.u) annotation (Line(points={{102,-160},{110,-160},{
          110,-220},{118,-220}}, color={255,0,255}));

  connect(staOneBoi3.y,boiSet3. u1) annotation (Line(points={{62,-200},{150,-200},
          {150,-212},{158,-212}}, color={255,0,255}));

  connect(booRep3.y,boiSet3. u2)
    annotation (Line(points={{142,-220},{158,-220}}, color={255,0,255}));

  connect(staTwoBoi3.y,boiSet3. u3) annotation (Line(points={{62,-240},{152,-240},
          {152,-228},{158,-228}}, color={255,0,255}));

  connect(dowSta3.y, swi3.u1) annotation (Line(points={{62,-80},{100,-80},{100,-92},
          {118,-92}}, color={0,0,127}));

  connect(upSta3.y, swi3.u3) annotation (Line(points={{62,-120},{100,-120},{100,
          -108},{118,-108}}, color={0,0,127}));

  connect(staSet.y, nexBoi.uStaSet) annotation (Line(points={{-118,220},{-80,220},
          {-80,186},{-62,186}}, color={255,127,0}));

  connect(boiSet.y, nexBoi.uBoiSet) annotation (Line(points={{-118,100},{-100,100},
          {-100,180},{-62,180}}, color={255,0,255}));

  connect(staSet1.y, nexBoi1.uStaSet) annotation (Line(points={{182,220},{220,220},
          {220,186},{238,186}}, color={255,127,0}));

  connect(boiSet1.y, nexBoi1.uBoiSet) annotation (Line(points={{182,100},{200,100},
          {200,180},{238,180}}, color={255,0,255}));

  connect(staSet2.y, nexBoi2.uStaSet) annotation (Line(points={{-118,-100},{-80,
          -100},{-80,-134},{-62,-134}}, color={255,127,0}));

  connect(boiSet2.y, nexBoi2.uBoiSet) annotation (Line(points={{-118,-220},{-100,
          -220},{-100,-140},{-62,-140}}, color={255,0,255}));

  connect(staSet3.y, nexBoi3.uStaSet) annotation (Line(points={{182,-100},{220,-100},
          {220,-134},{238,-134}}, color={255,127,0}));

  connect(boiSet3.y, nexBoi3.uBoiSet) annotation (Line(points={{182,-220},{200,-220},
          {200,-140},{238,-140}}, color={255,0,255}));

  connect(staUp.y, truDel.u) annotation (Line(points={{-198,160},{-190,160},{-190,
          50},{-182,50}}, color={255,0,255}));
  connect(truDel.y, nexBoi.uStaChaPro) annotation (Line(points={{-158,50},{-88,50},
          {-88,174},{-62,174}}, color={255,0,255}));
  connect(staUp1.y, truDel1.u) annotation (Line(points={{102,160},{110,160},{110,
          60},{158,60}}, color={255,0,255}));
  connect(truDel1.y, nexBoi1.uStaChaPro) annotation (Line(points={{182,60},{220,
          60},{220,174},{238,174}}, color={255,0,255}));
  connect(staDow.y, truDel2.u) annotation (Line(points={{-198,-160},{-190,-160},
          {-190,-260},{-142,-260}}, color={255,0,255}));
  connect(truDel2.y, nexBoi2.uStaChaPro) annotation (Line(points={{-118,-260},{-80,
          -260},{-80,-146},{-62,-146}}, color={255,0,255}));
  connect(truDel3.y, nexBoi3.uStaChaPro) annotation (Line(points={{142,-270},{220,
          -270},{220,-146},{238,-146}}, color={255,0,255}));
  connect(staDow1.y, truDel3.u) annotation (Line(points={{102,-160},{110,-160},{
          110,-270},{118,-270}}, color={255,0,255}));
annotation (
 experiment(StopTime=120, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/Plants/Boilers/Staging/Processes/Subsequences/Validation/NextBoiler.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.Processes.Subsequences.NextBoiler\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.Processes.Subsequences.NextBoiler</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 13, 2020 by Karthik Devaprasad:<br/>
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
        coordinateSystem(preserveAspectRatio=false, extent={{-280,-320},{280,320}}),
        graphics={
        Text(
          extent={{-258,292},{-146,280}},
          textColor={0,0,127},
          textString="In stage up process (stage 1 to 2),"),
        Text(
          extent={{-254,278},{-94,266}},
          textColor={0,0,127},
          textString="requires small boiler (1) off and large boiler (2) on."),
        Text(
          extent={{64,278},{228,268}},
          textColor={0,0,127},
          textString="add one more boiler (1) on top of current boiler (2)."),
        Text(
          extent={{62,292},{174,280}},
          textColor={0,0,127},
          textString="In stage up process (stage 2 to 3),"),
        Text(
          extent={{-256,-40},{-96,-52}},
          textColor={0,0,127},
          textString="requires large boiler (2) off and small boiler (1) on."),
        Text(
          extent={{-260,-26},{-140,-36}},
          textColor={0,0,127},
          textString="In stage down process (stage 2 to 1),"),
        Text(
          extent={{58,-42},{130,-52}},
          textColor={0,0,127},
          textString="disable boiler (2)."),
        Text(
          extent={{62,-28},{182,-38}},
          textColor={0,0,127},
          textString="In stage down process (stage 2 to 1),")}));
end NextBoiler;
