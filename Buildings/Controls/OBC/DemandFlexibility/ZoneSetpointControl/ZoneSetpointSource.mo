within Buildings.Controls.OBC.DemandFlexibility.ZoneSetpointControl;
model ZoneSetpointSource

    parameter Real TSetNomHeaOcc(unit="K")=273.15+20;
  parameter Real TSetNomHeaUno(unit="K")=273.15+15.5556;
  parameter Real TSetNomCooOcc(unit="K")=273.15+25.5556;
  parameter Real TSetNomCooUno(unit="K")=273.15+32.2222;
  parameter Real delTSetSheHea(unit="K")=5.5556 "zone temperature setpoint delta for heating load shed";
  parameter Real delTSetSheCoo(unit="K")=5.5556 "zone temperature setpoint delta for cooling load shed";

  parameter Real delTSetPreHea(unit="K")=1.1111 "zone temperature setpoint delta for heating pre-heat";
  parameter Real delTSetPreCoo(unit="K")=1.1111 "zone temperature setpoint delta for cooling pre-cool";

  parameter Real occStaHouSta=7;
  parameter Real occStaHouEnd=20;
  CDL.Interfaces.RealOutput TSetTarPreHea
    annotation (Placement(transformation(extent={{100,60},{140,100}})));
  CDL.Interfaces.RealOutput TSetTarSheHea
                                         "setpoint target for load shed"
    annotation (Placement(transformation(extent={{100,26},{140,66}})));
  CDL.Interfaces.RealOutput TSetNomHea
                                      "nominal setpoint"
    annotation (Placement(transformation(extent={{100,-2},{140,38}})));
  CDL.Interfaces.RealOutput TSetTarPreCoo
                                         "setpoint target for precool"
    annotation (Placement(transformation(extent={{100,-40},{140,0}})));
  CDL.Interfaces.RealOutput TSetTarSheCoo
                                         "setpoint target for load shed"
    annotation (Placement(transformation(extent={{100,-66},{140,-26}})));
  CDL.Interfaces.RealOutput TSetNomCoo
                                      "nominal setpoint"
    annotation (Placement(transformation(extent={{100,-102},{140,-62}})));
  CDL.Logical.Sources.TimeTable booTimTab(
    table=[0,0; occStaHouSta,1; occStaHouEnd,0; 24,0],
    timeScale=3600,
    period=86400)
    annotation (Placement(transformation(extent={{-86,8},{-66,28}})));
  CDL.Conversions.BooleanToReal booToRea(realTrue=TSetNomHeaOcc, realFalse=
        TSetNomHeaUno)
    annotation (Placement(transformation(extent={{-8,8},{12,28}})));
  CDL.Conversions.BooleanToReal booToRea1(realTrue=TSetNomCooOcc, realFalse=
        TSetNomCooUno)
    annotation (Placement(transformation(extent={{-6,-92},{14,-72}})));
  CDL.Reals.Add add2
    annotation (Placement(transformation(extent={{46,-56},{66,-36}})));
  CDL.Reals.Subtract sub
    annotation (Placement(transformation(extent={{60,36},{80,56}})));
  CDL.Reals.Add add1
    annotation (Placement(transformation(extent={{62,70},{82,90}})));
  CDL.Reals.Subtract sub1
    annotation (Placement(transformation(extent={{46,-30},{66,-10}})));
  CDL.Reals.Sources.Constant con(k=delTSetPreHea)
    annotation (Placement(transformation(extent={{-84,64},{-64,84}})));
  CDL.Reals.Sources.Constant con1(k=delTSetSheHea)
    annotation (Placement(transformation(extent={{-50,40},{-30,60}})));
  CDL.Reals.Sources.Constant con2(k=delTSetPreCoo)
    annotation (Placement(transformation(extent={{-72,-28},{-52,-8}})));
  CDL.Reals.Sources.Constant con3(k=delTSetSheCoo)
    annotation (Placement(transformation(extent={{-74,-62},{-54,-42}})));
equation
  connect(booTimTab.y[1], booToRea.u) annotation (Line(points={{-64,18},{-10,18}},
                              color={255,0,255}));
  connect(booTimTab.y[1], booToRea1.u) annotation (Line(points={{-64,18},{-22,
          18},{-22,-82},{-8,-82}},
                                color={255,0,255}));
  connect(booToRea.y, TSetNomHea) annotation (Line(points={{14,18},{120,18}},
                     color={0,0,127}));
  connect(booToRea1.y, TSetNomCoo) annotation (Line(points={{16,-82},{120,-82}},
                           color={0,0,127}));
  connect(add1.y, TSetTarPreHea) annotation (Line(points={{84,80},{120,80}},
                     color={0,0,127}));
  connect(sub.y, TSetTarSheHea) annotation (Line(points={{82,46},{120,46}},
                     color={0,0,127}));
  connect(sub1.y, TSetTarPreCoo) annotation (Line(points={{68,-20},{120,-20}},
                           color={0,0,127}));
  connect(add2.y, TSetTarSheCoo) annotation (Line(points={{68,-46},{120,-46}},
                           color={0,0,127}));
  connect(booToRea.y, add1.u1) annotation (Line(points={{14,18},{36,18},{36,86},
          {60,86}}, color={0,0,127}));
  connect(booToRea.y, sub.u1) annotation (Line(points={{14,18},{36,18},{36,52},
          {58,52}},color={0,0,127}));
  connect(booToRea1.y, sub1.u1) annotation (Line(points={{16,-82},{34,-82},{34,
          -14},{44,-14}},
                    color={0,0,127}));
  connect(booToRea1.y, add2.u1) annotation (Line(points={{16,-82},{28,-82},{28,
          -40},{44,-40}},
                     color={0,0,127}));
  connect(con.y, add1.u2) annotation (Line(points={{-62,74},{60,74}},
                color={0,0,127}));
  connect(con2.y, sub1.u2) annotation (Line(points={{-50,-18},{-4,-18},{-4,-26},
          {44,-26}},color={0,0,127}));
  connect(con3.y, add2.u2)
    annotation (Line(points={{-52,-52},{44,-52}},color={0,0,127}));
  connect(con1.y, sub.u2) annotation (Line(points={{-28,50},{12,50},{12,40},{58,
          40}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>This block creates outputs for the zone&apos;s cooling and heating setpoint under different occupancy and different demand flexibility (pre-cool/pre-heat, baseline, load shed, load rebound) conditions. The pre-set variables are heating and cooling occupied and unoccupied setpoints under the baseline scenario. Then, adjustment variables such as <span style=\"font-family: Courier New;\">delTSetPreHea </span>and <span style=\"font-family: Courier New;\">delTSetSheHea </span>are applied to the heating and cooling occupied and unoccupied setpoints to output the desired setpoints. </p>
</html>"));
end ZoneSetpointSource;
