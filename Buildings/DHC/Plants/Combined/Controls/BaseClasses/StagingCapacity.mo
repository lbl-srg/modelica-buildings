within Buildings.DHC.Plants.Combined.Controls.BaseClasses;
block StagingCapacity
  "Total capacity at current stages times stage-up PLR limit"

  parameter Integer nChi(final min=1, start=1)
    "Number of units operating at design conditions"
    annotation (Dialog(group="CHW loop and cooling-only chillers"),
      Evaluate=true);
  parameter Real QChiWatChi_flow_nominal(
    final unit="W",
    final quantity="HeatFlowRate")
    "Cooling design heat flow rate of cooling-only chillers (all units)"
    annotation (Dialog(group="CHW loop and cooling-only chillers"));
  parameter Integer nChiHea(final min=1, start=1)
    "Number of units operating at design conditions"
    annotation (Dialog(group="HW loop and heat recovery chillers"),
      Evaluate=true);
  parameter Real PLRStaTra(unit="1") = 0.85
    "Part load ratio triggering stage transition";
  parameter Real QChiWatCasCoo_flow_nominal(
    final unit="W",
    final quantity="HeatFlowRate")
    "Cooling design heat flow rate of HRC in cascading cooling mode (all units)"
    annotation (Dialog(group="HW loop and heat recovery chillers"));
  parameter Real QHeaWat_flow_nominal(
    final unit="W",
    final quantity="HeatFlowRate")
    "Heating design heat flow rate (all units)"
    annotation (Dialog(group="HW loop and heat recovery chillers"));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uCooPreIdxSta
    "Left limit of the cooling stage index"
    annotation (Placement(transformation(extent={{-300,190},{-260,230}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uHeaPreIdxSta
    "Left limit of the heating stage index"
    annotation (Placement(transformation(extent={{-300,-90},{-260,-50}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCoo
    "Total capacity at current stage (>0) times stage-up PLR limit"
    annotation (Placement(transformation(extent={{260,150},{300,190}}),
        iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCooLow
    "Total capacity at next lower stage (>0) times stage-down PLR limit"
    annotation (Placement(transformation(extent={{260,-10},{300,30}}),
        iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHea
    "Total capacity at current stage (>0) times stage-up PLR limit"
    annotation (Placement(transformation(extent={{260,-110},{300,-70}}),
        iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHeaLow
    "Total capacity at next lower stage (>0) times stage-down PLR limit"
    annotation (Placement(transformation(extent={{260,-200},{300,-160}}),
        iconTransformation(extent={{100,-100},{140,-60}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conInt(
    final k=nChi)
    "Number of units operating at design conditions"
    annotation (Placement(transformation(extent={{-240,150},{-220,170}})));
  Buildings.Controls.OBC.CDL.Reals.Min min2 "Find smaller input"
    annotation (Placement(transformation(extent={{-140,200},{-120,220}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal cooLefLimInd
    "Cooling left limit stage index"
    annotation (Placement(transformation(extent={{-240,200},{-220,220}})));
  Buildings.Controls.OBC.CDL.Reals.Divide div1
    "Input 1 divided by input 2"
    annotation (Placement(transformation(extent={{-80,180},{-60,200}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai1(
    final k=QChiWatChi_flow_nominal)
    "Gain with factor of cooling design heat flow rate"
    annotation (Placement(transformation(extent={{40,180},{60,200}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub1
    "Find difference"
    annotation (Placement(transformation(extent={{-140,150},{-120,170}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conInt1(
    final k=0) "Zero"
    annotation (Placement(transformation(extent={{-240,70},{-220,90}})));
  Buildings.Controls.OBC.CDL.Reals.Max max1 "Find larger input"
    annotation (Placement(transformation(extent={{-80,140},{-60,160}})));
  Buildings.Controls.OBC.CDL.Reals.Divide div2
    "Input 1 divided by input 2"
    annotation (Placement(transformation(extent={{-20,120},{0,140}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conInt2(
    final k=nChiHea)
    "Number of units operating at design conditions"
    annotation (Placement(transformation(extent={{-240,-30},{-220,-10}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai2(
    final k=QChiWatCasCoo_flow_nominal)
    "Gain with factor of cooling design heat flow rate of HRC in cascading cooling mode"
    annotation (Placement(transformation(extent={{40,120},{60,140}})));
  Buildings.Controls.OBC.CDL.Reals.Add add1 "Sum of inputs"
    annotation (Placement(transformation(extent={{140,160},{160,180}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai3(
    final k=PLRStaTra)
    "Gain with factor of part load ratio triggering stage transition"
    annotation (Placement(transformation(extent={{180,160},{200,180}})));
  Buildings.Controls.OBC.CDL.Reals.Abs abs2 "Absolute value"
    annotation (Placement(transformation(extent={{220,160},{240,180}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar(final p=-1)
    "Add parameter"
    annotation (Placement(transformation(extent={{-140,70},{-120,90}})));
  Buildings.Controls.OBC.CDL.Reals.Max max2 "Find larger input"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Controls.OBC.CDL.Reals.Min min3 "Find smaller input"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  Buildings.Controls.OBC.CDL.Reals.Divide div3
    "Input 1 divided by input 2"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai4(
    final k=QChiWatChi_flow_nominal)
    "Gain with factor of cooling design heat flow rate"
    annotation (Placement(transformation(extent={{80,30},{100,50}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar1(
    final p=-1-nChi)
    "Add parameter"
    annotation (Placement(transformation(extent={{-140,0},{-120,20}})));
  Buildings.Controls.OBC.CDL.Reals.Max max3 "Find larger input"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Reals.Divide div4
    "Input 1 divided by input 2"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai5(
    final k=QChiWatCasCoo_flow_nominal)
    "Gain with factor of cooling design heat flow rate of HRC in cascading cooling mode"
    annotation (Placement(transformation(extent={{80,-30},{100,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Add add3 "Sum of inputs"
    annotation (Placement(transformation(extent={{140,0},{160,20}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai6(
    final k=PLRStaTra)
    "Gain with factor of part load ratio triggering stage transition"
    annotation (Placement(transformation(extent={{180,0},{200,20}})));
  Buildings.Controls.OBC.CDL.Reals.Abs abs3 "Absolute value"
    annotation (Placement(transformation(extent={{220,0},{240,20}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal heaLefLimInd
    "Cooling left limit stage index"
    annotation (Placement(transformation(extent={{-240,-80},{-220,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Divide div5 "Input 1 divided by input 2"
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai7(
    final k=PLRStaTra)
    "Gain with factor of part load ratio triggering stage transition"
    annotation (Placement(transformation(extent={{140,-100},{160,-80}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai8(
    final k=QHeaWat_flow_nominal)
    "Gain with factor of the heating design heat flow rate"
    annotation (Placement(transformation(extent={{220,-100},{240,-80}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar2(final p=-1)
    "Add parameter"
    annotation (Placement(transformation(extent={{-140,-150},{-120,-130}})));
  Buildings.Controls.OBC.CDL.Reals.Max max4 "Find larger input"
    annotation (Placement(transformation(extent={{-80,-170},{-60,-150}})));
  Buildings.Controls.OBC.CDL.Reals.Divide div6 "Input 1 divided by input 2"
    annotation (Placement(transformation(extent={{40,-190},{60,-170}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai9(
    final k=QHeaWat_flow_nominal)
    "Gain with factor of the heating design heat flow rate"
    annotation (Placement(transformation(extent={{220,-190},{240,-170}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai10(
    final k=PLRStaTra)
    "Gain with factor of part load ratio triggering stage transition"
    annotation (Placement(transformation(extent={{140,-190},{160,-170}})));

equation
  connect(uCooPreIdxSta, cooLefLimInd.u)
    annotation (Line(points={{-280,210},{-242,210}}, color={255,127,0}));
  connect(cooLefLimInd.y, min2.u2) annotation (Line(points={{-218,210},{-200,210},
          {-200,204},{-142,204}}, color={0,0,127}));
  connect(conInt.y, min2.u1) annotation (Line(points={{-218,160},{-180,160},{-180,
          216},{-142,216}}, color={0,0,127}));
  connect(min2.y, div1.u1) annotation (Line(points={{-118,210},{-100,210},{-100,
          196},{-82,196}}, color={0,0,127}));
  connect(conInt.y, div1.u2) annotation (Line(points={{-218,160},{-180,160},{-180,
          184},{-82,184}}, color={0,0,127}));
  connect(div1.y, gai1.u)
    annotation (Line(points={{-58,190},{38,190}}, color={0,0,127}));
  connect(cooLefLimInd.y, sub1.u1) annotation (Line(points={{-218,210},{-200,210},
          {-200,166},{-142,166}}, color={0,0,127}));
  connect(conInt.y, sub1.u2) annotation (Line(points={{-218,160},{-180,160},{-180,
          154},{-142,154}}, color={0,0,127}));
  connect(conInt1.y, max1.u2) annotation (Line(points={{-218,80},{-210,80},{-210,
          144},{-82,144}}, color={0,0,127}));
  connect(sub1.y, max1.u1) annotation (Line(points={{-118,160},{-100,160},{-100,
          156},{-82,156}}, color={0,0,127}));
  connect(max1.y, div2.u1) annotation (Line(points={{-58,150},{-40,150},{-40,136},
          {-22,136}}, color={0,0,127}));
  connect(conInt2.y, div2.u2) annotation (Line(points={{-218,-20},{-160,-20},{-160,
          124},{-22,124}}, color={0,0,127}));
  connect(div2.y, gai2.u)
    annotation (Line(points={{2,130},{38,130}}, color={0,0,127}));
  connect(gai1.y, add1.u1) annotation (Line(points={{62,190},{100,190},{100,176},
          {138,176}}, color={0,0,127}));
  connect(gai2.y, add1.u2) annotation (Line(points={{62,130},{80,130},{80,164},{
          138,164}}, color={0,0,127}));
  connect(add1.y, gai3.u)
    annotation (Line(points={{162,170},{178,170}}, color={0,0,127}));
  connect(gai3.y, abs2.u)
    annotation (Line(points={{202,170},{218,170}}, color={0,0,127}));
  connect(abs2.y, yCoo)
    annotation (Line(points={{242,170},{280,170}}, color={0,0,127}));
  connect(cooLefLimInd.y, addPar.u) annotation (Line(points={{-218,210},{-200,210},
          {-200,80},{-142,80}}, color={0,0,127}));
  connect(addPar.y, max2.u1) annotation (Line(points={{-118,80},{-100,80},{-100,
          76},{-82,76}}, color={0,0,127}));
  connect(conInt1.y, max2.u2) annotation (Line(points={{-218,80},{-210,80},{-210,
          64},{-82,64}}, color={0,0,127}));
  connect(max2.y, min3.u1) annotation (Line(points={{-58,70},{-40,70},{-40,66},{
          -22,66}}, color={0,0,127}));
  connect(conInt.y, min3.u2) annotation (Line(points={{-218,160},{-180,160},{-180,
          54},{-22,54}}, color={0,0,127}));
  connect(min3.y, div3.u1) annotation (Line(points={{2,60},{20,60},{20,46},{38,46}},
        color={0,0,127}));
  connect(conInt.y, div3.u2) annotation (Line(points={{-218,160},{-180,160},{-180,
          34},{38,34}}, color={0,0,127}));
  connect(div3.y, gai4.u)
    annotation (Line(points={{62,40},{78,40}}, color={0,0,127}));
  connect(cooLefLimInd.y, addPar1.u) annotation (Line(points={{-218,210},{-200,210},
          {-200,10},{-142,10}}, color={0,0,127}));
  connect(addPar1.y, max3.u1) annotation (Line(points={{-118,10},{-100,10},{-100,
          6},{-82,6}}, color={0,0,127}));
  connect(conInt1.y, max3.u2) annotation (Line(points={{-218,80},{-210,80},{-210,
          -6},{-82,-6}}, color={0,0,127}));
  connect(max3.y, div4.u1) annotation (Line(points={{-58,0},{20,0},{20,-14},{38,
          -14}}, color={0,0,127}));
  connect(conInt2.y, div4.u2) annotation (Line(points={{-218,-20},{-160,-20},{-160,
          -26},{38,-26}}, color={0,0,127}));
  connect(div4.y, gai5.u)
    annotation (Line(points={{62,-20},{78,-20}}, color={0,0,127}));
  connect(gai4.y, add3.u1) annotation (Line(points={{102,40},{120,40},{120,16},{
          138,16}}, color={0,0,127}));
  connect(gai5.y, add3.u2) annotation (Line(points={{102,-20},{120,-20},{120,4},
          {138,4}}, color={0,0,127}));
  connect(add3.y, gai6.u)
    annotation (Line(points={{162,10},{178,10}}, color={0,0,127}));
  connect(gai6.y, abs3.u)
    annotation (Line(points={{202,10},{218,10}}, color={0,0,127}));
  connect(abs3.y, yCooLow)
    annotation (Line(points={{242,10},{280,10}}, color={0,0,127}));
  connect(uHeaPreIdxSta, heaLefLimInd.u)
    annotation (Line(points={{-280,-70},{-242,-70}}, color={255,127,0}));
  connect(heaLefLimInd.y, div5.u1) annotation (Line(points={{-218,-70},{20,-70},
          {20,-84},{38,-84}}, color={0,0,127}));
  connect(conInt2.y, div5.u2) annotation (Line(points={{-218,-20},{-160,-20},{-160,
          -96},{38,-96}}, color={0,0,127}));
  connect(div5.y, gai7.u)
    annotation (Line(points={{62,-90},{138,-90}}, color={0,0,127}));
  connect(gai7.y, gai8.u)
    annotation (Line(points={{162,-90},{218,-90}}, color={0,0,127}));
  connect(gai8.y, yHea)
    annotation (Line(points={{242,-90},{280,-90}}, color={0,0,127}));
  connect(heaLefLimInd.y, addPar2.u) annotation (Line(points={{-218,-70},{-180,-70},
          {-180,-140},{-142,-140}}, color={0,0,127}));
  connect(addPar2.y, max4.u1) annotation (Line(points={{-118,-140},{-100,-140},{
          -100,-154},{-82,-154}}, color={0,0,127}));
  connect(conInt1.y, max4.u2) annotation (Line(points={{-218,80},{-210,80},{-210,
          -166},{-82,-166}}, color={0,0,127}));
  connect(max4.y, div6.u1) annotation (Line(points={{-58,-160},{20,-160},{20,-174},
          {38,-174}}, color={0,0,127}));
  connect(conInt2.y, div6.u2) annotation (Line(points={{-218,-20},{-160,-20},{-160,
          -186},{38,-186}}, color={0,0,127}));
  connect(div6.y, gai10.u)
    annotation (Line(points={{62,-180},{138,-180}}, color={0,0,127}));
  connect(gai10.y, gai9.u)
    annotation (Line(points={{162,-180},{218,-180}}, color={0,0,127}));
  connect(gai9.y, yHeaLow)
    annotation (Line(points={{242,-180},{280,-180}}, color={0,0,127}));

annotation (defaultComponentName="staCap",
Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          textColor={0,0,255},
          extent={{-100,100},{100,140}},
          textString="%name")}),
Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-260,-240},{260,240}})),
Documentation(info="<html>
<p>
It calcualtes the total capacity at current stages times stage-up PLR limit.
</p>
</html>", revisions="<html>
<ul>
<li>
February 13, 2025, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end StagingCapacity;
