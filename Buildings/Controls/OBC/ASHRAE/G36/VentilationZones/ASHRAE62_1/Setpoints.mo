within Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.ASHRAE62_1;
block Setpoints
  CDL.Interfaces.RealInput                        TZon(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    final displayUnit="degC")
    "Measured room temperature"
    annotation (Placement(transformation(extent={{-260,210},{-220,250}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  CDL.Interfaces.RealInput                        TDis(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    final displayUnit="degC")
    "Measured supply air temperature after heating coil"
    annotation (Placement(transformation(extent={{-260,170},{-220,210}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  CDL.Continuous.Feedback feedback
    annotation (Placement(transformation(extent={{-190,220},{-170,240}})));
  CDL.Continuous.Hysteresis cooSup(uLow=-dT, uHigh=dT)
    "Check if it is supplying cooling"
    annotation (Placement(transformation(extent={{-140,220},{-120,240}})));
  CDL.Conversions.BooleanToReal airDisEff(realTrue=EzC, realFalse=EzH)
    "Air distribution effectiveness"
    annotation (Placement(transformation(extent={{-100,220},{-80,240}})));
  CDL.Interfaces.RealInput                        ppmCO2 if have_CO2Sen
    "Detected CO2 conventration"
    annotation (Placement(transformation(extent={{-260,120},{-220,160}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  CDL.Continuous.Line lin "CO2 control loop"
    annotation (Placement(transformation(extent={{-80,130},{-60,150}})));
  CDL.Continuous.Sources.Constant zer(k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-200,100},{-180,120}})));
  CDL.Continuous.Sources.Constant one(k=1) "Constant one"
    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));
  CDL.Continuous.Sources.Constant co2Set(k=CO2Set) "CO2 setpoint"
    annotation (Placement(transformation(extent={{-200,150},{-180,170}})));
  CDL.Continuous.AddParameter addPar(p=-200) "Lower threshold of CO2 setpoint"
    annotation (Placement(transformation(extent={{-140,150},{-120,170}})));
  CDL.Interfaces.IntegerInput                        uOpeMod
    "Zone operation mode"
    annotation (Placement(transformation(extent={{-260,50},{-220,90}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  CDL.Integers.Equal inOccMod "Check if it is in occupied mode"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));
  CDL.Conversions.BooleanToReal booToRea "Convert boolean to real"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  CDL.Continuous.Product co2Con "Corrected CO2 control loop output"
    annotation (Placement(transformation(extent={{-40,100},{-20,120}})));
protected
  CDL.Integers.Sources.Constant occMod(final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.occupied)
    "Occupied mode"
    annotation (Placement(transformation(extent={{-200,30},{-180,50}})));
equation
  connect(TZon, feedback.u1)
    annotation (Line(points={{-240,230},{-192,230}}, color={0,0,127}));
  connect(TDis, feedback.u2) annotation (Line(points={{-240,190},{-180,190},{
          -180,218}}, color={0,0,127}));
  connect(feedback.y, cooSup.u)
    annotation (Line(points={{-168,230},{-142,230}}, color={0,0,127}));
  connect(cooSup.y, airDisEff.u)
    annotation (Line(points={{-118,230},{-102,230}}, color={255,0,255}));
  connect(co2Set.y, addPar.u)
    annotation (Line(points={{-178,160},{-142,160}}, color={0,0,127}));
  connect(addPar.y, lin.x1) annotation (Line(points={{-118,160},{-100,160},{
          -100,148},{-82,148}}, color={0,0,127}));
  connect(zer.y, lin.f1) annotation (Line(points={{-178,110},{-150,110},{-150,
          144},{-82,144}}, color={0,0,127}));
  connect(ppmCO2, lin.u)
    annotation (Line(points={{-240,140},{-82,140}}, color={0,0,127}));
  connect(co2Set.y, lin.x2) annotation (Line(points={{-178,160},{-160,160},{
          -160,136},{-82,136}}, color={0,0,127}));
  connect(one.y, lin.f2) annotation (Line(points={{-118,110},{-100,110},{-100,
          132},{-82,132}}, color={0,0,127}));
  connect(uOpeMod, inOccMod.u1)
    annotation (Line(points={{-240,70},{-142,70}}, color={255,127,0}));
  connect(occMod.y, inOccMod.u2) annotation (Line(points={{-178,40},{-160,40},{
          -160,62},{-142,62}}, color={255,127,0}));
  connect(inOccMod.y, booToRea.u)
    annotation (Line(points={{-118,70},{-82,70}}, color={255,0,255}));
  connect(lin.y, co2Con.u1) annotation (Line(points={{-58,140},{-50,140},{-50,
          116},{-42,116}}, color={0,0,127}));
  connect(booToRea.y, co2Con.u2) annotation (Line(points={{-58,70},{-50,70},{
          -50,104},{-42,104}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-220,
            -260},{200,260}})), Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-220,-260},{200,260}})));
end Setpoints;
