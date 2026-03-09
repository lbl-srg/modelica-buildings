within Buildings.Controls.OBC.DemandFlexibility;
block DualTemperatureSetpointControl

  parameter Boolean demFleHeaAct=true "the demand flexibility for heating is active";
    parameter Boolean demFleCooAct=true "the demand flexibility for cooling is active";

       parameter Real delChaRatHea=-1
    "Change amount for ratchet for heating";

   parameter Real delChaRebHea=1
    "Change amount for rebound for heating";
        parameter Real samPerPreHea(unit="s")=300
    "Sample period for preheat";
            parameter Real samPerNomHea(unit="s")=300
    "Sample period for the nominal condition for heating";
        parameter Real samPerRatHea(unit="s")=300
    "Sample period for ratche for heatingt";
        parameter Real samPerRebHea(unit="s")=300
    "Sample period for rebound for heating";

    parameter Real delRatThoHea=0.5
    "Threshold below which heating ratcheting is triggerd. This is an absolute value, so it is always positive";

        parameter Real delRatThoCoo=0.5
    "Threshold below which cooling ratcheting is triggerd. This is an absolute value, so it is always positive";

       parameter Real delChaRatCoo=1
    "Change amount for ratchet for cooling";

   parameter Real delChaRebCoo=-1
    "Change amount for rebound for cooling";
        parameter Real samPerPreCoo(unit="s")=300
    "Sample period for precool";
            parameter Real samPerNomCoo(unit="s")=300
    "Sample period for the nominal condition for cooling";
        parameter Real samPerRatCoo(unit="s")=300
    "Sample period for ratchet for cooling";
        parameter Real samPerRebCoo(unit="s")=300
    "Sample period for rebound for cooling";

  Buildings.Controls.OBC.DemandFlexibility.SingleTemperatureSetpointControl
    sinTemSetConHea(
    delChaRat=delChaRatHea,
    delChaReb=delChaRebHea,
    delRatTho=delRatThoHea,
    setMod=true,
    samPerPre=samPerPreHea,
    samPerNom=samPerNomHea,
    samPerRat=samPerRatHea,
    samPerReb=samPerRebHea) "single temperature setpoint control for heating"
    annotation (Placement(transformation(extent={{44,54},{64,74}})));
  CDL.Interfaces.BooleanInput
                           have_pri "have priority"
    annotation (Placement(transformation(extent={{-140,64},{-100,104}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  CDL.Interfaces.IntegerInput uMod
    "setpoint mode; 0 = normal; -1 = precool or preheat; 1 = ratchet; 2 = rebound"
    annotation (Placement(transformation(extent={{-140,34},{-100,74}}),
        iconTransformation(extent={{-140,26},{-100,66}})));
  CDL.Interfaces.RealInput TSetTarPreHea "setpoint target for preheat"
    annotation (Placement(transformation(extent={{-140,2},{-100,42}})));
  CDL.Interfaces.RealInput TSetTarSheHea "setpoint target for load shed"
    annotation (Placement(transformation(extent={{-140,-34},{-100,6}})));
  CDL.Interfaces.RealInput TSetNomHea "nominal setpoint"
    annotation (Placement(transformation(extent={{-140,-62},{-100,-22}})));
  CDL.Interfaces.RealInput TSetCurHea "current setpoint"
    annotation (Placement(transformation(extent={{-140,-86},{-100,-46}})));
  Buildings.Controls.OBC.DemandFlexibility.SingleTemperatureSetpointControl
    sinTemSetConCoo(
    delChaRat=delChaRatCoo,
    delChaReb=delChaRebCoo,
    delRatTho=delRatThoCoo,
    setMod=false,
    samPerPre=samPerPreCoo,
    samPerNom=samPerNomCoo,
    samPerRat=samPerRatCoo,
    samPerReb=samPerRebCoo) "single temperature setpoint control for cooling"
    annotation (Placement(transformation(extent={{-8,-92},{12,-72}})));
  CDL.Interfaces.RealInput TSetTarPreCoo "setpoint target for precool"
    annotation (Placement(transformation(extent={{-140,-150},{-100,-110}})));
  CDL.Interfaces.RealInput TSetTarSheCoo "setpoint target for load shed"
    annotation (Placement(transformation(extent={{-140,-176},{-100,-136}})));
  CDL.Interfaces.RealInput TSetNomCoo "nominal setpoint"
    annotation (Placement(transformation(extent={{-140,-212},{-100,-172}})));
  CDL.Interfaces.BooleanOutput reach_TSetTarSheHea annotation (Placement(
        transformation(extent={{100,60},{140,100}}), iconTransformation(extent={
            {100,60},{140,100}})));
  CDL.Interfaces.RealOutput TSetComHea "setpoint command" annotation (Placement(
        transformation(extent={{100,26},{140,66}}), iconTransformation(extent={{
            100,26},{140,66}})));
  CDL.Interfaces.BooleanOutput reach_TSetNomHea annotation (Placement(
        transformation(extent={{100,-14},{140,26}}), iconTransformation(extent={
            {100,-14},{140,26}})));
  CDL.Interfaces.BooleanOutput reach_TSetTarSheCoo annotation (Placement(
        transformation(extent={{100,-72},{140,-32}}), iconTransformation(extent
          ={{100,-72},{140,-32}})));
  CDL.Interfaces.BooleanOutput reach_TSetNomCoo annotation (Placement(
        transformation(extent={{100,-160},{140,-120}}), iconTransformation(
          extent={{100,-150},{140,-110}})));
  CDL.Interfaces.RealOutput TSetComCoo "setpoint command"
    annotation (Placement(transformation(extent={{100,-112},{140,-72}})));
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
    annotation (Placement(transformation(extent={{-140,-246},{-100,-206}})));
  CDL.Interfaces.RealInput TCur "current zone temperature"
    annotation (Placement(transformation(extent={{-140,-118},{-100,-78}})));
equation
  connect(sinTemSetConHea.reach_TSetTarShe,reach_TSetTarSheHea)
    annotation (Line(points={{66,71.2},{66,80},{120,80}}, color={255,0,255}));
  connect(sinTemSetConHea.TSetCom,TSetComHea)  annotation (Line(points={{66,64},
          {94,64},{94,46},{120,46}}, color={0,0,127}));
  connect(sinTemSetConHea.reach_TSetNom,reach_TSetNomHea)
    annotation (Line(points={{66,57.4},{66,6},{120,6}}, color={255,0,255}));
  connect(sinTemSetConCoo.reach_TSetTarShe,reach_TSetTarSheCoo)  annotation (
      Line(points={{14,-74.8},{14,-52},{120,-52}}, color={255,0,255}));
  connect(sinTemSetConCoo.TSetCom,TSetComCoo)  annotation (Line(points={{14,-82},
          {94,-82},{94,-92},{120,-92}}, color={0,0,127}));
  connect(sinTemSetConCoo.reach_TSetNom,reach_TSetNomCoo)  annotation (Line(
        points={{14,-88.6},{14,-140},{120,-140}}, color={255,0,255}));
  connect(uMod, sinTemSetConHea.uMod) annotation (Line(points={{-120,54},{32,54},
          {32,68.6},{42,68.6}},   color={255,127,0}));
  connect(uMod, sinTemSetConCoo.uMod) annotation (Line(points={{-120,54},{-20,54},
          {-20,-77.4},{-10,-77.4}}, color={255,127,0}));
  connect(con.y, logSwi.u2) annotation (Line(points={{-48,78},{-32,78},{-32,80},
          {-24,80}}, color={255,0,255}));
  connect(have_pri, logSwi.u1) annotation (Line(points={{-120,84},{-76,84},{-76,
          92},{-34,92},{-34,88},{-24,88}}, color={255,0,255}));
  connect(con1.y, logSwi.u3) annotation (Line(points={{-48,16},{-40,16},{-40,72},
          {-24,72}}, color={255,0,255}));
  connect(logSwi.y, sinTemSetConHea.have_pri) annotation (Line(points={{0,80},{32,
          80},{32,72},{42,72}}, color={255,0,255}));
  connect(logSwi1.y, sinTemSetConCoo.have_pri) annotation (Line(points={{-18,-152},
          {-16,-152},{-16,-74},{-10,-74}}, color={255,0,255}));
  connect(con2.y, logSwi1.u2)
    annotation (Line(points={{-56,-152},{-42,-152}}, color={255,0,255}));
  connect(have_pri, logSwi1.u1) annotation (Line(points={{-120,84},{-76,84},{-76,
          92},{-34,92},{-34,-136},{-42,-136},{-42,-144}}, color={255,0,255}));
  connect(con1.y, logSwi1.u3) annotation (Line(points={{-48,16},{-48,-160},{-42,
          -160}}, color={255,0,255}));
  connect(TSetTarPreHea,sinTemSetConHea.TSetTarPre)  annotation (Line(points={{-120,
          22},{-76,22},{-76,32},{32,32},{32,52},{34,52},{34,65.2},{42,65.2}},
        color={0,0,127}));
  connect(TSetTarSheHea,sinTemSetConHea.TSetTarShe)  annotation (Line(points={{-120,
          -14},{-16,-14},{-16,62},{42,62}}, color={0,0,127}));
  connect(TSetNomHea,sinTemSetConHea.TSetNom)  annotation (Line(points={{-120,
          -42},{-12,-42},{-12,58.8},{42,58.8}},
                                           color={0,0,127}));
  connect(TSetCurHea,sinTemSetConHea.TSetCur)  annotation (Line(points={{-120,
          -66},{12,-66},{12,30},{42,30},{42,55}}, color={0,0,127}));
  connect(TSetTarPreCoo,sinTemSetConCoo.TSetTarPre)  annotation (Line(points={{-120,
          -130},{-36,-130},{-36,-80.8},{-10,-80.8}},
                                                   color={0,0,127}));
  connect(TSetTarSheCoo,sinTemSetConCoo.TSetTarShe)  annotation (Line(points={{-120,
          -156},{-32,-156},{-32,-84},{-10,-84}}, color={0,0,127}));
  connect(TSetNomCoo,sinTemSetConCoo.TSetNom)  annotation (Line(points={{-120,-192},
          {-120,-132},{-30,-132},{-30,-87.2},{-10,-87.2}},           color={0,0,
          127}));
  connect(TSetCurCoo, sinTemSetConCoo.TSetCur) annotation (Line(points={{-120,-226},
          {-10,-226},{-10,-91}},       color={0,0,127}));
  connect(TCur, sinTemSetConCoo.TCur) annotation (Line(points={{-120,-98},{-38,-98},
          {-38,-78},{-24,-78},{-24,-95.6},{-10,-95.6}}, color={0,0,127}));
  connect(TCur, sinTemSetConHea.TCur) annotation (Line(points={{-120,-98},{-38,-98},
          {-38,-78},{-24,-78},{-24,34},{34,34},{34,50.4},{42,50.4}}, color={0,0,
          127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -260},{100,120}})),
                          Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-260},{100,120}})));
end DualTemperatureSetpointControl;
