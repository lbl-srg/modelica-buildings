within Buildings.Templates.Plants.Controls.StagingRotation;
block EquipmentAvailability
  parameter Boolean have_heaWat
    "Set to true for plants that provide HW"
    annotation(Evaluate=true);
  parameter Boolean have_chiWat
    "Set to true for plants that provide CHW"
    annotation(Evaluate=true);

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1_actual
    "Equipment status" annotation (Placement(transformation(extent={{-140,40},{-100,
            80}}),      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Hea if have_heaWat
    "Equipment available for heating" annotation (Placement(transformation(
          extent={{100,40},{140,80}}),  iconTransformation(extent={{100,40},{
            140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Hea_actual
    if have_heaWat and have_chiWat
    "Equipment operating mode" annotation (Placement(transformation(extent={{-140,
            -80},{-100,-40}}), iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Coo if have_chiWat
    "Equipment available for cooling" annotation (Placement(transformation(
          extent={{100,-80},{140,-40}}), iconTransformation(extent={{100,-80},{
            140,-40}})));
  Buildings.Controls.OBC.CDL.Logical.And onAndHea
    "Return true if equipment on and in heating mode"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Buildings.Controls.OBC.CDL.Logical.And onAndCoo
    "Return true if equipment on and in cooling mode"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Buildings.Controls.OBC.CDL.Logical.Not coo
    "Return true if equipment in cooling mode"
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Not avaCoo
    "Return true if equipment available for cooling"
    annotation (Placement(transformation(extent={{30,-70},{50,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Not avaHea
    "Return true if equipment available for heating"
    annotation (Placement(transformation(extent={{30,50},{50,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Ava
    "Equipment available signal" annotation (Placement(transformation(extent={{-140,
            -20},{-100,20}}), iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Logical.And avaCooAva
    "Return true if equipment available for cooling and hardware available"
    annotation (Placement(transformation(extent={{70,-70},{90,-50}})));
  Buildings.Controls.OBC.CDL.Logical.And avaHeaAva
    "Return true if equipment available for heating and hardware available"
    annotation (Placement(transformation(extent={{70,50},{90,70}})));
  Utilities.PlaceHolder pla(final have_inp=have_heaWat and have_chiWat, final
      u_internal=have_heaWat or not have_chiWat)
    "Replace with placeholder value if input signal is not available"
    annotation (Placement(transformation(extent={{-90,-70},{-70,-50}})));
equation
  connect(coo.y, onAndCoo.u2) annotation (Line(points={{-28,-40},{-16,-40},{-16,
          52},{-12,52}},   color={255,0,255}));
  connect(u1_actual, onAndHea.u1)
    annotation (Line(points={{-120,60},{-20,60},{-20,-60},{-12,-60}},
                                                color={255,0,255}));
  connect(u1_actual, onAndCoo.u1) annotation (Line(points={{-120,60},{-12,60}},
                           color={255,0,255}));
  connect(onAndHea.y, avaCoo.u)
    annotation (Line(points={{12,-60},{28,-60}}, color={255,0,255}));
  connect(onAndCoo.y, avaHea.u)
    annotation (Line(points={{12,60},{28,60}},   color={255,0,255}));
  connect(avaCooAva.y, y1Coo)
    annotation (Line(points={{92,-60},{120,-60}}, color={255,0,255}));
  connect(avaCoo.y, avaCooAva.u2) annotation (Line(points={{52,-60},{56,-60},{56,
          -68},{68,-68}}, color={255,0,255}));
  connect(u1Ava, avaCooAva.u1) annotation (Line(points={{-120,0},{60,0},{60,-60},
          {68,-60}}, color={255,0,255}));
  connect(avaHeaAva.y, y1Hea)
    annotation (Line(points={{92,60},{120,60}}, color={255,0,255}));
  connect(u1Ava, avaHeaAva.u2) annotation (Line(points={{-120,0},{60,0},{60,52},
          {68,52}}, color={255,0,255}));
  connect(avaHea.y, avaHeaAva.u1)
    annotation (Line(points={{52,60},{68,60}}, color={255,0,255}));
  connect(u1Hea_actual, pla.u)
    annotation (Line(points={{-120,-60},{-92,-60}}, color={255,0,255}));
  connect(pla.y, onAndHea.u2) annotation (Line(points={{-68,-60},{-40,-60},{-40,
          -68},{-12,-68}}, color={255,0,255}));
  connect(pla.y, coo.u) annotation (Line(points={{-68,-60},{-60,-60},{-60,-40},
          {-52,-40}}, color={255,0,255}));
          annotation (
 defaultComponentName="avaHeaCoo",
 Icon(
  coordinateSystem(
    preserveAspectRatio=true,
    extent={{-100,-100},{100,100}}),
  graphics={
    Line(
      points={{-90,-80.3976},{68,-80.3976}},
      color={192,192,192}),
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
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
FIXME: Check if the commanded mode should be used, 
or rather the active operating mode as reported by the equipment itself.
</html>"));
end EquipmentAvailability;
