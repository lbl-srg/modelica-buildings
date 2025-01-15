within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences;
block CapacityRequirement
  "Cooling capacity requirement"

  parameter Real avePer(
    final unit="s",
    final quantity="Time")=300
    "Time period for the rolling average";

  parameter Real holPer(
    final unit="s",
    final quantity="Time",
    displayUnit="h")=900
    "Time period for the value hold at stage change";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput chaPro
    "Stage change process status, true = on, false = off"
    annotation (Placement(transformation(extent={{-180,90},{-140,130}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-180,-10},{-140,30}}),
        iconTransformation(extent={{-140,70},{-100,110}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatRet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{-180,-70},{-140,-30}}),
        iconTransformation(extent={{-140,20},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWat_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s") "Measured chilled water flow rate"
    annotation (Placement(transformation(extent={{-180,-150},{-140,-110}}),
        iconTransformation(extent={{-140,-30},{-100,10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(
    final quantity="HeatFlowRate",
    final unit="W") "Chilled water cooling capacity requirement"
    annotation (Placement(transformation(extent={{140,110},{180,150}}),
        iconTransformation(extent={{100,-20},{140,20}})));

protected
  constant Real rhoWat(
    final unit="kg/m3",
    final quantity="Density",
    displayUnit="kg/m3")=1000 "Water density";

  constant Real cpWat(
    final unit="J/(kg.K)",
    final quantity="SpecificEntropy",
    displayUnit="J/(kg.K)")=4184
    "Specific heat capacity of water";

  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam
    "Triggered sampler"
    annotation (Placement(transformation(extent={{-40,120},{-20,140}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swi "Switch"
    annotation (Placement(transformation(extent={{80,120},{100,140}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg "Edge"
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol(
    final trueHoldDuration=holPer,
    final falseHoldDuration=0) "True hold"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant density(
    final k = rhoWat)
    "Water density"
    annotation (Placement(transformation(extent={{-120,-110},{-100,-90}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant speHeaCap(
    final k = cpWat)
    "Specific heat capacity of water"
    annotation (Placement(transformation(extent={{-120,-160},{-100,-140}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant minLim(
    final k=0)
    "Minimum capacity requirement limit"
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));

  Buildings.Controls.OBC.CDL.Reals.Subtract sub1
    "Find input difference"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));

  Buildings.Controls.OBC.CDL.Reals.MovingAverage movMea(
    final delta=avePer)
    "Moving average"
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));

  Buildings.Controls.OBC.CDL.Reals.Multiply pro "Product"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));

  Buildings.Controls.OBC.CDL.Reals.Multiply pro1 "Product"
    annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));

  Buildings.Controls.OBC.CDL.Reals.Multiply pro2 "Product"
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));

  Buildings.Controls.OBC.CDL.Reals.Max max "Maximum of two inputs"
    annotation (Placement(transformation(extent={{100,-80},{120,-60}})));

equation
  connect(sub1.y, pro.u1) annotation (Line(points={{-58,-20},{10,-20},{10,-64},
          {18,-64}},color={0,0,127}));
  connect(pro.y, movMea.u)
    annotation (Line(points={{42,-70},{58,-70}}, color={0,0,127}));
  connect(speHeaCap.y, pro1.u2) annotation (Line(points={{-98,-150},{-90,-150},{
          -90,-126},{-82,-126}}, color={0,0,127}));
  connect(pro1.y, pro2.u2) annotation (Line(points={{-58,-120},{-50,-120},{-50,-86},
          {-22,-86}}, color={0,0,127}));
  connect(pro.u2, pro2.y) annotation (Line(points={{18,-76},{10,-76},{10,-80},{2,
          -80}}, color={0,0,127}));
  connect(pro1.u1, density.y) annotation (Line(points={{-82,-114},{-90,-114},{-90,
          -100},{-98,-100}}, color={0,0,127}));
  connect(VChiWat_flow, pro2.u1) annotation (Line(points={{-160,-130},{-130,-130},
          {-130,-74},{-22,-74}}, color={0,0,127}));
  connect(max.u1, minLim.y) annotation (Line(points={{98,-64},{90,-64},{90,-20},
          {82,-20}}, color={0,0,127}));
  connect(movMea.y, max.u2) annotation (Line(points={{82,-70},{90,-70},{90,-76},
          {98,-76}}, color={0,0,127}));
  connect(max.y, triSam.u) annotation (Line(points={{122,-70},{130,-70},{130,20},
          {-60,20},{-60,130},{-42,130}}, color={0,0,127}));
  connect(chaPro, edg.u)
    annotation (Line(points={{-160,110},{-102,110}}, color={255,0,255}));
  connect(edg.y, triSam.trigger) annotation (Line(points={{-78,110},{-30,110},{-30,
          118}},       color={255,0,255}));
  connect(triSam.y, swi.u1) annotation (Line(points={{-18,130},{10,130},{10,138},
          {78,138}}, color={0,0,127}));
  connect(max.y, swi.u3) annotation (Line(points={{122,-70},{130,-70},{130,60},{
          60,60},{60,122},{78,122}}, color={0,0,127}));
  connect(swi.y, y)
    annotation (Line(points={{102,130},{160,130}},color={0,0,127}));
  connect(chaPro, truFalHol.u) annotation (Line(points={{-160,110},{-120,110},{
          -120,80},{-42,80}}, color={255,0,255}));
  connect(truFalHol.y, swi.u2) annotation (Line(points={{-18,80},{40,80},{40,
          130},{78,130}}, color={255,0,255}));
  connect(TChiWatSupSet, sub1.u2) annotation (Line(points={{-160,10},{-120,10},{
          -120,-26},{-82,-26}}, color={0,0,127}));
  connect(TChiWatRet, sub1.u1) annotation (Line(points={{-160,-50},{-100,-50},{-100,
          -14},{-82,-14}}, color={0,0,127}));

  annotation (defaultComponentName = "capReq",
        Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-62,88},{60,-76}},
          textColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="Load")}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-180},{140,160}})),
Documentation(info="<html>
<p>
Calculates cooling capacity requirement based on the measured chilled water return temperature <code>TChiWatRet</code>,
calculated chilled water supply temperature setpoint
<code>TChiWatSupSet</code> and the measured chilled water flow <code>VChiWat_flow</code>.<br/>
The calculation is according to Guideline36-2021, section 5.20.4.8.
</p>
<p>
When a stage change process is in progress, as indicated by a boolean input
<code>chaPro</code>, the capacity requirement is kept constant for the longer of
<code>holPer</code> and the duration of the change process.<br/>
The calculation is according to Guideline36-2021, section 5.20.4.9.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 5, 2019, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end CapacityRequirement;
