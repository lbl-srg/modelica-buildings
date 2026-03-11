within Buildings.Controls.OBC.DemandFlexibility;
block SingleZoneSetpointControl

  parameter Boolean demFleHeaAct=true "the demand flexibility for heating is active";
    parameter Boolean demFleCooAct=true "the demand flexibility for cooling is active";

       parameter Real delChaSheHea=-1
    "Change amount for ratchet for heating";

   parameter Real delChaRebHea=1
    "Change amount for rebound for heating";
        parameter Real samPerPreHea(unit="s")=300
    "Sample period for preheat";
            parameter Real samPerNomHea(unit="s")=300
    "Sample period for the nominal condition for heating";
        parameter Real samPerSheHea(unit="s")=300
    "Sample period for ratche for heatingt";
        parameter Real samPerRebHea(unit="s")=300
    "Sample period for rebound for heating";

    parameter Real delSheThoHea=0.5
    "Threshold below which heating ratcheting is triggerd. This is an absolute value, so it is always positive";

        parameter Real delSheThoCoo=0.5
    "Threshold below which cooling ratcheting is triggerd. This is an absolute value, so it is always positive";

       parameter Real delChaSheCoo=1
    "Change amount for ratchet for cooling";

   parameter Real delChaRebCoo=-1
    "Change amount for rebound for cooling";
        parameter Real samPerPreCoo(unit="s")=300
    "Sample period for precool";
            parameter Real samPerNomCoo(unit="s")=300
    "Sample period for the nominal condition for cooling";
        parameter Real samPerSheCoo(unit="s")=300
    "Sample period for ratchet for cooling";
        parameter Real samPerRebCoo(unit="s")=300
    "Sample period for rebound for cooling";

  Buildings.Controls.OBC.DemandFlexibility.Subsequences.SingleTemperatureSetpointControl
    sinTemSetConHea(
    delChaShe=delChaSheHea,
    delChaReb=delChaRebHea,
    delSheTho=delSheThoHea,
    setMod=true,
    samPerPre=samPerPreHea,
    samPerNom=samPerNomHea,
    samPerShe=samPerSheHea,
    samPerReb=samPerRebHea) "single temperature setpoint control for heating"
    annotation (Placement(transformation(extent={{44,54},{64,74}})));
  CDL.Interfaces.BooleanInput have_priHea "have priority" annotation (Placement(
        transformation(extent={{-140,100},{-100,140}}), iconTransformation(
          extent={{-140,92},{-100,132}})));
  CDL.Interfaces.IntegerInput uMod
    "setpoint mode; 0 = normal; -1 = precool or preheat; 1 = ratchet; 2 = rebound"
    annotation (Placement(transformation(extent={{-140,34},{-100,74}}),
        iconTransformation(extent={{-140,26},{-100,66}})));
  CDL.Interfaces.RealInput TSetTarPreHea "setpoint target for preheat"
    annotation (Placement(transformation(extent={{-140,-96},{-100,-56}}),
        iconTransformation(extent={{-140,-96},{-100,-56}})));
  CDL.Interfaces.RealInput TSetTarSheHea "setpoint target for load shed"
    annotation (Placement(transformation(extent={{-140,-132},{-100,-92}}),
        iconTransformation(extent={{-140,-132},{-100,-92}})));
  CDL.Interfaces.RealInput TSetNomHea "nominal setpoint"
    annotation (Placement(transformation(extent={{-140,-166},{-100,-126}}),
        iconTransformation(extent={{-140,-166},{-100,-126}})));
  CDL.Interfaces.RealInput TSetCurHea "current setpoint"
    annotation (Placement(transformation(extent={{-140,-2},{-100,38}}),
        iconTransformation(extent={{-140,-2},{-100,38}})));
  Buildings.Controls.OBC.DemandFlexibility.Subsequences.SingleTemperatureSetpointControl
    sinTemSetConCoo(
    delChaShe=delChaSheCoo,
    delChaReb=delChaRebCoo,
    delSheTho=delSheThoCoo,
    setMod=false,
    samPerPre=samPerPreCoo,
    samPerNom=samPerNomCoo,
    samPerShe=samPerSheCoo,
    samPerReb=samPerRebCoo) "single temperature setpoint control for cooling"
    annotation (Placement(transformation(extent={{-8,-92},{12,-72}})));
  CDL.Interfaces.RealInput TSetTarPreCoo "setpoint target for precool"
    annotation (Placement(transformation(extent={{-140,-202},{-100,-162}})));
  CDL.Interfaces.RealInput TSetTarSheCoo "setpoint target for load shed"
    annotation (Placement(transformation(extent={{-140,-242},{-100,-202}})));
  CDL.Interfaces.RealInput TSetNomCoo "nominal setpoint"
    annotation (Placement(transformation(extent={{-140,-276},{-100,-236}})));
  CDL.Interfaces.BooleanOutput reach_TSetTarSheHea annotation (Placement(
        transformation(extent={{100,34},{140,74}}),  iconTransformation(extent={{100,34},
            {140,74}})));
  CDL.Interfaces.RealOutput TSetComHea "setpoint command" annotation (Placement(
        transformation(extent={{100,0},{140,40}}),  iconTransformation(extent={{100,0},
            {140,40}})));
  CDL.Interfaces.BooleanOutput reach_TSetNomHea annotation (Placement(
        transformation(extent={{100,-40},{140,0}}),  iconTransformation(extent={{100,-40},
            {140,0}})));
  CDL.Interfaces.BooleanOutput reach_TSetTarSheCoo annotation (Placement(
        transformation(extent={{100,-150},{140,-110}}),
                                                      iconTransformation(extent={{100,
            -150},{140,-110}})));
  CDL.Interfaces.BooleanOutput reach_TSetNomCoo annotation (Placement(
        transformation(extent={{100,-242},{140,-202}}), iconTransformation(
          extent={{100,-184},{140,-144}})));
  CDL.Interfaces.RealOutput TSetComCoo "setpoint command"
    annotation (Placement(transformation(extent={{100,-198},{140,-158}}),
        iconTransformation(extent={{100,-198},{140,-158}})));
  CDL.Logical.Sources.Constant con(k=demFleHeaAct)
    annotation (Placement(transformation(extent={{-70,68},{-50,88}})));
  CDL.Logical.Switch logSwi
    annotation (Placement(transformation(extent={{-22,70},{-2,90}})));
  CDL.Logical.Sources.Constant con1(k=false)
    annotation (Placement(transformation(extent={{-70,6},{-50,26}})));
  CDL.Logical.Sources.Constant con2(k=demFleCooAct)
    annotation (Placement(transformation(extent={{-78,-162},{-58,-142}})));
  CDL.Logical.Switch logSwi1
    annotation (Placement(transformation(extent={{-40,-162},{-20,-142}})));
  CDL.Interfaces.RealInput TSetCurCoo "current setpoint"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  CDL.Interfaces.RealInput TCur "current zone temperature"
    annotation (Placement(transformation(extent={{-140,-32},{-100,8}}),
        iconTransformation(extent={{-140,-32},{-100,8}})));
  CDL.Interfaces.BooleanOutput reach_TSetTarPreHea annotation (Placement(
        transformation(extent={{100,72},{140,112}}), iconTransformation(extent={
            {100,76},{140,116}})));
  CDL.Interfaces.BooleanOutput reach_TSetTarPreCoo annotation (Placement(
        transformation(extent={{100,-96},{140,-56}}), iconTransformation(extent
          ={{100,-108},{140,-68}})));
  CDL.Interfaces.BooleanInput have_priCoo "have priority" annotation (Placement(
        transformation(extent={{-140,64},{-100,104}}), iconTransformation(
          extent={{-140,60},{-100,100}})));
