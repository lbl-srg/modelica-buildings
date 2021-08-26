within Buildings.Controls.OBC.RadiantSystems.Heating;
block HighMassSupplyTemperature_TRoom
  "Room temperature controller for radiant heating with constant mass flow and variable supply temperature"

  parameter Real TSupSet_max(
    final unit="K",
    displayUnit="degC") "Maximum heating supply water temperature";
  parameter Real TSupSet_min(
    final unit="K",
    displayUnit="degC") = 293.15 "Minimum heating supply water temperature";

  parameter Controls.OBC.CDL.Types.SimpleController controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.P
    "Type of controller" annotation (Dialog(group="Control gains"));
  parameter Real k(
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)=2
    "Gain of controller"
    annotation (Dialog(group="Control gains"));
  parameter Real Ti(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)=3600
    "Time constant of integrator block"
    annotation (Dialog(group="Control gains",enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real Td(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)=0.1
    "Time constant of derivative block"
    annotation (Dialog(group="Control gains",enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  Controls.OBC.CDL.Interfaces.RealInput TRooSet(
    final unit="K",
    displayUnit="degC")
    "Set point for room air temperature" annotation (Placement(transformation(
          extent={{-140,20},{-100,60}}),   iconTransformation(extent={{-140,40},
            {-100,80}})));
  Controls.OBC.CDL.Interfaces.RealInput TRoo(
    final unit="K",
    displayUnit="degC") "Measured room air temperature"
    annotation (Placement(transformation(
          extent={{-140,-60},{-100,-20}}), iconTransformation(extent={{-140,-80},
            {-100,-40}})));
  Controls.OBC.CDL.Interfaces.RealOutput TSupSet(
    final unit="K",
    displayUnit="degC")
    "Set point for heating supply water temperature"
    annotation (Placement(transformation(extent={{100,60},{140,100}}),
        iconTransformation(extent={{100,40},{140,80}})));

  Controls.OBC.CDL.Interfaces.RealOutput y(
    final unit="1",
    final min=0,
    final max=1)
    "Control signal for heating system from P controller"
    annotation (Placement(
        transformation(extent={{100,10},{140,50}}), iconTransformation(extent={{
            100,0},{140,40}})));

  Controls.OBC.CDL.Interfaces.BooleanOutput on
    "Outputs true if the system is demanded on" annotation (Placement(
        transformation(extent={{100,-50},{140,-10}}),iconTransformation(extent={{100,-40},
            {140,0}})));

  Controls.OBC.CDL.Interfaces.RealOutput yPum(
    final unit="1",
    final min=0,
    final max=1)
    "Pump speed control signal"
    annotation (Placement(transformation(extent={{100,-100},{140,-60}}),
        iconTransformation(extent={{100,-80},{140,-40}})));

  Controls.OBC.CDL.Continuous.PID conHea(
    final controllerType=controllerType,
    final k=k,
    final Ti = Ti,
    final Td = Td,
    final yMax=1,
    final yMin=0,
    final reverseActing=true) "Controller for heating supply set point signal"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));

  Controls.OBC.CDL.Continuous.Hysteresis hysHea(
    uLow=0.1,
    uHigh=0.2)
    "Hysteresis to switch system on and off"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

protected
  Controls.OBC.CDL.Continuous.Sources.Constant one(final k=1) "Outputs one"
    annotation (Placement(transformation(extent={{-40,-42},{-20,-22}})));
  Controls.OBC.CDL.Continuous.Sources.Constant zero(final k=0) "Outputs zero"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));

  Controls.OBC.CDL.Continuous.Sources.Constant THeaSup_minimum(final k(
      final unit="K",
      displayUnit="degC") = TSupSet_min)
    "Negative value of minimum heating supply water temperature"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));

  Controls.OBC.CDL.Continuous.Sources.Constant THeaSup_maximum(
    final k(
      final unit="K",
      displayUnit="degC") = TSupSet_max) "Maximum heating supply water temperature"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));

  Controls.OBC.CDL.Continuous.Line TSup(
    limitBelow=false,
    limitAbove=false,
    y(final unit="K",
      displayUnit="degC"))
    "Set point for supply water temperature"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));

  Controls.OBC.CDL.Logical.Switch swiPum "Switch for pump"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
