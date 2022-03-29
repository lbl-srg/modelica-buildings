within Buildings.Controls.OBC.RadiantSystems.Cooling;
block HighMassSupplyTemperature_TSurRelHum
  "Controller for radiant cooling that controls the surface temperature using constant mass flow and variable supply temperature"

  parameter Real TSupSet_max(
    final unit="K",
    displayUnit="degC") = 297.15 "Maximum cooling supply water temperature";

  parameter Real TSupSet_min(
    final unit="K",
    displayUnit="degC") "Minimum cooling supply water temperature";

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
    annotation (Dialog(group="Control gains",
      enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real Td(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)=0.1
    "Time constant of derivative block"
    annotation (Dialog(group="Control gains",
      enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  Controls.OBC.CDL.Interfaces.RealInput TSurSet(
    final unit="K",
    displayUnit="degC")
    "Set point for room air temperature" annotation (Placement(transformation(
          extent={{-140,60},{-100,100}}),  iconTransformation(extent={{-140,60},
            {-100,100}})));

  Controls.OBC.CDL.Interfaces.RealInput TRoo(
    final unit="K",
    displayUnit="degC") "Measured room air temperature"
    annotation (Placement(transformation(
          extent={{-140,-60},{-100,-20}}), iconTransformation(extent={{-140,-60},
            {-100,-20}})));

  Controls.OBC.CDL.Interfaces.RealInput phiRoo(
    final unit="1") "Measured room air relative humidity"
    annotation (Placement(transformation(
          extent={{-140,-100},{-100,-60}}),iconTransformation(extent={{-140,-100},
            {-100,-60}})));

  Controls.OBC.CDL.Interfaces.RealInput TSur(
    final unit="K",
    displayUnit="degC") "Measured room air temperature"
    annotation (Placement(transformation(
          extent={{-140,20},{-100,60}}),   iconTransformation(extent={{-140,20},
            {-100,60}})));

  Controls.OBC.CDL.Interfaces.RealOutput TSupSet(
    final unit="K",
    displayUnit="degC") "Set point for cooling supply water temperature"
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

  CDL.Psychrometrics.DewPoint_TDryBulPhi dewPoi
    "Dew point temperature, used to avoid condensation"
    annotation (Placement(transformation(extent={{-80,-56},{-60,-36}})));
  CDL.Continuous.Hysteresis hysCoo(
    uLow=0.1,
    uHigh=0.2)
    "Hysteresis to switch system on and off"
    annotation (Placement(transformation(extent={{30,-90},{50,-70}})));
  CDL.Continuous.PID conCoo(
    final controllerType=controllerType,
    final k=k,
    final Ti = Ti,
    final Td = Td,
    final yMax=1,
    final yMin=0,
    reverseActing=false)
    "Controller for cooling"
    annotation (Placement(transformation(extent={{-50,10},{-30,30}})));

protected
  CDL.Continuous.Sources.Constant TSupMin(
    final k(
      final unit="K",
      displayUnit="degC") = TSupSet_min,
      y(final unit="K", displayUnit="degC"))
    "Minimum cooling supply water temperature"
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  CDL.Continuous.Sources.Constant TSupMax(
    final k(
      final unit="K",
      displayUnit="degC") = TSupSet_max,
    y(final unit="K", displayUnit="degC"))
    "Maximum cooling supply water temperature"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));

  CDL.Continuous.Sources.Constant one(final k=1) "Outputs one"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  CDL.Continuous.Sources.Constant zero(final k=0) "Outputs zero"
    annotation (Placement(transformation(extent={{-10,60},{10,80}})));

  CDL.Continuous.Line TSupNoDewPoi(
    limitBelow=false,
    limitAbove=false,
    y(final unit="K", displayUnit="degC"))
    "Set point for supply water temperature without consideration of dew point"
    annotation (Placement(transformation(extent={{30,10},{50,30}})));
  CDL.Continuous.Max TSupCoo
    "Cooling water supply temperature"
    annotation (Placement(transformation(extent={{60,4},{80,24}})));
  CDL.Conversions.BooleanToReal booToRea(
    final realFalse=0,
    final realTrue=1)
    "Pump control signal as a Real number (either 0 or 1)"
    annotation (Placement(transformation(extent={{70,-90},{90,-70}})));

  CDL.Continuous.Max TSurConMin
    "Minimum allowed supply air temperature to avoid condensation"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
equation
  connect(hysCoo.y,booToRea.u)
    annotation (Line(points={{52,-80},{68,-80}},    color={255,0,255}));
  connect(conCoo.y,hysCoo.u)
    annotation (Line(points={{-28,20},{-20,20},{-20,-80},{28,-80}},
                                                    color={0,0,127}));
  connect(TSupCoo.y, TSupSet) annotation (Line(points={{82,14},{86,14},{86,80},{
          120,80}}, color={0,0,127}));
  connect(conCoo.y, y) annotation (Line(points={{-28,20},{-20,20},{-20,-58},{56,
          -58},{56,0},{92,0},{92,30},{120,30}},
                            color={0,0,127}));
  connect(dewPoi.phi, phiRoo) annotation (Line(points={{-82,-52},{-92,-52},{-92,
          -80},{-120,-80}},
                       color={0,0,127}));
  connect(booToRea.y, yPum)
    annotation (Line(points={{92,-80},{120,-80}}, color={0,0,127}));
  connect(hysCoo.y, on) annotation (Line(points={{52,-80},{60,-80},{60,-30},{120,
          -30}}, color={255,0,255}));
  connect(TSupNoDewPoi.x1, zero.y) annotation (Line(points={{28,28},{22,28},{22,
          70},{12,70}},  color={0,0,127}));
  connect(TSupNoDewPoi.f1, TSupMax.y) annotation (Line(points={{28,24},{16,24},{
          16,40},{12,40}},    color={0,0,127}));
  connect(TSupNoDewPoi.x2, one.y) annotation (Line(points={{28,16},{16,16},{16,0},
          {12,0}},         color={0,0,127}));
  connect(TSupNoDewPoi.f2, TSupMin.y) annotation (Line(points={{28,12},{22,12},
          {22,-30},{12,-30}},   color={0,0,127}));
  connect(conCoo.y, TSupNoDewPoi.u)
    annotation (Line(points={{-28,20},{28,20}}, color={0,0,127}));
  connect(TSupNoDewPoi.y, TSupCoo.u1) annotation (Line(points={{52,20},{58,20}},
                           color={0,0,127}));
  connect(TRoo, dewPoi.TDryBul) annotation (Line(points={{-120,-40},{-82,-40}},
                                       color={0,0,127}));
  connect(conCoo.u_m, TSur) annotation (Line(points={{-40,8},{-40,0},{-96,0},{-96,
          40},{-120,40}}, color={0,0,127}));
  connect(dewPoi.TDewPoi, TSurConMin.u2) annotation (Line(points={{-58,-46},{-50,
          -46},{-50,-30},{-88,-30},{-88,44},{-82,44}}, color={0,0,127}));
  connect(TSurSet, TSurConMin.u1) annotation (Line(points={{-120,80},{-90,80},{-90,
          56},{-82,56}}, color={0,0,127}));
  connect(TSurConMin.y, conCoo.u_s) annotation (Line(points={{-58,50},{-56,50},{
          -56,20},{-52,20}}, color={0,0,127}));
  connect(dewPoi.TDewPoi, TSupCoo.u2) annotation (Line(points={{-58,-46},{50,
          -46},{50,8},{58,8}},               color={0,0,127}));
  annotation (
  defaultComponentName="conCoo",
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
          extent={{-94,112},{-50,64}},
          textColor={0,0,127},
          textString="TSurSet"),
        Rectangle(
          extent={{-30,-16},{48,-40}},
          lineColor={95,95,95},
          lineThickness=1,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Line(
          points={{56,-82},{56,-26},{-24,-26},{-24,-20},{56,-20}},
          color={28,108,200},
          thickness=1),
        Rectangle(
          extent={{-30,-16},{48,48}},
          lineColor={28,108,200},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
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
        Line(points={{-30,12},{-72,12},{-72,-40},{-100,-40}},
             color={28,108,200}),
        Line(points={{-30,-8},{-66,-8},{-66,-80},{-100,-80}},
             color={28,108,200}),
        Text(
          extent={{-96,-6},{-76,-52}},
          textColor={0,0,127},
          textString="TRoo"),
        Text(
          extent={{-96,-44},{-76,-90}},
          textColor={0,0,127},
          textString="phi"),
        Text(
          extent={{-92,62},{-70,34}},
          textColor={0,0,127},
          textString="TSur"),
        Line(points={{4,-12},{-32,-12},{-32,-84},{-66,-84}},
             color={28,108,200}),
        Line(points={{-100,80},{20,80},{20,-16}},
             color={28,108,200})}),
    Documentation(info="<html>
<p>
Controller for a radiant cooling system.
</p>
<p>
The controller tracks the surface temperature set point <code>TSurSet</code> by
adjusting the supply water temperature set point <code>TSupSet</code>
based on the output signal <code>y</code> of the proportional controller.
Both, the surface temperature set point <code>TSurSet</code> and the resulting
supply water temperature set point <code>TSupSet</code> are
limited by the dew point temperature that is calculated based on the inputs
<code>TRoo</code> and <code>phiRoo</code>.
The pump is either off or operates at full speed, in which case <code>yPum = 1</code>.
The pump control is based on a hysteresis that switches the pump on when the output of the
proportional controller <code>y</code> exceeds <i>0.2</i>, and the pump is commanded off when the output falls
below <i>0.1</i>. See figure below for the control charts.
</p>
<p align=\"center\">
<img alt=\"Image of control output\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/RadiantSystems/Cooling/HighMassSupplyTemperature_TRoomRelHum.png\"/>
</p>
<p>
ASHRAE Standard 55-2004 recommends that the surface temperature of a radiant floor is above
<i>18</i>&deg;C to avoid discomfort for spaces in which people wear typical footwear.
</p>
<p>
For systems with high thermal mass, this controller should be left configured
as a P-controller, which is the default setting.
PI-controller likely saturate due to the slow system response.
</p>
</html>", revisions="<html>
<ul>
<li>
March 29, 2022, by Michael Wetter:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2823\">issue 2823</a>.
</li>
</ul>
</html>"));
end HighMassSupplyTemperature_TSurRelHum;
