within Buildings.Templates.Plants.Controls.StagingRotation;
block EquipmentAvailability
  parameter Boolean have_heaWat
    "Set to true for plants that provide HW"
    annotation (Evaluate=true);
  parameter Boolean have_chiWat
    "Set to true for plants that provide CHW"
    annotation (Evaluate=true);
  parameter Real dtOff(
    final min=0,
    final unit="s",
    start=900)=900
    "Off time required before equipment is deemed available for alternate mode"
    annotation (Dialog(enable=have_heaWat and have_chiWat));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1
    "Equipment enable command"
    annotation (Placement(transformation(extent={{-200,60},{-160,100}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Hea
    if have_heaWat
    "Equipment available for heating"
    annotation (Placement(transformation(extent={{160,60},{200,100}}),
      iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Hea
    if have_heaWat and have_chiWat
    "Equipment operating mode command"
    annotation (Placement(transformation(extent={{-200,-100},{-160,-60}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Coo
    if have_chiWat
    "Equipment available for cooling"
    annotation (Placement(transformation(extent={{160,-100},{200,-60}}),
      iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Logical.And onAndHea
    "Return true if equipment on and in heating mode"
    annotation (Placement(transformation(extent={{-70,-90},{-50,-70}})));
  Buildings.Controls.OBC.CDL.Logical.And onAndCoo
    "Return true if equipment on and in cooling mode"
    annotation (Placement(transformation(extent={{-70,70},{-50,90}})));
  Buildings.Controls.OBC.CDL.Logical.Not coo
    "Return true if equipment in cooling mode"
    annotation (Placement(transformation(extent={{-110,-50},{-90,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Ava
    "Equipment available signal"
    annotation (Placement(transformation(extent={{-200,-20},{-160,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Logical.And avaCooAva
    if have_chiWat
    "Return true if equipment available for cooling and hardware available"
    annotation (Placement(transformation(extent={{130,-90},{150,-70}})));
  Buildings.Controls.OBC.CDL.Logical.And avaHeaAva
    if have_heaWat
    "Return true if equipment available for heating and hardware available"
    annotation (Placement(transformation(extent={{132,70},{152,90}})));
  Utilities.PlaceHolder phHea(final have_inp=have_heaWat and have_chiWat,
      final u_internal=have_heaWat or not have_chiWat)
    "Placeholder value if signal is not available"
    annotation (Placement(transformation(extent={{-148,-90},{-128,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Not off
    "Return true if equipment is off"
    annotation (Placement(transformation(extent={{-140,30},{-120,50}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timOff(
    t=dtOff)
    "Time elapsed since equipment is off"
    annotation (Placement(transformation(extent={{-70,30},{-50,50}})));
  Buildings.Controls.OBC.CDL.Logical.Or avaOrOnHea
    if have_heaWat
    "Available after off time or already on in heating mode"
    annotation (Placement(transformation(extent={{90,70},{110,90}})));
  Buildings.Controls.OBC.CDL.Logical.Or avaOrOnCoo
    if have_chiWat
    "Available after off time or already on in cooling mode"
    annotation (Placement(transformation(extent={{90,-90},{110,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Latch latCoo
    "Lock (on and cooling) signal to true until cleared by minimum off time"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  Buildings.Controls.OBC.CDL.Logical.Nor unaHea
    "Deem unavailable for heating until both cooling and off signals cleared by off time"
    annotation (Placement(transformation(extent={{30,30},{50,50}})));
  Buildings.Controls.OBC.CDL.Logical.Latch latHea
    "Return true if equipment is off"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Nor unaCoo
    "Deem unavailable for cooling until both heating and off signals cleared by off time"
    annotation (Placement(transformation(extent={{30,-30},{50,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Latch latOff
    "Lock off signal to true until cleared by minimum off time"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));
equation
  connect(coo.y, onAndCoo.u2)
    annotation (Line(points={{-88,-40},{-76,-40},{-76,72},{-72,72}},color={255,0,255}));
  connect(u1, onAndHea.u1)
    annotation (Line(points={{-180,80},{-80,80},{-80,-80},{-72,-80}},color={255,0,255}));
  connect(u1, onAndCoo.u1)
    annotation (Line(points={{-180,80},{-72,80}},color={255,0,255}));
  connect(u1Ava, avaCooAva.u1)
    annotation (Line(points={{-180,0},{120,0},{120,-80},{128,-80}},color={255,0,255}));
  connect(u1Ava, avaHeaAva.u2)
    annotation (Line(points={{-180,0},{120,0},{120,72},{130,72}},color={255,0,255}));
  connect(u1Hea, phHea.u)
    annotation (Line(points={{-180,-80},{-150,-80}}, color={255,0,255}));
  connect(phHea.y, onAndHea.u2) annotation (Line(points={{-126,-80},{-100,-80},
          {-100,-88},{-72,-88}}, color={255,0,255}));
  connect(phHea.y, coo.u) annotation (Line(points={{-126,-80},{-120,-80},{-120,
          -40},{-112,-40}}, color={255,0,255}));
  connect(u1, off.u)
    annotation (Line(points={{-180,80},{-150,80},{-150,40},{-142,40}},color={255,0,255}));
  connect(off.y, timOff.u)
    annotation (Line(points={{-118,40},{-72,40}},color={255,0,255}));
  connect(avaHeaAva.y, y1Hea)
    annotation (Line(points={{154,80},{180,80}},color={255,0,255}));
  connect(avaCooAva.y, y1Coo)
    annotation (Line(points={{152,-80},{180,-80}},color={255,0,255}));
  connect(onAndHea.y, avaOrOnHea.u2)
    annotation (Line(points={{-48,-80},{70,-80},{70,72},{88,72}},color={255,0,255}));
  connect(avaOrOnCoo.y, avaCooAva.u2)
    annotation (Line(points={{112,-80},{116,-80},{116,-88},{128,-88}},color={255,0,255}));
  connect(avaOrOnHea.y, avaHeaAva.u1)
    annotation (Line(points={{112,80},{130,80}},color={255,0,255}));
  connect(timOff.passed, latCoo.clr)
    annotation (Line(points={{-48,32},{-30,32},{-30,54},{-22,54}},color={255,0,255}));
  connect(timOff.passed, latHea.clr)
    annotation (Line(points={{-48,32},{-30,32},{-30,-26},{-22,-26}},color={255,0,255}));
  connect(unaHea.y, avaOrOnHea.u1)
    annotation (Line(points={{52,40},{80,40},{80,80},{88,80}},color={255,0,255}));
  connect(unaCoo.y, avaOrOnCoo.u1)
    annotation (Line(points={{52,-20},{80,-20},{80,-80},{88,-80}},color={255,0,255}));
  connect(onAndHea.y, latHea.u)
    annotation (Line(points={{-48,-80},{-40,-80},{-40,-20},{-22,-20}},color={255,0,255}));
  connect(off.y, latOff.u)
    annotation (Line(points={{-118,40},{-100,40},{-100,20},{-22,20}},color={255,0,255}));
  connect(timOff.passed, latOff.clr)
    annotation (Line(points={{-48,32},{-30,32},{-30,14},{-22,14}},color={255,0,255}));
  connect(latOff.y, unaCoo.u1)
    annotation (Line(points={{2,20},{20,20},{20,-20},{28,-20}},color={255,0,255}));
  connect(latHea.y, unaCoo.u2)
    annotation (Line(points={{2,-20},{8,-20},{8,-28},{28,-28}},color={255,0,255}));
  connect(latCoo.y, unaHea.u1)
    annotation (Line(points={{2,60},{20,60},{20,40},{28,40}},color={255,0,255}));
  connect(latOff.y, unaHea.u2)
    annotation (Line(points={{2,20},{20,20},{20,32},{28,32}},color={255,0,255}));
  connect(onAndCoo.y, latCoo.u)
    annotation (Line(points={{-48,80},{-30,80},{-30,60},{-22,60}},color={255,0,255}));
  connect(onAndCoo.y, avaOrOnCoo.u2)
    annotation (Line(points={{-48,80},{60,80},{60,-88},{88,-88}},color={255,0,255}));
  annotation (
    defaultComponentName="avaHeaCoo",
    Icon(
      coordinateSystem(
        preserveAspectRatio=false),
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
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-160,-120},{160,120}})),
    Documentation(
      info="<html>
<p>
If a heat pump is commanded enabled in either heating or cooling mode, 
it is removed from the staging order of the opposite mode until it has 
been off for <code>dtOff</code>.
</p>
</html>"));
end EquipmentAvailability;