equation
  connect(hysHea.y,swiPum.u2)
    annotation (Line(points={{-18,0},{20,0},{20,-40},{38,-40}}, color={255,0,255}));
  connect(conHea.y,hysHea.u)
    annotation (Line(points={{-58,40},{-50,40},{-50,0},{-42,0}},
                                                      color={0,0,127}));
  connect(zero.y, swiPum.u3) annotation (Line(points={{-18,-60},{20,-60},{20,-48},
          {38,-48}}, color={0,0,127}));
  connect(one.y, swiPum.u1)
    annotation (Line(points={{-18,-32},{38,-32}}, color={0,0,127}));
  connect(TRoo, conHea.u_m)
    annotation (Line(points={{-120,-40},{-70,-40},{-70,28}},
                                                         color={0,0,127}));
  connect(TRooSet, conHea.u_s) annotation (Line(points={{-120,40},{-82,40}},
                         color={0,0,127}));
  connect(yPum, swiPum.y)
    annotation (Line(points={{120,-80},{92,-80},{92,-40},{62,-40}},
                                                  color={0,0,127}));
  connect(TSup.x1, zero.y) annotation (Line(points={{18,58},{-4,58},{-4,-60},{-18,
          -60}}, color={0,0,127}));
  connect(one.y, TSup.x2) annotation (Line(points={{-18,-32},{-2,-32},{-2,46},{18,
          46}}, color={0,0,127}));
  connect(conHea.y, TSup.u) annotation (Line(points={{-58,40},{-50,40},{-50,50},
          {18,50}}, color={0,0,127}));
  connect(TSup.f1, THeaSup_minimum.y) annotation (Line(points={{18,54},{0,54},{0,
          70},{-18,70}}, color={0,0,127}));
  connect(THeaSup_maximum.y, TSup.f2) annotation (Line(points={{-18,30},{0,30},{
          0,42},{18,42}}, color={0,0,127}));
  connect(TSup.y, TSupSet) annotation (Line(points={{42,50},{80,50},{80,80},{120,
          80}}, color={0,0,127}));
  connect(hysHea.y, on)
    annotation (Line(points={{-18,0},{80,0},{80,-30},{120,-30}},
                                               color={255,0,255}));
  connect(conHea.y, y) annotation (Line(points={{-58,40},{-50,40},{-50,50},{12,50},
          {12,30},{120,30}}, color={0,0,127}));
  annotation (
  defaultComponentName="conHea",
  Diagram(coordinateSystem(extent={{-100,-100},{100,100}})), Icon(
        coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
        Rectangle(extent={{-172,66},{-172,66}}, lineColor={28,108,200}),
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          lineColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name"),
        Text(
          extent={{74,92},{94,46}},
          lineColor={0,0,127},
          textString="TSet"),
        Text(
          extent={{76,-44},{96,-90}},
          lineColor={0,0,127},
          textString="yPum"),
        Text(
          extent={{76,2},{98,-16}},
          lineColor={0,0,127},
          textString="on"),
        Text(
          extent={{-92,92},{-48,44}},
          lineColor={0,0,127},
          textString="TRooSet"),
        Text(
          extent={{-92,-30},{-72,-76}},
          lineColor={0,0,127},
          textString="TRoo"),
        Rectangle(
          extent={{-30,-16},{48,-40}},
          lineColor={95,95,95},
          lineThickness=1,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Line(
          points={{56,-82},{56,-26},{-24,-26},{-24,-20},{56,-20}},
          color={238,46,47},
          thickness=1),
        Line(points={{-100,-60},{-62,-60},{-62,4},{-28,4}}, color={28,108,200}),
        Rectangle(
          extent={{-30,-16},{48,48}},
          lineColor={28,108,200},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(points={{-100,60},{-64,60},{-64,26},{-30,26}}, color={28,108,200}),
        Line(points={{106,60},{74,60},{74,-36},{58,-36}}, color={28,108,200}),
        Ellipse(
          extent={{46,-50},{68,-72}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{56,-50},{46,-60},{68,-60},{56,-50}},
          lineColor={28,108,200},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{100,-60},{84,-60},{68,-60}}, color={28,108,200}),
        Ellipse(
          extent={{56,-32},{64,-40}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{100,-20},{86,-20},{86,-60}},
                                               color={255,0,255}),
        Text(
          extent={{80,32},{98,16}},
          lineColor={0,0,127},
          textString="y")}),
    Documentation(info="<html>
<p>
Controller for a radiant heating system.
</p>
<p>
This controller tracks the room temperature set point <code>TRooSet</code> by
adjusting the supply water temperature set point <code>TSupSet</code>.
The pump is either off or operates at full speed, in which case <code>yPum = 1</code>.
The pump control is based on a hysteresis that takes as an input the control signal from
the supply temperature set point controller.
</p>
<p>
While this controller allows to be configured as a PI-controller,
for system with high mass, best result are achieved if configured as a P-controller,
which is the default setting.
</p>
</html>", revisions="<html>
<ul>
<li>
August 26, 2021, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end HighMassSupplyTemperature_TRoom;
