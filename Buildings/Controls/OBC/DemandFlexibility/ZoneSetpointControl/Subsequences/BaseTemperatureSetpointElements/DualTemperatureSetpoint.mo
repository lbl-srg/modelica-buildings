within Buildings.Controls.OBC.DemandFlexibility.ZoneSetpointControl.Subsequences.BaseTemperatureSetpointElements;
block DualTemperatureSetpoint

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

  Buildings.Controls.OBC.DemandFlexibility.ZoneSetpointControl.Subsequences.BaseTemperatureSetpointElements.SingleTemperatureSetpoint
    sinTemSetConHea(
    delChaShe=delChaSheHea,
    delChaReb=delChaRebHea,
    delSheTho=delSheThoHea,
    setMod=true,
    samPerPre=samPerPreHea,
    samPerNom=samPerNomHea,
    samPerShe=samPerSheHea,
    samPerReb=samPerRebHea) "single temperature setpoint control for heating"
    annotation (Placement(transformation(extent={{26,56},{46,76}})));
  CDL.Interfaces.BooleanInput have_priHea "have priority" annotation (Placement(
        transformation(extent={{-218,100},{-178,140}}), iconTransformation(
          extent={{-220,96},{-180,136}})));
  CDL.Interfaces.IntegerInput uMod
    "setpoint mode; 0 = normal; -1 = precool or preheat; 1 = ratchet; 2 = rebound"
    annotation (Placement(transformation(extent={{-218,34},{-178,74}}),
        iconTransformation(extent={{-220,30},{-180,70}})));
  CDL.Interfaces.RealInput TSetTarPreHea "setpoint target for preheat"
    annotation (Placement(transformation(extent={{-218,-96},{-178,-56}}),
        iconTransformation(extent={{-218,-96},{-178,-56}})));
  CDL.Interfaces.RealInput TSetTarSheHea "setpoint target for load shed"
    annotation (Placement(transformation(extent={{-218,-132},{-178,-92}}),
        iconTransformation(extent={{-218,-132},{-178,-92}})));
  CDL.Interfaces.RealInput TSetNomHea "nominal setpoint"
    annotation (Placement(transformation(extent={{-218,-166},{-178,-126}}),
        iconTransformation(extent={{-218,-166},{-178,-126}})));
  CDL.Interfaces.RealInput TSetCurHea "current setpoint"
    annotation (Placement(transformation(extent={{-218,-2},{-178,38}}),
        iconTransformation(extent={{-218,-2},{-178,38}})));
  Buildings.Controls.OBC.DemandFlexibility.ZoneSetpointControl.Subsequences.BaseTemperatureSetpointElements.SingleTemperatureSetpoint
    sinTemSetConCoo(
    delChaShe=delChaSheCoo,
    delChaReb=delChaRebCoo,
    delSheTho=delSheThoCoo,
    setMod=false,
    samPerPre=samPerPreCoo,
    samPerNom=samPerNomCoo,
    samPerShe=samPerSheCoo,
    samPerReb=samPerRebCoo) "single temperature setpoint control for cooling"
    annotation (Placement(transformation(extent={{24,-160},{44,-140}})));
  CDL.Interfaces.RealInput TSetTarPreCoo "setpoint target for precool"
    annotation (Placement(transformation(extent={{-218,-202},{-178,-162}})));
  CDL.Interfaces.RealInput TSetTarSheCoo "setpoint target for load shed"
    annotation (Placement(transformation(extent={{-218,-242},{-178,-202}})));
  CDL.Interfaces.RealInput TSetNomCoo "nominal setpoint"
    annotation (Placement(transformation(extent={{-218,-276},{-178,-236}})));
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
          extent={{100,-244},{140,-204}})));
  CDL.Interfaces.RealOutput TSetComCoo "setpoint command"
    annotation (Placement(transformation(extent={{100,-196},{140,-156}}),
        iconTransformation(extent={{100,-196},{140,-156}})));
  CDL.Logical.Sources.Constant con(k=demFleHeaAct)
    annotation (Placement(transformation(extent={{-116,82},{-96,102}})));
  CDL.Logical.Switch logSwi
    annotation (Placement(transformation(extent={{-20,92},{0,112}})));
  CDL.Logical.Sources.Constant con1(k=false)
    annotation (Placement(transformation(extent={{-72,-54},{-52,-34}})));
  CDL.Logical.Sources.Constant con2(k=demFleCooAct)
    annotation (Placement(transformation(extent={{-110,-250},{-90,-230}})));
  CDL.Logical.Switch logSwi1
    annotation (Placement(transformation(extent={{-16,-230},{4,-210}})));
  CDL.Interfaces.RealInput TSetCurCoo "current setpoint"
    annotation (Placement(transformation(extent={{-218,-60},{-178,-20}}),
        iconTransformation(extent={{-218,-60},{-178,-20}})));
  CDL.Interfaces.RealInput TCur "current zone temperature"
    annotation (Placement(transformation(extent={{-218,-32},{-178,8}}),
        iconTransformation(extent={{-218,-32},{-178,8}})));
  CDL.Interfaces.BooleanOutput reach_TSetTarPreHea annotation (Placement(
        transformation(extent={{100,72},{140,112}}), iconTransformation(extent={
            {100,76},{140,116}})));
  CDL.Interfaces.BooleanOutput reach_TSetTarPreCoo annotation (Placement(
        transformation(extent={{100,-96},{140,-56}}), iconTransformation(extent
          ={{100,-108},{140,-68}})));
  CDL.Interfaces.BooleanInput have_priCoo "have priority" annotation (Placement(
        transformation(extent={{-218,64},{-178,104}}), iconTransformation(
          extent={{-220,64},{-180,104}})));
