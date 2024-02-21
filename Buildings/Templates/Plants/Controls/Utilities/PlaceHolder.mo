within Buildings.Templates.Plants.Controls.Utilities;
block PlaceHolder "Output a placeholder signal"
  parameter Boolean have_inp=true
    "Set to true if input signal is available"
    annotation(Evaluate=true);
  parameter Boolean have_inpPla=false
    "Set to true if placeholder value is provided with input signal"
    annotation(Evaluate=true);
  parameter Boolean u_internal(start=true)
    "Placeholder value if input signal is not available"
    annotation(Dialog(enable=not have_inpPla));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u
    if have_inp
    "Input"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPla
    if not have_inp and have_inpPla
    "Input"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y
    "Output"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant pla(
    final k=u_internal)
    if not have_inp and not have_inpPla
    "Placeholder signal if input signal is not available"
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
equation
  connect(u, y) annotation (Line(points={{-120,0},{-6,0},{-6,0},{120,0}}, color
        ={255,0,255}));
  connect(pla.y, y) annotation (Line(points={{12,-80},{80,-80},{80,0},{120,0}},
        color={255,0,255}));
  connect(uPla, y) annotation (Line(points={{-120,-40},{60,-40},{60,0},{120,0}},
        color={255,0,255}));
annotation (
    defaultComponentName="pla",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          lineThickness=5.0,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Ellipse(
          extent={{71,7},{85,-7}},
          lineColor=DynamicSelect({235,235,235},
            if y then
              {0,255,0}
            else
              {235,235,235}),
          fillColor=DynamicSelect({235,235,235},
            if y then
              {0,255,0}
            else
              {235,235,235}),
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-120,140},{-120,140}},
          lineColor={28,108,200}),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255})}));
end PlaceHolder;
