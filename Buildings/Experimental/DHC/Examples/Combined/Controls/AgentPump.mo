within Buildings.Experimental.DHC.Examples.Combined.Controls;
block AgentPump "Ambient network storage and plants agent controls"
   extends Modelica.Blocks.Icons.Block;
   parameter Real yPumMin(min=0, max=1, final unit="1") = 0.05
    "Minimum pump speed";
   parameter Modelica.Units.SI.TemperatureDifference dTnom(min=0.1) = 1
    "Nominal temperature abs(DT) between supply and return for each load";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TsupDis(each final unit="K",
      each displayUnit="degC") "Plant supply temperature"
    annotation (Placement(transformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSouIn(each final unit="K",
      each displayUnit="degC") "Temperatures at the inlet of the source"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TretDis(each final unit="K",
      each displayUnit="degC") "District return temperature"
    annotation (Placement(transformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSou(each final unit="K",
      each displayUnit="degC") "Average temperature available at source"
    annotation (Placement(transformation(extent={{-140,32},{-100,72}})));
  Buildings.Controls.OBC.CDL.Reals.Less les1(h=h)
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi
    annotation (Placement(transformation(extent={{74,-2},{94,18}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(
    min=0,
    max=1,
    unit="1")
    "Pump control signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Reals.PID conPIDHea(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    k=khea,
    Ti=Ti,
    yMin=yPumMin)
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  parameter Real k=1 "Gain of controller";
  parameter Real khea=k "Gain of controller";
  parameter Real kcoo=k "Gain of controller";
  parameter Real Ti=0.5 "Time constant of integrator block";
  Buildings.Controls.OBC.CDL.Reals.PID conPIDCoo(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    k=kcoo,
    Ti=Ti,
    yMin=yPumMin,
    reverseActing=false)
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TsupPla(each final unit="K",
      each displayUnit="degC") "Plant supply temperature"
    annotation (Placement(transformation(extent={{-140,-30},{-100,10}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys(uLow=uLowCoo, uHigh=
        uHighCoo)
    annotation (Placement(transformation(extent={{18,-98},{38,-78}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1
    annotation (Placement(transformation(extent={{46,-20},{66,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(k=0)
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  parameter Real uLowHea=1 "if y=true and u<uLow, switch to y=false";
  parameter Real uHighHea=2 "if y=false and u>uHigh, switch to y=true";
  parameter Real uLowCoo=1 "if y=true and u<uLow, switch to y=false";
  parameter Real uHighCoo=2 "if y=false and u>uHigh, switch to y=true";
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys1(uLow=uLowHea, uHigh=
        uHighHea)
    annotation (Placement(transformation(extent={{22,70},{42,90}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi2
    annotation (Placement(transformation(extent={{40,38},{60,58}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai1(k=-1)
    annotation (Placement(transformation(extent={{-14,-98},{6,-78}})));
  parameter Real h=0.15 "Hysteresis";
  Buildings.Controls.OBC.CDL.Reals.AddParameter Tsou_negshift(final p=-
        dTnom, y(final unit="K", displayUnit="degC"))
    "Source temperature after negative shift"
    annotation (Placement(transformation(extent={{-40,39},{-20,61}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter Tsou_posshift(final p=
        dTnom, y(final unit="K", displayUnit="degC"))
    "Source temperature after positive shift"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract dTLoads3
    "Temperature differences over loads"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter TMax_lower2(final p=-dTnom,  y(
        final unit="K", displayUnit="degC"))
    "Minimum temperatuer value of upper slope after shifting it"
    annotation (Placement(transformation(extent={{-26,69},{-6,91}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter TMax_lower3(final p=dTnom,  y(
        final unit="K", displayUnit="degC"))
    "Minimum temperatuer value of upper slope after shifting it"
    annotation (Placement(transformation(extent={{-42,-99},{-22,-77}})));
equation
  connect(les1.y, swi.u2) annotation (Line(points={{-58,-50},{70,-50},{70,8},{
          72,8}}, color={255,0,255}));
  connect(TretDis, les1.u1) annotation (Line(points={{-120,-50},{-82,-50}},
                      color={0,0,127}));
  connect(TsupDis, les1.u2) annotation (Line(points={{-120,-90},{-90,-90},{-90,
          -58},{-82,-58}},
                      color={0,0,127}));
  connect(hys.y, swi1.u2) annotation (Line(points={{40,-88},{40,-32},{44,-32},{
          44,-30}},
                 color={255,0,255}));
  connect(con.y, swi1.u3) annotation (Line(points={{22,10},{30,10},{30,-22},{44,
          -22}},      color={0,0,127}));
  connect(swi.y, y) annotation (Line(points={{96,8},{98,8},{98,0},{120,0}},
        color={0,0,127}));
  connect(conPIDCoo.y, swi1.u1) annotation (Line(points={{22,-30},{32,-30},{32,
          -38},{44,-38}},
                      color={0,0,127}));
  connect(swi1.y, swi.u3) annotation (Line(points={{68,-30},{72,-30},{72,0}},
                                   color={0,0,127}));
  connect(hys1.y, swi2.u2) annotation (Line(points={{44,80},{50,80},{50,62},{32,
          62},{32,48},{38,48}},
                    color={255,0,255}));
  connect(conPIDHea.y, swi2.u1) annotation (Line(points={{22,50},{30,50},{30,56},
          {38,56}},  color={0,0,127}));
  connect(con.y, swi2.u3) annotation (Line(points={{22,10},{30,10},{30,40},{38,
          40}},                        color={0,0,127}));
  connect(swi2.y, swi.u1) annotation (Line(points={{62,48},{72,48},{72,16}},
                                color={0,0,127}));
  connect(TSou, Tsou_negshift.u) annotation (Line(points={{-120,52},{-40,52},{
          -40,50},{-42,50}}, color={0,0,127}));
  connect(Tsou_negshift.y, conPIDHea.u_s)
    annotation (Line(points={{-18,50},{-2,50}}, color={0,0,127}));
  connect(TSou, Tsou_posshift.u) annotation (Line(points={{-120,52},{-92,52},{
          -92,-30},{-42,-30}}, color={0,0,127}));
  connect(Tsou_posshift.y, conPIDCoo.u_s)
    annotation (Line(points={{-18,-30},{-2,-30}}, color={0,0,127}));
  connect(TsupPla, conPIDCoo.u_m) annotation (Line(points={{-120,-10},{-10,-10},
          {-10,-48},{10,-48},{10,-42}}, color={0,0,127}));
  connect(TsupPla, conPIDHea.u_m) annotation (Line(points={{-120,-10},{-10,-10},
          {-10,30},{10,30},{10,38}}, color={0,0,127}));
  connect(gai1.y, hys.u) annotation (Line(points={{8,-88},{16,-88}},
                                      color={0,0,127}));
  connect(dTLoads3.y, TMax_lower2.u)
    annotation (Line(points={{-58,10},{-54,10},{-54,80},{-28,80}},
                                                          color={0,0,127}));
  connect(TSou, dTLoads3.u1) annotation (Line(points={{-120,52},{-92,52},{-92,
          16},{-82,16}}, color={0,0,127}));
  connect(TMax_lower2.y, hys1.u) annotation (Line(points={{-4,80},{20,80}},
                                        color={0,0,127}));
  connect(dTLoads3.y, TMax_lower3.u) annotation (Line(points={{-58,10},{-48,10},
          {-48,-88},{-44,-88}}, color={0,0,127}));
  connect(TMax_lower3.y, gai1.u) annotation (Line(points={{-20,-88},{-16,-88}},
                                      color={0,0,127}));
  connect(TSouIn, dTLoads3.u2) annotation (Line(points={{-120,20},{-94,20},{-94,
          4},{-82,4}},                     color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,
            -120},{140,120}}),                                  graphics={
        Ellipse(
          extent={{-54,64},{48,-36}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-4,64},{-4,-36},{48,14},{-4,64}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-62,-46},{68,-84}},
          textColor={0,0,0},
          textString="Plant")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-120},{140,
            120}})));
end AgentPump;