equation
  connect(sinTemSetConHea.reach_TSetTarShe,reach_TSetTarSheHea)
    annotation (Line(points={{47,68.5},{86,68.5},{86,54},{120,54}},
                                                          color={255,0,255}));
  connect(sinTemSetConHea.TSetCom,TSetComHea)  annotation (Line(points={{47,
          64.125},{76,64.125},{76,20},{120,20}},
                                     color={0,0,127}));
  connect(sinTemSetConHea.reach_TSetNom,reach_TSetNomHea)
    annotation (Line(points={{47,60},{60,60},{60,-20},{120,-20}},
                                                        color={255,0,255}));
  connect(sinTemSetConCoo.reach_TSetTarShe,reach_TSetTarSheCoo)  annotation (
      Line(points={{45,-147.5},{45,-148},{90,-148},{90,-130},{120,-130}},
                                                   color={255,0,255}));
  connect(sinTemSetConCoo.TSetCom,TSetComCoo)  annotation (Line(points={{45,
          -151.875},{90,-151.875},{90,-176},{120,-176}},
                                        color={0,0,127}));
  connect(sinTemSetConCoo.reach_TSetNom,reach_TSetNomCoo)  annotation (Line(
        points={{45,-156},{66,-156},{66,-222},{120,-222}},
                                                  color={255,0,255}));
  connect(uMod, sinTemSetConHea.uMod) annotation (Line(points={{-198,54},{-170,
          54},{-170,71.25},{25,71.25}},
                                  color={255,127,0}));
  connect(uMod, sinTemSetConCoo.uMod) annotation (Line(points={{-198,54},{-106,
          54},{-106,-144},{22,-144},{22,-144.75},{23,-144.75}},
                                    color={255,127,0}));
  connect(con.y, logSwi.u2) annotation (Line(points={{-94,92},{-64,92},{-64,102},
          {-22,102}},color={255,0,255}));
  connect(con1.y, logSwi.u3) annotation (Line(points={{-50,-44},{-40,-44},{-40,
          94},{-22,94}},
                     color={255,0,255}));
  connect(logSwi.y, sinTemSetConHea.have_pri) annotation (Line(points={{2,102},
          {12,102},{12,73.5},{25,73.5}},
                                color={255,0,255}));
  connect(logSwi1.y, sinTemSetConCoo.have_pri) annotation (Line(points={{6,-220},
          {12,-220},{12,-142.5},{23,-142.5}},
                                           color={255,0,255}));
  connect(con2.y, logSwi1.u2)
    annotation (Line(points={{-88,-240},{-62,-240},{-62,-220},{-18,-220}},
                                                     color={255,0,255}));
  connect(con1.y, logSwi1.u3) annotation (Line(points={{-50,-44},{-40,-44},{-40,
          -228},{-18,-228}},
                  color={255,0,255}));
  connect(TSetTarSheHea,sinTemSetConHea.TSetTarShe)  annotation (Line(points={{-198,
          -112},{-84,-112},{-84,60},{24.9,60}},
                                            color={0,0,127}));
  connect(TSetNomHea,sinTemSetConHea.TSetNom)  annotation (Line(points={{-198,
          -146},{-140,-146},{-140,57},{24.9,57}},
                                           color={0,0,127}));
  connect(TSetTarPreCoo,sinTemSetConCoo.TSetTarPre)  annotation (Line(points={{-198,
          -182},{-162,-182},{-162,-152.875},{22.9,-152.875}},
                                                   color={0,0,127}));
  connect(TSetTarSheCoo,sinTemSetConCoo.TSetTarShe)  annotation (Line(points={{-198,
          -222},{-150,-222},{-150,-156},{22.9,-156}},
                                                 color={0,0,127}));
  connect(TSetCurCoo, sinTemSetConCoo.TSetCur) annotation (Line(points={{-198,
          -40},{-152,-40},{-152,-149.625},{23,-149.625}},
                                       color={0,0,127}));
  connect(TCur, sinTemSetConCoo.TCur) annotation (Line(points={{-198,-12},{-122,
          -12},{-122,-147},{23,-147}},                  color={0,0,127}));
  connect(TCur, sinTemSetConHea.TCur) annotation (Line(points={{-198,-12},{-122,
          -12},{-122,69},{25,69}},                                   color={0,0,
          127}));
  connect(sinTemSetConHea.reach_TSetTarPre, reach_TSetTarPreHea)
    annotation (Line(points={{47,72.5},{47,72},{60,72},{60,92},{120,92}},
                                                          color={255,0,255}));
  connect(sinTemSetConCoo.reach_TSetTarPre, reach_TSetTarPreCoo) annotation (
      Line(points={{45,-143.5},{45,-144},{66,-144},{66,-76},{120,-76}},
                                                   color={255,0,255}));
  connect(have_priHea, logSwi.u1) annotation (Line(points={{-198,120},{-150,120},
          {-150,110},{-22,110}},
                              color={255,0,255}));
  connect(have_priCoo, logSwi1.u1) annotation (Line(points={{-198,84},{-166,84},
          {-166,-212},{-18,-212}},
        color={255,0,255}));
  connect(TSetNomCoo, sinTemSetConCoo.TSetNom) annotation (Line(points={{-198,
          -256},{-140,-256},{-140,-159},{22.9,-159}}, color={0,0,127}));
  connect(TSetCurHea, sinTemSetConHea.TSetCur) annotation (Line(points={{-198,
          18},{-152,18},{-152,66.375},{25,66.375}}, color={0,0,127}));
  connect(TSetTarPreHea, sinTemSetConHea.TSetTarPre) annotation (Line(points={{
          -198,-76},{-94,-76},{-94,63.125},{24.9,63.125}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-180,
            -280},{100,140}})),
                          Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-180,-280},{100,140}})),
    Documentation(info="<html>
<p>This is a utility block that controls both the cooling setpoint and the heating setpoint for a 
single building zone. It reference the sub-block <code>SingleTemperatureZoneSetpointControl</code> 
twice, one for the heating setpoint and one for the cooling setpoint. </p>
<p>This block will be referenced by the main blocks SingleZoneSetpointControl and 
MultipleZoneSetpointControl. For SingleZoneSetpointControl, this block is called once with variables 
<code>have_priHea</code> and <code>have_priCoo</code> setting to true. For <code>MultipleZoneSetpointControl</code>, this block is called 
the same amount of times as the number of zones to control temperature setpoints. </p>
</html>"));
end DualTemperatureSetpoint;
