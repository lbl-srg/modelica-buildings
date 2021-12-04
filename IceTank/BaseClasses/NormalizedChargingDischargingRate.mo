within IceTank.BaseClasses;
model NormalizedChargingDischargingRate
  "Charging or discharging rate based on the curves"
  parameter Integer nCha=6 "Number of coefficients for charging qstar curve";
  parameter Real coeffCha[nCha]={1.99930278E-5,0,0,0,0,0} "Coefficients for charging qstar curve";
  parameter Real dtCha=15 "Time step of curve fitting data";

  parameter Integer nDisCha=6 "Number of coefficients for discharging qstar curve";
  parameter Real coeffDisCha[nDisCha]={5.54E-05,-0.000145679,9.28E-05,0.001126122,-0.0011012,0.000300544}
    "Coefficients for discharging qstar curve";
  parameter Real dtDisCha=15 "Time step of curve fitting data";

  qStar qStaCha(
    n=nCha,
    coeff=coeffCha,
    dt=dtCha) annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  qStar qStaDisCha(
    n=nDisCha,
    coeff=coeffDisCha,
    dt=dtDisCha)
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1
    annotation (Placement(transformation(extent={{66,40},{86,60}})));
  Modelica.Blocks.Sources.Constant const(k=0)
    annotation (Placement(transformation(extent={{-10,80},{10,100}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi2
    annotation (Placement(transformation(extent={{34,-10},{54,10}})));
  Modelica.Blocks.Interfaces.RealOutput qNor(final quantity="1")
    "Normalized heat transfer rate: charging when postive, discharge when negative"
                                    annotation (Placement(transformation(extent={{100,-10},
            {120,10}}),           iconTransformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput fraCha "Fraction of charge in ice tank"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput lmtdSta "Normalized LMTD"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.IntegerInput u
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Integers.LessEqualThreshold    dorMod(
    threshold=
     Integer(IceTank.Types.IceThermalStorageMode.Dormant))
    "Dormant mode"
    annotation (Placement(transformation(extent={{-70,80},{-50,100}})));
  Buildings.Controls.OBC.CDL.Integers.LessThreshold         chaMod(threshold=
        Integer(IceTank.Types.IceThermalStorageMode.Discharging))
    "Chargin mode"
    annotation (Placement(transformation(extent={{-70,50},{-50,70}})));

  Modelica.Blocks.Math.Gain neg(k=-1) "Negative"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));

  Modelica.Blocks.Math.Feedback Dif "Difference"
    annotation (Placement(transformation(extent={{-76,28},{-64,40}})));
  Modelica.Blocks.Sources.Constant Cha(k=1) "For charging mode"
    annotation (Placement(transformation(extent={{-92,30},{-84,38}})));
equation
  connect(const.y, swi1.u1) annotation (Line(points={{11,90},{20,90},{20,58},{64,
          58}}, color={0,0,127}));
  connect(qStaCha.qNor, swi2.u1)
    annotation (Line(points={{-19,30},{0,30},{0,8},{32,8}}, color={0,0,127}));
  connect(swi2.y, swi1.u3)
    annotation (Line(points={{56,0},{60,0},{60,42},{64,42}}, color={0,0,127}));
  connect(qStaCha.lmtdSta, lmtdSta) annotation (Line(points={{-42,26},{-50,26},
          {-50,-60},{-120,-60}},color={0,0,127}));
  connect(lmtdSta, qStaDisCha.lmtdSta) annotation (Line(points={{-120,-60},{-50,
          -60},{-50,-34},{-42,-34}}, color={0,0,127}));
  connect(dorMod.u, u) annotation (Line(points={{-72,90},{-90,90},{-90,60},{-120,
          60}}, color={255,127,0}));
  connect(dorMod.y, swi1.u2) annotation (Line(points={{-48,90},{-12,90},{-12,50},
          {64,50}}, color={255,0,255}));
  connect(chaMod.y, swi2.u2) annotation (Line(points={{-48,60},{-14,60},{-14,0},
          {32,0}}, color={255,0,255}));
  connect(u, chaMod.u)
    annotation (Line(points={{-120,60},{-72,60}}, color={255,127,0}));
  connect(neg.y, swi2.u3) annotation (Line(points={{21,-30},{26,-30},{26,-8},{32,
          -8}}, color={0,0,127}));
  connect(qStaDisCha.qNor, neg.u)
    annotation (Line(points={{-19,-30},{-2,-30}}, color={0,0,127}));
  connect(swi1.y, qNor) annotation (Line(points={{88,50},{94,50},{94,0},{110,0}},
        color={0,0,127}));
  connect(Cha.y, Dif.u1)
    annotation (Line(points={{-83.6,34},{-74.8,34}}, color={0,0,127}));
  connect(Dif.y, qStaCha.fraCha)
    annotation (Line(points={{-64.6,34},{-42,34}}, color={0,0,127}));
  connect(fraCha, Dif.u2) annotation (Line(points={{-120,0},{-70,0},{-70,29.2},
          {-70,29.2}}, color={0,0,127}));
  connect(fraCha, qStaDisCha.fraCha) annotation (Line(points={{-120,0},{-70,0},
          {-70,-26},{-42,-26}}, color={0,0,127}));
  annotation (defaultComponentName = "norQSta",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid), Text(
        extent={{-148,150},{152,110}},
        textString="%name",
        lineColor={0,0,255})}),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end NormalizedChargingDischargingRate;
