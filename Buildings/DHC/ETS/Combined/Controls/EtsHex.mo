within Buildings.DHC.ETS.Combined.Controls;
model EtsHex
  extends Modelica.Blocks.Icons.Block;
  Buildings.Controls.OBC.CDL.Logical.Nor opeEtsHex
    "Output true to operate ETS heat exchanger"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal uEtsHex(realTrue=0,
      realFalse=1) "Control signal for ETS heat exchanger"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y annotation (Placement(
        transformation(rotation=0, extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Logical.And botTanCha
    "Output true if both tanks charge"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer(k=0) "Outputs zero"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yVal1 "Valve position"
    annotation (Placement(transformation(rotation=0, extent={{-140,-40},{-100,0}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yVal2 "Valve position"
    annotation (Placement(transformation(rotation=0, extent={{-142,-80},{-102,
            -40}}),
        iconTransformation(extent={{-140,-102},{-100,-62}})));
  Buildings.Controls.OBC.CDL.Reals.Add add2
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr(t=0.3, h=0.05)
    "Outputs true if at least one valve is partially open"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1
    "Charge signal from tank 1" annotation (Placement(transformation(extent={{
            -140,40},{-100,80}}), iconTransformation(extent={{-140,58},{-100,98}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u2
    "Charge signal from tank 2" annotation (Placement(transformation(extent={{
            -140,0},{-100,40}}), iconTransformation(extent={{-140,20},{-100,60}})));
equation
  connect(opeEtsHex.y,uEtsHex. u)
    annotation (Line(points={{-38,0},{-22,0}},       color={255,0,255}));
  connect(u1, opeEtsHex.u1) annotation (Line(points={{-120,60},{-80,60},{-80,0},
          {-62,0}}, color={255,0,255}));
  connect(u2, opeEtsHex.u2) annotation (Line(points={{-120,20},{-80,20},{-80,-8},
          {-62,-8}}, color={255,0,255}));
  connect(u1, botTanCha.u1) annotation (Line(points={{-120,60},{-74,60},{-74,
          -30},{-62,-30}},
                      color={255,0,255}));
  connect(u2, botTanCha.u2) annotation (Line(points={{-120,20},{-74,20},{-74,
          -38},{-62,-38}},
                      color={255,0,255}));
  connect(swi.y, y) annotation (Line(points={{82,0},{110,0}},
        color={0,0,127}));
  connect(yVal1, add2.u1) annotation (Line(points={{-120,-20},{-90,-20},{-90,
          -64},{-82,-64}},
                      color={0,0,127}));
  connect(yVal2, add2.u2) annotation (Line(points={{-122,-60},{-96,-60},{-96,
          -76},{-82,-76}},
                      color={0,0,127}));
  connect(greThr.u, add2.y)
    annotation (Line(points={{-42,-70},{-58,-70}}, color={0,0,127}));
  connect(swi.u1, uEtsHex.y)
    annotation (Line(points={{58,8},{8,8},{8,0},{2,0}}, color={0,0,127}));
  connect(greThr.y, swi.u2) annotation (Line(points={{-18,-70},{14,-70},{14,0},{
          58,0}}, color={255,0,255}));
  connect(zer.y, swi.u3) annotation (Line(points={{42,-30},{50,-30},{50,-8},{58,
          -8}}, color={0,0,127}));
end EtsHex;
