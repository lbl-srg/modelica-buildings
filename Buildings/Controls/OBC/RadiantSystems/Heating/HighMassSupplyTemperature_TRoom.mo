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
          extent={{-140,40},{-100,80}}),   iconTransformation(extent={{-140,40},
            {-100,80}})));
  Controls.OBC.CDL.Interfaces.RealInput TRoo(
    final unit="K",
    displayUnit="degC") "Measured room air temperature"
    annotation (Placement(transformation(
          extent={{-140,-20},{-100,20}}),  iconTransformation(extent={{-140,-20},
            {-100,20}})));
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

  Buildings.Controls.OBC.CDL.Reals.PID conHea(
    final controllerType=controllerType,
    final k=k,
    final Ti = Ti,
    final Td = Td,
    final yMax=1,
    final yMin=0,
    final reverseActing=true) "Controller for heating supply set point signal"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hysHea(
    uLow=0.1,
    uHigh=0.2)
    "Hysteresis to switch system on and off"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant one(final k=1) "Outputs one"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zero(final k=0) "Outputs zero"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THeaSup_minimum(final k(
      final unit="K",
      displayUnit="degC") = TSupSet_min)
    "Negative value of minimum heating supply water temperature"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THeaSup_maximum(
    final k(
      final unit="K",
      displayUnit="degC") = TSupSet_max) "Maximum heating supply water temperature"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));

  Buildings.Controls.OBC.CDL.Reals.Line TSup(
    limitBelow=false,
    limitAbove=false,
    y(final unit="K",
      displayUnit="degC")) "Set point for supply water temperature"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));

  CDL.Conversions.BooleanToReal booToRea(
    final realFalse=0,
    final realTrue=1)
    "Pump control signal as a Real number (either 0 or 1)"
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
equation
  connect(conHea.y,hysHea.u)
    annotation (Line(points={{-58,20},{-50,20},{-50,-60},{-42,-60}},
                                                      color={0,0,127}));
  connect(TRoo, conHea.u_m)
    annotation (Line(points={{-120,0},{-70,0},{-70,8}},  color={0,0,127}));
  connect(TRooSet, conHea.u_s) annotation (Line(points={{-120,60},{-90,60},{-90,
          20},{-82,20}}, color={0,0,127}));
  connect(TSup.x1, zero.y) annotation (Line(points={{18,28},{0,28},{0,70},{-18,70}},
                 color={0,0,127}));
  connect(one.y, TSup.x2) annotation (Line(points={{-18,0},{-4,0},{-4,16},{18,16}},
                color={0,0,127}));
  connect(conHea.y, TSup.u) annotation (Line(points={{-58,20},{18,20}},
                    color={0,0,127}));
  connect(TSup.f1, THeaSup_minimum.y) annotation (Line(points={{18,24},{-4,24},{
          -4,40},{-18,40}},
                         color={0,0,127}));
  connect(THeaSup_maximum.y, TSup.f2) annotation (Line(points={{-18,-30},{0,-30},
          {0,12},{18,12}},color={0,0,127}));
  connect(TSup.y, TSupSet) annotation (Line(points={{42,20},{80,20},{80,80},{120,
          80}}, color={0,0,127}));
  connect(hysHea.y, on)
    annotation (Line(points={{-18,-60},{80,-60},{80,-30},{120,-30}},
                                               color={255,0,255}));
  connect(conHea.y, y) annotation (Line(points={{-58,20},{-50,20},{-50,88},{60,88},
          {60,30},{120,30}}, color={0,0,127}));
  connect(booToRea.y, yPum)
    annotation (Line(points={{62,-80},{120,-80}}, color={0,0,127}));
  connect(booToRea.u, hysHea.y) annotation (Line(points={{38,-80},{20,-80},{20,-60},
          {-18,-60}}, color={255,0,255}));
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
          textColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name"),
        Text(
          extent={{58,94},{94,44}},
          textColor={0,0,127},
          textString="TSupSet"),
        Text(
          extent={{76,-44},{96,-90}},
          textColor={0,0,127},
          textString="yPum"),
        Text(
          extent={{76,2},{98,-16}},
          textColor={0,0,127},
          textString="on"),
        Text(
          extent={{-92,92},{-48,44}},
          textColor={0,0,127},
          textString="TRooSet"),
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
          textColor={0,0,127},
          textString="y"),
        Text(
          extent={{230,108},{110,58}},
          textColor={0,0,127},
          textString=DynamicSelect("",
            String(TSupSet,
              leftJustified=false,
              significantDigits=3))),
        Text(
          extent={{230,64},{110,14}},
          textColor={0,0,127},
          textString=DynamicSelect("",
            String(y,
              leftJustified=false,
              significantDigits=2))),
        Line(points={{-100,0},{-30,0}},                     color={28,108,200}),
        Text(
          extent={{-92,30},{-72,-16}},
          textColor={0,0,127},
          textString="TRoo")}),
    Documentation(info="<html>
<p>
Controller for a radiant heating system.
</p>
<p>
The controller tracks the room temperature set point <code>TRooSet</code> by
adjusting the supply water temperature set point <code>TSupSet</code> linearly between
<code>TSupSetMin</code> and <code>TSupSetMax</code>
based on the output signal <code>y</code> of the proportional controller.
The pump is either off or operates at full speed, in which case <code>yPum = 1</code>.
The pump control is based on a hysteresis that switches the pump on when the output of the
proportional controller <code>y</code> exceeds <i>0.2</i>, and the pump is commanded off when the output falls
below <i>0.1</i>. See figure below for the control charts.
</p>
<p align=\"center\">
<img alt=\"Image of control output\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/RadiantSystems/Heating/HighMassSupplyTemperature_TRoom.png\"/>
</p>
<p>
For systems with high thermal mass, this controller should be left configured
as a P-controller, which is the default setting.
PI-controller likely saturate due to the slow system response.
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
