within Buildings.Controls.OBC.DemandFlexibility.Generic;
model ZoneSetpointSource

    parameter Real TDefOccHeaSet(unit="K")=273.15+20;
  parameter Real TDefUnoHeaSet(unit="K")=273.15+15.5556;
  parameter Real TDefOccCooSet(unit="K")=273.15+25.5556;
  parameter Real TDefUnoCooSet(unit="K")=273.15+32.2222;
  parameter Real dTSheHeaSet(unit="K")=5.5556 "zone temperature setpoint delta for heating load shed";
  parameter Real dTSheCooSet(unit="K")=5.5556 "zone temperature setpoint delta for cooling load shed";

  parameter Real dTPreHeaSet(unit="K")=1.1111 "zone temperature setpoint delta for heating pre-heat";
  parameter Real dTPreCooSet(unit="K")=1.1111 "zone temperature setpoint delta for cooling pre-cool";

  parameter Real occHouSta=7;
  parameter Real occHouEnd=20;
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TPreTarHeaSet
    annotation (Placement(transformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSheTarHeaSet
    "setpoint target for load shed"
    annotation (Placement(transformation(extent={{100,26},{140,66}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TDefHeaSet
    "nominal setpoint"
    annotation (Placement(transformation(extent={{100,-2},{140,38}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TPreTarCooSet
    "setpoint target for precool"
    annotation (Placement(transformation(extent={{100,-40},{140,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSheTarCooSet
    "setpoint target for load shed"
    annotation (Placement(transformation(extent={{100,-66},{140,-26}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TDefCooSet
    "nominal setpoint"
    annotation (Placement(transformation(extent={{100,-102},{140,-62}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable booTimTab(
    table=[0,0; occHouSta,1; occHouEnd,0; 24,0],
    timeScale=3600,
    period=86400)
    annotation (Placement(transformation(extent={{-86,8},{-66,28}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea(realTrue=
        TDefOccHeaSet, realFalse=TDefUnoHeaSet)
    annotation (Placement(transformation(extent={{-8,8},{12,28}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1(realTrue=
        TDefOccCooSet, realFalse=TDefUnoCooSet)
    annotation (Placement(transformation(extent={{-6,-92},{14,-72}})));
  Buildings.Controls.OBC.CDL.Reals.Add add2
    annotation (Placement(transformation(extent={{46,-56},{66,-36}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub
    annotation (Placement(transformation(extent={{60,36},{80,56}})));
  Buildings.Controls.OBC.CDL.Reals.Add add1
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub1
    annotation (Placement(transformation(extent={{46,-30},{66,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(k=dTPreHeaSet)
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con1(k=dTSheHeaSet)
    annotation (Placement(transformation(extent={{-50,40},{-30,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con2(k=dTPreCooSet)
    annotation (Placement(transformation(extent={{-72,-28},{-52,-8}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con3(k=dTSheCooSet)
    annotation (Placement(transformation(extent={{-74,-62},{-54,-42}})));
equation
  connect(booTimTab.y[1], booToRea.u) annotation (Line(points={{-64,18},{-10,18}},
                              color={255,0,255}));
  connect(booTimTab.y[1], booToRea1.u) annotation (Line(points={{-64,18},{-22,
          18},{-22,-82},{-8,-82}},
                                color={255,0,255}));
  connect(booToRea.y, TDefHeaSet) annotation (Line(points={{14,18},{120,18}},
                     color={0,0,127}));
  connect(booToRea1.y, TDefCooSet) annotation (Line(points={{16,-82},{120,-82}},
                           color={0,0,127}));
  connect(add1.y, TPreTarHeaSet) annotation (Line(points={{82,90},{102,90},{102,
          80},{120,80}},
                     color={0,0,127}));
  connect(sub.y, TSheTarHeaSet) annotation (Line(points={{82,46},{120,46}},
                     color={0,0,127}));
  connect(sub1.y, TPreTarCooSet) annotation (Line(points={{68,-20},{120,-20}},
                           color={0,0,127}));
  connect(add2.y, TSheTarCooSet) annotation (Line(points={{68,-46},{120,-46}},
                           color={0,0,127}));
  connect(booToRea.y, add1.u1) annotation (Line(points={{14,18},{36,18},{36,96},
          {58,96}}, color={0,0,127}));
  connect(booToRea.y, sub.u1) annotation (Line(points={{14,18},{36,18},{36,52},
          {58,52}},color={0,0,127}));
  connect(booToRea1.y, sub1.u1) annotation (Line(points={{16,-82},{34,-82},{34,
          -14},{44,-14}},
                    color={0,0,127}));
  connect(booToRea1.y, add2.u1) annotation (Line(points={{16,-82},{28,-82},{28,
          -40},{44,-40}},
                     color={0,0,127}));
  connect(con.y, add1.u2) annotation (Line(points={{-58,90},{-2,90},{-2,84},{58,
          84}}, color={0,0,127}));
  connect(con2.y, sub1.u2) annotation (Line(points={{-50,-18},{-4,-18},{-4,-26},
          {44,-26}},color={0,0,127}));
  connect(con3.y, add2.u2)
    annotation (Line(points={{-52,-52},{44,-52}},color={0,0,127}));
  connect(con1.y, sub.u2) annotation (Line(points={{-28,50},{12,50},{12,40},{58,
          40}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>This block creates outputs for the zone&apos;s cooling and heating setpoint under different occupancy 
and different demand flexibility (pre-cool/pre-heat, baseline, load shed, load rebound) conditions. 
The pre-set variables are heating and cooling occupied and unoccupied setpoints under the baseline 
scenario. Then, adjustment variables such as <code>dTPreHeaSet </code>and 
<code>dTSheHeaSet </code> are applied to the heating and cooling occupied and unoccupied setpoints 
to output the desired setpoints. </p>
</html>"));
end ZoneSetpointSource;
