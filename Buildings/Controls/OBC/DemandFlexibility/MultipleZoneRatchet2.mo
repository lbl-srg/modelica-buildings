within Buildings.Controls.OBC.DemandFlexibility;
block MultipleZoneRatchet2



  parameter Integer nZon=4;
  CDL.Interfaces.IntegerInput uMod
    "setpoint mode; 0 = normal; -1 = precool or preheat; 1 = ratchet; 2 = rebound"
    annotation (Placement(transformation(extent={{-142,48},{-102,88}}),
        iconTransformation(extent={{-140,26},{-100,66}})));
  CDL.Interfaces.RealInput TSetTarPreHea[nZon] "setpoint target for preheat"
    annotation (Placement(transformation(extent={{-142,16},{-102,56}})));
  CDL.Interfaces.RealInput TSetTarSheHea[nZon] "setpoint target for load shed"
    annotation (Placement(transformation(extent={{-142,-20},{-102,20}})));
  CDL.Interfaces.RealInput TSetCurHea[nZon] "current setpoint"
    annotation (Placement(transformation(extent={{-142,-72},{-102,-32}})));
  CDL.Interfaces.RealInput TSetNomHea[nZon] "nominal setpoint"
    annotation (Placement(transformation(extent={{-142,-48},{-102,-8}})));
  CDL.Interfaces.RealInput TSetTarPreCoo[nZon] "setpoint target for precool"
    annotation (Placement(transformation(extent={{-142,-136},{-102,-96}})));
  CDL.Interfaces.RealInput TCur[nZon] "current zone temperature"
    annotation (Placement(transformation(extent={{-142,-102},{-102,-62}})));
  CDL.Interfaces.RealInput TSetTarSheCoo[nZon] "setpoint target for load shed"
    annotation (Placement(transformation(extent={{-142,-166},{-102,-126}})));
  CDL.Interfaces.RealInput TSetNomCoo[nZon] "nominal setpoint"
    annotation (Placement(transformation(extent={{-142,-202},{-102,-162}})));
  CDL.Interfaces.RealInput TSetCurCoo[nZon] "current setpoint"
    annotation (Placement(transformation(extent={{-142,-236},{-102,-196}})));
  CDL.Interfaces.BooleanOutput reach_TSetTarSheHea[nZon] annotation (Placement(
        transformation(extent={{262,24},{302,64}}),  iconTransformation(extent={
            {100,60},{140,100}})));
  CDL.Interfaces.RealOutput TSetComHea[nZon] "setpoint command" annotation (Placement(
        transformation(extent={{262,-10},{302,30}}),iconTransformation(extent={{
            100,26},{140,66}})));
  CDL.Interfaces.BooleanOutput reach_TSetNomHea[nZon] annotation (Placement(
        transformation(extent={{262,-50},{302,-10}}),iconTransformation(extent={
            {100,-14},{140,26}})));
  CDL.Interfaces.BooleanOutput reach_TSetTarSheCoo[nZon] annotation (Placement(
        transformation(extent={{262,-108},{302,-68}}),iconTransformation(extent
          ={{100,-72},{140,-32}})));
  CDL.Interfaces.BooleanOutput reach_TSetNomCoo[nZon] annotation (Placement(
        transformation(extent={{262,-196},{302,-156}}), iconTransformation(
          extent={{100,-150},{140,-110}})));
  CDL.Interfaces.RealOutput TSetComCoo[nZon] "setpoint command"
    annotation (Placement(transformation(extent={{262,-148},{302,-108}})));
  DualTemperatureSetpointControl dualTemperatureSetpointControl[nZon]
    annotation (Placement(transformation(extent={{84,-108},{206,64}})));
  CDL.Routing.IntegerScalarReplicator intScaRep(nout=nZon)
    annotation (Placement(transformation(extent={{-46,90},{-26,110}})));
  Subsequences.SelectSmallestTemperatureDifference2
    selectSmallestTemperatureDifferenceRatHea(nZon=nZon, nSel=1)
    annotation (Placement(transformation(extent={{-28,14},{-8,34}})));
  Subsequences.SelectSmallestTemperatureDifference2
    selectSmallestTemperatureDifferenceRebHea(nZon=nZon, nSel=1)
    annotation (Placement(transformation(extent={{-26,-28},{-6,-8}})));
  Subsequences.SelectSmallestTemperatureDifference2
    selectSmallestTemperatureDifferencePreHea(nZon=nZon, nSel=1)
    annotation (Placement(transformation(extent={{-26,46},{-6,66}})));
equation
  connect(uMod, intScaRep.u) annotation (Line(points={{-122,68},{-58,68},{-58,
          100},{-48,100}}, color={255,127,0}));
  connect(intScaRep.y, dualTemperatureSetpointControl.uMod) annotation (Line(
        points={{-24,100},{54,100},{54,30.5053},{71.8,30.5053}}, color={255,127,
          0}));
  connect(TCur, selectSmallestTemperatureDifferenceRatHea.TCur) annotation (
      Line(points={{-122,-82},{-32,-82},{-32,-50},{-38,-50},{-38,30},{-29.3793,
          30}}, color={0,0,127}));
  connect(TSetCurHea, selectSmallestTemperatureDifferenceRatHea.TSetCur)
    annotation (Line(points={{-122,-52},{-38,-52},{-38,-12},{-32,-12},{-32,8},{
          -34,8},{-34,24},{-29.3793,24}}, color={0,0,127}));
  connect(dualTemperatureSetpointControl.reach_TSetTarSheHea,
    selectSmallestTemperatureDifferenceRatHea.uIgnFla) annotation (Line(points=
          {{218.2,45.8947},{218.2,74},{52,74},{52,42},{-34,42},{-34,26},{-36,26},
          {-36,18.2},{-29.3793,18.2}}, color={255,0,255}));
  connect(TCur, selectSmallestTemperatureDifferenceRebHea.TCur) annotation (
      Line(points={{-122,-82},{-32,-82},{-32,-50},{-38,-50},{-38,-12},{-27.3793,
          -12}}, color={0,0,127}));
  connect(TSetCurHea, selectSmallestTemperatureDifferenceRebHea.TSetCur)
    annotation (Line(points={{-122,-52},{-38,-52},{-38,-18},{-27.3793,-18}},
        color={0,0,127}));
  connect(dualTemperatureSetpointControl.reach_TSetNomHea,
    selectSmallestTemperatureDifferenceRebHea.uIgnFla) annotation (Line(points=
          {{218.2,12.4},{236,12.4},{236,60},{212,60},{212,70},{-30,70},{-30,74},
          {-38,74},{-38,52},{-40,52},{-40,8},{-36,8},{-36,-23.8},{-27.3793,
          -23.8}}, color={255,0,255}));
  connect(TCur, selectSmallestTemperatureDifferencePreHea.TCur) annotation (
      Line(points={{-122,-82},{-58,-82},{-58,62},{-27.3793,62}}, color={0,0,127}));
  connect(TSetCurHea, selectSmallestTemperatureDifferencePreHea.TSetCur)
    annotation (Line(points={{-122,-52},{-38,-52},{-38,-12},{-44,-12},{-44,32},
          {-38,32},{-38,50},{-32,50},{-32,56},{-27.3793,56}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-240},
            {260,100}})), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-240},{260,100}})));
end MultipleZoneRatchet2;
