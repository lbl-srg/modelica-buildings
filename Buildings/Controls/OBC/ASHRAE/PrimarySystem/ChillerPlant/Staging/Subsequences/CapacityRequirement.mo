within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences;
block CapacityRequirement
  "Cooling capacity requirement"

  parameter Modelica.SIunits.Time avePer = 300
  "Time period for the rolling average";

  parameter Modelica.SIunits.Time holPer = 900
  "Time period for the value hold at stage change";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput chaPro
    "Stage change process status, true = on, false = off"
    annotation (Placement(transformation(extent={{-180,70},{-140,110}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-180,10},{-140,50}}),
        iconTransformation(extent={{-140,70},{-100,110}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatRet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{-180,-50},{-140,-10}}),
        iconTransformation(extent={{-140,20},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWat_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s") "Measured chilled water flow rate"
    annotation (Placement(transformation(extent={{-180,-130},{-140,-90}}),
        iconTransformation(extent={{-140,-30},{-100,10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(
    final quantity="Power",
    final unit="W") "Chilled water cooling capacity requirement"
    annotation (Placement(transformation(extent={{140,90},{180,130}}),
        iconTransformation(extent={{100,-20},{140,20}})));

protected
  constant Modelica.SIunits.Density rhoWat = 1000 "Water density";

  constant Modelica.SIunits.SpecificHeatCapacity cpWat = 4184
  "Specific heat capacity of water";

  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam
    annotation (Placement(transformation(extent={{-40,100},{-20,120}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi
    annotation (Placement(transformation(extent={{40,100},{60,120}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol(
    final trueHoldDuration=holPer,
    final falseHoldDuration=0)
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant density(
    final k = rhoWat)
    "Water density"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant speHeaCap(
    final k = cpWat)
    "Specific heat capacity of water"
    annotation (Placement(transformation(extent={{-120,-140},{-100,-120}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minLim(
    final k=0)
    "Minimum capacity requirement limit"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add2(
    final k1=-1) "Adder"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));

  Buildings.Controls.OBC.CDL.Continuous.MovingMean movMea(
    final delta=avePer)
    "Moving average"
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Product pro "Product"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Product pro1 "Product"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));

  Buildings.Controls.OBC.CDL.Continuous.Product pro2 "Product"
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.Max max "Maximum of two inputs"
    annotation (Placement(transformation(extent={{100,-60},{120,-40}})));

equation
  connect(TChiWatRet, add2.u2) annotation (Line(points={{-160,-30},{-130,-30},{-130,
          -6},{-122,-6}},color={0,0,127}));
  connect(add2.u1, TChiWatSupSet) annotation (Line(points={{-122,6},{-130,6},{-130,
          30},{-160,30}}, color={0,0,127}));
  connect(add2.y, pro.u1) annotation (Line(points={{-98,0},{10,0},{10,-44},{18,-44}},
                  color={0,0,127}));
  connect(pro.y, movMea.u)
    annotation (Line(points={{42,-50},{58,-50}}, color={0,0,127}));
  connect(speHeaCap.y, pro1.u2) annotation (Line(points={{-98,-130},{-90,-130},{
          -90,-106},{-82,-106}}, color={0,0,127}));
  connect(pro1.y, pro2.u2) annotation (Line(points={{-58,-100},{-50,-100},{-50,-66},
          {-22,-66}}, color={0,0,127}));
  connect(pro.u2, pro2.y) annotation (Line(points={{18,-56},{10,-56},{10,-60},{2,
          -60}}, color={0,0,127}));
  connect(pro1.u1, density.y) annotation (Line(points={{-82,-94},{-90,-94},{-90,
          -80},{-98,-80}}, color={0,0,127}));
  connect(VChiWat_flow, pro2.u1) annotation (Line(points={{-160,-110},{-130,-110},
          {-130,-54},{-22,-54}}, color={0,0,127}));
  connect(max.u1, minLim.y) annotation (Line(points={{98,-44},{90,-44},{90,0},{82,
          0}},  color={0,0,127}));
  connect(movMea.y, max.u2) annotation (Line(points={{82,-50},{90,-50},{90,-56},
          {98,-56}}, color={0,0,127}));
  connect(max.y, triSam.u) annotation (Line(points={{122,-50},{130,-50},{130,30},
          {-60,30},{-60,110},{-42,110}}, color={0,0,127}));
  connect(chaPro, edg.u)
    annotation (Line(points={{-160,90},{-122,90}}, color={255,0,255}));
  connect(edg.y, triSam.trigger) annotation (Line(points={{-98,90},{-30,90},{-30,
          98.2}}, color={255,0,255}));
  connect(triSam.y, swi.u1) annotation (Line(points={{-18,110},{10,110},{10,118},
          {38,118}}, color={0,0,127}));
  connect(max.y, swi.u3) annotation (Line(points={{122,-50},{130,-50},{130,80},
          {28,80},{28,102},{38,102}},color={0,0,127}));
  connect(swi.y, y)
    annotation (Line(points={{62,110},{160,110}}, color={0,0,127}));
  connect(truFalHol.y, swi.u2) annotation (Line(points={{-18,60},{20,60},{20,110},
          {38,110}}, color={255,0,255}));
  connect(chaPro, truFalHol.u) annotation (Line(points={{-160,90},{-130,90},{-130,
          60},{-42,60}}, color={255,0,255}));
  annotation (defaultComponentName = "capReq",
        Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-62,88},{60,-76}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="Load")}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-160},{140,140}})),
Documentation(info="<html>
<p>
Calculates cooling capacity requirement based on the measured chilled water return temperature, <code>TChiWatRet</code>,
calculated chilled water supply temperature setpoint,
<code>TChiWatSupSet</code>, and the measured chilled water flow, <code>VChiWat_flow</code>.<br/>
The calculation is according to July Draft, section 5.2.4.7.
</p>
<p>
When a stage change process is in progress, as indicated by a boolean input
<code>chaPro</code>, the capacity requirement is kept constant for the longer of
<code>holPer</code> and the duration of the change process.<br/>
The calculation is according to July Draft, section 5.2.4.8.
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