equation
  connect(sinTemSetConHea.reach_TSetTarShe,reach_TSetTarSheHea)
    annotation (Line(points={{65.1429,67.3333},{94,67.3333},{94,54},{120,54}},
                                                          color={255,0,255}));
  connect(sinTemSetConHea.TSetCom,TSetComHea)  annotation (Line(points={{65.1429,
          62.6667},{90,62.6667},{90,20},{120,20}},
                                     color={0,0,127}));
  connect(sinTemSetConHea.reach_TSetNom,reach_TSetNomHea)
    annotation (Line(points={{56.5714,58.1333},{88,58.1333},{88,-20},{120,-20}},
                                                        color={255,0,255}));
  connect(sinTemSetConCoo.reach_TSetTarShe,reach_TSetTarSheCoo)  annotation (
      Line(points={{13.1429,-78.6667},{13.1429,-80},{94,-80},{94,-130},{120,
          -130}},                                  color={255,0,255}));
  connect(sinTemSetConCoo.TSetCom,TSetComCoo)  annotation (Line(points={{13.1429,
          -83.3333},{90,-83.3333},{90,-178},{120,-178}},
                                        color={0,0,127}));
  connect(sinTemSetConCoo.reach_TSetNom,reach_TSetNomCoo)  annotation (Line(
        points={{4.57143,-87.8667},{88,-87.8667},{88,-222},{120,-222}},
                                                  color={255,0,255}));
  connect(uMod, sinTemSetConHea.uMod) annotation (Line(points={{-120,54},{32,54},
          {32,70.4},{42.8571,70.4}},
                                  color={255,127,0}));
  connect(uMod, sinTemSetConCoo.uMod) annotation (Line(points={{-120,54},{-20,
          54},{-20,-75.6},{-9.14286,-75.6}},
                                    color={255,127,0}));
  connect(con.y, logSwi.u2) annotation (Line(points={{-48,78},{-32,78},{-32,80},
          {-24,80}}, color={255,0,255}));
  connect(con1.y, logSwi.u3) annotation (Line(points={{-48,16},{-40,16},{-40,72},
          {-24,72}}, color={255,0,255}));
  connect(logSwi.y, sinTemSetConHea.have_pri) annotation (Line(points={{0,80},{
          32,80},{32,72.6667},{42.8571,72.6667}},
                                color={255,0,255}));
  connect(logSwi1.y, sinTemSetConCoo.have_pri) annotation (Line(points={{-18,
          -152},{-16,-152},{-16,-73.3333},{-9.14286,-73.3333}},
                                           color={255,0,255}));
  connect(con2.y, logSwi1.u2)
    annotation (Line(points={{-56,-152},{-42,-152}}, color={255,0,255}));
  connect(con1.y, logSwi1.u3) annotation (Line(points={{-48,16},{-48,-160},{-42,
          -160}}, color={255,0,255}));
  connect(TSetTarPreHea,sinTemSetConHea.TSetTarPre)  annotation (Line(points={{-120,
          -76},{-120,-44},{-10,-44},{-10,64},{34,64},{34,61.6},{42.8571,61.6}},
        color={0,0,127}));
  connect(TSetTarSheHea,sinTemSetConHea.TSetTarShe)  annotation (Line(points={{-120,
          -112},{-16,-112},{-16,58.2667},{42.8571,58.2667}},
                                            color={0,0,127}));
  connect(TSetNomHea,sinTemSetConHea.TSetNom)  annotation (Line(points={{-120,
          -146},{-12,-146},{-12,55.0667},{42.8571,55.0667}},
                                           color={0,0,127}));
  connect(TSetCurHea,sinTemSetConHea.TSetCur)  annotation (Line(points={{-120,18},
          {-84,18},{-84,56},{-14,56},{-14,60},{34,60},{34,65.0667},{42.8571,
          65.0667}},                              color={0,0,127}));
  connect(TSetTarPreCoo,sinTemSetConCoo.TSetTarPre)  annotation (Line(points={{-120,
          -182},{-120,-84},{-36,-84},{-36,-84.4},{-9.14286,-84.4}},
                                                   color={0,0,127}));
  connect(TSetTarSheCoo,sinTemSetConCoo.TSetTarShe)  annotation (Line(points={{-120,
          -222},{-120,-196},{-84,-196},{-84,-136},{-44,-136},{-44,-132},{-18,
          -132},{-18,-87.7333},{-9.14286,-87.7333}},
                                                 color={0,0,127}));
  connect(TSetNomCoo,sinTemSetConCoo.TSetNom)  annotation (Line(points={{-120,
          -256},{-120,-182},{-88,-182},{-88,-98},{-22,-98},{-22,-94},{-20,-94},
          {-20,-90.9333},{-9.14286,-90.9333}},                       color={0,0,
          127}));
  connect(TSetCurCoo, sinTemSetConCoo.TSetCur) annotation (Line(points={{-120,
          -40},{-74,-40},{-74,-88},{-22,-88},{-22,-80.9333},{-9.14286,-80.9333}},
                                       color={0,0,127}));
  connect(TCur, sinTemSetConCoo.TCur) annotation (Line(points={{-120,-12},{-120,
          -26},{-46,-26},{-46,-86},{-24,-86},{-24,-78.1333},{-9.14286,-78.1333}},
                                                        color={0,0,127}));
  connect(TCur, sinTemSetConHea.TCur) annotation (Line(points={{-120,-12},{-120,
          -26},{-46,-26},{-46,-46},{34,-46},{34,67.8667},{42.8571,67.8667}},
                                                                     color={0,0,
          127}));
  connect(sinTemSetConHea.reach_TSetTarPre, reach_TSetTarPreHea)
    annotation (Line(points={{65.1429,71.6},{65.1429,92},{120,92}},
                                                          color={255,0,255}));
  connect(sinTemSetConCoo.reach_TSetTarPre, reach_TSetTarPreCoo) annotation (
      Line(points={{13.1429,-74.4},{13.1429,-74},{94,-74},{94,-76},{120,-76}},
                                                   color={255,0,255}));
  connect(have_priHea, logSwi.u1) annotation (Line(points={{-120,120},{-72,120},
          {-72,88},{-24,88}}, color={255,0,255}));
  connect(have_priCoo, logSwi1.u1) annotation (Line(points={{-120,84},{-88,84},{
          -88,24},{-78,24},{-78,-100},{-34,-100},{-34,-136},{-42,-136},{-42,-144}},
        color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -260},{100,120}})),
                          Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-260},{100,120}})),
    Documentation(info="<html>
<p><span style=\"font-size: 9pt;\">This block controls the cooling setpoint and the heating setpoint for a single building zone.</span></p>
</html>"));
end SingleZoneSetpointControl;
