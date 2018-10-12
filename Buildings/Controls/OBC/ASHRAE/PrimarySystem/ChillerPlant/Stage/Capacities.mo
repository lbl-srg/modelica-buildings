within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Stage;
block Capacities
  "Returns nominal capacities at current and one lower stage"

  parameter Real nomCapSta1(quantity="Power", unit="W") = 10000000
  "Nominal capacity of the first stage";

  parameter Real nomCapSta2(quantity="Power", unit="W") = 10000000
  "Nominal capacity of the second stage";

  parameter Real min_plr1 = 0.1
  "Minimum part load ratio for the first stage";

  CDL.Continuous.Sources.Constant chiSta1(k=nomCapSta1)
    "Nominal capacity of the first chiller stage"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  CDL.Continuous.Sources.Constant chiSta2(k=nomCapSta2)
    "Nominal capacity of the second chiller stage"
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));
  CDL.Interfaces.IntegerInput uChiSta "Chiller stage"
    annotation (Placement(transformation(extent={{-200,-20},{-160,20}})));
  CDL.Integers.Equal intEqu
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  CDL.Integers.Sources.Constant   stage1(k=1) "Stage 1"
    annotation (Placement(transformation(extent={{-140,-70},{-120,-50}})));
  CDL.Integers.Sources.Constant   stage2(k=2) "Stage 2"
    annotation (Placement(transformation(extent={{-140,-100},{-120,-80}})));

  CDL.Integers.Sources.Constant   stage0(k=0) "Stage 0"
    annotation (Placement(transformation(extent={{-140,-40},{-120,-20}})));
  CDL.Logical.Switch swi
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  CDL.Interfaces.RealOutput yCapNomSta "Nominal capacity of the current stage"
    annotation (Placement(transformation(extent={{160,30},{180,50}})));
  CDL.Interfaces.RealOutput yCapNomLowSta
    "Nominal capacity of the first lower stage"
    annotation (Placement(transformation(extent={{160,-50},{180,-30}})));
  CDL.Integers.Equal intEqu1
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  CDL.Integers.Equal intEqu2
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  CDL.Logical.Switch swi1
    annotation (Placement(transformation(extent={{12,20},{32,40}})));
  CDL.Logical.Switch swi2
    annotation (Placement(transformation(extent={{48,60},{68,80}})));
  CDL.Utilities.Assert assMes(message="The provided chiller stage is higher than the number of stages available")
    annotation (Placement(transformation(extent={{120,100},{140,120}})));
  CDL.Continuous.GreaterThreshold greThr(threshold=0.5)
    annotation (Placement(transformation(extent={{90,100},{110,120}})));
  CDL.Integers.LessEqual
                     intLesEqu
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  CDL.Logical.Switch swiLowSta1
    annotation (Placement(transformation(extent={{100,-60},{120,-40}})));
  CDL.Continuous.Product pro
    annotation (Placement(transformation(extent={{70,-50},{90,-30}})));
protected
  CDL.Continuous.Sources.Constant chiSta0(final k=0)
    "Nominal capacity of the 0th chiller stage"
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));
protected
  CDL.Continuous.Sources.Constant chiSta3(final k=0)
    "Nominal capacity of the 0th chiller stage"
    annotation (Placement(transformation(extent={{-8,102},{12,122}})));
protected
  CDL.Continuous.Sources.Constant minPlrSta1(final k=min_plr1)
    "Minimum part load ratio of the first stage"
    annotation (Placement(transformation(extent={{10,-20},{30,0}})));
