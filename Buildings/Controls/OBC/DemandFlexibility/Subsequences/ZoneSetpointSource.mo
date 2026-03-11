within Buildings.Controls.OBC.DemandFlexibility.Subsequences;
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
    annotation (Placement(transformation(extent={{-80,26},{-60,46}})));
  CDL.Conversions.BooleanToReal booToRea(realTrue=TSetNomHeaOcc, realFalse=
        TSetNomHeaUno)
    annotation (Placement(transformation(extent={{-8,32},{12,52}})));
  CDL.Conversions.BooleanToReal booToRea1(realTrue=TSetNomCooOcc, realFalse=
        TSetNomCooUno)
    annotation (Placement(transformation(extent={{-10,-104},{10,-84}})));
  CDL.Reals.Add add2
    annotation (Placement(transformation(extent={{46,-58},{66,-38}})));
  CDL.Reals.Subtract sub
    annotation (Placement(transformation(extent={{50,48},{70,68}})));
  CDL.Reals.Add add1
    annotation (Placement(transformation(extent={{46,80},{66,100}})));
  CDL.Reals.Subtract sub1
    annotation (Placement(transformation(extent={{48,-22},{68,-2}})));
  CDL.Reals.Sources.Constant con(k=delTSetPreHea)
    annotation (Placement(transformation(extent={{-42,94},{-22,114}})));
  CDL.Reals.Sources.Constant con1(k=delTSetSheHea)
    annotation (Placement(transformation(extent={{-42,56},{-22,76}})));
  CDL.Reals.Sources.Constant con2(k=delTSetPreCoo)
    annotation (Placement(transformation(extent={{-6,-20},{14,0}})));
  CDL.Reals.Sources.Constant con3(k=delTSetSheCoo)
    annotation (Placement(transformation(extent={{-8,-64},{12,-44}})));
equation
  connect(booTimTab.y[1], booToRea.u) annotation (Line(points={{-58,36},{-20,36},
          {-20,42},{-10,42}}, color={255,0,255}));
  connect(booTimTab.y[1], booToRea1.u) annotation (Line(points={{-58,36},{-22,36},
          {-22,-94},{-12,-94}}, color={255,0,255}));
  connect(booToRea.y, TSetNomHea) annotation (Line(points={{14,42},{94,42},{94,18},
          {120,18}}, color={0,0,127}));
  connect(booToRea1.y, TSetNomCoo) annotation (Line(points={{12,-94},{94,-94},{94,
          -82},{120,-82}}, color={0,0,127}));
  connect(add1.y, TSetTarPreHea) annotation (Line(points={{68,90},{94,90},{94,80},
          {120,80}}, color={0,0,127}));
  connect(sub.y, TSetTarSheHea) annotation (Line(points={{72,58},{94,58},{94,46},
          {120,46}}, color={0,0,127}));
  connect(sub1.y, TSetTarPreCoo) annotation (Line(points={{70,-12},{94,-12},{94,
          -20},{120,-20}}, color={0,0,127}));
  connect(add2.y, TSetTarSheCoo) annotation (Line(points={{68,-48},{96,-48},{96,
          -46},{120,-46}}, color={0,0,127}));
  connect(booToRea.y, add1.u1) annotation (Line(points={{14,42},{36,42},{36,96},
          {44,96}}, color={0,0,127}));
  connect(booToRea.y, sub.u1) annotation (Line(points={{14,42},{36,42},{36,64},{
          48,64}}, color={0,0,127}));
  connect(booToRea1.y, sub1.u1) annotation (Line(points={{12,-94},{34,-94},{34,-6},
          {46,-6}}, color={0,0,127}));
  connect(booToRea1.y, add2.u1) annotation (Line(points={{12,-94},{28,-94},{28,-42},
          {44,-42}}, color={0,0,127}));
  connect(con.y, add1.u2) annotation (Line(points={{-20,104},{34,104},{34,84},{44,
          84}}, color={0,0,127}));
  connect(con2.y, sub1.u2) annotation (Line(points={{16,-10},{36,-10},{36,-18},{
          46,-18}}, color={0,0,127}));
  connect(con3.y, add2.u2)
    annotation (Line(points={{14,-54},{44,-54}}, color={0,0,127}));
  connect(con1.y, sub.u2) annotation (Line(points={{-20,66},{38,66},{38,52},{48,
          52}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ZoneSetpointSource;
