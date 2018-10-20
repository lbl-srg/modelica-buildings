within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Stage;
block Capacities "Returns nominal capacities at current and one lower stage"

  parameter Integer numSta = 2
  "Minimum part load ratio for the first stage";

  parameter Real small = 0.00000001
  "Small number to avoid division with zero";

  parameter Modelica.SIunits.Power staNomCap[numSta + 1] = {small, 5e5, 1e6}
  "Nominal capacity at all chiller stages, including 0 stage";

  parameter Real min_plr1(final unit="1") = 0.1
  "Minimum part load ratio for the first stage";

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uSta "Chiller stage"
    annotation (Placement(transformation(extent={{-200,-20},{-160,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySta(final unit="W", final
      quantity="Power") "Nominal capacity of the current stage" annotation (
      Placement(transformation(extent={{160,30},{180,50}}), iconTransformation(
          extent={{100,30},{120,50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yLowSta(final unit="W",
      final quantity="Power") "Nominal capacity of the first lower stage"
    annotation (Placement(transformation(extent={{160,-50},{180,-30}}),
        iconTransformation(extent={{100,-50},{120,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant staCap[numSta + 1](
      k=staNomCap)
    "Array of chiller stage nominal capacities starting with stage 0"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant   staLow(k=1)
    "One stage lower"
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant   stage0(k=0) "Stage 0"
    annotation (Placement(transformation(extent={{-120,-120},{-100,-100}})));

  Buildings.Controls.OBC.CDL.Utilities.Assert staExc(message="The provided chiller stage is in not within the number of stages available")
    annotation (Placement(transformation(extent={{20,40},{40,60}})));

  CDL.Continuous.LessThreshold                           lesThr(threshold=-0.5)
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));

  CDL.Integers.Equal                            intEqu
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Product pro
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));

  CDL.Routing.RealExtractor extStaCap(outOfRangeValue=-1, nin=numSta + 1)
    "Extracts the nominal capacity at the current stage"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  CDL.Integers.Add addInt(k2=-1)
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  CDL.Routing.RealExtractor extStaLowCap(outOfRangeValue=-1, nin=numSta + 1)
    "Extracts the nominal capacity of one stage lower than the current stage"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  CDL.Integers.Min minInt
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  CDL.Continuous.Sources.Constant                        minPlrSta1(final k=
        min_plr1)
    "Minimum part load ratio of the first stage"
    annotation (Placement(transformation(extent={{0,-120},{20,-100}})));
  CDL.Logical.Switch swi
    annotation (Placement(transformation(extent={{102,-40},{122,-20}})));
equation
  connect(extStaCap.y, lesThr.u) annotation (Line(points={{-39,50},{-22,50}},
                                  color={0,0,127}));
  connect(staExc.u, lesThr.y)
    annotation (Line(points={{18,50},{1,50}},        color={255,0,255}));
  connect(staCap.y,extStaCap. u)
    annotation (Line(points={{-79,50},{-62,50}},   color={0,0,127}));
  connect(uSta,extStaCap. index)
    annotation (Line(points={{-180,0},{-100,0},{-100,20},{-50,20},{-50,38}},
                                                         color={255,127,0}));
  connect(staLow.y, addInt.u2) annotation (Line(points={{-119,-70},{-110,-70},{
          -110,-36},{-102,-36}},
                            color={255,127,0}));
  connect(uSta, addInt.u1) annotation (Line(points={{-180,0},{-130,0},{-130,-24},
          {-102,-24}}, color={255,127,0}));
  connect(staCap.y, extStaLowCap.u) annotation (Line(points={{-79,50},{-70,50},
          {-70,-10},{-22,-10}},   color={0,0,127}));
  connect(addInt.y, intEqu.u1)
    annotation (Line(points={{-79,-30},{18,-30}},   color={255,127,0}));
  connect(staLow.y, intEqu.u2) annotation (Line(points={{-119,-70},{-8,-70},{-8,
          -38},{18,-38}},  color={255,127,0}));
  connect(stage0.y, minInt.u2) annotation (Line(points={{-99,-110},{-90,-110},{
          -90,-56},{-62,-56}},    color={255,127,0}));
  connect(addInt.y, minInt.u1) annotation (Line(points={{-79,-30},{-70,-30},{
          -70,-44},{-62,-44}},
                            color={255,127,0}));
  connect(minInt.y, extStaLowCap.index) annotation (Line(points={{-39,-50},{-10,
          -50},{-10,-22}},                     color={255,127,0}));
  connect(extStaCap.y, ySta) annotation (Line(points={{-39,50},{-30,50},{-30,30},
          {120,30},{120,40},{170,40}}, color={0,0,127}));
  connect(pro.u2, minPlrSta1.y) annotation (Line(points={{58,-76},{36,-76},{36,
          -110},{21,-110}},
                     color={0,0,127}));
  connect(intEqu.y, swi.u2)
    annotation (Line(points={{41,-30},{100,-30}}, color={255,0,255}));
  connect(pro.y, swi.u1) annotation (Line(points={{81,-70},{86,-70},{86,-22},{
          100,-22}},
                 color={0,0,127}));
  connect(extStaCap.y, pro.u1) annotation (Line(points={{-39,50},{-32,50},{-32,
          -64},{58,-64}},
                     color={0,0,127}));
  connect(extStaLowCap.y, swi.u3) annotation (Line(points={{1,-10},{80,-10},{80,
          -38},{100,-38}},    color={0,0,127}));
  connect(swi.y, yLowSta) annotation (Line(points={{123,-30},{140,-30},{140,-40},
          {170,-40}}, color={0,0,127}));
  annotation (defaultComponentName = "staCap",
        Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name")}),
                          Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-160,-140},{160,140}})),
Documentation(info="<html>
<p>
Fixme
</p>
</html>",
revisions="<html>
<ul>
<li>
October 13, 2018, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Capacities;
