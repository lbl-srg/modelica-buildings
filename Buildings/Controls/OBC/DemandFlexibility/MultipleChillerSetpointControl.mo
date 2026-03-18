within Buildings.Controls.OBC.DemandFlexibility;
block MultipleChillerSetpointControl

  parameter Integer nChi=4;



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
  SingleChillerSetpointControl singleChillerSetpointControl[nChi](
    delChaShe=delChaShe,
    delChaReb=delChaReb,
    uCooCoiValTho=uCooCoiValTho,
    samPerNom=samPerNom,
    samPerShe=samPerShe,
    samPerReb=samPerReb)
    annotation (Placement(transformation(extent={{90,22},{130,54}})));
  CDL.Routing.IntegerScalarReplicator intScaRep(nout=nChi)
    annotation (Placement(transformation(extent={{-22,90},{-2,110}})));
equation
  connect(uMod, intScaRep.u) annotation (Line(points={{-120,88},{-74,88},{-74,100},
          {-24,100}}, color={255,127,0}));
  connect(intScaRep.y, singleChillerSetpointControl.uMod) annotation (Line(
        points={{0,100},{44,100},{44,46.4},{88,46.4}}, color={255,127,0}));
  connect(uCooCoiValCur, singleChillerSetpointControl.uCooCoiValCur)
    annotation (Line(points={{-120,52},{-16,52},{-16,42.8},{88,42.8}}, color={0,
          0,127}));
  connect(TSetCur, singleChillerSetpointControl.TSetCur) annotation (Line(
        points={{-120,10},{-15,10},{-15,38.6},{88,38.6}}, color={0,0,127}));
  connect(TSetTarShe, singleChillerSetpointControl.TSetTarShe) annotation (Line(
        points={{-122,-92},{-86,-92},{-86,-90},{76,-90},{76,28.4},{87.8,28.4}},
        color={0,0,127}));
  connect(TSetNom, singleChillerSetpointControl.TSetNom) annotation (Line(
        points={{-122,-140},{-16,-140},{-16,23.6},{87.8,23.6}}, color={0,0,127}));
  connect(singleChillerSetpointControl.TSetCom, TSetCom) annotation (Line(
        points={{132,35},{182,35},{182,-6},{240,-6}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-160},
            {220,120}})), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-160},{220,120}})));
end MultipleChillerSetpointControl;
