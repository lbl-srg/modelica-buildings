within Buildings.Controls.OBC.DemandFlexibility.FanValveLimiting;
block SingleFanValveSingleAdjustment

            parameter Real samPerNom(unit="s")=300
    "Sample period for the nominal condition";
        parameter Real samPerShe(unit="s")=300
    "Sample period for ratchet";
        parameter Real samPerReb(unit="s")=300
    "Sample period for rebound";
  Generic.SetpointSingleStepChange setShe(setChaMod=true, samPer=samPerShe)
    annotation (Placement(transformation(extent={{162,-34},{182,-14}})));
  CDL.Interfaces.IntegerInput uMod
    "setpoint mode; 0 = normal;  1 = shed; 2 = rebound"
    annotation (Placement(transformation(extent={{-190,24},{-150,64}}),
        iconTransformation(extent={{-190,24},{-150,64}})));
  CDL.Interfaces.RealOutput uSetCom "setpoint command"
    annotation (Placement(transformation(extent={{250,-90},{290,-50}}),
        iconTransformation(extent={{250,-90},{290,-50}})));
  CDL.Interfaces.RealInput uSetNom "nominal setpoint"
    annotation (Placement(transformation(extent={{-192,-204},{-152,-164}})));
  CDL.Interfaces.RealInput uSetCur "current setpoint"
    annotation (Placement(transformation(extent={{-190,-54},{-150,-14}})));
  CDL.Interfaces.RealInput uSetTarShe "setpoint target for load shed"
    annotation (Placement(transformation(extent={{-192,-156},{-152,-116}}),
        iconTransformation(extent={{-192,-156},{-152,-116}})));
  CDL.Discrete.Sampler setNom(samplePeriod=samPerNom)
    annotation (Placement(transformation(extent={{170,48},{190,68}})));
  Generic.GeneralModeSelection chillerTemperatureModeSelection
    annotation (Placement(transformation(extent={{216,-78},{236,-58}})));
  CDL.Logical.Sources.Constant con(k=true)
    annotation (Placement(transformation(extent={{-74,86},{-54,106}})));
equation
  connect(uSetCur, setShe.uSetCur) annotation (Line(points={{-170,-34},{-24,-34},
          {-24,-20.5185},{160.667,-20.5185}},
                                  color={0,0,127}));
  connect(uSetTarShe, setShe.uSetTar) annotation (Line(points={{-172,-136},{14,
          -136},{14,-24.2222},{160.667,-24.2222}},
                                color={0,0,127}));
  connect(uMod, chillerTemperatureModeSelection.uMod) annotation (Line(points={{-170,44},
          {-72,44},{-72,-60},{214.261,-60},{214.261,-60.6667}},
        color={255,127,0}));
  connect(setNom.y, chillerTemperatureModeSelection.uNom) annotation (Line(
        points={{192,58},{204,58},{204,-67.3333},{214.261,-67.3333}}, color={0,0,
          127}));
  connect(chillerTemperatureModeSelection.y,uSetCom)  annotation (Line(points={{237.739,
          -68},{244,-68},{244,-70},{270,-70}},         color={0,0,127}));
  connect(setNom.u,uSetNom)  annotation (Line(points={{168,58},{-106,58},{-106,
          -184},{-172,-184}}, color={0,0,127}));
  connect(uSetNom, setShe.uSetNom) annotation (Line(points={{-172,-184},{64,
          -184},{64,-27.9259},{160.667,-27.9259}},  color={0,0,127}));
  connect(setShe.ySetCom, chillerTemperatureModeSelection.uShe) annotation (
      Line(points={{183.333,-22.8889},{192,-22.8889},{192,-70},{214.261,-70},{
          214.261,-70.6667}},
        color={0,0,127}));
  connect(con.y, setShe.have_pri) annotation (Line(points={{-52,96},{54,96},{54,
          -16.8148},{160.667,-16.8148}}, color={255,0,255}));
  connect(setNom.y, chillerTemperatureModeSelection.uReb) annotation (Line(
        points={{192,58},{204,58},{204,-74},{214.261,-74},{214.261,-74.5}},
        color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,
        extent={{-150,-200},{250,120}},
        grid={2,2})),                                            Diagram(
        coordinateSystem(preserveAspectRatio=false,
        extent={{-150,-200},{250,120}},
        grid={2,2})),
    Documentation(info="<html>
<p>This block controls the fan or valve limiting for a single fan or valve. It offers a one-step 
change for the maximum fan or valve position setpoint. This is based on the current mode <code>uMod</code>: 
0 = baseline mode, 1 = load shed mode, and 2 = load rebound mode. </p>
<p>At the baseline mode and the load rebound mode, the maximum fan or valve position setpoint 
is equal to <code>uSetNom</code>. At the load shed mode, the maximum fan or valve position setpoint is equal 
to uSetTarShe.</p>
</html>"));
end SingleFanValveSingleAdjustment;
