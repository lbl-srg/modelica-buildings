within Buildings.Controls.OBC.DemandFlexibility.Subsequences;
block one_zone_ratchet_cooling "one_zone_ratchet_cooling"

      parameter Real samplePeriodRatchet(unit="s")=300
    "Sample period of the demand flexibility control";
          parameter Real samplePeriodRebound(unit="s")=900
    "Sample period of rebound";
     parameter Real TRatThreshold=0.5
    "Threshold of zone air temperature setpoint difference below which ratcheting is triggerd";
    parameter Real TRat=1
    "Ratcheting temperature";
               parameter Real TReb=-1
    "rebound temperature";
     parameter Real reboundDuration(unit="s")=3600;

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput loaShe
    "Load shed event flag" annotation (Placement(transformation(extent={{-240,32},
            {-200,72}}), iconTransformation(extent={{-240,32},{-200,72}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Current zone room air temperature" annotation (Placement(transformation(
          extent={{-240,-78},{-200,-38}}),  iconTransformation(extent={{-240,
            -78},{-200,-38}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TZonCooSetCom(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone temperature setpoint command" annotation (Placement(transformation(
          extent={{300,22},{340,62}}), iconTransformation(extent={{300,22},{340,
            62}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput ratSig annotation (
      Placement(transformation(extent={{-240,2},{-200,42}}), iconTransformation(
          extent={{-240,2},{-200,42}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput rebSig annotation (
      Placement(transformation(extent={{-240,-30},{-200,10}}),
        iconTransformation(extent={{-240,-30},{-200,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonCooSetCur(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Current zone temperature setpoint" annotation (Placement(transformation(
          extent={{-240,-110},{-200,-70}}), iconTransformation(extent={{-240,-110},
            {-200,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput reachTZonCooSetMax
    annotation (Placement(transformation(extent={{300,-114},{340,-74}}),
        iconTransformation(extent={{300,-114},{340,-74}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput reachTZonCooSetNom
    annotation (Placement(transformation(extent={{300,-156},{340,-116}}),
        iconTransformation(extent={{300,-156},{340,-116}})));
  Buildings.Controls.OBC.CDL.Discrete.Sampler sam(samplePeriod=
        samplePeriodRatchet)
    annotation (Placement(transformation(extent={{184,60},{204,80}})));
  Buildings.Controls.OBC.CDL.Reals.Add add
    annotation (Placement(transformation(extent={{70,34},{90,54}})));
  Buildings.Controls.OBC.CDL.Discrete.Sampler sam1(samplePeriod=
        samplePeriodRebound)
    annotation (Placement(transformation(extent={{184,14},{204,34}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1
    "Switch to zero adjustment when window is open"
    annotation (Placement(transformation(extent={{226,34},{246,54}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal
                                          booToRea1(realTrue=-TReb,realFalse=0)
    annotation (Placement(transformation(extent={{-70,-70},{-50,-50}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal
                                          booToRea(realTrue=TRat, realFalse=0)
    annotation (Placement(transformation(extent={{-46,52},{-26,72}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi6
    "Switch to zero adjustment when window is open"
    annotation (Placement(transformation(extent={{20,34},{40,54}})));
  Buildings.Controls.OBC.CDL.Reals.Max max1
    annotation (Placement(transformation(extent={{140,34},{160,54}})));
  Buildings.Controls.OBC.CDL.Reals.Min min1
    annotation (Placement(transformation(extent={{100,34},{120,54}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract subt
    annotation (Placement(transformation(extent={{-172,-40},{-152,-20}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr(t=-1*TRatThreshold,
      h=0)
    annotation (Placement(transformation(extent={{-140,-40},{-120,-20}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    annotation (Placement(transformation(extent={{-86,18},{-66,38}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonCooSetMax(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "thermal limit zone temperature setpoint" annotation (Placement(
        transformation(extent={{-236,-244},{-196,-204}}), iconTransformation(
          extent={{-240,-214},{-200,-174}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonCooSetNom(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "nominal zone temperature setpoint" annotation (Placement(transformation(
          extent={{-236,-284},{-196,-244}}), iconTransformation(extent={{-238,
            -250},{-198,-210}})));
  Buildings.Controls.OBC.CDL.Reals.Less    les
    annotation (Placement(transformation(extent={{138,-142},{158,-122}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3
    annotation (Placement(transformation(extent={{180,-142},{200,-122}})));
  Buildings.Controls.OBC.CDL.Reals.Greater gre2
    annotation (Placement(transformation(extent={{138,-252},{158,-232}})));
  Buildings.Controls.OBC.CDL.Logical.Not not4
    annotation (Placement(transformation(extent={{180,-252},{200,-232}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{-98,76},{-78,96}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(delayTime=reboundDuration)
    annotation (Placement(transformation(extent={{-138,74},{-118,94}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    annotation (Placement(transformation(extent={{-178,74},{-158,94}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi2
    annotation (Placement(transformation(extent={{260,-16},{280,4}})));
equation
  connect(sam.y, swi1.u1) annotation (Line(points={{206,70},{220,70},{220,52},{
          224,52}},
                color={0,0,127}));
  connect(sam1.y, swi1.u3) annotation (Line(points={{206,24},{220,24},{220,36},
          {224,36}},color={0,0,127}));
  connect(loaShe, swi6.u2) annotation (Line(points={{-220,52},{-96,52},{-96,8},
          {2,8},{2,44},{18,44}}, color={255,0,255}));
  connect(swi6.y, add.u1) annotation (Line(points={{42,44},{60,44},{60,50},{68,
          50}}, color={0,0,127}));
  connect(add.y, min1.u1) annotation (Line(points={{92,44},{98,44},{98,50}},
                    color={0,0,127}));
  connect(max1.u1, min1.y) annotation (Line(points={{138,50},{130,50},{130,44},
          {122,44}}, color={0,0,127}));
  connect(sam.u, max1.y) annotation (Line(points={{182,70},{172,70},{172,44},{
          162,44}}, color={0,0,127}));
  connect(max1.y, sam1.u) annotation (Line(points={{162,44},{172,44},{172,24},{
          182,24}}, color={0,0,127}));
  connect(TZon, subt.u1) annotation (Line(points={{-220,-58},{-184,-58},{-184,
          -24},{-174,-24}},color={0,0,127}));
  connect(swi1.u2, loaShe) annotation (Line(points={{224,44},{176,44},{176,50},
          {170,50},{170,80},{-68,80},{-68,52},{-220,52}},
                                                    color={255,0,255}));
  connect(subt.u2, TZonCooSetCur) annotation (Line(points={{-174,-36},{-182,-36},
          {-182,-90},{-220,-90}},                   color={0,0,127}));
  connect(add.u2, TZonCooSetCur) annotation (Line(points={{68,38},{50,38},{50,-116},
          {-178,-116},{-178,-90},{-220,-90}}, color={0,0,127}));
  connect(subt.y, greThr.u) annotation (Line(points={{-150,-30},{-142,-30}},
                                                  color={0,0,127}));
  connect(ratSig, and2.u2) annotation (Line(points={{-220,22},{-98,22},{-98,20},
          {-88,20}},      color={255,0,255}));
  connect(les.u1, TZonCooSetCur) annotation (Line(points={{136,-132},{124,-132},
          {124,-96},{52,-96},{52,-116},{-168,-116},{-168,-92},{-220,-92},{-220,-90}},
        color={0,0,127}));
  connect(gre2.u1, TZonCooSetCur) annotation (Line(points={{136,-242},{136,-244},
          {112,-244},{112,-96},{52,-96},{52,-116},{-168,-116},{-168,-92},{-220,-92},
          {-220,-90}}, color={0,0,127}));
  connect(TZonCooSetMax, les.u2) annotation (Line(points={{-216,-224},{-120,
          -224},{-120,-216},{98,-216},{98,-140},{136,-140}}, color={0,0,127}));
  connect(les.y, not3.u)
    annotation (Line(points={{160,-132},{178,-132}}, color={255,0,255}));
  connect(TZonCooSetNom, gre2.u2) annotation (Line(points={{-216,-264},{104,
          -264},{104,-250},{136,-250}},                       color={0,0,127}));
  connect(gre2.y, not4.u)
    annotation (Line(points={{160,-242},{178,-242}}, color={255,0,255}));
  connect(not3.y, reachTZonCooSetMax) annotation (Line(points={{202,-132},{288,-132},
          {288,-94},{320,-94}}, color={255,0,255}));
  connect(not4.y, reachTZonCooSetNom) annotation (Line(points={{202,-242},{292,-242},
          {292,-136},{320,-136}}, color={255,0,255}));
  connect(and2.y, booToRea.u) annotation (Line(points={{-64,28},{-54,28},{-54,
          54},{-56,54},{-56,62},{-48,62}},
                         color={255,0,255}));
  connect(booToRea.y, swi6.u1) annotation (Line(points={{-24,62},{8,62},{8,52},
          {18,52}}, color={0,0,127}));
  connect(greThr.y, and2.u1) annotation (Line(points={{-118,-30},{-102,-30},{
          -102,28},{-88,28}},  color={255,0,255}));
  connect(booToRea1.y, swi6.u3) annotation (Line(points={{-48,-60},{-38,-60},{
          -38,32},{8,32},{8,36},{18,36}}, color={0,0,127}));
  connect(rebSig, booToRea1.u) annotation (Line(points={{-220,-10},{-106,-10},{
          -106,-60},{-72,-60}}, color={255,0,255}));
  connect(TZonCooSetMax, min1.u2) annotation (Line(points={{-216,-224},{-120,
          -224},{-120,-216},{98,-216},{98,38}},
        color={0,0,127}));
  connect(TZonCooSetNom, max1.u2) annotation (Line(points={{-216,-264},{128,
          -264},{128,38},{138,38}}, color={0,0,127}));
  connect(loaShe, not2.u) annotation (Line(points={{-220,52},{-190,52},{-190,84},
          {-180,84}}, color={255,0,255}));
  connect(not2.y, truDel.u)
    annotation (Line(points={{-156,84},{-140,84}}, color={255,0,255}));
  connect(truDel.y, not1.u) annotation (Line(points={{-116,84},{-108,84},{-108,
          86},{-100,86}}, color={255,0,255}));
  connect(swi2.y, TZonCooSetCom) annotation (Line(points={{282,-6},{294,-6},{
          294,42},{320,42}}, color={0,0,127}));
  connect(swi1.y, swi2.u1)
    annotation (Line(points={{248,44},{258,44},{258,2}}, color={0,0,127}));
  connect(not1.y, swi2.u2) annotation (Line(points={{-76,86},{216,86},{216,-6},
          {258,-6}}, color={255,0,255}));
  connect(TZonCooSetNom, swi2.u3) annotation (Line(points={{-216,-264},{104,
          -264},{104,-250},{128,-250},{128,-14},{258,-14}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,-300},
            {300,100}},
        grid={2,2})),                                            Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-300},{300,100}},
        grid={2,2})));
end one_zone_ratchet_cooling;
