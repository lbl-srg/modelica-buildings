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
    annotation(Placement(transformation(extent={{-240,-20},{-200,20}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Hea
    if have_heaWat
    "Equipment available for heating"
    annotation(Placement(transformation(extent={{200,-20},{240,20}}),
      iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1EnaCoo
    if have_chiWat "Cooling enable command"
    annotation(Placement(transformation(extent={{-240,-140},{-200,-100}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Coo
    if have_chiWat
    "Equipment available for cooling"
    annotation(Placement(transformation(extent={{200,-140},{240,-100}}),
      iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Ava
    "Equipment available signal"
    annotation(Placement(transformation(extent={{-240,-80},{-200,-40}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Utilities.PlaceholderLogical phCoo(
    final have_inp=have_chiWat,
    final u_internal=false)
    "Placeholder value if signal is not available"
    annotation(Placement(transformation(extent={{-190,-130},{-170,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Not offOrNotHea
    "Return true if equipment is off or not in heating mode"
    annotation(Placement(transformation(extent={{-50,10},{-30,30}})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation(Placement(transformation(extent={{-160,160},{-140,180}})));
  Modelica.StateGraph.StepWithSignal onHea(nOut=2, nIn=1)
    "Enabled in heating mode"
    annotation(Placement(transformation(extent={{10,150},{30,170}})));
  Modelica.StateGraph.InitialStepWithSignal avaMod(nOut=3, nIn=2)
    "Initial state – Equipment available for all modes"
    annotation(Placement(transformation(extent={{-70,150},{-50,170}})));
  Modelica.StateGraph.TransitionWithSignal trnToOff
    "Transition to off state"
    annotation(Placement(transformation(extent={{50,150},{70,170}})));
  Modelica.StateGraph.StepWithSignal onCoo(nOut=2, nIn=1)
    "Enabled in cooling mode"
    annotation(Placement(transformation(extent={{70,110},{90,130}})));
  Modelica.StateGraph.TransitionWithSignal trnToCoo
    "Transition to cooling mode"
    annotation(Placement(transformation(extent={{-10,110},{10,130}})));
  Modelica.StateGraph.TransitionWithSignal trnToHea
    "Transition to heating mode"
    annotation(Placement(transformation(extent={{-30,150},{-10,170}})));
  Modelica.StateGraph.TransitionWithSignal trnToOff1
    "Transition to off state"
    annotation(Placement(transformation(extent={{110,110},{130,130}})));
  Buildings.Controls.OBC.CDL.Logical.Or avaAllHea
    "Return true if equipment available for all modes or in heating mode"
    annotation(Placement(transformation(extent={{128,-10},{148,10}})));
  Buildings.Controls.OBC.CDL.Logical.Or avaAllCoo
    "Return true if equipment available for all modes or in cooling mode"
    annotation(Placement(transformation(extent={{130,-130},{150,-110}})));
  Modelica.StateGraph.Step offSta(nOut=1, nIn=2)
    "Off state"
    annotation(Placement(transformation(extent={{140,130},{160,150}})));
  Modelica.StateGraph.Transition trnToAvaTim(
    enableTimer=true,
    final waitTime=dtOff)
    "Transition back to available state after off time elapsed"
    annotation(Placement(transformation(extent={{160,170},{140,190}})));
  Modelica.StateGraph.Step unaSta(nOut=1, nIn=3)
    "Unavailable state"
    annotation(Placement(transformation(extent={{140,90},{160,110}})));
  Modelica.StateGraph.TransitionWithSignal trnToUna
    "Transition to unavailable state"
    annotation(Placement(transformation(extent={{-36,70},{-16,90}})));
  Buildings.Controls.OBC.CDL.Logical.Not una
    "Return true if equipment is unavailable"
    annotation(Placement(transformation(extent={{-110,-50},{-90,-30}})));
  Modelica.StateGraph.TransitionWithSignal trnToAva
    "Transition back to available state"
    annotation(Placement(transformation(extent={{170,90},{190,110}})));
  Modelica.StateGraph.TransitionWithSignal trnToUna2
    "Transition to unavailable state"
    annotation(Placement(transformation(extent={{30,90},{50,110}})));
  Modelica.StateGraph.TransitionWithSignal trnToUna3
    "Transition to unavailable state"
    annotation(Placement(transformation(extent={{90,70},{110,90}})));
  Utilities.PlaceholderLogical phHea(
    final have_inp=have_heaWat,
    final u_internal=false)
    "Placeholder value if signal is not available"
    annotation(Placement(transformation(extent={{-190,-10},{-170,10}})));
  Buildings.Controls.OBC.CDL.Logical.Not offOrNotCoo
    "Return true if equipment is off or not in cooling mode"
    annotation(Placement(transformation(extent={{-50,-110},{-30,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Or offOrNotHeaOrHeaAndCoo
    "Return true if equipment is off or not in heating mode or in simultaneous heating and cooling mode"
    annotation(Placement(transformation(extent={{-10,10},{10,30}})));
  Buildings.Controls.OBC.CDL.Logical.Or offOrNotCooOrHeaAndCoo
    "Return true if equipment is off or not in cooling mode or in simultaneous heating and cooling mode"
    annotation(Placement(transformation(extent={{0,-110},{20,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Shc
    if is_php
    "Equipment available for simultaneous heating and cooling operation"
    annotation(Placement(transformation(extent={{200,-180},{240,-140}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd avaAllCooAndNotHea(nin=3)
    "Avoid race condition when heating and cooling enabled at same time event: priority to heating"
    annotation(Placement(transformation(extent={{170,-130},{190,-110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1EnaShc
    if is_php "Simultaneous heating and cooling enable command"
    annotation(Placement(transformation(extent={{-240,-200},{-200,-160}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Not notEdgHea
    "True if not simultaneously enabled in heating mode"
    annotation(Placement(transformation(extent={{40,-150},{60,-130}})));
  Utilities.PlaceholderLogical phShc(
    final have_inp=is_php,
    final u_internal=false)
    "Placeholder value if signal is not available"
    annotation(Placement(transformation(extent={{-190,-190},{-170,-170}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edgHea
    "True at the time heating is enabled"
    annotation(Placement(transformation(extent={{0,-150},{20,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Not notEdgShc
    "True if not simultaneously enabled in SHC mode"
    annotation(Placement(transformation(extent={{40,-190},{60,-170}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edgShc
    "True at the time SHC is enabled"
    annotation(Placement(transformation(extent={{0,-190},{20,-170}})));
equation
  connect(avaMod.outPort[1], trnToCoo.inPort)
    annotation(Line(points={{-49.5,159.833},{-40,159.833},{-40,120},{-4,120}},
      color={0,0,0}));
  connect(onHea.outPort[1], trnToOff.inPort)
    annotation(Line(points={{30.5,159.875},{44,159.875},{44,160},{56,160}},
      color={0,0,0}));
  connect(onCoo.outPort[1], trnToOff1.inPort)
    annotation(Line(points={{90.5,119.875},{104,119.875},{104,120},{116,120}},
      color={0,0,0}));
  connect(trnToCoo.outPort, onCoo.inPort[1])
    annotation(Line(points={{1.5,120},{69,120}},
      color={0,0,0}));
  connect(avaMod.outPort[2], trnToHea.inPort)
    annotation(Line(points={{-49.5,160},{-36,160},{-36,160},{-24,160}},
      color={0,0,0}));
  connect(avaMod.active, avaAllHea.u1)
    annotation(Line(points={{-60,149},{-60,0},{126,0}},
      color={255,0,255}));
  connect(onHea.active, avaAllHea.u2)
    annotation(Line(points={{20,149},{20,-8},{126,-8}},
      color={255,0,255}));
  connect(trnToHea.outPort, onHea.inPort[1])
    annotation(Line(points={{-18.5,160},{-4,160},{-4,160},{9,160}},
      color={0,0,0}));
  connect(offSta.outPort[1], trnToAvaTim.inPort)
    annotation(Line(points={{160.5,140},{170,140},{170,180},{154,180}},
      color={0,0,0}));
  connect(trnToOff.outPort, offSta.inPort[1])
    annotation(Line(points={{61.5,160},{130,160},{130,139.75},{139,139.75}},
      color={0,0,0}));
  connect(trnToOff1.outPort, offSta.inPort[2])
    annotation(Line(
      points={{121.5,120},{130,120},{130,140},{134,140},{134,140.25},{139,140.25}},
      color={0,0,0}));
  connect(trnToAvaTim.outPort, avaMod.inPort[1])
    annotation(Line(points={{148.5,180},{-80,180},{-80,159.75},{-71,159.75}},
      color={0,0,0}));
  connect(u1Ava, una.u)
    annotation(Line(points={{-220,-60},{-120,-60},{-120,-40},{-112,-40}},
      color={255,0,255}));
  connect(avaMod.outPort[3], trnToUna.inPort)
    annotation(Line(
      points={{-49.5,160.167},{-49.5,160},{-40,160},{-40,80},{-30,80}},
      color={0,0,0}));
  connect(una.y, trnToUna.condition)
    annotation(Line(points={{-88,-40},{-26,-40},{-26,68}},
      color={255,0,255}));
  connect(trnToUna.outPort, unaSta.inPort[1])
    annotation(Line(points={{-24.5,80},{50,80},{50,99.6667},{139,99.6667}},
      color={0,0,0}));
  connect(unaSta.outPort[1], trnToAva.inPort)
    annotation(Line(points={{160.5,100},{176,100}},
      color={0,0,0}));
  connect(u1Ava, trnToAva.condition)
    annotation(Line(points={{-220,-60},{180,-60},{180,88}},
      color={255,0,255}));
  connect(trnToAva.outPort, avaMod.inPort[2])
    annotation(Line(
      points={{181.5,100},{190,100},{190,190},{-90,190},{-90,160.25},{-71,160.25}},
      color={0,0,0}));
  connect(avaMod.active, avaAllCoo.u1)
    annotation(Line(points={{-60,149},{-60,-120},{128,-120}},
      color={255,0,255}));
  connect(onCoo.active, avaAllCoo.u2)
    annotation(Line(points={{80,109},{80,-128},{128,-128}},
      color={255,0,255}));
  connect(onHea.outPort[2], trnToUna2.inPort)
    annotation(Line(points={{30.5,160.125},{32,160.125},{32,100},{36,100}},
      color={0,0,0}));
  connect(trnToUna2.outPort, unaSta.inPort[2])
    annotation(Line(points={{41.5,100},{90,100},{90,100},{139,100}},
      color={0,0,0}));
  connect(una.y, trnToUna2.condition)
    annotation(Line(points={{-88,-40},{40,-40},{40,88}},
      color={255,0,255}));
  connect(onCoo.outPort[2], trnToUna3.inPort)
    annotation(Line(points={{90.5,120.125},{92,120.125},{92,80},{96,80}},
      color={0,0,0}));
  connect(trnToUna3.outPort, unaSta.inPort[3])
    annotation(Line(points={{101.5,80},{130,80},{130,100.333},{139,100.333}},
      color={0,0,0}));
  connect(una.y, trnToUna3.condition)
    annotation(Line(points={{-88,-40},{100,-40},{100,68}},
      color={255,0,255}));
  connect(offOrNotHea.y, offOrNotHeaOrHeaAndCoo.u1)
    annotation(Line(points={{-28,20},{-12,20}},
      color={255,0,255}));
  connect(offOrNotCoo.y, offOrNotCooOrHeaAndCoo.u1)
    annotation(Line(points={{-28,-100},{-2,-100}},
      color={255,0,255}));
  connect(offOrNotHeaOrHeaAndCoo.y, trnToOff.condition)
    annotation(Line(points={{12,20},{60,20},{60,148}},
      color={255,0,255}));
  connect(offOrNotCooOrHeaAndCoo.y, trnToOff1.condition)
    annotation(Line(points={{22,-100},{120,-100},{120,108}},
      color={255,0,255}));
  connect(phHea.u, u1EnaHea)
    annotation(Line(points={{-192,0},{-220,0}},
      color={255,0,255}));
  connect(u1EnaCoo, phCoo.u)
    annotation(Line(points={{-220,-120},{-192,-120}},
      color={255,0,255}));
  connect(phHea.y, offOrNotHea.u)
    annotation(Line(points={{-168,0},{-120,0},{-120,20},{-52,20}},
      color={255,0,255}));
  connect(phHea.y, trnToHea.condition)
    annotation(Line(points={{-168,0},{-120,0},{-120,140},{-20,140},{-20,148}},
      color={255,0,255}));
  connect(phCoo.y, trnToCoo.condition)
    annotation(Line(points={{-168,-120},{-130,-120},{-130,100},{0,100},{0,108}},
      color={255,0,255}));
  connect(phCoo.y, offOrNotCoo.u)
    annotation(Line(points={{-168,-120},{-130,-120},{-130,-100},{-52,-100}},
      color={255,0,255}));
  connect(u1Ava, y1Shc)
    annotation(Line(points={{-220,-60},{-120,-60},{-120,-160},{220,-160}},
      color={255,0,255}));
  connect(avaAllCooAndNotHea.y, y1Coo)
    annotation(Line(points={{192,-120},{220,-120}},
      color={255,0,255}));
  connect(u1EnaShc, phShc.u)
    annotation(Line(points={{-220,-180},{-192,-180}},
      color={255,0,255}));
  connect(phShc.y, offOrNotCooOrHeaAndCoo.u2)
    annotation(Line(points={{-168,-180},{-20,-180},{-20,-108},{-2,-108}},
      color={255,0,255}));
  connect(phShc.y, offOrNotHeaOrHeaAndCoo.u2)
    annotation(Line(points={{-168,-180},{-20,-180},{-20,12},{-12,12}},
      color={255,0,255}));
  connect(avaAllHea.y, y1Hea)
    annotation(Line(points={{150,0},{220,0}},
      color={255,0,255}));
  connect(avaAllCoo.y, avaAllCooAndNotHea.u[1])
    annotation(Line(
      points={{152,-120},{162,-120},{162,-122.333},{168,-122.333}},
      color={255,0,255}));
  connect(notEdgHea.y, avaAllCooAndNotHea.u[2])
    annotation(Line(points={{62,-140},{160,-140},{160,-120},{168,-120}},
      color={255,0,255}));
  connect(phHea.y, edgHea.u)
    annotation(Line(points={{-168,0},{-160,0},{-160,-140},{-2,-140}},
      color={255,0,255}));
  connect(edgHea.y, notEdgHea.u)
    annotation(Line(points={{22,-140},{38,-140}},
      color={255,0,255}));
  connect(notEdgShc.y, avaAllCooAndNotHea.u[3])
    annotation(Line(points={{62,-180},{160,-180},{160,-117.667},{168,-117.667}},
      color={255,0,255}));
  connect(phShc.y, edgShc.u)
    annotation(Line(points={{-168,-180},{-2,-180}},
      color={255,0,255}));
  connect(edgShc.y, notEdgShc.u)
    annotation(Line(points={{22,-180},{38,-180}},
      color={255,0,255}));
annotation(__cdl(extensionBlock=true),
  defaultComponentName="avaHeaCoo",
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
    extent={{-200,-200},{200,200}})),
  Documentation(
    info="<html>
<p>
  If a heat pump is commanded enabled in either heating or cooling mode, it is
  removed from the staging order of the opposite mode until it has been off
  for <code>dtOff</code>.
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
</html>",
    revisions="<html>
<ul>
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
