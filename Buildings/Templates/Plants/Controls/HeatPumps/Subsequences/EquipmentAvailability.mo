within Buildings.Templates.Plants.Controls.HeatPumps.Subsequences;
block EquipmentAvailability
  "Equipment availability for heating and cooling applications"
  parameter Boolean is_php = false
    "Set to true for polyvalent heat pumps"
    annotation(Evaluate=true);
  parameter Boolean have_heaWat
    "Set to true for plants that provide HW"
    annotation(Evaluate=true);
  parameter Boolean have_chiWat
    "Set to true for plants that provide CHW"
    annotation(Evaluate=true);
  parameter Real dtOff(min=0, unit="s") = 900
    "Off time required before equipment is deemed available again";
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1EnaHea
    if have_heaWat "Heating enable command"
    annotation(Placement(transformation(extent={{-260,20},{-220,60}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Hea
    if have_heaWat
    "Equipment available for heating"
    annotation(Placement(transformation(extent={{220,20},{260,60}}),
      iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1EnaCoo
    if have_chiWat "Cooling enable command"
    annotation(Placement(transformation(extent={{-260,-80},{-220,-40}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Coo if have_chiWat
    "Equipment available for cooling"
    annotation(Placement(transformation(extent={{220,-100},{260,-60}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Ava
    "Equipment available signal"
    annotation(Placement(transformation(extent={{-260,-160},{-220,-120}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1EnaShc
    if is_php "Simultaneous heating and cooling enable command"
    annotation(Placement(transformation(extent={{-260,-120},{-220,-80}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Shc if is_php
    "Equipment available for simultaneous heating and cooling"
    annotation(Placement(transformation(extent={{220,-160},{260,-120}}),
      iconTransformation(extent={{100,-100},{140,-60}})));
  Utilities.PlaceholderLogical phHea(
    final have_inp=have_heaWat,
    final u_internal=false)
    "Placeholder value if signal is not available"
    annotation(Placement(transformation(extent={{-190,30},{-170,50}})));
  Utilities.PlaceholderLogical phCoo(
    final have_inp=have_chiWat,
    final u_internal=false)
    "Placeholder value if signal is not available"
    annotation(Placement(transformation(extent={{-190,-70},{-170,-50}})));
  Utilities.PlaceholderLogical phShc(
    final have_inp=is_php,
    final u_internal=false)
    "Placeholder value if signal is not available"
    annotation(Placement(transformation(extent={{-190,-110},{-170,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Not notShc
    "Return true if equipment not required to run in simultaneous heating and cooling mode"
    annotation(Placement(transformation(extent={{-150,-110},{-130,-90}})));
  Buildings.Controls.OBC.CDL.Logical.And reqHea
    "Return true if equipment required to run in heating mode only"
    annotation(Placement(transformation(extent={{-110,30},{-90,50}})));
  Buildings.Controls.OBC.CDL.Logical.And reqCoo
    "Return true if equipment required to run in cooling mode only"
    annotation(Placement(transformation(extent={{-110,-70},{-90,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Pre preLatHea
    "Previous value of heating mode latch"
    annotation(Placement(transformation(extent={{-190,150},{-170,170}})));
  Buildings.Controls.OBC.CDL.Logical.Pre preLatCoo
    "Previous value of cooling mode latch"
    annotation(Placement(transformation(extent={{-190,110},{-170,130}})));
  Buildings.Controls.OBC.CDL.Logical.Or latAll
    "Return true if equipment has operated in a single mode and off time has not elapsed – Previous values"
    annotation(Placement(transformation(extent={{-150,130},{-130,150}})));
  Buildings.Controls.OBC.CDL.Logical.Not entHea
    "Return true if equipment allowed to enter heating mode – Off time elapsed for all modes"
    annotation(Placement(transformation(extent={{-110,130},{-90,150}})));
  Buildings.Controls.OBC.CDL.Logical.Nor entCoo
    "Return true if equipment allowed to enter cooling mode – No heating command and off time elapsed for all modes"
    annotation(Placement(transformation(extent={{-70,10},{-50,30}})));
  Buildings.Controls.OBC.CDL.Logical.Pre preRunHea
    "Previous value of heating mode operation signal"
    annotation(Placement(transformation(extent={{-110,70},{-90,90}})));
  Buildings.Controls.OBC.CDL.Logical.Or avaHea
    "Return true if equipment operating in heating mode or allowed to enter it"
    annotation(Placement(transformation(extent={{-70,70},{-50,90}})));
  Buildings.Controls.OBC.CDL.Logical.And runHea
    "Return true if equipment operating in heating mode"
    annotation(Placement(transformation(extent={{20,30},{40,50}})));
  Buildings.Controls.OBC.CDL.Logical.Pre preRunCoo
    "Previous value of cooling mode operation signal"
    annotation(Placement(transformation(extent={{-110,-30},{-90,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Or avaCoo
    "Return true if equipment operating in cooling mode or allowed to enter it"
    annotation(Placement(transformation(extent={{-28,-30},{-8,-10}})));
  Buildings.Controls.OBC.CDL.Logical.And runCoo
    "Return true if equipment operating in cooling mode"
    annotation(Placement(transformation(extent={{20,-70},{40,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Nor off
    "Return true if equipment not operating in any single mode"
    annotation(Placement(transformation(extent={{60,-30},{80,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim(
    final t=dtOff)
    "Return true if equipment has been off for the required time"
    annotation(Placement(transformation(extent={{90,-30},{110,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Latch latHea
    "Return true from the time equipment enters heating mode until off time has elapsed"
    annotation(Placement(transformation(extent={{130,30},{150,50}})));
  Buildings.Controls.OBC.CDL.Logical.Latch latCoo
    "Return true from the time equipment enters cooling mode until off time has elapsed"
    annotation(Placement(transformation(extent={{130,-70},{150,-50}})));
  Buildings.Controls.OBC.CDL.Logical.And avaAllHea
    "Return true if equipment available for heating"
    annotation(Placement(transformation(extent={{190,30},{210,50}})));
  Buildings.Controls.OBC.CDL.Logical.And avaAllCoo
    "Return true if equipment available for cooling"
    annotation(Placement(transformation(extent={{190,-90},{210,-70}})));
equation
  connect(phHea.u, u1EnaHea)
    annotation(Line(points={{-192,40},{-240,40}},
      color={255,0,255}));
  connect(u1EnaCoo, phCoo.u)
    annotation(Line(points={{-240,-60},{-192,-60}},
      color={255,0,255}));
  connect(u1EnaShc, phShc.u)
    annotation(Line(points={{-240,-100},{-192,-100}},
      color={255,0,255}));
  connect(phShc.y, notShc.u)
    annotation(Line(points={{-168,-100},{-152,-100}},
      color={255,0,255}));
  connect(phHea.y, reqHea.u1)
    annotation(Line(points={{-168,40},{-112,40}},
      color={255,0,255}));
  connect(notShc.y, reqHea.u2)
    annotation(Line(points={{-128,-100},{-120,-100},{-120,32},{-112,32}},
      color={255,0,255}));
  connect(phCoo.y, reqCoo.u1)
    annotation(Line(points={{-168,-60},{-112,-60}},
      color={255,0,255}));
  connect(notShc.y, reqCoo.u2)
    annotation(Line(points={{-128,-100},{-120,-100},{-120,-68},{-112,-68}},
      color={255,0,255}));
  connect(preLatHea.y, latAll.u1)
    annotation(Line(points={{-168,160},{-160,160},{-160,140},{-152,140}},
      color={255,0,255}));
  connect(preLatCoo.y, latAll.u2)
    annotation(Line(points={{-168,120},{-160,120},{-160,132},{-152,132}},
      color={255,0,255}));
  connect(latAll.y, entHea.u)
    annotation(Line(points={{-128,140},{-112,140}},
      color={255,0,255}));
  connect(phHea.y, entCoo.u1)
    annotation(Line(points={{-168,40},{-160,40},{-160,20},{-72,20}},
      color={255,0,255}));
  connect(latAll.y, entCoo.u2)
    annotation(Line(points={{-128,140},{-124,140},{-124,12},{-72,12}},
      color={255,0,255}));
  connect(runHea.y, preRunHea.u)
    annotation(Line(points={{42,40},{50,40},{50,60},{-120,60},{-120,80},{-112,
          80}},
      color={255,0,255}));
  connect(runCoo.y, preRunCoo.u)
    annotation(Line(
      points={{42,-60},{50,-60},{50,-40},{-116,-40},{-116,-20},{-112,-20}},
      color={255,0,255}));
  connect(runHea.y, off.u1)
    annotation(Line(points={{42,40},{50,40},{50,-20},{58,-20}},
      color={255,0,255}));
  connect(runCoo.y, off.u2)
    annotation(Line(points={{42,-60},{50,-60},{50,-28},{58,-28}},
      color={255,0,255}));
  connect(off.y, tim.u)
    annotation(Line(points={{82,-20},{88,-20}},
      color={255,0,255}));
  connect(runHea.y, latHea.u)
    annotation(Line(points={{42,40},{128,40}},
      color={255,0,255}));
  connect(tim.passed, latHea.clr)
    annotation(Line(points={{112,-28},{120,-28},{120,34},{128,34}},
      color={255,0,255}));
  connect(runCoo.y, latCoo.u)
    annotation(Line(points={{42,-60},{128,-60}},
      color={255,0,255}));
  connect(tim.passed, latCoo.clr)
    annotation(Line(points={{112,-28},{120,-28},{120,-66},{128,-66}},
      color={255,0,255}));
  connect(latHea.y, preLatHea.u)
    annotation(Line(
      points={{152,40},{160,40},{160,100},{-200,100},{-200,160},{-192,160}},
      color={255,0,255}));
  connect(latCoo.y, preLatCoo.u)
    annotation(Line(
      points={{152,-60},{164,-60},{164,104},{-196,104},{-196,120},{-192,120}},
      color={255,0,255}));
  connect(avaHea.y, avaAllHea.u1)
    annotation(Line(points={{-48,80},{180,80},{180,40},{188,40}},
      color={255,0,255}));
  connect(u1Ava, avaAllHea.u2)
    annotation(Line(
      points={{-240,-140},{180,-140},{180,32},{188,32}},
      color={255,0,255}));
  connect(u1Ava, avaAllCoo.u2)
    annotation(Line(
      points={{-240,-140},{180,-140},{180,-88},{188,-88}},
      color={255,0,255}));
  connect(avaAllHea.y, y1Hea)
    annotation(Line(points={{212,40},{240,40}},
      color={255,0,255}));
  connect(avaAllCoo.y, y1Coo)
    annotation(Line(points={{212,-80},{240,-80}},
      color={255,0,255}));
  connect(u1Ava, y1Shc)
    annotation(Line(
      points={{-240,-140},{240,-140}},
      color={255,0,255}));
  connect(avaHea.y, runHea.u1) annotation (Line(points={{-48,80},{0,80},{0,40},
          {18,40}}, color={255,0,255}));
  connect(reqHea.y, runHea.u2) annotation (Line(points={{-88,40},{-10,40},{-10,
          32},{18,32}}, color={255,0,255}));
  connect(entHea.y, avaHea.u1) annotation (Line(points={{-88,140},{-80,140},{
          -80,80},{-72,80}}, color={255,0,255}));
  connect(preRunHea.y, avaHea.u2) annotation (Line(points={{-88,80},{-84,80},{
          -84,72},{-72,72}}, color={255,0,255}));
  connect(avaCoo.y, runCoo.u1) annotation (Line(points={{-6,-20},{0,-20},{0,-60},
          {18,-60}}, color={255,0,255}));
  connect(avaCoo.y, avaAllCoo.u1) annotation (Line(points={{-6,-20},{0,-20},{0,
          -80},{188,-80}}, color={255,0,255}));
  connect(reqCoo.y, runCoo.u2) annotation (Line(points={{-88,-60},{-10,-60},{
          -10,-68},{18,-68}}, color={255,0,255}));
  connect(preRunCoo.y, avaCoo.u2) annotation (Line(points={{-88,-20},{-46,-20},
          {-46,-28},{-30,-28}}, color={255,0,255}));
  connect(entCoo.y, avaCoo.u1) annotation (Line(points={{-48,20},{-40,20},{-40,
          -20},{-30,-20}}, color={255,0,255}));
annotation(defaultComponentName="avaHeaCoo",
  Icon(coordinateSystem(preserveAspectRatio=true,
    extent={{-100,-100},{100,100}}),
    graphics={Rectangle(extent={{-100,100},{100,-100}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid),
    Text(extent={{-150,150},{150,110}},
      textString="%name",
      textColor={0,0,255})}),
  Diagram(coordinateSystem(preserveAspectRatio=false,
    extent={{-220,-180},{220,180}},
        grid={2,2})),
  Documentation(
    info="<html>
<p>
  If a reversible heat pump is commanded enabled in either heating or cooling mode, it is
  removed from the staging order of the opposite mode until it has been off
  for <code>dtOff</code>.
</p>
<p>
  If a polyvalent heat pump is commanded enabled in single mode, it is
  removed from the staging order of the opposite single mode until it has been off
  or operating in simultaneous heating and cooling mode for <code>dtOff</code>.
</p>
<h4>Implementation details</h4>
<p>
  To avoid concurrent stage transitions between heating and cooling modes,
  \"commanded enabled in a given mode\" should be interpreted as \"required to
  run in a given mode\", and evaluated before the heat pump is actually
  enabled. Event sequencing during stage transitions introduces a delay
  between these two events. During this delay, the heat pump should not be
  considered available for the opposite mode.
</p>
<p>
  Since the enable commands are computed from the availability signals 
  within the plant controller, the block is structured to avoid creating 
  an algebraic loop at simulation time and at initialization: 
  the heating availability has no direct dependency on any enable command, 
  and the cooling availability directly depends on the heating enable command only.
  If both single mode commands are received at the same time event, the
  heating command prevails and the equipment is reported unavailable for cooling.
</p>
<p>
  A mode command is only accepted &ndash; and the equipment considered as
  operating in that mode &ndash; if it is received while the equipment is 
  available or already operating in that mode.
  Commands received before the off time has elapsed are disregarded, 
  so the availability outputs remain false even if an enable command is issued.
</p>
<p>
  At initial time the equipment is available for all modes.
</p>
</html>",
    revisions="<html>
<ul>
  <li>
    July 2, 2026, by Antoine Gautier:<br />
    Refactored using CDL blocks in place of
    <code>Modelica.StateGraph</code> components.
  </li>
  <li>
    June 10, 2026, by Antoine Gautier:<br />
    Removed unnecessary <code>Or</code> and <code>And</code> blocks.<br />
    This is for
    <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4624\">#4624</a>.
  </li>
  <li>
    January 23, 2025, by Antoine Gautier:<br />
    Refactored to use \"required to run\" conditions.<br />
    This is for
    <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4432\">#4432</a>.
  </li>
  <li>
    March 29, 2024, by Antoine Gautier:<br />
    First implementation.
  </li>
</ul>
</html>"));
end EquipmentAvailability;
