within Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Towers.Staging.Subsequences.Validation;
model StageProcesses
  "Validation sequence of tower cells staging process"

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Towers.Staging.Subsequences.StageProcesses
    enaPro(have_endSwi=true, nTowCel=4)
    "Enable tower cells: inlet isolation valve with end switch status feedback"
    annotation (Placement(transformation(extent={{-80,250},{-60,270}})));
  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Towers.Staging.Subsequences.StageProcesses
    disPro(have_endSwi=true, nTowCel=4)
    "Disable tower cells: inlet isolation valve with end switch status feedback"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Towers.Staging.Subsequences.StageProcesses
    enaPro1(final have_endSwi=false, final nTowCel=4)
    "Enable tower cells: inlet isolation valve without end switch status feedback"
    annotation (Placement(transformation(extent={{140,250},{160,270}})));
  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Towers.Staging.Subsequences.StageProcesses
    disPro1(have_endSwi=false, nTowCel=4)
    "Disable tower cells: inlet isolation valve without end switch status feedback"
    annotation (Placement(transformation(extent={{140,70},{160,90}})));
  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Towers.Staging.Subsequences.StageProcesses
    enaPro2(
    have_endSwi=true,
    have_outIsoVal=true,
    nTowCel=4)
    "Enable tower cells: inlet and outlet isolation valve with end switch status feedback"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Towers.Staging.Subsequences.StageProcesses
    disPro2(
    have_endSwi=true,
    have_outIsoVal=true,
    nTowCel=4)
    "Disable tower cells: inlet and outlet isolation valve with end switch status feedback"
    annotation (Placement(transformation(extent={{-100,-270},{-80,-250}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con[4](
    final k=fill(false,4)) "Constant zero"
    annotation (Placement(transformation(extent={{-300,240},{-280,260}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2[4](
    final k={false,true,true,false})
    "Enabling cells index"
    annotation (Placement(transformation(extent={{-260,330},{-240,350}})));
  Buildings.Controls.OBC.CDL.Logical.Not staUp1 "Chiller stage up status"
    annotation (Placement(transformation(extent={{-260,290},{-240,310}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul2(
    final width=0.1,
    final period=3800) "Boolean pulse"
    annotation (Placement(transformation(extent={{-300,290},{-280,310}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi[4] "Logical switch"
    annotation (Placement(transformation(extent={{-160,290},{-140,310}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(
    final nout=4) "Replicate boolean input"
    annotation (Placement(transformation(extent={{-220,290},{-200,310}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre[4] "Tower cell actual status"
    annotation (Placement(transformation(extent={{-20,190},{0,210}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre1[4](
    final pre_u_start={true,true,true,true})
    "Tower cell actual status"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Controls.OBC.CDL.Logical.Switch fulClo1[4]
    "Fully closed end switch"
    annotation (Placement(transformation(extent={{-180,40},{-160,60}})));
  Buildings.Controls.OBC.CDL.Logical.Switch fulOpe[4] "Fully open end switch"
    annotation (Placement(transformation(extent={{-160,230},{-140,250}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay opeEnd[4](delayTime=fill(90, 4))
    "Open end status"
    annotation (Placement(transformation(extent={{-20,240},{0,260}})));
  Buildings.Controls.OBC.CDL.Logical.Switch fulClo[4] "Fully closed end switch"
    annotation (Placement(transformation(extent={{-160,170},{-140,190}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1[4](
    final k=fill(true,4))
    "Constant zero"
    annotation (Placement(transformation(extent={{-300,120},{-280,140}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay cloEnd[4](delayTime=fill(90, 4))
    "Closed end status"
    annotation (Placement(transformation(extent={{-20,110},{0,130}})));
  Buildings.Controls.OBC.CDL.Logical.Switch fulOpe1[4] "Fully open end switch"
    annotation (Placement(transformation(extent={{-180,90},{-160,110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con3[4](
    final k=fill(false,4))
    "Constant zero"
    annotation (Placement(transformation(extent={{-300,30},{-280,50}})));
  Buildings.Controls.OBC.CDL.Logical.Not clo[4] "Closed end status"
    annotation (Placement(transformation(extent={{-220,190},{-200,210}})));
  Buildings.Controls.OBC.CDL.Logical.Not clo1[4] "Closed end status"
    annotation (Placement(transformation(extent={{-60,110},{-40,130}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre2[4]
    "Tower cell actual status"
    annotation (Placement(transformation(extent={{220,230},{240,250}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre3[4](
    final pre_u_start={true,true,true,true})
    "Tower cell actual status"
    annotation (Placement(transformation(extent={{220,50},{240,70}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay outOpeEnd[4](
    delayTime=fill(90, 4))
    "Outlet valve open end status"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay inOpeEnd[4](
    delayTime=fill(120, 4))
    "Inlet valve open end status"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre4[4]
    "Tower cell actual status"
    annotation (Placement(transformation(extent={{-20,-120},{0,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Switch outFulOpe[4]
    "Outlet valve fully open end switch"
    annotation (Placement(transformation(extent={{-160,-80},{-140,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con4[4](
    final k=fill(false,4))
    "Constant zero"
    annotation (Placement(transformation(extent={{-300,-70},{-280,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Switch fulClo2[4]
    "Fully closed end switch"
    annotation (Placement(transformation(extent={{-160,-140},{-140,-120}})));
  Buildings.Controls.OBC.CDL.Logical.Not clo2[4] "Closed end status"
    annotation (Placement(transformation(extent={{-222,-120},{-202,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Switch inFulOpe[4]
    "Inlet valve fully open end switch"
    annotation (Placement(transformation(extent={{-160,-50},{-140,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con5[4](
    final k=fill(true,4))
    "Constant zero"
    annotation (Placement(transformation(extent={{-298,-180},{-278,-160}})));
  Buildings.Controls.OBC.CDL.Logical.Not clo3[4] "Closed end status"
    annotation (Placement(transformation(extent={{-40,-250},{-20,-230}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay inCloEnd[4](delayTime=fill(120, 4))
    "Inlet valve closed end status"
    annotation (Placement(transformation(extent={{0,-210},{20,-190}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre5[4](
    final pre_u_start={true,true,true,true})
    "Tower cell actual status"
    annotation (Placement(transformation(extent={{-20,-290},{0,-270}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay outCloEnd[4](delayTime=fill(90, 4))
    "Outlet valve closed end status"
    annotation (Placement(transformation(extent={{0,-250},{20,-230}})));
  Buildings.Controls.OBC.CDL.Logical.Switch fulOpe2[4] "Fully open end switch"
    annotation (Placement(transformation(extent={{-180,-240},{-160,-220}})));
  Buildings.Controls.OBC.CDL.Logical.Switch inFulClo[4]
    "Inlet valve fully closed end switch"
    annotation (Placement(transformation(extent={{-180,-290},{-160,-270}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con6[4](
    final k=fill(false,4))
    "Constant zero"
    annotation (Placement(transformation(extent={{-300,-280},{-280,-260}})));
  Buildings.Controls.OBC.CDL.Logical.Switch outFulClo[4]
    "Outlet valve fully closed end switch"
    annotation (Placement(transformation(extent={{-180,-330},{-160,-310}})));

equation
  connect(booPul2.y, staUp1.u)
    annotation (Line(points={{-278,300},{-262,300}}, color={255,0,255}));
  connect(con2.y, logSwi.u1)
    annotation (Line(points={{-238,340},{-180,340},{-180,308},{-162,308}},
      color={255,0,255}));
  connect(con.y, logSwi.u3)
    annotation (Line(points={{-278,250},{-180,250},{-180,292},{-162,292}},
      color={255,0,255}));
  connect(logSwi.y, enaPro.uChaCel) annotation (Line(points={{-138,300},{-130,300},
          {-130,268},{-82,268}}, color={255,0,255}));
  connect(booRep.y, logSwi.u2)
    annotation (Line(points={{-198,300},{-162,300}}, color={255,0,255}));
  connect(staUp1.y, booRep.u)
    annotation (Line(points={{-238,300},{-222,300}}, color={255,0,255}));
  connect(enaPro.yTowSta, pre.u) annotation (Line(points={{-58,260},{-50,260},{-50,
          200},{-22,200}}, color={255,0,255}));
  connect(pre.y, enaPro.uTowSta) annotation (Line(points={{2,200},{20,200},{20,180},
          {-100,180},{-100,252},{-82,252}}, color={255,0,255}));
  connect(disPro.yTowSta, pre1.u) annotation (Line(points={{-78,80},{-60,80},{-60,
          50},{-42,50}},  color={255,0,255}));
  connect(pre1.y, disPro.uTowSta) annotation (Line(points={{-18,50},{20,50},{20,
          30},{-120,30},{-120,72},{-102,72}}, color={255,0,255}));
  connect(logSwi.y, disPro.uChaCel) annotation (Line(points={{-138,300},{-130,300},
          {-130,88},{-102,88}}, color={255,0,255}));
  connect(fulClo1.y, disPro.u1InlIsoValClo) annotation (Line(points={{-158,50},{-140,
          50},{-140,78},{-102,78}}, color={255,0,255}));
  connect(booRep.y, fulOpe.u2) annotation (Line(points={{-198,300},{-190,300},{-190,
          240},{-162,240}}, color={255,0,255}));
  connect(con.y, fulOpe.u3) annotation (Line(points={{-278,250},{-180,250},{-180,
          232},{-162,232}}, color={255,0,255}));
  connect(enaPro.y1IsoVal,opeEnd. u) annotation (Line(points={{-58,266},{-40,266},
          {-40,250},{-22,250}}, color={255,0,255}));
  connect(opeEnd.y, fulOpe.u1) annotation (Line(points={{2,250},{20,250},{20,280},
          {-170,280},{-170,248},{-162,248}}, color={255,0,255}));
  connect(fulOpe.y, enaPro.u1InlIsoValOpe) annotation (Line(points={{-138,240},{-120,
          240},{-120,264},{-82,264}}, color={255,0,255}));
  connect(booRep.y, fulClo.u2) annotation (Line(points={{-198,300},{-190,300},{-190,
          180},{-162,180}}, color={255,0,255}));
  connect(con1.y, fulClo.u3) annotation (Line(points={{-278,130},{-260,130},{-260,
          172},{-162,172}}, color={255,0,255}));
  connect(fulClo.y, enaPro.u1InlIsoValClo) annotation (Line(points={{-138,180},{-110,
          180},{-110,258},{-82,258}}, color={255,0,255}));
  connect(fulOpe1.y, disPro.u1InlIsoValOpe) annotation (Line(points={{-158,100},{
          -140,100},{-140,84},{-102,84}}, color={255,0,255}));
  connect(con3.y,fulClo1. u3) annotation (Line(points={{-278,40},{-222,40},{-222,
          42},{-182,42}}, color={255,0,255}));
  connect(con1.y,fulOpe1. u3) annotation (Line(points={{-278,130},{-260,130},{-260,
          92},{-182,92}}, color={255,0,255}));
  connect(disPro.y1IsoVal,fulOpe1. u1) annotation (Line(points={{-78,86},{-70,86},
          {-70,120},{-200,120},{-200,108},{-182,108}}, color={255,0,255}));
  connect(clo.y, fulClo.u1) annotation (Line(points={{-198,200},{-180,200},{-180,
          188},{-162,188}}, color={255,0,255}));
  connect(enaPro.y1IsoVal, clo.u) annotation (Line(points={{-58,266},{-40,266},{
          -40,220},{-230,220},{-230,200},{-222,200}}, color={255,0,255}));
  connect(disPro.y1IsoVal, clo1.u) annotation (Line(points={{-78,86},{-70,86},{-70,
          120},{-62,120}}, color={255,0,255}));
  connect(clo1.y, cloEnd.u)
    annotation (Line(points={{-38,120},{-22,120}}, color={255,0,255}));
  connect(cloEnd.y, fulClo1.u1) annotation (Line(points={{2,120},{20,120},{20,150},
          {-220,150},{-220,58},{-182,58}}, color={255,0,255}));
  connect(booRep.y,fulOpe1. u2) annotation (Line(points={{-198,300},{-190,300},{
          -190,180},{-240,180},{-240,100},{-182,100}}, color={255,0,255}));
  connect(booRep.y,fulClo1. u2) annotation (Line(points={{-198,300},{-190,300},{
          -190,180},{-240,180},{-240,50},{-182,50}}, color={255,0,255}));
  connect(logSwi.y, enaPro1.uChaCel) annotation (Line(points={{-138,300},{110,300},
          {110,268},{138,268}}, color={255,0,255}));
  connect(enaPro1.yTowSta, pre2.u) annotation (Line(points={{162,260},{200,260},
          {200,240},{218,240}}, color={255,0,255}));
  connect(pre2.y, enaPro1.uTowSta) annotation (Line(points={{242,240},{250,240},
          {250,210},{120,210},{120,252},{138,252}}, color={255,0,255}));
  connect(logSwi.y, disPro1.uChaCel) annotation (Line(points={{-138,300},{110,300},
          {110,88},{138,88}}, color={255,0,255}));
  connect(disPro1.yTowSta, pre3.u) annotation (Line(points={{162,80},{200,80},{200,
          60},{218,60}}, color={255,0,255}));
  connect(pre3.y, disPro1.uTowSta) annotation (Line(points={{242,60},{250,60},{250,
          32},{120,32},{120,72},{138,72}}, color={255,0,255}));
  connect(enaPro2.y1IsoVal, inOpeEnd.u) annotation (Line(points={{-58,-34},{-40,
          -34},{-40,-10},{-22,-10}}, color={255,0,255}));
  connect(enaPro2.y1IsoVal, outOpeEnd.u) annotation (Line(points={{-58,-34},{-40,
          -34},{-40,-50},{-22,-50}}, color={255,0,255}));
  connect(enaPro2.yTowSta, pre4.u) annotation (Line(points={{-58,-40},{-50,-40},
          {-50,-110},{-22,-110}}, color={255,0,255}));
  connect(booRep.y, inFulOpe.u2) annotation (Line(points={{-198,300},{-190,300},
          {-190,-40},{-162,-40}}, color={255,0,255}));
  connect(booRep.y, outFulOpe.u2) annotation (Line(points={{-198,300},{-190,300},
          {-190,-70},{-162,-70}}, color={255,0,255}));
  connect(booRep.y,fulClo2. u2) annotation (Line(points={{-198,300},{-190,300},{
          -190,-130},{-162,-130}}, color={255,0,255}));
  connect(con4.y, outFulOpe.u3) annotation (Line(points={{-278,-60},{-220,-60},{
          -220,-78},{-162,-78}}, color={255,0,255}));
  connect(con4.y, inFulOpe.u3) annotation (Line(points={{-278,-60},{-220,-60},{-220,
          -48},{-162,-48}}, color={255,0,255}));
  connect(inOpeEnd.y, inFulOpe.u1) annotation (Line(points={{2,-10},{10,-10},{10,
          10},{-170,10},{-170,-32},{-162,-32}}, color={255,0,255}));
  connect(outOpeEnd.y, outFulOpe.u1) annotation (Line(points={{2,-50},{20,-50},{
          20,20},{-180,20},{-180,-62},{-162,-62}}, color={255,0,255}));
  connect(logSwi.y, enaPro2.uChaCel) annotation (Line(points={{-138,300},{-130,300},
          {-130,-32},{-82,-32}}, color={255,0,255}));
  connect(inFulOpe.y, enaPro2.u1InlIsoValOpe) annotation (Line(points={{-138,-40},
          {-120,-40},{-120,-36},{-82,-36}}, color={255,0,255}));
  connect(outFulOpe.y, enaPro2.u1OutIsoValOpe) annotation (Line(points={{-138,-70},
          {-110,-70},{-110,-38},{-82,-38}}, color={255,0,255}));
  connect(con5.y,fulClo2. u3) annotation (Line(points={{-276,-170},{-260,-170},{
          -260,-138},{-162,-138}}, color={255,0,255}));
  connect(enaPro2.y1IsoVal, clo2.u) annotation (Line(points={{-58,-34},{-40,-34},
          {-40,-90},{-240,-90},{-240,-110},{-224,-110}}, color={255,0,255}));
  connect(clo2.y, fulClo2.u1) annotation (Line(points={{-200,-110},{-180,-110},{
          -180,-122},{-162,-122}}, color={255,0,255}));
  connect(fulClo2.y, enaPro2.u1InlIsoValClo) annotation (Line(points={{-138,-130},
          {-100,-130},{-100,-42},{-82,-42}}, color={255,0,255}));
  connect(fulClo2.y, enaPro2.u1OutIsoValClo) annotation (Line(points={{-138,-130},
          {-100,-130},{-100,-44},{-82,-44}}, color={255,0,255}));
  connect(pre4.y, enaPro2.uTowSta) annotation (Line(points={{2,-110},{20,-110},{
          20,-130},{-90,-130},{-90,-48},{-82,-48}}, color={255,0,255}));
  connect(disPro2.y1IsoVal, clo3.u) annotation (Line(points={{-78,-254},{-60,-254},
          {-60,-240},{-42,-240}}, color={255,0,255}));
  connect(clo3.y, outCloEnd.u)
    annotation (Line(points={{-18,-240},{-2,-240}}, color={255,0,255}));
  connect(clo3.y, inCloEnd.u) annotation (Line(points={{-18,-240},{-10,-240},{-10,
          -200},{-2,-200}}, color={255,0,255}));
  connect(logSwi.y, disPro2.uChaCel) annotation (Line(points={{-138,300},{-130,300},
          {-130,-252},{-102,-252}}, color={255,0,255}));
  connect(booRep.y,fulOpe2. u2) annotation (Line(points={{-198,300},{-190,300},{
          -190,-230},{-182,-230}}, color={255,0,255}));
  connect(booRep.y, inFulClo.u2) annotation (Line(points={{-198,300},{-190,300},
          {-190,-280},{-182,-280}}, color={255,0,255}));
  connect(con5.y,fulOpe2. u3) annotation (Line(points={{-276,-170},{-260,-170},{
          -260,-238},{-182,-238}}, color={255,0,255}));
  connect(disPro2.y1IsoVal,fulOpe2. u1) annotation (Line(points={{-78,-254},{-60,
          -254},{-60,-210},{-200,-210},{-200,-222},{-182,-222}}, color={255,0,255}));
  connect(fulOpe2.y, disPro2.u1InlIsoValOpe) annotation (Line(points={{-158,-230},
          {-140,-230},{-140,-256},{-102,-256}}, color={255,0,255}));
  connect(fulOpe2.y, disPro2.u1OutIsoValOpe) annotation (Line(points={{-158,-230},
          {-140,-230},{-140,-258},{-102,-258}}, color={255,0,255}));
  connect(con6.y, outFulClo.u3) annotation (Line(points={{-278,-270},{-260,-270},
          {-260,-328},{-182,-328}}, color={255,0,255}));
  connect(con6.y, inFulClo.u3) annotation (Line(points={{-278,-270},{-260,-270},
          {-260,-288},{-182,-288}}, color={255,0,255}));
  connect(booRep.y, outFulClo.u2) annotation (Line(points={{-198,300},{-190,300},
          {-190,-320},{-182,-320}}, color={255,0,255}));
  connect(inCloEnd.y, inFulClo.u1) annotation (Line(points={{22,-200},{40,-200},
          {40,-180},{-210,-180},{-210,-272},{-182,-272}}, color={255,0,255}));
  connect(outCloEnd.y, outFulClo.u1) annotation (Line(points={{22,-240},{50,-240},
          {50,-170},{-220,-170},{-220,-312},{-182,-312}}, color={255,0,255}));
  connect(inFulClo.y, disPro2.u1InlIsoValClo) annotation (Line(points={{-158,-280},
          {-140,-280},{-140,-262},{-102,-262}}, color={255,0,255}));
  connect(outFulClo.y, disPro2.u1OutIsoValClo) annotation (Line(points={{-158,-320},
          {-130,-320},{-130,-264},{-102,-264}}, color={255,0,255}));
  connect(disPro2.yTowSta, pre5.u) annotation (Line(points={{-78,-260},{-40,-260},
          {-40,-280},{-22,-280}}, color={255,0,255}));
  connect(pre5.y, disPro2.uTowSta) annotation (Line(points={{2,-280},{20,-280},{
          20,-310},{-120,-310},{-120,-268},{-102,-268}}, color={255,0,255}));
annotation (experiment(StopTime=1000.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/Plants/Chillers/Towers/Staging/Subsequences/Validation/StageProcesses.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Towers.Staging.Subsequences.StageProcesses\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Towers.Staging.Subsequences.StageProcesses</a>.
It demonstrates the process of enabling (<code>enaPro</code>) and
disabling (<code>disPro</code>) tower cells.
</p>
<p>
It shows the processes for three different cooling tower configurations.
</p>
<ul>
<li>
The towers have the isolation valves only at the cell inlet, with the valve end
switches status feedback: <code>endPro</code> and <code>disPro</code>.
</li>
<li>
The towers have the isolation valves only at the cell inlet, without the valve end
switches status feedback: <code>endPro1</code> and <code>disPro1</code>.
</li>
<li>
The towers have the isolation valves at the cell inlet and outlet, with the valve end
switches status feedback: <code>endPro2</code> and <code>disPro2</code>.
</li>
</ul>

<p>
Following processes are being validated:
</p>
<ul>

<li>
For enabling process in instance <code>enaPro</code>, 
<ul>
<li>
Initially, all four cells are disabled, the fully open end switches are
<code>false</code>, and the fully closed end switches are <code>true</code>.
</li>
<li>
At 380 seconds, the input <code>uChaCel[2]</code> and <code>uChaCel[3]</code> are
<code>true</code>, indicating that the status of cell 2 and 3 should be changed.
Thus, the isolation valve 2 and 3 are commanded on (<code>y1IsoVal[2]</code> and
<code>y1IsoVal[3]</code> become <code>true</code>);
the fully closed end switch of valve 2 and 3 become <code>false</code>
(<code>u1InlIsoValClo[2]</code> and <code>u1InlIsoValClo[3]</code> become <code>false</code>);
all the fully open end switch are still <code>false</code>.
</li>
<li>
After 90 seconds at 470 seconds, the fully open end switch of valve 2 and 3 become
<code>true</code> (<code>u1InlIsoValOpe[2]</code> and <code>u1InlIsoValOpe[3]</code>
become <code>true</code>). Thus, the cell 2 and 3 are commanded on
(<code>yTowSta[2]</code> and <code>yTowSta[3]</code> change to <code>true</code>).
</li>
</ul>
</li>

<li>
For disabling process in instance <code>disPro</code>, 
<ul>
<li>
Initially, all four cells are enabled, the fully open end switches are
<code>true</code>, and the fully closed end switches are <code>false</code>.
</li>
<li>
At 380 seconds, the input <code>uChaCel[2]</code> and <code>uChaCel[3]</code> are
<code>true</code>, indicating that the status of cell 2 and 3 should be changed.
Thus, the cell 2 and 3 are commanded off
(<code>yTowSta[2]</code> and <code>yTowSta[3]</code> change to <code>false</code>)
and the isolation valve 2 and 3 are commanded off (<code>y1IsoVal[2]</code> and
<code>y1IsoVal[3]</code> become <code>false</code>);
the fully open end switch of valve 2 and 3 become <code>false</code>
(<code>u1InlIsoValOpe[2]</code> and <code>u1InlIsoValOpe[3]</code> become <code>false</code>);
all the fully closed end switch are still <code>false</code>.
</li>
<li>
After 90 seconds at 470 seconds, the fully closed end switch of valve 2 and 3 become
<code>true</code> (<code>u1InlIsoValClo[2]</code> and <code>u1InlIsoValClo[3]</code>
become <code>true</code>).
</li>
</ul>
</li>

<li>
For enabling process in instance <code>enaPro1</code>, 
<ul>
<li>
Initially, all four cells are disabled.
</li>
<li>
At 380 seconds, the input <code>uChaCel[2]</code> and <code>uChaCel[3]</code> are
<code>true</code>, indicating that the status of cell 2 and 3 should be changed.
Thus, the isolation valve 2 and 3 are commanded on (<code>y1IsoVal[2]</code> and
<code>y1IsoVal[3]</code> become <code>true</code>).
</li>
<li>
After the needed time of operating isolation valves (90 seconds) at 470 seconds,
the valve 2 and 3 are considered as fully open. Thus, the cell 2 and 3 are commanded on
(<code>yTowSta[2]</code> and <code>yTowSta[3]</code> change to <code>true</code>).
</li>
</ul>
</li>

<li>
For disabling process in instance <code>disPro1</code>, 
<ul>
<li>
Initially, all four cells are enabled.
</li>
<li>
At 380 seconds, the input <code>uChaCel[2]</code> and <code>uChaCel[3]</code> are
<code>true</code>, indicating that the status of cell 2 and 3 should be changed.
Thus, the isolation valve 2 and 3 are commanded off (<code>y1IsoVal[2]</code> and
<code>y1IsoVal[3]</code> become <code>false</code>),
and the cell 2 and 3 are commanded off
(<code>yTowSta[2]</code> and <code>yTowSta[3]</code> change to <code>false</code>).
</li>
</ul>
</li>

<li>
For enabling process in instance <code>enaPro2</code>, 
<ul>
<li>
Initially, all four cells are disabled, the fully open end switches are
<code>false</code>, and the fully closed end switches are <code>true</code>.
</li>
<li>
At 380 seconds, the input <code>uChaCel[2]</code> and <code>uChaCel[3]</code> are
<code>true</code>, indicating that the status of cell 2 and 3 should be changed.
Thus, the isolation valve 2 and 3 are commanded on (<code>y1IsoVal[2]</code> and
<code>y1IsoVal[3]</code> become <code>true</code>);
the fully closed end switch of valve 2 and 3 become <code>false</code>
(<code>u1InlIsoValClo[2]</code>, <code>u1InlIsoValClo[3]</code>,
<code>u1OutIsoValClo[2]</code>, <code>u1OutIsoValClo[3]</code>
become <code>false</code>);
all the fully open end switch are still <code>false</code>.
</li>
<li>
After 90 seconds at 470 seconds, the fully open end switch of outlet valve 2 and 3 become
<code>true</code> (<code>u1OutIsoValOpe[2]</code> and <code>u1OutIsoValOpe[3]</code>
become <code>true</code>), but the fully open end switch of inlet valve 2 and 3 are
still <code>false</code>. Thus, the cell 2 and 3 are still commanded off
(<code>yTowSta[2]</code> and <code>yTowSta[3]</code> are <code>false</code>).
</li>
<li>
After another 30 seconds at 500 seconds, the fully open end switch of inlet valve 2
and 3 also become <code>true</code> (<code>u1InlIsoValOpe[2]</code> and <code>u1InlIsoValOpe[3]</code>
become <code>true</code>). Thus, the cell 2 and 3 can become commanded on
(<code>yTowSta[2]</code> and <code>yTowSta[3]</code> are <code>true</code>).
</li>
</ul>
</li>

<li>
For disabling process in instance <code>disPro2</code>, 
<ul>
<li>
Initially, all four cells are enabled, the fully open end switches are
<code>true</code>, and the fully closed end switches are <code>false</code>.
</li>
<li>
At 380 seconds, the input <code>uChaCel[2]</code> and <code>uChaCel[3]</code> are
<code>true</code>, indicating that the status of cell 2 and 3 should be changed.
Thus, the isolation valve 2 and 3 are commanded off (<code>y1IsoVal[2]</code> and
<code>y1IsoVal[3]</code> become <code>false</code>),
and the cell 2 and 3 should be commanded off
(<code>yTowSta[2]</code> and <code>yTowSta[3]</code> become <code>false</code>);
the fully open end switch of valve 2 and 3 become <code>false</code>
(<code>u1InlIsoValOpe[2]</code>, <code>u1InlIsoValOpe[3]</code>,
<code>u1OutIsoValOpe[2]</code>, <code>u1OutIsoValOpe[3]</code>
become <code>false</code>);
all the fully closed end switch are still <code>false</code>.
</li>
<li>
After 90 seconds at 470 seconds, the fully closed end switch of outlet valve 2 and 3 become
<code>true</code> (<code>u1OutIsoValClo[2]</code> and <code>u1OutIsoValClo[3]</code>
become <code>true</code>), and after another 30 seconds at 500 seconds,
the fully closed end switch of inlet valve 2 and 3 also become
<code>true</code> (<code>u1InlIsoValClo[2]</code> and <code>u1InlIsoValClo[3]</code>
become <code>true</code>).
</li>
</ul>
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
September 12, 2019, by Jianjun Hu:<br/>
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
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-320,-360},{320,360}}),
        graphics={
        Rectangle(
          extent={{-316,356},{36,4}},
          lineColor={215,215,215},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{44,356},{316,4}},
          lineColor={215,215,215},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-314,-4},{38,-356}},
          lineColor={215,215,215},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
                                     Text(
          extent={{-172,358},{32,304}},
          textColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Enable and disable cells:
inlet isolation valve with end switch status feedback"),
                                     Text(
          extent={{56,360},{276,302}},
          textColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Enable and disable cells:
inlet isolation valve without end switch status feedback"),
                                     Text(
          extent={{-302,-308},{-46,-380}},
          textColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Enable and disable cells:
inlet and outlet isolation valve with end switch status feedback")}));
end StageProcesses;