equation
  connect(uChiSta, intEqu.u1)
    annotation (Line(points={{-180,0},{-82,0}}, color={255,127,0}));
  connect(stage0.y, intEqu.u2) annotation (Line(points={{-119,-30},{-100,-30},{-100,
          -8},{-82,-8}}, color={255,127,0}));
  connect(stage2.y, intEqu2.u2) annotation (Line(points={{-119,-90},{-114,-90},{
          -114,-98},{-82,-98}}, color={255,127,0}));
  connect(stage1.y, intEqu1.u2) annotation (Line(points={{-119,-60},{-100,-60},{
          -100,-58},{-82,-58}}, color={255,127,0}));
  connect(intEqu.y, swi.u2)
    annotation (Line(points={{-59,0},{-32,0}}, color={255,0,255}));
  connect(chiSta0.y, swi.u1) annotation (Line(points={{-99,90},{-40,90},{-40,8},
          {-32,8}}, color={0,0,127}));
  connect(chiSta1.y, swi.u3) annotation (Line(points={{-99,60},{-48,60},{-48,-8},
          {-32,-8}}, color={0,0,127}));
  connect(swi.y, swi1.u1)
    annotation (Line(points={{-9,0},{-6,0},{-6,38},{10,38}}, color={0,0,127}));
  connect(intEqu1.y, swi1.u2) annotation (Line(points={{-59,-50},{0,-50},{0,30},
          {10,30}}, color={255,0,255}));
  connect(chiSta2.y, swi1.u3) annotation (Line(points={{-99,30},{-50,30},{-50,22},
          {10,22}}, color={0,0,127}));
  connect(swi1.y, swi2.u1) annotation (Line(points={{33,30},{36,30},{36,78},{46,
          78}}, color={0,0,127}));
  connect(intEqu2.y, swi2.u2) annotation (Line(points={{-59,-90},{40,-90},{40,70},
          {46,70}}, color={255,0,255}));
  connect(swi2.u3, chiSta3.y) annotation (Line(points={{46,62},{24,62},{24,112},
          {13,112}}, color={0,0,127}));
  connect(swi2.y, greThr.u) annotation (Line(points={{69,70},{80,70},{80,110},{88,
          110}}, color={0,0,127}));
  connect(greThr.y, assMes.u)
    annotation (Line(points={{111,110},{118,110}}, color={255,0,255}));
  connect(uChiSta, intEqu1.u1) annotation (Line(points={{-180,0},{-94,0},{-94,-50},
          {-82,-50}}, color={255,127,0}));
  connect(uChiSta, intEqu2.u1) annotation (Line(points={{-180,0},{-106,0},{-106,
          -90},{-82,-90}}, color={255,127,0}));
  connect(swi2.y, yCapNomSta) annotation (Line(points={{69,70},{100,70},{100,40},
          {170,40}}, color={0,0,127}));
  connect(stage1.y, intLesEqu.u2) annotation (Line(points={{-119,-60},{-52,-60},
          {-52,-78},{-2,-78}}, color={255,127,0}));
  connect(uChiSta, intLesEqu.u1) annotation (Line(points={{-180,0},{-114,0},{-114,
          -24},{-18,-24},{-18,-70},{-2,-70}}, color={255,127,0}));
  connect(intLesEqu.y, swiLowSta1.u2) annotation (Line(points={{21,-70},{42,-70},
          {42,-50},{98,-50}}, color={255,0,255}));
  connect(chiSta1.y, swiLowSta1.u3) annotation (Line(points={{-99,60},{4,60},{4,
          -40},{30,-40},{30,-58},{98,-58}},
                          color={0,0,127}));
  connect(swiLowSta1.y, yCapNomLowSta) annotation (Line(points={{121,-50},{124,
          -50},{124,-40},{170,-40}}, color={0,0,127}));
  connect(pro.u2, minPlrSta1.y) annotation (Line(points={{68,-46},{60,-46},{60,
          -10},{31,-10}}, color={0,0,127}));
  connect(chiSta1.y, pro.u1) annotation (Line(points={{-99,60},{-2,60},{-2,-34},
          {68,-34}}, color={0,0,127}));
  connect(swiLowSta1.u1, pro.y) annotation (Line(points={{98,-42},{94,-42},{94,
          -40},{91,-40}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-160,-140},
            {160,140}})), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-160,-140},{160,140}})));
end Capacities;
