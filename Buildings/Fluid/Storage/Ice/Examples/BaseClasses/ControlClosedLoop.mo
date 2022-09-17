within Buildings.Fluid.Storage.Ice.Examples.BaseClasses;
block ControlClosedLoop "Closed loop control for ice storage plant"

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput powMod annotation (
    Placement(visible = true, transformation(origin={-260,100},    extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin={-260,98},     extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput demLev "Demand level" annotation (
    Placement(visible = true, transformation(origin={-260,180},   extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin={-260,200},   extent = {{-20, -20}, {20, 20}}, rotation = 0)));

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
    annotation (Placement(transformation(extent={{240,138},{280,178}}),
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
  Controls.OBC.CDL.Interfaces.RealOutput yPumGly(
    final unit="1")
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

  Controls.OBC.CDL.Continuous.PIDWithReset conPumGlyHex(controllerType=
        Buildings.Controls.OBC.CDL.Types.SimpleController.PI)
    "Controller for glycol-side pump of heat exchanger"
    annotation (Placement(transformation(extent={{-190,-70},{-170,-50}})));

  ControlEfficiencyMode effMod "Controller used during efficiency mode"
    annotation (Placement(transformation(extent={{0,80},{48,130}})));
  Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    annotation (Placement(transformation(extent={{180,-90},{200,-70}})));
  Controls.OBC.CDL.Conversions.BooleanToReal booToRea1
    annotation (Placement(transformation(extent={{180,-130},{200,-110}})));
  Controls.OBC.CDL.Conversions.BooleanToReal booToRea2
    annotation (Placement(transformation(extent={{180,-210},{200,-190}})));
  Controls.OBC.CDL.Continuous.Sources.Constant dTHex(k=4)
    "Design temperature drop over heat exchanger"
    annotation (Placement(transformation(extent={{-48,132},{-28,152}})));
  Controls.OBC.CDL.Continuous.Sources.Constant chiGlyTSet(k=273.15 - 7)
    "Set point"
    annotation (Placement(transformation(extent={{60,166},{80,186}})));
  Controls.OBC.CDL.Conversions.BooleanToReal booToRea3
    annotation (Placement(transformation(extent={{200,110},{220,130}})));
  Controls.OBC.CDL.Conversions.BooleanToReal booToRea4
    annotation (Placement(transformation(extent={{200,70},{220,90}})));
  Controls.OBC.CDL.Continuous.Switch swi
    annotation (Placement(transformation(extent={{160,158},{180,178}})));
  Controls.OBC.CDL.Continuous.Subtract sub
    annotation (Placement(transformation(extent={{20,140},{40,160}})));
  Controls.OBC.CDL.Continuous.Switch swi1
    annotation (Placement(transformation(extent={{182,-170},{202,-150}})));
  Controls.OBC.CDL.Continuous.Sources.Constant zer(k=0) "Outputs zero"
    annotation (Placement(transformation(extent={{60,-190},{80,-170}})));
  Controls.OBC.CDL.Conversions.BooleanToReal booToRea5
    annotation (Placement(transformation(extent={{180,-250},{200,-230}})));
equation
  connect(TSetLoa, TChiWatSet) annotation (Line(points={{-260,0},{100,0},{100,
          200},{260,200}},
                      color={0,0,127}));
  connect(conPumGlyHex.u_s, TSetLoa) annotation (Line(points={{-192,-60},{-220,-60},
          {-220,0},{-260,0}}, color={0,0,127}));
  connect(conPumGlyHex.u_m, THexWatLea) annotation (Line(points={{-180,-72},{-180,
          -100},{-260,-100}}, color={0,0,127}));
  connect(effMod.yWatChi, yWatChi) annotation (Line(points={{50,108},{160,108},
          {160,20},{260,20}}, color={255,0,255}));
  connect(effMod.yGlyChi, yGlyChi) annotation (Line(points={{50,104},{152,104},
          {152,-20},{260,-20}}, color={255,0,255}));
  connect(yPumSto, booToRea.y)
    annotation (Line(points={{260,-80},{202,-80}}, color={0,0,127}));
  connect(booToRea.u, effMod.yPumSto) annotation (Line(points={{178,-80},{148,
          -80},{148,98},{50,98}}, color={255,0,255}));
  connect(booToRea1.y, yPumGly)
    annotation (Line(points={{202,-120},{260,-120}}, color={0,0,127}));
  connect(booToRea1.u, effMod.yPumGly) annotation (Line(points={{178,-120},{140,
          -120},{140,93.8},{50,93.8}}, color={255,0,255}));
  connect(booToRea2.y, yPumWatHex)
    annotation (Line(points={{202,-200},{260,-200}}, color={0,0,127}));
  connect(booToRea2.u, effMod.yPumWatHex) annotation (Line(points={{178,-200},{
          134,-200},{134,86},{50,86}}, color={255,0,255}));
  connect(effMod.demLev, demLev) annotation (Line(points={{-2,126},{-100,126},{
          -100,180},{-260,180}}, color={255,127,0}));
  connect(SOC, effMod.SOC) annotation (Line(points={{-260,-180},{-40,-180},{-40,
          88},{-2,88}}, color={0,0,127}));
  connect(yStoOn, booToRea3.y)
    annotation (Line(points={{260,120},{222,120}}, color={0,0,127}));
  connect(effMod.yStoOn, booToRea3.u) annotation (Line(points={{50,118},{52,118},
          {52,120},{198,120}}, color={255,0,255}));
  connect(yStoByp, booToRea4.y)
    annotation (Line(points={{260,80},{222,80}}, color={0,0,127}));
  connect(booToRea4.u, effMod.yStoByp) annotation (Line(points={{198,80},{180,
          80},{180,114},{50,114}}, color={255,0,255}));
  connect(swi.y, TChiGlySet) annotation (Line(points={{182,168},{222,168},{222,
          158},{260,158}}, color={0,0,127}));
  connect(effMod.yStoByp, swi.u2) annotation (Line(points={{50,114},{140,114},{
          140,168},{158,168}}, color={255,0,255}));
  connect(chiGlyTSet.y, swi.u1)
    annotation (Line(points={{82,176},{158,176}}, color={0,0,127}));
  connect(TSetLoa, sub.u1) annotation (Line(points={{-260,0},{-60,0},{-60,156},
          {18,156}}, color={0,0,127}));
  connect(sub.u2, dTHex.y) annotation (Line(points={{18,144},{16,144},{16,142},
          {-26,142}}, color={0,0,127}));
  connect(sub.y, swi.u3) annotation (Line(points={{42,150},{152,150},{152,160},
          {158,160}}, color={0,0,127}));
  connect(effMod.yPumWatHex, conPumGlyHex.trigger) annotation (Line(points={{50,
          86},{80,86},{80,-120},{-186,-120},{-186,-72}}, color={255,0,255}));
  connect(swi1.u1, conPumGlyHex.y) annotation (Line(points={{180,-152},{-160,
          -152},{-160,-60},{-168,-60}}, color={0,0,127}));
  connect(swi1.u2, effMod.yPumWatHex) annotation (Line(points={{180,-160},{134,
          -160},{134,86},{50,86}}, color={255,0,255}));
  connect(zer.y, swi1.u3) annotation (Line(points={{82,-180},{174,-180},{174,
          -168},{180,-168}}, color={0,0,127}));
  connect(swi1.y, yPumGlyHex)
    annotation (Line(points={{204,-160},{260,-160}}, color={0,0,127}));
  connect(booToRea5.y, yPumWatChi)
    annotation (Line(points={{202,-240},{260,-240}}, color={0,0,127}));
  connect(booToRea5.u, effMod.yPumWatChi) annotation (Line(points={{178,-240},{
          128,-240},{128,82},{50,82}}, color={255,0,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio = false, extent={{-240,-260},{240,
            240}}),                                                                          graphics={  Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent={{-240,
              240},{240,-260}}),                                                                                                                                                                                       Text(lineColor = {0, 0, 127}, extent={{-50,282},
              {50,238}},                                                                                                                                                                                                        textString = "%name")}),
    Diagram(coordinateSystem(preserveAspectRatio = false, extent={{-240,-260},{240,
            240}})));
end ControlClosedLoop;
