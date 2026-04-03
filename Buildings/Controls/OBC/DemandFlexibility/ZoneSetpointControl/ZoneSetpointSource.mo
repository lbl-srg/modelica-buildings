within Buildings.Controls.OBC.DemandFlexibility.ZoneSetpointControl;
model ZoneSetpointSource "Zone setpoint source"

  parameter Real TSetNomHeaOcc(unit="K")=273.15+20;
  parameter Real TSetNomHeaUno(unit="K")=273.15+15.5556;
  parameter Real TSetNomCooOcc(unit="K")=273.15+25.5556;
  parameter Real TSetNomCooUno(unit="K")=273.15+32.2222;
  parameter Real TSetAdjSheHea(unit="K")=5.5556 "zone temperature setpoint adjustment for heating load shed";
  parameter Real TSetAdjSheCoo(unit="K")=5.5556 "zone temperature setpoint adjustment for cooling load shed";

  parameter Real TSetAdjPreHea(unit="K")=1.1111 "zone temperature setpoint adjustment for heating pre-heat";
  parameter Real TSetAdjPreCoo(unit="K")=1.1111 "zone temperature setpoint adjustment for cooling pre-cool";

  parameter Real occStaHouSta=7;
  parameter Real occStaHouEnd=20;


  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSetTarPreHea
    annotation (Placement(transformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSetTarSheHea
                                         "setpoint target for load shed"
    annotation (Placement(transformation(extent={{100,26},{140,66}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSetBasHea "baseline setpoint"
    annotation (Placement(transformation(extent={{100,-2},{140,38}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSetTarPreCoo
                                         "setpoint target for precool"
    annotation (Placement(transformation(extent={{100,-40},{140,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSetTarSheCoo
                                         "setpoint target for load shed"
    annotation (Placement(transformation(extent={{100,-66},{140,-26}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSetBasCoo "baseline setpoint"
    annotation (Placement(transformation(extent={{100,-102},{140,-62}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable booTimTab(
    table=[0,0; occStaHouSta,1; occStaHouEnd,0; 24,0],
    timeScale=3600,
    period=86400)
    annotation (Placement(transformation(extent={{-86,8},{-66,28}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea(realTrue=TSetNomHeaOcc, realFalse=
        TSetNomHeaUno)
    annotation (Placement(transformation(extent={{-8,8},{12,28}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1(realTrue=TSetNomCooOcc, realFalse=
        TSetNomCooUno)
    annotation (Placement(transformation(extent={{-6,-92},{14,-72}})));
  Buildings.Controls.OBC.CDL.Reals.Add add2
    annotation (Placement(transformation(extent={{46,-56},{66,-36}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub
    annotation (Placement(transformation(extent={{60,36},{80,56}})));
  Buildings.Controls.OBC.CDL.Reals.Add add1
    annotation (Placement(transformation(extent={{62,70},{82,90}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub1
    annotation (Placement(transformation(extent={{46,-30},{66,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(k=TSetAdjPreHea)
    annotation (Placement(transformation(extent={{-84,64},{-64,84}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con1(k=TSetAdjSheHea)
    annotation (Placement(transformation(extent={{-50,40},{-30,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con2(k=TSetAdjPreCoo)
    annotation (Placement(transformation(extent={{-72,-28},{-52,-8}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con3(k=TSetAdjSheCoo)
    annotation (Placement(transformation(extent={{-74,-62},{-54,-42}})));
equation
  connect(booTimTab.y[1], booToRea.u) annotation (Line(points={{-64,18},{-10,18}},
                              color={255,0,255}));
  connect(booTimTab.y[1], booToRea1.u) annotation (Line(points={{-64,18},{-22,
          18},{-22,-82},{-8,-82}},
                                color={255,0,255}));
  connect(booToRea.y,TSetBasHea)  annotation (Line(points={{14,18},{120,18}},
                     color={0,0,127}));
  connect(booToRea1.y,TSetBasCoo)  annotation (Line(points={{16,-82},{120,-82}},
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
<p>This block creates output variables for a zone&apos;s cooling and heating setpoint under different occupancy conditions (occupied and unoccupied) and different demand flexibility modes (pre-cool/pre-heat, baseline, load-shed, load-rebound). </p>
<p>The parameters for this block are heating or cooling, and occupied or unoccupied setpoints under the baseline mode. Then, adjustment parameters such as <code>TSetAdjPreHea </code>and <code>TSetAdjSheHea </code>are applied to the setpoints under the baseline mode to output the desired setpoints for all demand flexibility modes. </p>
</html>",
        revisions="<html>
<ul>
<li>
April 03, 2026, by Weiping Huang:<br/>
First implementation.
</li>

</ul>
</html>"));
end ZoneSetpointSource;
