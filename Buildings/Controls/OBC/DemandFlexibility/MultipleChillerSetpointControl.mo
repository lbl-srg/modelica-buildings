within Buildings.Controls.OBC.DemandFlexibility;
block MultipleChillerSetpointControl

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
  Subsequences.SingleChillerSetpointControlBase
                               singleChillerSetpointControlBase
                                                           [nChi](
    delChaShe=delChaShe,
    delChaReb=delChaReb,
    uCooCoiValTho=uCooCoiValTho,
    samPerNom=samPerNom,
    samPerShe=samPerShe,
    samPerReb=samPerReb)
    annotation (Placement(transformation(extent={{90,22},{130,54}})));
  CDL.Routing.IntegerScalarReplicator intScaRep(nout=nChi)
    annotation (Placement(transformation(extent={{-22,90},{-2,110}})));
  Subsequences.SelectSmallestValvePosition selectSmallestValvePositionShe(nChi=nChi,
      movAvgTimRan=movAvgTimRan)
    annotation (Placement(transformation(extent={{4,-14},{24,6}})));
  Subsequences.GeneralModeSelectionBool chillerTemperatureModeSelectionBool[
    nChi] annotation (Placement(transformation(extent={{48,-30},{70,-6}})));
  Subsequences.SelectSmallestValvePosition selectSmallestValvePositionReb(nChi=nChi,
      movAvgTimRan=movAvgTimRan)
    annotation (Placement(transformation(extent={{12,-68},{32,-48}})));
equation
  connect(uMod, intScaRep.u) annotation (Line(points={{-120,88},{-74,88},{-74,100},
          {-24,100}}, color={255,127,0}));
  connect(intScaRep.y, singleChillerSetpointControlBase.uMod) annotation (Line(
        points={{0,100},{44,100},{44,46.4},{88,46.4}}, color={255,127,0}));
  connect(uCooCoiValCur, singleChillerSetpointControlBase.uCooCoiValCur)
    annotation (Line(points={{-120,52},{-16,52},{-16,42.8},{88,42.8}}, color={0,
          0,127}));
  connect(TSetCur, singleChillerSetpointControlBase.TSetCur) annotation (Line(
        points={{-120,10},{-15,10},{-15,38.6},{88,38.6}}, color={0,0,127}));
  connect(TSetTarShe, singleChillerSetpointControlBase.TSetTarShe) annotation (
      Line(points={{-122,-92},{-86,-92},{-86,-90},{76,-90},{76,28.4},{87.8,28.4}},
        color={0,0,127}));
  connect(TSetNom, singleChillerSetpointControlBase.TSetNom) annotation (Line(
        points={{-122,-140},{-16,-140},{-16,23.6},{87.8,23.6}}, color={0,0,127}));
  connect(singleChillerSetpointControlBase.TSetCom, TSetCom) annotation (Line(
        points={{132,35},{182,35},{182,-6},{240,-6}}, color={0,0,127}));
  connect(uCooCoiValCur, selectSmallestValvePositionShe.uCooCoiValCur)
    annotation (Line(points={{-120,52},{-60,52},{-60,-4},{2,-4}}, color={0,0,
          127}));
  connect(selectSmallestValvePositionReb.uCooCoiValCur, uCooCoiValCur)
    annotation (Line(points={{10,-58},{-50,-58},{-50,52},{-120,52}}, color={0,0,
          127}));
  connect(singleChillerSetpointControlBase.reach_TSetTarShe,
    selectSmallestValvePositionShe.uIgnFla) annotation (Line(points={{132,42},{
          -38,42},{-38,-9.8},{2,-9.8}}, color={255,0,255}));
  connect(singleChillerSetpointControlBase.reach_TSetNom,
    selectSmallestValvePositionReb.uIgnFla) annotation (Line(points={{132,28.4},
          {142,28.4},{142,28},{150,28},{150,-108},{10,-108},{10,-63.8}}, color=
          {255,0,255}));
  connect(selectSmallestValvePositionShe.yAcnFla,
    chillerTemperatureModeSelectionBool.uShe) annotation (Line(points={{26,-4},
          {36,-4},{36,-21.2},{46.087,-21.2}}, color={255,0,255}));
  connect(selectSmallestValvePositionReb.yAcnFla,
    chillerTemperatureModeSelectionBool.uReb) annotation (Line(points={{34,-58},
          {40,-58},{40,-25.8},{46.087,-25.8}}, color={255,0,255}));
  connect(intScaRep.y, chillerTemperatureModeSelectionBool.uMod) annotation (
      Line(points={{0,100},{30,100},{30,-10},{38,-10},{38,-9.2},{46.087,-9.2}},
        color={255,127,0}));
  connect(chillerTemperatureModeSelectionBool.y,
    singleChillerSetpointControlBase.have_pri) annotation (Line(points={{71.913,
          -18},{74,-18},{74,50},{88,50}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-160},
            {220,120}})), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-160},{220,120}})),
    Documentation(info="<html>
<p><span style=\"font-size: 9pt;\">This is a utility block that controls the chiller temperature setpoint for multiple chillers, based on the current mode uMod: 1 = load shed mode, 2 = load rebound mode, and 0 = baseline mode. </span></p>
<p><span style=\"font-size: 9pt;\">In this block, out of the many chillers, we need to decide which zone has the priority to perform the chiller setpoint change via the variables have_pri. For the one zone with the **smallest** cooling coil valve position, this chiller will have its have_pri variable set to true, and the other chillers will have their have_pri variable set to false. This applies for both the  load shed mode and the load rebound mode. </span></p>
</html>"));
end MultipleChillerSetpointControl;
