within Buildings.Controls.OBC.DemandFlexibility.Subsequences;
block OneZoneRatchetHeating "one_zone_ratchet_heating"

      parameter Real samplePeriodRatchet(unit="s")=300
    "Sample period of the demand flexibility control";
          parameter Real samplePeriodRebound(unit="s")=900
    "Sample period of rebound";
     parameter Real TRatThreshold=0.5
    "Threshold of zone air temperature setpoint difference below which ratcheting is triggerd";

           parameter Real TRat=-1
    "Ratcheting temperature";
           parameter Real TReb=1
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
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TZonSetHeaCom(
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
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonHeaSetCur(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Current zone temperature setpoint" annotation (Placement(transformation(
          extent={{-240,-110},{-200,-70}}), iconTransformation(extent={{-240,-110},
            {-200,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput reach_TZonHeaSetMin
    annotation (Placement(transformation(extent={{300,-114},{340,-74}}),
        iconTransformation(extent={{300,-114},{340,-74}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput reach_TZonHeaSetNom
    annotation (Placement(transformation(extent={{300,-156},{340,-116}}),
        iconTransformation(extent={{300,-156},{340,-116}})));
  Buildings.Controls.OBC.CDL.Discrete.Sampler sam(samplePeriod=
        samplePeriodRatchet)
    annotation (Placement(transformation(extent={{188,56},{208,76}})));
  Buildings.Controls.OBC.CDL.Reals.Add add
    annotation (Placement(transformation(extent={{60,34},{80,54}})));
  Buildings.Controls.OBC.CDL.Discrete.Sampler sam1(samplePeriod=
        samplePeriodRebound)
    annotation (Placement(transformation(extent={{188,10},{208,30}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1
    "Switch to zero adjustment when window is open"
    annotation (Placement(transformation(extent={{224,28},{244,48}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonHeaSetMin(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "thermal limit zone temperature setpoint" annotation (Placement(
        transformation(extent={{-240,-154},{-200,-114}}), iconTransformation(
          extent={{-240,-144},{-200,-104}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonHeaSetNom(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "nominal zone temperature setpoint" annotation (Placement(transformation(
          extent={{-240,-194},{-200,-154}}), iconTransformation(extent={{-240,-180},
            {-200,-140}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal
                                          booToRea1(realTrue=TReb, realFalse=0)
    annotation (Placement(transformation(extent={{-42,-68},{-22,-48}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal
                                          booToRea(realTrue=-TRat,realFalse=0)
    annotation (Placement(transformation(extent={{-44,34},{-24,54}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi6
    "Switch to zero adjustment when window is open"
    annotation (Placement(transformation(extent={{20,34},{40,54}})));
  Buildings.Controls.OBC.CDL.Reals.Max max1
    annotation (Placement(transformation(extent={{126,34},{146,54}})));
  Buildings.Controls.OBC.CDL.Reals.Min min1
    annotation (Placement(transformation(extent={{92,34},{112,54}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract subt
    annotation (Placement(transformation(extent={{-172,-38},{-152,-18}})));
  Buildings.Controls.OBC.CDL.Reals.Less    les1
    annotation (Placement(transformation(extent={{136,-214},{156,-194}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{178,-214},{198,-194}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    annotation (Placement(transformation(extent={{176,-104},{196,-84}})));
  Buildings.Controls.OBC.CDL.Reals.Greater
                                        gre3
    annotation (Placement(transformation(extent={{134,-104},{154,-84}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold    lesThr(t=TRatThreshold, h=0)
    annotation (Placement(transformation(extent={{-140,-38},{-120,-18}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    annotation (Placement(transformation(extent={{-90,18},{-70,38}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3
    annotation (Placement(transformation(extent={{-174,70},{-154,90}})));
  Buildings.Controls.OBC.CDL.Logical.Not not4
    annotation (Placement(transformation(extent={{-94,72},{-74,92}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(delayTime=reboundDuration)
    annotation (Placement(transformation(extent={{-134,70},{-114,90}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi2
    annotation (Placement(transformation(extent={{254,6},{274,26}})));
equation
  connect(sam.y, swi1.u1) annotation (Line(points={{210,66},{222,66},{222,46}},
                color={0,0,127}));
  connect(sam1.y, swi1.u3) annotation (Line(points={{210,20},{222,20},{222,30}},
                    color={0,0,127}));
  connect(loaShe, swi6.u2) annotation (Line(points={{-220,52},{-96,52},{-96,8},
          {2,8},{2,44},{18,44}}, color={255,0,255}));
  connect(swi6.y, add.u1) annotation (Line(points={{42,44},{50,44},{50,50},{58,
          50}}, color={0,0,127}));
  connect(add.y, min1.u1) annotation (Line(points={{82,44},{90,44},{90,50}},
                    color={0,0,127}));
  connect(max1.u1, min1.y) annotation (Line(points={{124,50},{120,50},{120,44},
          {114,44}}, color={0,0,127}));
  connect(sam.u, max1.y) annotation (Line(points={{186,66},{158,66},{158,44},{
          148,44}}, color={0,0,127}));
  connect(max1.y, sam1.u) annotation (Line(points={{148,44},{158,44},{158,66},{
          178,66},{178,20},{186,20}},
                    color={0,0,127}));
  connect(TZon, subt.u1) annotation (Line(points={{-220,-58},{-182,-58},{-182,
          -22},{-174,-22}},color={0,0,127}));
  connect(les1.y, not1.u)
    annotation (Line(points={{158,-204},{176,-204}}, color={255,0,255}));
  connect(gre3.y, not2.u) annotation (Line(
      points={{156,-94},{174,-94}},
      color={255,0,255},
      smooth=Smooth.Bezier));
  connect(swi1.u2, loaShe) annotation (Line(points={{222,38},{212,38},{212,100},
          {-190,100},{-190,52},{-220,52}},          color={255,0,255}));
  connect(TZonHeaSetCur, gre3.u1) annotation (Line(points={{-220,-90},{-178,-90},
          {-178,-116},{50,-116},{50,-94},{132,-94}}, color={0,0,127}));
  connect(TZonHeaSetCur, les1.u1) annotation (Line(points={{-220,-90},{-220,-92},
          {-180,-92},{-180,-116},{52,-116},{52,-96},{124,-96},{124,-204},{134,-204}},
        color={0,0,127}));
  connect(subt.u2, TZonHeaSetCur) annotation (Line(points={{-174,-34},{-194,-34},
          {-194,-90},{-220,-90}},                   color={0,0,127}));
  connect(add.u2, TZonHeaSetCur) annotation (Line(points={{58,38},{50,38},{50,
          -90},{-220,-90}},                   color={0,0,127}));
  connect(subt.y, lesThr.u) annotation (Line(points={{-150,-28},{-142,-28}},
                                                  color={0,0,127}));
  connect(ratSig, and2.u2) annotation (Line(points={{-220,22},{-100,22},{-100,
          20},{-92,20}},  color={255,0,255}));
  connect(TZonHeaSetMin, gre3.u2) annotation (Line(points={{-220,-134},{-220,-128},
          {132,-128},{132,-102}},
                  color={0,0,127}));
  connect(TZonHeaSetNom, les1.u2) annotation (Line(points={{-220,-174},{-220,
          -176},{-140,-176},{-140,-192},{116,-192},{116,-208},{134,-208},{134,
          -212}}, color={0,0,127}));
  connect(not1.y, reach_TZonHeaSetNom) annotation (Line(points={{200,-204},{292,
          -204},{292,-136},{320,-136}}, color={255,0,255}));
  connect(not2.y, reach_TZonHeaSetMin)
    annotation (Line(points={{198,-94},{320,-94}}, color={255,0,255}));
  connect(TZonHeaSetNom, min1.u2) annotation (Line(points={{-220,-174},{-140,
          -174},{-140,-172},{-136,-172},{-136,-132},{68,-132},{68,28},{90,28},{
          90,38}},   color={0,0,127}));
  connect(TZonHeaSetMin, max1.u2) annotation (Line(points={{-220,-134},{-220,
          -128},{24,-128},{24,14},{124,14},{124,38}},color={0,0,127}));
  connect(lesThr.y, and2.u1) annotation (Line(points={{-118,-28},{-110,-28},{
          -110,28},{-92,28}},                                            color=
          {255,0,255}));
  connect(booToRea.y, swi6.u1) annotation (Line(points={{-22,44},{0,44},{0,52},
          {18,52}}, color={0,0,127}));
  connect(and2.y, booToRea.u) annotation (Line(points={{-68,28},{-54,28},{-54,
          44},{-46,44}}, color={255,0,255}));
  connect(rebSig, booToRea1.u) annotation (Line(points={{-220,-10},{-220,-12},{
          -180,-12},{-180,-64},{-52,-64},{-52,-58},{-44,-58}}, color={255,0,255}));
  connect(booToRea1.y, swi6.u3) annotation (Line(points={{-20,-58},{-20,-60},{
          -12,-60},{-12,36},{18,36}}, color={0,0,127}));
  connect(loaShe, not3.u) annotation (Line(points={{-220,52},{-186,52},{-186,80},
          {-176,80}}, color={255,0,255}));
  connect(not3.y, truDel.u)
    annotation (Line(points={{-152,80},{-136,80}}, color={255,0,255}));
  connect(truDel.y, not4.u) annotation (Line(points={{-112,80},{-104,80},{-104,
          82},{-96,82}}, color={255,0,255}));
  connect(swi1.y, swi2.u1)
    annotation (Line(points={{246,38},{252,38},{252,24}}, color={0,0,127}));
  connect(not4.y, swi2.u2) annotation (Line(points={{-72,82},{176,82},{176,6},{
          248,6},{248,16},{252,16}}, color={255,0,255}));
  connect(TZonHeaSetNom, swi2.u3) annotation (Line(points={{-220,-174},{-140,
          -174},{-140,-172},{-136,-172},{-136,-132},{68,-132},{68,8},{252,8}},
        color={0,0,127}));
  connect(swi2.y, TZonSetHeaCom) annotation (Line(points={{276,16},{294,16},{
          294,42},{320,42}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,-300},
            {300,100}},
        grid={2,2})),                                            Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-300},{300,100}},
        grid={2,2})));
end OneZoneRatchetHeating;
