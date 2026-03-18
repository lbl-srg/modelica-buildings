within Buildings.Controls.OBC.DemandFlexibility;
block MultipleFanValveLimitingSingleAdjustment

    parameter Integer nEqu=4
    "number of pieces of fan or valve equipment";


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
    annotation (Placement(transformation(extent={{-140,12},{-100,52}})));
  CDL.Interfaces.RealInput uSetTarShe[nEqu] "setpoint target for load shed"
    annotation (Placement(transformation(extent={{-142,-90},{-102,-50}}),
        iconTransformation(extent={{-192,-156},{-152,-116}})));
  CDL.Interfaces.RealInput uSetNom[nEqu] "nominal setpoint"
    annotation (Placement(transformation(extent={{-142,-138},{-102,-98}})));
  CDL.Interfaces.RealOutput uSetCom[nEqu] "setpoint command" annotation (
      Placement(transformation(extent={{100,-20},{140,20}}), iconTransformation(
          extent={{250,-90},{290,-50}})));
  SingleFanValveLimitingSingleAdjustment singleFanValveLimitingSingleAdjustment[
    nEqu](
    samPerNom=samPerNom,
    samPerShe=samPerShe,
    samPerReb=samPerReb)
    annotation (Placement(transformation(extent={{-22,-6},{18,26}})));
  CDL.Routing.IntegerScalarReplicator intScaRep(nout=nEqu)
    annotation (Placement(transformation(extent={{-62,90},{-42,110}})));
equation
  connect(uMod, intScaRep.u) annotation (Line(points={{-120,110},{-92,110},{-92,
          100},{-64,100}}, color={255,127,0}));
  connect(intScaRep.y, singleFanValveLimitingSingleAdjustment.uMod) annotation
    (Line(points={{-40,100},{-34,100},{-34,18.4},{-24,18.4}}, color={255,127,0}));
  connect(uSetCur, singleFanValveLimitingSingleAdjustment.uSetCur) annotation (
      Line(points={{-120,32},{-74,32},{-74,10.6},{-24,10.6}}, color={0,0,127}));
  connect(uSetTarShe, singleFanValveLimitingSingleAdjustment.uSetTarShe)
    annotation (Line(points={{-122,-70},{-74,-70},{-74,0.4},{-24.2,0.4}}, color
        ={0,0,127}));
  connect(uSetNom, singleFanValveLimitingSingleAdjustment.uSetNom) annotation (
      Line(points={{-122,-118},{-74,-118},{-74,-4.4},{-24.2,-4.4}}, color={0,0,
          127}));
  connect(singleFanValveLimitingSingleAdjustment.uSetCom, uSetCom)
    annotation (Line(points={{20,7},{66,7},{66,0},{120,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-140},
            {100,140}})), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-140},{100,140}})));
end MultipleFanValveLimitingSingleAdjustment;
