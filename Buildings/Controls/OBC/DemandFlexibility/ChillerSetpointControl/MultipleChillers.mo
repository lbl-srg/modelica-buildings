within Buildings.Controls.OBC.DemandFlexibility.ChillerSetpointControl;
block MultipleChillers

  parameter Integer nChi=4;

parameter Real movAvgTimRan(unit="s")=1800
    "time range for moving average";
     parameter Real delChaShe=1
    "Change amount for load shed";

   parameter Real delChaReb=-1
    "Change amount for rebound";

    parameter Real uCooCoiValTho(min=0)=0.95
    "Cooling coil valve threshold below which ratcheting is triggerd.";

            parameter Real samPerNom(unit="s")=300
    "Sample period for the nominal condition";
        parameter Real samPerShe(unit="s")=300
    "Sample period for ratchet";
        parameter Real samPerReb(unit="s")=300
    "Sample period for rebound";

  CDL.Interfaces.IntegerInput uMod
    "setpoint mode; 0 = normal;  1 = shed; 2 = rebound"
    annotation (Placement(transformation(extent={{-140,68},{-100,108}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  CDL.Interfaces.RealInput uCooCoiValCur[nChi]
    "current cooling coil valve signal"
    annotation (Placement(transformation(extent={{-140,32},{-100,72}})));
  CDL.Interfaces.RealInput TSetCur[nChi] "current setpoint"
    annotation (Placement(transformation(extent={{-140,-10},{-100,30}})));
  CDL.Interfaces.RealInput TSetTarShe[nChi] "setpoint target for load shed"
    annotation (Placement(transformation(extent={{-142,-112},{-102,-72}}),
        iconTransformation(extent={{-142,-118},{-102,-78}})));
  CDL.Interfaces.RealInput TSetNom[nChi] "nominal setpoint"
    annotation (Placement(transformation(extent={{-142,-160},{-102,-120}})));
  CDL.Interfaces.RealOutput TSetCom[nChi] "setpoint command" annotation (
      Placement(transformation(extent={{220,-26},{260,14}}), iconTransformation(
          extent={{250,-90},{290,-50}})));
  Subsequences.SingleChillerBase singleChillerSetpointControlBase[nChi](
    delChaShe=delChaShe,
    delChaReb=delChaReb,
    uCooCoiValTho=uCooCoiValTho,
    samPerNom=samPerNom,
    samPerShe=samPerShe,
    samPerReb=samPerReb)
    annotation (Placement(transformation(extent={{134,-116},{174,-84}})));
  CDL.Routing.IntegerScalarReplicator intScaRep(nout=nChi)
    annotation (Placement(transformation(extent={{-22,90},{-2,110}})));
  FanValveLimiting.Subsequences.SelectSmallestValvePosition
    selectSmallestValvePositionShe(nChi=nChi, movAvgTimRan=movAvgTimRan)
    annotation (Placement(transformation(extent={{-22,50},{-2,70}})));
  Generic.GeneralModeSelectionBool chillerTemperatureModeSelectionBool[nChi]
    annotation (Placement(transformation(extent={{64,4},{86,28}})));
  FanValveLimiting.Subsequences.SelectSmallestValvePosition
    selectSmallestValvePositionReb(nChi=nChi, movAvgTimRan=movAvgTimRan)
    annotation (Placement(transformation(extent={{-22,-2},{-2,18}})));
equation
  connect(uMod, intScaRep.u) annotation (Line(points={{-120,88},{-74,88},{-74,100},
          {-24,100}}, color={255,127,0}));
  connect(intScaRep.y, singleChillerSetpointControlBase.uMod) annotation (Line(
        points={{0,100},{98,100},{98,-91.6},{132,-91.6}},
                                                       color={255,127,0}));
  connect(uCooCoiValCur, singleChillerSetpointControlBase.uCooCoiValCur)
    annotation (Line(points={{-120,52},{-60,52},{-60,8},{-48,8},{-48,-94},{132,
          -94},{132,-95.2}},                                           color={0,
          0,127}));
  connect(TSetCur, singleChillerSetpointControlBase.TSetCur) annotation (Line(
        points={{-120,10},{-72,10},{-72,-100},{132,-100},{132,-99.4}},
                                                          color={0,0,127}));
  connect(TSetTarShe, singleChillerSetpointControlBase.TSetTarShe) annotation (
      Line(points={{-122,-92},{-88,-92},{-88,-110},{131.8,-110},{131.8,-109.6}},
        color={0,0,127}));
  connect(TSetNom, singleChillerSetpointControlBase.TSetNom) annotation (Line(
        points={{-122,-140},{78,-140},{78,-114.4},{131.8,-114.4}},
                                                                color={0,0,127}));
  connect(singleChillerSetpointControlBase.TSetCom, TSetCom) annotation (Line(
        points={{176,-103},{176,-104},{210,-104},{210,-6},{240,-6}},
                                                      color={0,0,127}));
  connect(uCooCoiValCur, selectSmallestValvePositionShe.uCooCoiValCur)
    annotation (Line(points={{-120,52},{-46,52},{-46,60},{-24,60}},
                                                                  color={0,0,
          127}));
  connect(selectSmallestValvePositionReb.uCooCoiValCur, uCooCoiValCur)
    annotation (Line(points={{-24,8},{-60,8},{-60,52},{-120,52}},    color={0,0,
          127}));
  connect(singleChillerSetpointControlBase.reach_TSetTarShe,
    selectSmallestValvePositionShe.uIgnFla) annotation (Line(points={{176,-96},
          {200,-96},{200,38},{-34,38},{-34,54},{-24,54},{-24,54.2}},
                                        color={255,0,255}));
  connect(singleChillerSetpointControlBase.reach_TSetNom,
    selectSmallestValvePositionReb.uIgnFla) annotation (Line(points={{176,
          -109.6},{176,-110},{200,-110},{200,-126},{-32,-126},{-32,2.2},{-24,
          2.2}},                                                         color=
          {255,0,255}));
  connect(selectSmallestValvePositionShe.yAcnFla,
    chillerTemperatureModeSelectionBool.uShe) annotation (Line(points={{0,60},{
          22,60},{22,12.8},{62.087,12.8}},    color={255,0,255}));
  connect(selectSmallestValvePositionReb.yAcnFla,
    chillerTemperatureModeSelectionBool.uReb) annotation (Line(points={{0,8},{
          56,8},{56,8.2},{62.087,8.2}},        color={255,0,255}));
  connect(intScaRep.y, chillerTemperatureModeSelectionBool.uMod) annotation (
      Line(points={{0,100},{42,100},{42,26},{62,26},{62,24},{62.087,24},{62.087,
          24.8}},
        color={255,127,0}));
  connect(chillerTemperatureModeSelectionBool.y,
    singleChillerSetpointControlBase.have_pri) annotation (Line(points={{87.913,
          16},{114,16},{114,-88},{132,-88}},
                                          color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-160},
            {220,120}})), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-160},{220,120}})),
    Documentation(info="<html>
<p><span style=\"font-size: 9pt;\">This is a utility block that controls the chiller temperature setpoint for multiple chillers, based on the current mode uMod: 1 = load shed mode, 2 = load rebound mode, and 0 = baseline mode. </span></p>
<p><span style=\"font-size: 9pt;\">In this block, out of the many chillers, we need to decide which zone has the priority to perform the chiller setpoint change via the variables have_pri. For the one zone with the **smallest** cooling coil valve position, this chiller will have its have_pri variable set to true, and the other chillers will have their have_pri variable set to false. This applies for both the  load shed mode and the load rebound mode. </span></p>
</html>"));
end MultipleChillers;
