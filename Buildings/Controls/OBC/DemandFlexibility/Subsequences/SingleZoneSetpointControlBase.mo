within Buildings.Controls.OBC.DemandFlexibility.Subsequences;
block SingleZoneSetpointControlBase

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

  Buildings.Controls.OBC.DemandFlexibility.Subsequences.SingleTemperatureZoneSetpointControl
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
  Buildings.Controls.OBC.DemandFlexibility.Subsequences.SingleTemperatureZoneSetpointControl
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
    annotation (Line(points={{65,66.5},{94,66.5},{94,54},{120,54}},
                                                          color={255,0,255}));
  connect(sinTemSetConHea.TSetCom,TSetComHea)  annotation (Line(points={{65,
          62.125},{90,62.125},{90,20},{120,20}},
                                     color={0,0,127}));
  connect(sinTemSetConHea.reach_TSetNom,reach_TSetNomHea)
    annotation (Line(points={{65,58},{88,58},{88,-20},{120,-20}},
                                                        color={255,0,255}));
  connect(sinTemSetConCoo.reach_TSetTarShe,reach_TSetTarSheCoo)  annotation (
      Line(points={{13,-79.5},{13,-80},{94,-80},{94,-130},{120,-130}},
                                                   color={255,0,255}));
  connect(sinTemSetConCoo.TSetCom,TSetComCoo)  annotation (Line(points={{13,
          -83.875},{90,-83.875},{90,-178},{120,-178}},
                                        color={0,0,127}));
  connect(sinTemSetConCoo.reach_TSetNom,reach_TSetNomCoo)  annotation (Line(
        points={{13,-88},{88,-88},{88,-222},{120,-222}},
                                                  color={255,0,255}));
  connect(uMod, sinTemSetConHea.uMod) annotation (Line(points={{-120,54},{32,54},
          {32,69.25},{43,69.25}}, color={255,127,0}));
  connect(uMod, sinTemSetConCoo.uMod) annotation (Line(points={{-120,54},{-20,
          54},{-20,-76.75},{-9,-76.75}},
                                    color={255,127,0}));
  connect(con.y, logSwi.u2) annotation (Line(points={{-48,78},{-32,78},{-32,80},
          {-24,80}}, color={255,0,255}));
  connect(con1.y, logSwi.u3) annotation (Line(points={{-48,16},{-40,16},{-40,72},
          {-24,72}}, color={255,0,255}));
  connect(logSwi.y, sinTemSetConHea.have_pri) annotation (Line(points={{0,80},{
          32,80},{32,71.5},{43,71.5}},
                                color={255,0,255}));
  connect(logSwi1.y, sinTemSetConCoo.have_pri) annotation (Line(points={{-18,
          -152},{-16,-152},{-16,-74.5},{-9,-74.5}},
                                           color={255,0,255}));
  connect(con2.y, logSwi1.u2)
    annotation (Line(points={{-56,-152},{-42,-152}}, color={255,0,255}));
  connect(con1.y, logSwi1.u3) annotation (Line(points={{-48,16},{-48,-160},{-42,
          -160}}, color={255,0,255}));
  connect(TSetTarPreHea,sinTemSetConHea.TSetTarPre)  annotation (Line(points={{-120,
          -76},{-120,-44},{-10,-44},{-10,64},{34,64},{34,61.125},{42.9,61.125}},
        color={0,0,127}));
  connect(TSetTarSheHea,sinTemSetConHea.TSetTarShe)  annotation (Line(points={{-120,
          -112},{-16,-112},{-16,58},{42.9,58}},
                                            color={0,0,127}));
  connect(TSetNomHea,sinTemSetConHea.TSetNom)  annotation (Line(points={{-120,
          -146},{-12,-146},{-12,55},{42.9,55}},
                                           color={0,0,127}));
  connect(TSetCurHea,sinTemSetConHea.TSetCur)  annotation (Line(points={{-120,18},
          {-84,18},{-84,56},{-14,56},{-14,60},{34,60},{34,64.375},{43,64.375}},
                                                  color={0,0,127}));
  connect(TSetTarPreCoo,sinTemSetConCoo.TSetTarPre)  annotation (Line(points={{-120,
          -182},{-120,-84},{-36,-84},{-36,-84.875},{-9.1,-84.875}},
                                                   color={0,0,127}));
  connect(TSetTarSheCoo,sinTemSetConCoo.TSetTarShe)  annotation (Line(points={{-120,
          -222},{-120,-196},{-84,-196},{-84,-136},{-44,-136},{-44,-132},{-18,
          -132},{-18,-88},{-9.1,-88}},           color={0,0,127}));
  connect(TSetNomCoo,sinTemSetConCoo.TSetNom)  annotation (Line(points={{-120,
          -256},{-120,-182},{-88,-182},{-88,-98},{-22,-98},{-22,-94},{-20,-94},
          {-20,-91},{-9.1,-91}},                                     color={0,0,
          127}));
  connect(TSetCurCoo, sinTemSetConCoo.TSetCur) annotation (Line(points={{-120,
          -40},{-74,-40},{-74,-88},{-22,-88},{-22,-81.625},{-9,-81.625}},
                                       color={0,0,127}));
  connect(TCur, sinTemSetConCoo.TCur) annotation (Line(points={{-120,-12},{-120,
          -26},{-46,-26},{-46,-86},{-24,-86},{-24,-79},{-9,-79}},
                                                        color={0,0,127}));
  connect(TCur, sinTemSetConHea.TCur) annotation (Line(points={{-120,-12},{-120,
          -26},{-46,-26},{-46,-46},{34,-46},{34,67},{43,67}},        color={0,0,
          127}));
  connect(sinTemSetConHea.reach_TSetTarPre, reach_TSetTarPreHea)
    annotation (Line(points={{65,70.5},{65,92},{120,92}}, color={255,0,255}));
  connect(sinTemSetConCoo.reach_TSetTarPre, reach_TSetTarPreCoo) annotation (
      Line(points={{13,-75.5},{13,-74},{94,-74},{94,-76},{120,-76}},
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
<p><span style=\"font-size: 9pt;\">This is a utility block that controls both the cooling setpoint and the heating setpoint for a single building zone. It reference the sub-block </span>SingleTemperatureZoneSetpointControl twice, one for the heating setpoint and one for the cooling setpoint. </p>
<p>This block will be referenced by the main blocks SingleZoneSetpointControl and MultipleZoneSetpointControl. For SingleZoneSetpointControl, this block is called once with variables have_priHea and have_priCoo setting to true. For MultipleZoneSetpointControl, this block is called the same amount of times as the number of zones to control temperature setpoints. </p>
</html>"));
end SingleZoneSetpointControlBase;
