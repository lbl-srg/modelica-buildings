within Buildings.Controls.OBC.DemandFlexibility;
block MultipleFanValveLimitingRatchetLoadAdjustment

    parameter Integer nEqu=4
    "number of pieces of fan or valve equipment";

     parameter Real delChaShe=1
    "Change amount for load shed";

   parameter Real delChaReb=-1
    "Change amount for rebound";

            parameter Real samPerNom(unit="s")=300
    "Sample period for the nominal condition";
        parameter Real samPerShe(unit="s")=300
    "Sample period for ratchet";
        parameter Real samPerReb(unit="s")=300
    "Sample period for rebound";
  CDL.Interfaces.IntegerInput uMod
    "setpoint mode; 0 = normal;  1 = shed; 2 = rebound"
    annotation (Placement(transformation(extent={{-140,90},{-100,130}}),
        iconTransformation(extent={{-190,24},{-150,64}})));
  CDL.Interfaces.RealInput uSetCur[nEqu] "current setpoint"
    annotation (Placement(transformation(extent={{-140,30},{-100,70}})));
  CDL.Interfaces.RealInput uSetTarShe[nEqu] "setpoint target for load shed"
    annotation (Placement(transformation(extent={{-140,-18},{-100,22}}),
        iconTransformation(extent={{-192,-156},{-152,-116}})));
  CDL.Interfaces.RealInput uSetNom[nEqu] "nominal setpoint"
    annotation (Placement(transformation(extent={{-140,-66},{-100,-26}})));
  CDL.Interfaces.RealOutput uSetCom[nEqu] "setpoint command" annotation (
      Placement(transformation(extent={{100,-20},{140,20}}), iconTransformation(
          extent={{250,-90},{290,-50}})));
  SingleFanValveLimitingRatchetLoadAdjustment
    singleFanValveLimitingRatchetLoadAdjustment[nEqu](
    delChaShe=delChaShe,
    delChaReb=delChaReb,
    samPerNom=samPerNom,
    samPerShe=samPerShe,
    samPerReb=samPerReb)
    annotation (Placement(transformation(extent={{-22,-6},{18,26}})));
  CDL.Routing.IntegerScalarReplicator intScaRep(nout=nEqu)
    annotation (Placement(transformation(extent={{-62,90},{-42,110}})));
  CDL.Interfaces.RealInput PBui "building electric power"
    annotation (Placement(transformation(extent={{-140,-108},{-100,-68}})));
  CDL.Interfaces.RealInput PBuiMaxTar "building electric power maximum target"
    annotation (Placement(transformation(extent={{-140,-148},{-100,-108}})));
  CDL.Routing.RealScalarReplicator    reaScaRep(nout=nEqu)
    annotation (Placement(transformation(extent={{-66,-86},{-46,-66}})));
  CDL.Routing.RealScalarReplicator    reaScaRep1(nout=nEqu)
    annotation (Placement(transformation(extent={{-66,-132},{-46,-112}})));
equation
  connect(uMod, intScaRep.u) annotation (Line(points={{-120,110},{-92,110},{-92,
          100},{-64,100}}, color={255,127,0}));
  connect(intScaRep.y, singleFanValveLimitingRatchetLoadAdjustment.uMod)
    annotation (Line(points={{-40,100},{-34,100},{-34,23},{-24,23}}, color={255,
          127,0}));
  connect(uSetCur, singleFanValveLimitingRatchetLoadAdjustment.uSetCur)
    annotation (Line(points={{-120,50},{-36,50},{-36,17.8},{-24,17.8}}, color={
          0,0,127}));
  connect(uSetTarShe, singleFanValveLimitingRatchetLoadAdjustment.uSetTarShe)
    annotation (Line(points={{-120,2},{-34,2},{-34,10.4},{-24.2,10.4}}, color={
          0,0,127}));
  connect(uSetNom, singleFanValveLimitingRatchetLoadAdjustment.uSetNom)
    annotation (Line(points={{-120,-46},{-34,-46},{-34,0},{-32,0},{-32,5.8},{
          -24,5.8}}, color={0,0,127}));
  connect(singleFanValveLimitingRatchetLoadAdjustment.uSetCom, uSetCom)
    annotation (Line(points={{20,7},{66,7},{66,0},{120,0}}, color={0,0,127}));
  connect(PBui, reaScaRep.u) annotation (Line(points={{-120,-88},{-76,-88},{-76,
          -76},{-68,-76}}, color={0,0,127}));
  connect(PBuiMaxTar, reaScaRep1.u) annotation (Line(points={{-120,-128},{-78,
          -128},{-78,-122},{-68,-122}}, color={0,0,127}));
  connect(reaScaRep.y, singleFanValveLimitingRatchetLoadAdjustment.PBui)
    annotation (Line(points={{-44,-76},{-34,-76},{-34,-46},{-32,-46},{-32,1},{
          -24,1}}, color={0,0,127}));
  connect(reaScaRep1.y, singleFanValveLimitingRatchetLoadAdjustment.PBuiMaxTar)
    annotation (Line(points={{-44,-122},{-24,-122},{-24,-4}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-140},
            {100,140}})), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-140},{100,140}})));
end MultipleFanValveLimitingRatchetLoadAdjustment;
