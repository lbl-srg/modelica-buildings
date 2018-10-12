within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Stage;
block Status
  "Determines chiller stage based on the previous stage and the current capacity requirement. fixme: stagin up and down process (delays, etc) should be added."

  parameter Integer numSta = 2
  "Number of stages";

  Capacities capacities(nomCapSta1=1090224.38, nomCapSta2=1090224.38)
    annotation (Placement(transformation(extent={{-60,20},{-28,48}})));
  CapacityRequirement capacityRequirement
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  ConditionsForPositiveDisplacement conditionsForPositiveDisplacement(numSta=
        numSta)
    annotation (Placement(transformation(extent={{14,40},{46,68}})));
  CDL.Interfaces.IntegerInput                        uChiSta
    "Current chiller stage"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
      iconTransformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,70})));
  CDL.Integers.Add addInt(k2=+1)
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  CDL.Interfaces.IntegerOutput yChiSta(final min=0, final max=numSta)
    "Chiller stage" annotation (Placement(transformation(extent={{100,-10},{120,
            10}}), iconTransformation(extent={{200,-140},{220,-120}})));
  CDL.Interfaces.RealInput VChiWat_flow(final quantity="VolumeFlowRate", final
      unit="m3/s") "Measured chilled water flow rate" annotation (Placement(
        transformation(extent={{-140,-100},{-100,-60}}),iconTransformation(
          extent={{-120,50},{-100,70}})));
  CDL.Interfaces.RealInput                        TChiWatRet(final unit="K",
      final quantity="ThermodynamicTemperature")
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
      iconTransformation(extent={{-120,-40},{-100,-20}})));
  CDL.Interfaces.RealInput TChiWatSupSet(final unit="K", final quantity=
        "ThermodynamicTemperature") "Chilled water supply setpoint temperature"
                                                annotation (Placement(
        transformation(extent={{-140,-20},{-100,20}}), iconTransformation(
          extent={{-120,-10},{-100,10}})));
equation
  connect(VChiWat_flow, capacityRequirement.VChiWat_flow) annotation (Line(
        points={{-120,-80},{-72,-80},{-72,-24},{-21,-24}}, color={0,0,127}));
  connect(TChiWatRet, capacityRequirement.TChiWatRet) annotation (Line(points={
          {-120,-40},{-72,-40},{-72,-27},{-21,-27}}, color={0,0,127}));
  connect(TChiWatSupSet, capacityRequirement.TChiWatSupSet) annotation (Line(
        points={{-120,0},{-72,0},{-72,-30},{-21,-30}}, color={0,0,127}));
  connect(uChiSta, capacities.uChiSta) annotation (Line(points={{-120,60},{-90,
          60},{-90,34},{-62,34}}, color={255,127,0}));
  connect(capacityRequirement.yCapReq, conditionsForPositiveDisplacement.uCapReq)
    annotation (Line(points={{1,-30},{6,-30},{6,48},{13,48}}, color={0,0,127}));
  connect(capacities.yCapNomSta, conditionsForPositiveDisplacement.uCapNomSta)
    annotation (Line(points={{-27,38},{-12,38},{-12,57},{13,57}}, color={0,0,
          127}));
  connect(capacities.yCapNomLowSta, conditionsForPositiveDisplacement.uCapNomLowSta)
    annotation (Line(points={{-27,30},{-12,30},{-12,54},{13,54}}, color={0,0,
          127}));
  connect(uChiSta, conditionsForPositiveDisplacement.uChiSta) annotation (Line(
        points={{-120,60},{-56,60},{-56,64},{12,64}}, color={255,127,0}));
  connect(conditionsForPositiveDisplacement.yChiStaCha, addInt.u1) annotation (
      Line(points={{49,41},{49,23.5},{58,23.5},{58,6}}, color={255,127,0}));
  connect(uChiSta, addInt.u2) annotation (Line(points={{-120,60},{-80,60},{-80,
          10},{-12,10},{-12,-6},{58,-6}}, color={255,127,0}));
  connect(addInt.y, yChiSta)
    annotation (Line(points={{81,0},{110,0}}, color={255,127,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Status;
