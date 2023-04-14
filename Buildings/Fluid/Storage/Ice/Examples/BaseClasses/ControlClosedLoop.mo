within Buildings.Fluid.Storage.Ice.Examples.BaseClasses;
block ControlClosedLoop "Closed loop control for ice storage plant"

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput powMod annotation (
    Placement(visible = true, transformation(origin={-260,60},     extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin={-260,60},     extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput demLev "Demand level" annotation (
    Placement(visible = true, transformation(origin={-260,180},   extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin={-260,200},   extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Controls.OBC.CDL.Interfaces.RealInput yDemLev2(
    final min=0,
    final max=1,
    final unit="1")
    "Control signal if in demand level 2" annotation (Placement(transformation(
          extent={{-280,80},{-240,120}}),  iconTransformation(extent={{-280,98},
            {-240,138}})));
  Controls.OBC.CDL.Interfaces.RealInput TSetLoa "Set point temperature of load"
    annotation (Placement(transformation(extent={{-280,-20},{-240,20}}),
        iconTransformation(extent={{-280,-20},{-240,20}})));
  Controls.OBC.CDL.Interfaces.RealInput THexWatLea
    "Water temperature leaving heat exchanger" annotation (Placement(
        transformation(extent={{-280,-120},{-240,-80}}), iconTransformation(
          extent={{-280,-122},{-240,-82}})));
  Controls.OBC.CDL.Interfaces.RealInput SOC(
    final unit="1") "State of charge of ice tank"
    annotation (Placement(transformation(extent={{-280,-200},{-240,-160}}),
        iconTransformation(extent={{-280,-200},{-240,-160}})));

  Controls.OBC.CDL.Interfaces.BooleanOutput yWatChi "If true, enable water chiller operation" annotation (
    Placement(transformation(extent={{240,0},{280,40}}), iconTransformation(
          extent={{240,0},{280,40}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput yGlyChi "If true, enable glycol chiller operation" annotation (
    Placement(transformation(extent={{240,-40},{280,0}}), iconTransformation(
          extent={{240,-40},{280,0}})));
  Controls.OBC.CDL.Interfaces.RealOutput TChiWatSet(
    final unit = "K",
    displayUnit= "degC") "Setpoint chiller water leaving temperature"
    annotation (Placement(transformation(extent={{240,180},{280,220}}),
        iconTransformation(extent={{240,180},{280,220}})));
  Controls.OBC.CDL.Interfaces.RealOutput TChiGlySet(
    final unit = "K",
    displayUnit= "degC") "Setpoint chiller glycol leaving temperature"
    annotation (Placement(transformation(extent={{240,140},{280,180}}),
        iconTransformation(extent={{240,140},{280,180}})));
  Controls.OBC.CDL.Interfaces.RealOutput yStoOn
    "Control signal for storage main leg"
    annotation (Placement(transformation(extent={{240,100},{280,140}}),
        iconTransformation(extent={{240,100},{280,140}})));
  Controls.OBC.CDL.Interfaces.RealOutput yStoByp
    "Control signal for storage bypass leg"
    annotation (Placement(transformation(extent={{240,60},{280,100}}),
        iconTransformation(extent={{240,60},{280,100}})));
  Controls.OBC.CDL.Interfaces.RealOutput yPumSto(
    final unit="1")
    "Pump speed ice storage" annotation (Placement(transformation(extent={{240,-100},
            {280,-60}}), iconTransformation(extent={{240,-100},{280,-60}})));
  Controls.OBC.CDL.Interfaces.RealOutput yPumGlyChi(final unit="1")
    "Pump speed glycol chiller" annotation (Placement(transformation(extent={{240,
            -140},{280,-100}}), iconTransformation(extent={{240,-142},{280,-102}})));
  Controls.OBC.CDL.Interfaces.RealOutput yPumGlyHex(
    final unit="1")
    "Pump speed glycol heat exchanger" annotation (Placement(transformation(
          extent={{240,-180},{280,-140}}), iconTransformation(extent={{240,-180},
            {280,-140}})));
  Controls.OBC.CDL.Interfaces.RealOutput yPumWatChi(
    final unit="1") "Pump speed water chiller"
    annotation (Placement(transformation(extent={{240,-260},{280,-220}}),
        iconTransformation(extent={{240,-260},{280,-220}})));
  Controls.OBC.CDL.Interfaces.RealOutput yPumWatHex(
    final unit="1")
    "Pump speed water-side of heat exchanger" annotation (Placement(
        transformation(extent={{240,-220},{280,-180}}), iconTransformation(
          extent={{240,-220},{280,-180}})));

  Buildings.Fluid.Storage.Ice.Examples.BaseClasses.ModeWrapper ConMod
    "Control wrapper for different modes"
    annotation (Placement(transformation(extent={{-12,80},{36,130}})));
  Controls.OBC.CDL.Conversions.BooleanToReal booToRea1
    annotation (Placement(transformation(extent={{180,-130},{200,-110}})));
  Controls.OBC.CDL.Conversions.BooleanToReal booToRea2
    annotation (Placement(transformation(extent={{180,-210},{200,-190}})));
  Controls.OBC.CDL.Continuous.Sources.Constant chiGlyTSetMin(
    k(final unit = "K",
      displayUnit= "degC")=266.15) "Minimum glycol leaving temperature"
    annotation (Placement(transformation(extent={{-200,150},{-180,170}})));
  Controls.OBC.CDL.Conversions.BooleanToReal booToRea3
    annotation (Placement(transformation(extent={{200,110},{220,130}})));
  Controls.OBC.CDL.Conversions.BooleanToReal booToRea4
    annotation (Placement(transformation(extent={{200,70},{220,90}})));
  Controls.OBC.CDL.Continuous.Switch swi
    annotation (Placement(transformation(extent={{160,158},{180,178}})));
  Controls.OBC.CDL.Continuous.Switch swi1
    annotation (Placement(transformation(extent={{180,-170},{200,-150}})));
  Controls.OBC.CDL.Continuous.Sources.Constant zer(k=0) "Outputs zero"
    annotation (Placement(transformation(extent={{-200,-220},{-180,-200}})));
  Controls.OBC.CDL.Conversions.BooleanToReal booToRea5
    annotation (Placement(transformation(extent={{180,-250},{200,-230}})));
  Controls.OBC.CDL.Continuous.Switch swiPumSto "Switch for storage pump"
    annotation (Placement(transformation(extent={{180,-90},{200,-70}})));
  Controls.OBC.CDL.Continuous.Sources.Constant one(k=1) "Outputs one"
    annotation (Placement(transformation(extent={{-200,-154},{-180,-134}})));
  Controls.OBC.CDL.Continuous.Switch stoPumGlyHex
    "Switch for glycol hex pump signal depending on chiller or storage operation"
    annotation (Placement(transformation(extent={{100,-162},{120,-142}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TSetChiOff(k(
      final unit="K",
      displayUnit="degC") = 283.15) "Set point for chiller if switched off"
    annotation (Placement(transformation(extent={{60,140},{80,160}})));
  Controls.OBC.CDL.Continuous.Line chiGlyTSet
    "Set point temperature for glycol chiller leaving temperature"
    annotation (Placement(transformation(extent={{-100,166},{-80,186}})));

  Controls.OBC.CDL.Continuous.Line chiWatTSet
    "Set point temperature for water chiller leaving temperature"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Controls.OBC.CDL.Interfaces.RealInput yDemLev1(
    final min=0,
    final max=1,
    final unit="1")
    "Control signal if in demand level 2" annotation (Placement(transformation(
          extent={{-280,120},{-240,160}}), iconTransformation(extent={{-280,138},
            {-240,178}})));
  Controls.OBC.CDL.Continuous.Sources.Constant chiWatTSetMin(k(
      final unit="K",
      displayUnit="degC") = 277.15) "Minimum waterl leaving temperature"
    annotation (Placement(transformation(extent={{-220,20},{-200,40}})));
  Controls.OBC.CDL.Continuous.AddParameter addPar(p=0.5)
    annotation (Placement(transformation(extent={{-200,-10},{-180,10}})));
  Controls.OBC.CDL.Continuous.AddParameter addPar1(p=-7)
    annotation (Placement(transformation(extent={{-168,200},{-148,220}})));
  Controls.OBC.CDL.Continuous.Switch swi2
    annotation (Placement(transformation(extent={{160,190},{180,210}})));
  Controls.OBC.CDL.Continuous.GreaterThreshold greThr(t=273.15 + 5, h=3)
    annotation (Placement(transformation(extent={{-202,-106},{-182,-86}})));
  Controls.OBC.CDL.Logical.And andPumSto "Output true to enable storage pump"
    annotation (Placement(transformation(extent={{140,118},{160,138}})));
  Controls.OBC.CDL.Logical.And andPumSto1
                                         "Output true to enable storage pump"
    annotation (Placement(transformation(extent={{4,-136},{24,-116}})));
  Controls.OBC.CDL.Logical.And andPumSto2
                                         "Output true to enable storage pump"
    annotation (Placement(transformation(extent={{150,-124},{170,-104}})));
  Controls.OBC.CDL.Continuous.Switch swi3
    annotation (Placement(transformation(extent={{28,164},{48,184}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TsetChillSto(k(
      final unit="K",
      displayUnit="degC") = 268.15)
    "Set point for chiller when charging storage"
    annotation (Placement(transformation(extent={{-20,180},{0,200}})));
equation
  connect(ConMod.yWatChi, yWatChi) annotation (Line(points={{38,108},{178,108},
          {178,20},{260,20}}, color={255,0,255}));
  connect(ConMod.yGlyChi, yGlyChi) annotation (Line(points={{38,104},{52,104},{
          52,-20},{260,-20}},   color={255,0,255}));
  connect(booToRea1.y, yPumGlyChi)
    annotation (Line(points={{202,-120},{260,-120}}, color={0,0,127}));
  connect(booToRea2.y, yPumWatHex)
    annotation (Line(points={{202,-200},{260,-200}}, color={0,0,127}));
  connect(booToRea2.u,ConMod. yPumWatHex) annotation (Line(points={{178,-200},{
          134,-200},{134,86},{38,86}}, color={255,0,255}));
  connect(ConMod.demLev, demLev) annotation (Line(points={{-14,126},{-174,126},
          {-174,144},{-234,144},{-234,180},{-260,180}},
                                 color={255,127,0}));
  connect(yStoOn, booToRea3.y)
    annotation (Line(points={{260,120},{222,120}}, color={0,0,127}));
  connect(yStoByp, booToRea4.y)
    annotation (Line(points={{260,80},{222,80}}, color={0,0,127}));
  connect(booToRea4.u,ConMod. yStoByp) annotation (Line(points={{198,80},{50,80},
          {50,114},{38,114}},      color={255,0,255}));
  connect(swi.y, TChiGlySet) annotation (Line(points={{182,168},{222,168},{222,
          160},{260,160}}, color={0,0,127}));
  connect(swi1.u2,ConMod. yPumWatHex) annotation (Line(points={{178,-160},{134,
          -160},{134,86},{38,86}}, color={255,0,255}));
  connect(zer.y, swi1.u3) annotation (Line(points={{-178,-210},{160,-210},{160,
          -168},{178,-168}}, color={0,0,127}));
  connect(swi1.y, yPumGlyHex)
    annotation (Line(points={{202,-160},{260,-160}}, color={0,0,127}));
  connect(booToRea5.y, yPumWatChi)
    annotation (Line(points={{202,-240},{260,-240}}, color={0,0,127}));
  connect(booToRea5.u,ConMod. yPumWatChi) annotation (Line(points={{178,-240},{
          156,-240},{156,-150},{130,-150},{130,82},{38,82}},
                                       color={255,0,255}));
  connect(swiPumSto.u2,ConMod. yPumSto) annotation (Line(points={{178,-80},{128,
          -80},{128,98},{38,98}}, color={255,0,255}));
  connect(swiPumSto.y, yPumSto)
    annotation (Line(points={{202,-80},{260,-80}}, color={0,0,127}));
  connect(swiPumSto.u3, zer.y) annotation (Line(points={{178,-88},{160,-88},{
          160,-210},{-178,-210}},         color={0,0,127}));
  connect(stoPumGlyHex.u1, one.y) annotation (Line(points={{98,-144},{-178,-144}},
                               color={0,0,127}));
  connect(swi1.u1, stoPumGlyHex.y)
    annotation (Line(points={{178,-152},{122,-152}}, color={0,0,127}));
  connect(chiGlyTSet.x1, zer.y) annotation (Line(points={{-102,184},{-160,184},
          {-160,-210},{-178,-210}},color={0,0,127}));
  connect(chiGlyTSet.x2, one.y) annotation (Line(points={{-102,172},{-148,172},
          {-148,-144},{-178,-144}},color={0,0,127}));
  connect(chiGlyTSet.f2, chiGlyTSetMin.y) annotation (Line(points={{-102,168},{
          -130,168},{-130,160},{-178,160}},
                                       color={0,0,127}));
  connect(chiGlyTSet.u, yDemLev2) annotation (Line(points={{-102,176},{-154,176},
          {-154,100},{-260,100}}, color={0,0,127}));
  connect(chiWatTSetMin.y, chiWatTSet.f2) annotation (Line(points={{-198,30},{
          -140,30},{-140,22},{-102,22}}, color={0,0,127}));
  connect(one.y, chiWatTSet.x2) annotation (Line(points={{-178,-144},{-136,-144},
          {-136,26},{-102,26}}, color={0,0,127}));
  connect(chiWatTSet.u, yDemLev1) annotation (Line(points={{-102,30},{-112,30},
          {-112,140},{-260,140}}, color={0,0,127}));
  connect(zer.y, chiWatTSet.x1) annotation (Line(points={{-178,-210},{-160,-210},
          {-160,38},{-102,38}}, color={0,0,127}));
  connect(chiWatTSet.f1, addPar.y) annotation (Line(points={{-102,34},{-106,34},
          {-106,0},{-178,0}}, color={0,0,127}));
  connect(addPar.u, TSetLoa)
    annotation (Line(points={{-202,0},{-260,0}}, color={0,0,127}));
  connect(ConMod.yGlyChi, swi.u2) annotation (Line(points={{38,104},{114,104},{
          114,168},{158,168}}, color={255,0,255}));
  connect(addPar1.y, chiGlyTSet.f1) annotation (Line(points={{-146,210},{-138,
          210},{-138,180},{-102,180}}, color={0,0,127}));
  connect(addPar1.u, TSetLoa) annotation (Line(points={{-170,210},{-172,210},{
          -172,60},{-232,60},{-232,0},{-260,0}}, color={0,0,127}));
  connect(ConMod.yWatChi, swi2.u2) annotation (Line(points={{38,108},{168,108},
          {168,152},{152,152},{152,200},{158,200}},
                                color={255,0,255}));
  connect(swi2.y, TChiWatSet)
    annotation (Line(points={{182,200},{260,200}}, color={0,0,127}));
  connect(chiWatTSet.y, swi2.u1) annotation (Line(points={{-78,30},{-60,30},{
          -60,208},{158,208}}, color={0,0,127}));
  connect(swi2.u3, TSetChiOff.y) annotation (Line(points={{158,192},{90,192},{
          90,150},{82,150}}, color={0,0,127}));
  connect(swi.u3, TSetChiOff.y) annotation (Line(points={{158,160},{90,160},{90,
          150},{82,150}}, color={0,0,127}));
  connect(SOC,ConMod. SOC) annotation (Line(points={{-260,-180},{-116,-180},{
          -116,-70},{-26,-70},{-26,88},{-14,88}},
                                            color={0,0,127}));
  connect(THexWatLea, greThr.u) annotation (Line(points={{-260,-100},{-212,-100},
          {-212,-96},{-204,-96}}, color={0,0,127}));
  connect(ConMod.yStoOn, andPumSto.u1) annotation (Line(points={{38,118},{126,
          118},{126,128},{138,128}},
                                color={255,0,255}));
  connect(andPumSto.y, booToRea3.u) annotation (Line(points={{162,128},{190,128},
          {190,120},{198,120}}, color={255,0,255}));
  connect(greThr.y, andPumSto.u2) annotation (Line(points={{-180,-96},{-40,-96},
          {-40,132},{54,132},{54,120},{138,120}}, color={255,0,255}));
  connect(greThr.y, andPumSto1.u1) annotation (Line(points={{-180,-96},{-4,-96},
          {-4,-126},{2,-126}}, color={255,0,255}));
  connect(ConMod.yGlyChi, andPumSto1.u2) annotation (Line(points={{38,104},{52,
          104},{52,-134},{30,-134},{30,-142},{-4,-142},{-4,-134},{2,-134}},
                                                   color={255,0,255}));
  connect(andPumSto1.y, stoPumGlyHex.u2) annotation (Line(points={{26,-126},{32,
          -126},{32,-152},{98,-152}}, color={255,0,255}));
  connect(ConMod.yPumGlyChi, andPumSto2.u1) annotation (Line(points={{38,93.8},
          {38,92},{138,92},{138,-114},{148,-114}},          color={255,0,255}));
  connect(andPumSto2.y, booToRea1.u) annotation (Line(points={{172,-114},{172,-120},
          {178,-120}}, color={255,0,255}));
  connect(andPumSto2.u2, andPumSto1.u1) annotation (Line(points={{148,-122},{68,
          -122},{68,-96},{-4,-96},{-4,-126},{2,-126}}, color={255,0,255}));
  connect(powMod, ConMod.powMod) annotation (Line(points={{-260,60},{-234,60},{
          -234,104},{-22,104},{-22,112},{-14,112}}, color={255,127,0}));
  connect(yDemLev1, swiPumSto.u1) annotation (Line(points={{-260,140},{-94,140},
          {-94,-72},{178,-72}}, color={0,0,127}));
  connect(yDemLev1, stoPumGlyHex.u3) annotation (Line(points={{-260,140},{-188,
          140},{-188,144},{-112,144},{-112,-160},{98,-160}}, color={0,0,127}));
  connect(chiGlyTSet.y, swi3.u3) annotation (Line(points={{-78,176},{-40,176},{
          -40,166},{26,166}}, color={0,0,127}));
  connect(ConMod.yStoByp, swi3.u2) annotation (Line(points={{38,114},{40,114},{
          40,160},{4,160},{4,174},{26,174}}, color={255,0,255}));
  connect(TsetChillSto.y, swi3.u1) annotation (Line(points={{2,190},{18,190},{
          18,182},{26,182}}, color={0,0,127}));
  connect(swi3.y, swi.u1) annotation (Line(points={{50,174},{150,174},{150,176},
          {158,176}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio = false, extent={{-240,-260},{240,
            240}}),
    graphics={  Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent={{-240,
              240},{240,-260}}),                                                                                                                                                                                       Text(lineColor = {0, 0, 127}, extent={{-50,282},
              {50,238}},                                                                                                                                                                                                        textString = "%name")}),
    Diagram(coordinateSystem(preserveAspectRatio = false, extent={{-240,-260},{240,
            240}})),
    Documentation(info="<html>
<p>
Controller that outputs control signals for the chillers, pumps and valves.
</p>
<p>
The controller takes as input the current demand level, a signal for the operation mode
that indicates the CO2 content on the electricity,
and the load that should be served for each demand level.
</p>
</html>", revisions="<html>
<ul>
<li>
November 10, 2022, by Ettore Zanetti:<br/>
Added control modes.
</li>
<li>
October 5, 2022, by Michael Wetter:<br/>
First implementation.
</li>
</ul>"));
end ControlClosedLoop;
