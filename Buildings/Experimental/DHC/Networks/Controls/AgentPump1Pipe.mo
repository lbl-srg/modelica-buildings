within Buildings.Experimental.DHC.Networks.Controls;
block AgentPump1Pipe
  "Ambient network storage and plants agent pump control, developed for reservoir network"
   parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=
      Buildings.Controls.OBC.CDL.Types.SimpleController.P "Type of controller";
   parameter Real yPumMin(min=0, max=1, final unit="1") = 0.05
    "Minimum pump speed";
   parameter Real yPumMax(min=0, max=1, final unit="1") = 1 "Upper limit of output";
   parameter Real k = 1 "Gain of controller";
   parameter Real Ti = 0.5 "Time constant of integrator block";
   parameter Real Td = 0.1 "Time constant of derivative block";
   parameter Modelica.Units.SI.TemperatureDifference dToff(min=0.1) = 1
    "Temperature offset to account for heat exchanger pinch point";
   parameter Real uLowHea = 1 "if y=true and u<uLow, switch to y=false";
   parameter Real uHighHea = 2 "if y=false and u>uHigh, switch to y=true";
   parameter Real uLowCoo = 1 "if y=true and u<uLow, switch to y=false";
   parameter Real uHighCoo = 2 "if y=false and u>uHigh, switch to y=true";
   parameter Real h = 0.15 "Hysteresis for net demand temperature calculation";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSouIn(final unit="K",
       displayUnit="degC") "Temperatures at the inlet of the source"
    annotation (Placement(transformation(extent={{-160,50},{-120,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSouOut(final unit="K",
      displayUnit="degC") "Agent supply temperature"
    annotation (Placement(transformation(extent={{-160,-30},{-120,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSou(final unit="K",
      displayUnit="degC") "Average temperature available at source"
    annotation (Placement(transformation(extent={{-160,10},{-120,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TretDis(final unit="K",
      displayUnit="degC") "District return temperature"
    annotation (Placement(transformation(extent={{-160,-70},{-120,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TsupDis(final unit="K",
      displayUnit="degC") "Plant supply temperature"
    annotation (Placement(transformation(extent={{-160,-100},{-120,-60}}),
        iconTransformation(extent={{-160,-100},{-120,-60}})));

  Buildings.Controls.OBC.CDL.Reals.Less NetDemBool(h=h)
    "Net district demand boolean"
    annotation (Placement(transformation(extent={{-102,-100},{-82,-80}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi
    annotation (Placement(transformation(extent={{110,-10},{130,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(
    min=0,
    max=1,
    unit="1")
    "Pump control signal"
    annotation (Placement(transformation(extent={{140,-20},{180,20}}),
        iconTransformation(extent={{140,-20},{180,20}})));
  Buildings.Controls.OBC.CDL.Reals.PID conPIDHea(
    controllerType=controllerType,
    k=k,
    Ti=Ti,
    Td=Td,
    yMax=yPumMax,
    yMin=yPumMin) "Controller to track target heating setpoint temperature"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));

  Buildings.Controls.OBC.CDL.Reals.PID conPIDCoo(
    controllerType=controllerType,
    k=k,
    Ti=Ti,
    Td=Td,
    yMax=yPumMax,
    yMin=yPumMin,
    reverseActing=false)
    "Controller to track target cooling setpoint temperature"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys(uLow=uLowCoo, uHigh=
        uHighCoo)
    "Turn on pump when source temperature lower than inlet temperature"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1
    annotation (Placement(transformation(extent={{60,-20},{80,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant Zero(k=0) "Pump off signal"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys1(uLow=uLowHea, uHigh=
        uHighHea)
    "Turn on pump when source temperature higher than inlet temperature"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi2
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai1(k=-1)
    "Change sign for hysteresis"
    annotation (Placement(transformation(extent={{-8,-40},{12,-20}})));

  Buildings.Controls.OBC.CDL.Reals.AddParameter Tsou_negshift(final p=-
        dToff, y(final unit="K", displayUnit="degC"))
    "Source temperature after negative shift"
    annotation (Placement(transformation(extent={{-40,69},{-20,91}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter Tsou_posshift(final p=
        dToff, y(final unit="K", displayUnit="degC"))
    "Source temperature after positive shift"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract dTSouSup
    "Temperature difference between source and source inlet"
    annotation (Placement(transformation(extent={{-100,40},{-80,20}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter dTSouSupHea(final p=-dToff, y(
        final unit="K", displayUnit="degC"))
    "Temperature difference between source and source inlet corrected for heating"
    annotation (Placement(transformation(extent={{-40,19},{-20,41}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter dTSouSupCoo(final p=dToff,  y(
        final unit="K", displayUnit="degC"))
    "Temperature difference between source and source inlet corrected for cooling"
    annotation (Placement(transformation(extent={{-40,-41},{-20,-19}})));

equation
  connect(NetDemBool.y, swi.u2) annotation (Line(points={{-80,-90},{98,-90},{98,
          0},{108,0}}, color={255,0,255}));
  connect(TretDis, NetDemBool.u1) annotation (Line(points={{-140,-50},{-110,-50},
          {-110,-90},{-104,-90}},                        color={0,0,127}));
  connect(TsupDis, NetDemBool.u2) annotation (Line(points={{-140,-80},{-112,-80},
          {-112,-98},{-104,-98}},  color={0,0,127}));
  connect(hys.y, swi1.u2) annotation (Line(points={{42,-30},{58,-30}},
                 color={255,0,255}));
  connect(Zero.y, swi1.u3) annotation (Line(points={{22,0},{50,0},{50,-22},{58,-22}},
        color={0,0,127}));
  connect(swi.y, y) annotation (Line(points={{132,0},{160,0}},
        color={0,0,127}));
  connect(conPIDCoo.y, swi1.u1) annotation (Line(points={{22,-70},{50,-70},{50,-38},
          {58,-38}},  color={0,0,127}));
  connect(swi1.y, swi.u3) annotation (Line(points={{82,-30},{100,-30},{100,-8},{
          108,-8}},                color={0,0,127}));
  connect(hys1.y, swi2.u2) annotation (Line(points={{42,30},{58,30}},
                    color={255,0,255}));
  connect(conPIDHea.y, swi2.u1) annotation (Line(points={{22,80},{50,80},{50,38},
          {58,38}},  color={0,0,127}));
  connect(Zero.y, swi2.u3)
    annotation (Line(points={{22,0},{50,0},{50,22},{58,22}}, color={0,0,127}));
  connect(swi2.y, swi.u1) annotation (Line(points={{82,30},{100,30},{100,8},{108,
          8}},                  color={0,0,127}));
  connect(TSou, Tsou_negshift.u) annotation (Line(points={{-140,30},{-116,30},{-116,
          80},{-42,80}},     color={0,0,127}));
  connect(Tsou_negshift.y, conPIDHea.u_s)
    annotation (Line(points={{-18,80},{-2,80}}, color={0,0,127}));
  connect(TSou, Tsou_posshift.u) annotation (Line(points={{-140,30},{-116,30},{-116,
          -70},{-42,-70}},     color={0,0,127}));
  connect(Tsou_posshift.y, conPIDCoo.u_s)
    annotation (Line(points={{-18,-70},{-2,-70}}, color={0,0,127}));
  connect(TSouOut, conPIDCoo.u_m) annotation (Line(points={{-140,-10},{-70,-10},
          {-70,-88},{10,-88},{10,-82}}, color={0,0,127}));
  connect(TSouOut, conPIDHea.u_m) annotation (Line(points={{-140,-10},{-70,-10},
          {-70,60},{10,60},{10,68}}, color={0,0,127}));
  connect(gai1.y, hys.u) annotation (Line(points={{14,-30},{18,-30}},
                                      color={0,0,127}));
  connect(dTSouSup.y, dTSouSupHea.u)
    annotation (Line(points={{-78,30},{-42,30}}, color={0,0,127}));
  connect(TSou,dTSouSup. u1) annotation (Line(points={{-140,30},{-116,30},{-116,
          24},{-102,24}},color={0,0,127}));
  connect(dTSouSupHea.y, hys1.u)
    annotation (Line(points={{-18,30},{18,30}}, color={0,0,127}));
  connect(dTSouSup.y,dTSouSupCoo. u) annotation (Line(points={{-78,30},{-50,30},
          {-50,-30},{-42,-30}}, color={0,0,127}));
  connect(dTSouSupCoo.y, gai1.u) annotation (Line(points={{-18,-30},{-10,-30}},
                                      color={0,0,127}));
  connect(TSouIn,dTSouSup. u2) annotation (Line(points={{-140,70},{-110,70},{-110,
          36},{-102,36}},                  color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,
            -100},{140,100}}),                                  graphics={
                                Rectangle(
        extent={{-120,-100},{140,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
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
          textString="Agent"),          Text(
        extent={{-152,170},{148,130}},
        textString="%name",
        textColor={0,0,255}),
        Text(
          extent={{-116,82},{-88,58}},
          textColor={0,0,127},
          textString="TSouIn"),
        Text(
          extent={{118,16},{140,-4}},
          textColor={0,0,127},
          textString="y"),
        Text(
          extent={{-116,42},{-94,20}},
          textColor={0,0,127},
          textString="TSou"),
        Text(
          extent={{-116,6},{-82,-24}},
          textColor={0,0,127},
          textString="TSouOut"),
        Text(
          extent={{-116,-34},{-84,-62}},
          textColor={0,0,127},
          textString="TretDis"),
        Text(
          extent={{-116,-66},{-84,-94}},
          textColor={0,0,127},
          textString="TsupDis")}),                               Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{140,
            100}})),
    Documentation(revisions="<html>
<ul>
<li>
January 20, 2023, by Ettore Zanetti:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Controller for balacing agents (i.e. reservoirs and plants) pump.
</p>
<p>
This controller decides to turn on or off the agent pump depending on the current net demand of the
district <code>if TretDis > TsupDis cooling else heating </code> and the temperature differential 
between the agent source temperature <code>TSou</code> and the agent inlet temperature <code>TSouIn</code>
adjusted by the offset <code>dToff</code>. In particular the pump turns on : <code>if heating and TSou - TsouIn - dToff > 0</code>
or <code>if cooling and TSouIn - Tsou - dToff > 0</code>. Then if the pump is turned on a PID controller, 
by default used as P, controls the pump control input by using <code>TSouOut</code> as measurement and as setpoint 
<code>Tsou - dToff</code> for heating or <code>Tsou + dToff</code> for cooling. <code>dToff</code> can be considered
the nominal value of the agent heat exchanger pinch point temperature difference.
</p>
<h4>References</h4>
<p>
Ettore Zanetti, David Blum, Michael Wetter <a href=\"https://www.conftool.com/modelica2023/index.php?page=browseSessions\">
Control development and sizing analysis for a 5th generation district heating and cooling network using Modelica</a>, 2023 International Modelica conference proceedings.
</p>

</html>"));
end AgentPump1Pipe;
