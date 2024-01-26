within Buildings.Templates.Plants.Components.Controls.Pumps.Primary;
block EnableLeadDedicated
  "Plants with dedicated primary pumps"
  parameter Boolean have_req=false
    "Set to true if plant equipment has flow request network point"
    annotation (Evaluate=true);
  parameter Real dtOff(
    min=0,
    unit="s")=if not have_req then 3 * 60 else 10 * 60
    "Runtime with lead equipment proven off before disabling";
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Req
    if have_req
    "HW or CHW request from lead equipment"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
      iconTransformation(extent={{-300,-56},{-260,-16}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1
    "Enable signal from system enable logic"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
      iconTransformation(extent={{-300,-56},{-260,-16}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1EquLea
    "Lead equipment enable signal"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}}),
      iconTransformation(extent={{-300,-56},{-260,-16}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1EquLea_actual
    "Lead equipment status"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}}),
      iconTransformation(extent={{-300,-56},{-260,-16}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1
    "Lead pump enable signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{-300,-56},{-260,-16}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Clear enable signal if disable conditions are met"
    annotation (Placement(transformation(extent={{72,-10},{92,10}})));
  Buildings.Controls.OBC.CDL.Logical.Not dis
    "Return true if lead equipment is disabled"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Logical.Not off
    "Return true if lead equipment is proven off"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant tru(
    final k=true)
    if not have_req
    "Placeholder constant"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Or offOrNotReq
    if not have_req
    "Return true if lead equipment proven off OR not requesting flow"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timOff(
    final t=dtOff)
    "Return true if lead equipment is proven off for specified duration"
    annotation (Placement(transformation(extent={{-50,-30},{-30,-10}})));
  Buildings.Controls.OBC.CDL.Logical.And disAndOffOrNotReq
    if not have_req
    "Return true if lead equipment disbaled AND (proven off OR not requesting flow)"
    annotation (Placement(transformation(extent={{30,-30},{50,-10}})));
equation
  connect(lat.y, y1)
    annotation (Line(points={{94,0},{120,0}},color={255,0,255}));
  connect(u1, lat.u)
    annotation (Line(points={{-120,60},{60,60},{60,0},{70,0}},color={255,0,255}));
  connect(u1EquLea, dis.u)
    annotation (Line(points={{-120,20},{-82,20}},color={255,0,255}));
  connect(u1EquLea_actual, off.u)
    annotation (Line(points={{-120,-20},{-82,-20}},color={255,0,255}));
  connect(tru.y, offOrNotReq.u2)
    annotation (Line(points={{-58,-80},{-40,-80},{-40,-68},{-12,-68}},color={255,0,255}));
  connect(u1Req, offOrNotReq.u2)
    annotation (Line(points={{-120,-60},{-40,-60},{-40,-68},{-12,-68}},color={255,0,255}));
  connect(off.y, timOff.u)
    annotation (Line(points={{-58,-20},{-52,-20}},color={255,0,255}));
  connect(timOff.passed, offOrNotReq.u1)
    annotation (Line(points={{-28,-28},{-20,-28},{-20,-60},{-12,-60}},color={255,0,255}));
  connect(offOrNotReq.y, disAndOffOrNotReq.u2)
    annotation (Line(points={{12,-60},{20,-60},{20,-28},{28,-28}},color={255,0,255}));
  connect(dis.y, disAndOffOrNotReq.u1)
    annotation (Line(points={{-58,20},{0,20},{0,-20},{28,-20}},color={255,0,255}));
  connect(disAndOffOrNotReq.y, lat.clr)
    annotation (Line(points={{52,-20},{60,-20},{60,-6},{70,-6}},color={255,0,255}));
  annotation (
    defaultComponentName="enaLea",
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
    Documentation(
      info="<html>
<p>Used in Guideline 36 for:
</p>
<ul>
<li>
dedicated primary pumps in chiller and boiler plants.
</li>
</ul>
<p>
For chillers plants, an optional CHW request network point is used
when available.
When this point is available, the default value for the pump disable delay 
<code>dtOff</code> is increased to <i>10</i> minutes to ensure that flow 
is not cut off too soon.
</p>
<p>
Equipment refers to the main plant equipment, e.g., chiller,
boiler or heat pump.
</p>
</html>"));
end EnableLeadDedicated;
