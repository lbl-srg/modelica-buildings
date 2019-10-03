within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.Validation;
model NextChiller
  "Validate sequence of identifying next enable or disable chillers"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.NextChiller
    nexEnaDisChi(
    final nChi=3,
    final havePonyChiller=true,
    final totChiSta=5,
    final upOnOffSta={false,false,true,false,true},
    final dowOnOffSta={false,true,false,true,false})
    "Identify chillers being enabled and disabled in stage up process"
    annotation (Placement(transformation(extent={{-80,190},{-60,210}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.NextChiller
    nexEnaChi(
    final nChi=3,
    final havePonyChiller=true,
    final totChiSta=5,
    final upOnOffSta={false,false,true,false,true},
    final dowOnOffSta={false,true,false,true,false})
    "Identify chillers being enabled in stage up process"
    annotation (Placement(transformation(extent={{240,190},{260,210}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.NextChiller
    nexEnaDisChi1(
    final nChi=3,
    final havePonyChiller=true,
    final totChiSta=5,
    final upOnOffSta={false,false,true,false,true},
    final dowOnOffSta={false,true,false,true,false})
    "Identify chillers being enabled or disabled in stage down process"
    annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.NextChiller
    nexDisChi(
    final nChi=3,
    final havePonyChiller=true,
    final totChiSta=5,
    final upOnOffSta={false,false,true,false,true},
    final dowOnOffSta={false,true,false,true,false})
    "Identify chillers being disabled in stage down process"
    annotation (Placement(transformation(extent={{240,-130},{260,-110}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.15,
    final period=120) "Boolean pulse"
    annotation (Placement(transformation(extent={{-260,120},{-240,140}})));
  Buildings.Controls.OBC.CDL.Logical.Not staUp "Stage up command"
    annotation (Placement(transformation(extent={{-220,120},{-200,140}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant chiOn(final k=true)
    "Operating chiller one"
    annotation (Placement(transformation(extent={{-220,190},{-200,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant upSta(
    final k=2) "Stage two"
    annotation (Placement(transformation(extent={{-260,80},{-240,100}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant enaPri[3](final k={1,2,3})
    "Chiller enabling priority"
    annotation (Placement(transformation(extent={{-220,230},{-200,250}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant chiOff(final k=false)
    "Chiller off status"
    annotation (Placement(transformation(extent={{-220,160},{-200,180}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dowSta(
    final k=1) "Stage one"
    annotation (Placement(transformation(extent={{-260,40},{-240,60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant staDow(
    final k=false) "Stage down status"
    annotation (Placement(transformation(extent={{-220,10},{-200,30}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant enaPri1[3](final k={2,1,3})
    "Chiller enabling priority"
    annotation (Placement(transformation(extent={{100,230},{120,250}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant chiOn1(final k=true)
    "Operating chiller one"
    annotation (Placement(transformation(extent={{100,190},{120,210}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant chiOff1(
    final k=false) "Chiller off status"
    annotation (Placement(transformation(extent={{100,160},{120,180}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    final width=0.15,
    final period=120) "Boolean pulse"
    annotation (Placement(transformation(extent={{60,120},{80,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant upSta1(
    final k=3) "Stage 3"
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dowSta1(
    final k=2) "Stage one"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Buildings.Controls.OBC.CDL.Logical.Not staUp1 "Stage up command"
    annotation (Placement(transformation(extent={{100,120},{120,140}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant staDow1(
    final k=false) "Stage down status"
    annotation (Placement(transformation(extent={{100,10},{120,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul2(
    final width=0.15,
    final period=120) "Boolean pulse"
    annotation (Placement(transformation(extent={{-260,-310},{-240,-290}})));
  Buildings.Controls.OBC.CDL.Logical.Not staDow2 "Stage down command"
    annotation (Placement(transformation(extent={{-220,-310},{-200,-290}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant chiOn2(
    final k=true) "Operating chiller one"
    annotation (Placement(transformation(extent={{-220,-130},{-200,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant upSta2(
    final k=4) "Stage four"
    annotation (Placement(transformation(extent={{-260,-270},{-240,-250}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant enaPri2[3](
    final k={2,3,1}) "Chiller enabling priority"
    annotation (Placement(transformation(extent={{-220,-90},{-200,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant chiOff2(
    final k=false) "Chiller off status"
    annotation (Placement(transformation(extent={{-220,-160},{-200,-140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dowSta2(
    final k=3) "Stage three"
    annotation (Placement(transformation(extent={{-260,-230},{-240,-210}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant staUp2(
    final k=false) "Stage up status"
    annotation (Placement(transformation(extent={{-220,-200},{-200,-180}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul3(
    final width=0.15,
    final period=120) "Boolean pulse"
    annotation (Placement(transformation(extent={{60,-310},{80,-290}})));
  Buildings.Controls.OBC.CDL.Logical.Not staDow3 "Stage down command"
    annotation (Placement(transformation(extent={{100,-310},{120,-290}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant chiOn3(
    final k=true) "Operating chiller one"
    annotation (Placement(transformation(extent={{100,-130},{120,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant upSta3(
    final k=3) "Stage three"
    annotation (Placement(transformation(extent={{60,-270},{80,-250}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant enaPri3[3](
    final k={2,1,3})
    "Chiller enabling priority"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant chiOff3(
    final k=false) "Chiller off status"
    annotation (Placement(transformation(extent={{100,-160},{120,-140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dowSta3(
    final k=2) "Stage two"
    annotation (Placement(transformation(extent={{60,-230},{80,-210}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant staUp3(
    final k=false) "Stage up status"
    annotation (Placement(transformation(extent={{100,-200},{120,-180}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi "Logical switch"
    annotation (Placement(transformation(extent={{-180,60},{-160,80}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger sta "Stage index"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1 "Logical switch"
    annotation (Placement(transformation(extent={{140,60},{160,80}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger sta1 "Stage index"
    annotation (Placement(transformation(extent={{180,60},{200,80}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi2 "Logical switch"
    annotation (Placement(transformation(extent={{-180,-250},{-160,-230}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger sta2 "Stage index"
    annotation (Placement(transformation(extent={{-140,-250},{-120,-230}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi3 "Logical switch"
    annotation (Placement(transformation(extent={{140,-250},{160,-230}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger sta3 "Stage index"
    annotation (Placement(transformation(extent={{180,-250},{200,-230}})));

equation
  connect(booPul.y, staUp.u)
    annotation (Line(points={{-238,130},{-222,130}}, color={255,0,255}));
  connect(staUp.y, swi.u2)
    annotation (Line(points={{-198,130},{-190,130},{-190,70},{-182,70}},
      color={255,0,255}));
  connect(dowSta.y, swi.u3)
    annotation (Line(points={{-238,50},{-220,50},{-220,62},{-182,62}},
      color={0,0,127}));
  connect(upSta.y, swi.u1)
    annotation (Line(points={{-238,90},{-220,90},{-220,78},{-182,78}},
      color={0,0,127}));
  connect(swi.y, sta.u)
    annotation (Line(points={{-158,70},{-142,70}}, color={0,0,127}));
  connect(enaPri.y, nexEnaDisChi.uChiPri)
    annotation (Line(points={{-198,240},{-140,240},{-140,208},{-82,208}},
      color={255,127,0}));
  connect(chiOn.y, nexEnaDisChi.uChiEna[1])
    annotation (Line(points={{-198,200},{-140,200},{-140,202.667},{-82,202.667}},
      color={255,0,255}));
  connect(chiOff.y, nexEnaDisChi.uChiEna[2])
    annotation (Line(points={{-198,170},{-136,170},{-136,204},{-82,204}},
      color={255,0,255}));
  connect(chiOff.y, nexEnaDisChi.uChiEna[3])
    annotation (Line(points={{-198,170},{-132,170},{-132,205.333},{-82,205.333}},
      color={255,0,255}));
  connect(staUp.y, nexEnaDisChi.uStaUp)
    annotation (Line(points={{-198,130},{-128,130},{-128,200},{-82,200}},
      color={255,0,255}));
  connect(sta.y, nexEnaDisChi.uChiSta)
    annotation (Line(points={{-118,70},{-100,70},{-100,196},{-82,196}},
      color={255,127,0}));
  connect(staDow.y, nexEnaDisChi.uStaDow)
    annotation (Line(points={{-198,20},{-96,20},{-96,192},{-82,192}},
      color={255,0,255}));
  connect(enaPri1.y, nexEnaChi.uChiPri)
    annotation (Line(points={{122,240},{180,240},{180,208},{238,208}},
      color={255,127,0}));
  connect(chiOn1.y, nexEnaChi.uChiEna[2])
    annotation (Line(points={{122,200},{180,200},{180,204},{238,204}},
      color={255,0,255}));
  connect(chiOff1.y, nexEnaChi.uChiEna[1])
    annotation (Line(points={{122,170},{184,170},{184,202.667},{238,202.667}},
      color={255,0,255}));
  connect(chiOff1.y, nexEnaChi.uChiEna[3])
    annotation (Line(points={{122,170},{188,170},{188,205.333},{238,205.333}},
      color={255,0,255}));
  connect(booPul1.y, staUp1.u)
    annotation (Line(points={{82,130},{98,130}}, color={255,0,255}));
  connect(staUp1.y, swi1.u2)
    annotation (Line(points={{122,130},{130,130},{130,70},{138,70}},
      color={255,0,255}));
  connect(dowSta1.y, swi1.u3)
    annotation (Line(points={{82,50},{100,50},{100,62},{138,62}}, color={0,0,127}));
  connect(upSta1.y, swi1.u1)
    annotation (Line(points={{82,90},{100,90},{100,78},{138,78}},
      color={0,0,127}));
  connect(swi1.y, sta1.u)
    annotation (Line(points={{162,70},{178,70}}, color={0,0,127}));
  connect(staUp1.y, nexEnaChi.uStaUp)
    annotation (Line(points={{122,130},{192,130},{192,200},{238,200}},
      color={255,0,255}));
  connect(sta1.y, nexEnaChi.uChiSta)
    annotation (Line(points={{202,70},{220,70},{220,196},{238,196}},
      color={255,127,0}));
  connect(staDow1.y, nexEnaChi.uStaDow)
    annotation (Line(points={{122,20},{224,20},{224,192},{238,192}},
      color={255,0,255}));
  connect(booPul2.y, staDow2.u)
    annotation (Line(points={{-238,-300},{-222,-300}}, color={255,0,255}));
  connect(swi2.y, sta2.u)
    annotation (Line(points={{-158,-240},{-142,-240}}, color={0,0,127}));
  connect(enaPri2.y, nexEnaDisChi1.uChiPri)
    annotation (Line(points={{-198,-80},{-140,-80},{-140,-112},{-82,-112}},
      color={255,127,0}));
  connect(sta2.y, nexEnaDisChi1.uChiSta)
    annotation (Line(points={{-118,-240},{-100,-240},{-100,-124},{-82,-124}},
      color={255,127,0}));
  connect(staDow2.y, swi2.u2)
    annotation (Line(points={{-198,-300},{-190,-300},{-190,-240},{-182,-240}},
      color={255,0,255}));
  connect(upSta2.y, swi2.u3)
    annotation (Line(points={{-238,-260},{-220,-260},{-220,-248},{-182,-248}},
      color={0,0,127}));
  connect(dowSta2.y, swi2.u1)
    annotation (Line(points={{-238,-220},{-220,-220},{-220,-232},{-182,-232}},
      color={0,0,127}));
  connect(chiOff2.y, nexEnaDisChi1.uChiEna[1])
    annotation (Line(points={{-198,-150},{-132,-150},{-132,-117.333},{-82,
          -117.333}},
      color={255,0,255}));
  connect(chiOn2.y, nexEnaDisChi1.uChiEna[2])
    annotation (Line(points={{-198,-120},{-136,-120},{-136,-116},{-82,-116}},
      color={255,0,255}));
  connect(chiOn2.y, nexEnaDisChi1.uChiEna[3])
    annotation (Line(points={{-198,-120},{-140,-120},{-140,-114.667},{-82,
          -114.667}},
      color={255,0,255}));
  connect(staUp2.y, nexEnaDisChi1.uStaUp)
    annotation (Line(points={{-198,-190},{-128,-190},{-128,-120},{-82,-120}},
      color={255,0,255}));
  connect(staDow2.y, nexEnaDisChi1.uStaDow)
    annotation (Line(points={{-198,-300},{-96,-300},{-96,-128},{-82,-128}},
      color={255,0,255}));
  connect(booPul3.y, staDow3.u)
    annotation (Line(points={{82,-300},{98,-300}}, color={255,0,255}));
  connect(swi3.y, sta3.u)
    annotation (Line(points={{162,-240},{178,-240}}, color={0,0,127}));
  connect(enaPri3.y, nexDisChi.uChiPri)
    annotation (Line(points={{122,-80},{180,-80},{180,-112},{238,-112}},
      color={255,127,0}));
  connect(sta3.y, nexDisChi.uChiSta)
    annotation (Line(points={{202,-240},{220,-240},{220,-124},{238,-124}},
      color={255,127,0}));
  connect(staDow3.y, swi3.u2)
    annotation (Line(points={{122,-300},{130,-300},{130,-240},{138,-240}},
      color={255,0,255}));
  connect(upSta3.y, swi3.u3)
    annotation (Line(points={{82,-260},{100,-260},{100,-248},{138,-248}},
      color={0,0,127}));
  connect(dowSta3.y, swi3.u1)
    annotation (Line(points={{82,-220},{100,-220},{100,-232},{138,-232}},
      color={0,0,127}));
  connect(staUp3.y, nexDisChi.uStaUp)
    annotation (Line(points={{122,-190},{192,-190},{192,-120},{238,-120}},
      color={255,0,255}));
  connect(staDow3.y, nexDisChi.uStaDow)
    annotation (Line(points={{122,-300},{224,-300},{224,-128},{238,-128}},
      color={255,0,255}));
  connect(chiOn3.y, nexDisChi.uChiEna[1])
    annotation (Line(points={{122,-120},{188,-120},{188,-117.333},{238,-117.333}},
      color={255,0,255}));
  connect(chiOn3.y, nexDisChi.uChiEna[2])
    annotation (Line(points={{122,-120},{184,-120},{184,-116},{238,-116}},
      color={255,0,255}));
  connect(chiOff3.y, nexDisChi.uChiEna[3])
    annotation (Line(points={{122,-150},{180,-150},{180,-114.667},{238,-114.667}},
      color={255,0,255}));

annotation (
 experiment(StopTime=120, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Processes/Subsequences/Validation/NextChiller.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.NextChiller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.NextChiller</a>.
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
        coordinateSystem(preserveAspectRatio=false, extent={{-280,-320},{280,320}}),
        graphics={
          Rectangle(
          extent={{2,-2},{278,-318}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Rectangle(
          extent={{-278,-2},{-2,-318}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Rectangle(
          extent={{2,318},{278,2}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Rectangle(
          extent={{-278,318},{-2,2}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-258,292},{-146,280}},
          lineColor={0,0,127},
          textString="In stage up process (stage 1 to 2),"),
        Text(
          extent={{-254,278},{-94,266}},
          lineColor={0,0,127},
          textString="requires small chiller (1) off and large chiller (2) on."),
        Text(
          extent={{64,278},{228,268}},
          lineColor={0,0,127},
          textString="add one more chiller (1) on top of current chiller (2)."),
        Text(
          extent={{62,292},{174,280}},
          lineColor={0,0,127},
          textString="In stage up process (stage 2 to 3),"),
        Text(
          extent={{-256,-40},{-96,-52}},
          lineColor={0,0,127},
          textString="requires large chiller (3) off and small chiller (1) on."),
        Text(
          extent={{-260,-26},{-140,-36}},
          lineColor={0,0,127},
          textString="In stage down process (stage 4 to 3),"),
        Text(
          extent={{64,-42},{228,-54}},
          lineColor={0,0,127},
          textString="disable chiller (1) from current chiller array (2, 1)."),
        Text(
          extent={{62,-28},{182,-38}},
          lineColor={0,0,127},
          textString="In stage down process (stage 3 to 2),")}));
end NextChiller;
