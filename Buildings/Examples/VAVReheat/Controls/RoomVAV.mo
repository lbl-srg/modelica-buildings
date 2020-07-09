within Buildings.Examples.VAVReheat.Controls;
block RoomVAV "Controller for room VAV box"
  extends Modelica.Blocks.Icons.Block;

  parameter Real ratVFloMin(final unit="1") = 0.3
    "VAV box minimum airflow ratio";
  parameter Real ratVFloHea(final unit="1") = ratVFloMin
    "VAV box airflow ratio in heating mode";
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController cooController=
      Buildings.Controls.OBC.CDL.Types.SimpleController.PI "Type of controller"
    annotation (Dialog(group="Cooling controller"));
  parameter Real kCoo=0.1 "Gain of controller"
    annotation (Dialog(group="Cooling controller"));
  parameter Modelica.SIunits.Time TiCoo=120 "Time constant of integrator block"
    annotation (Dialog(group="Cooling controller", enable=cooController==Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
                                                          cooController==Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Modelica.SIunits.Time TdCoo=60 "Time constant of derivative block"
    annotation (Dialog(group="Cooling controller", enable=cooController==Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
                                                          cooController==Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController heaController=
      Buildings.Controls.OBC.CDL.Types.SimpleController.PI "Type of controller"
    annotation (Dialog(group="Heating controller"));
  parameter Real kHea=0.1 "Gain of controller"
    annotation (Dialog(group="Heating controller"));
  parameter Modelica.SIunits.Time TiHea=120 "Time constant of integrator block"
    annotation (Dialog(group="Heating controller", enable=heaController==Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
                                                          heaController==Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Modelica.SIunits.Time TdHea=60 "Time constant of derivative block"
    annotation (Dialog(group="Heating controller", enable=heaController==Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
                                                          heaController==Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRooHeaSet(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC")
    "Setpoint temperature for room for heating"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRooCooSet(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC")
    "Setpoint temperature for room for cooling"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput TRoo(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC")
    "Measured room temperature"
    annotation (Placement(transformation(extent={{-140,-90},{-100,-50}}),
        iconTransformation(extent={{-120,-80},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealOutput yDam "Signal for VAV damper"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,38},{120,58}})));
  Modelica.Blocks.Interfaces.RealOutput yVal "Signal for heating coil valve"
    annotation (Placement(transformation(extent={{100,-80},{120,-60}}),
        iconTransformation(extent={{100,-60},{120,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.LimPID conHea(
    yMax=yMax,
    Td=TdHea,
    yMin=yMin,
    k=kHea,
    Ti=TiHea,
    controllerType=heaController,
    Ni=10)                        "Controller for heating"
    annotation (Placement(transformation(extent={{30,-80},{50,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conCoo(
    yMax=yMax,
    Td=TdCoo,
    k=kCoo,
    Ti=TiCoo,
    controllerType=cooController,
    yMin=yMin,
    reverseActing=false)
    "Controller for cooling (acts on damper)"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Line reqFlo "Required flow rate"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cooMax(k=1)
    "Cooling maximum flow"
    annotation (Placement(transformation(extent={{30,-50},{50,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minFloCoo(k=ratVFloMin)
    "VAV box minimum flow in cooling mode"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conOne(k=1)
    "Constant 1"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conZer(k=0)
    "Constant 0"
    annotation (Placement(transformation(extent={{30,30},{50,50}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysWitHol(uLow=-dTHys, uHigh=
       0) "Output true if room temperature below heating set point"
    annotation (Placement(transformation(extent={{-10,110},{10,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Feedback dTHea
    "Heating loop control error"
    annotation (Placement(transformation(extent={{-50,110},{-30,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minFloHea(k=
        ratVFloMinHea) "VAV box minimum flow in heating mode"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    "Switch minimum air flow rate between heating and cooling mode"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(message=
    "The difference between cooling and heating set points must be greater than dTHys")
    "Assert message"
    annotation (Placement(transformation(extent={{30,-130},{50,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Feedback dTSet
    "Difference between cooling and heating set points"
    annotation (Placement(transformation(extent={{-50,-130},{-30,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(threshold=dTHys)
    "Test for overlap of heating and cooling set points "
    annotation (Placement(transformation(extent={{-10,-130},{10,-110}})));
protected
  parameter Real yMax=1 "Upper limit of PID control output";
  parameter Real yMin=0 "Lower limit of PID control output";
  parameter Modelica.SIunits.TemperatureDifference dTHys(final min=0) = 0.5
    "Hysteresis width for enabling cooling mode";
equation
  connect(TRooCooSet, conCoo.u_s)
    annotation (Line(points={{-120,0},{-62,0}}, color={0,0,127}));
  connect(TRoo, conHea.u_m) annotation (Line(points={{-120,-70},{-80,-70},{-80,-90},
          {40,-90},{40,-82}},        color={0,0,127}));
  connect(TRooHeaSet, conHea.u_s) annotation (Line(points={{-120,60},{-70,60},{-70,
          -70},{28,-70}},      color={0,0,127}));
  connect(conHea.y, yVal)
    annotation (Line(points={{52,-70},{110,-70}},  color={0,0,127}));
  connect(conZer.y, reqFlo.x1)
    annotation (Line(points={{52,40},{60,40},{60,8},{68,8}},color={0,0,127}));
  connect(cooMax.y, reqFlo.f2) annotation (Line(points={{52,-40},{60,-40},{60,-8},
          {68,-8}},color={0,0,127}));
  connect(conOne.y, reqFlo.x2) annotation (Line(points={{-38,-40},{20,-40},{20,-4},
          {68,-4}},     color={0,0,127}));
  connect(conCoo.y, reqFlo.u)
    annotation (Line(points={{-38,0},{68,0}}, color={0,0,127}));
  connect(TRoo, conCoo.u_m) annotation (Line(points={{-120,-70},{-80,-70},{-80,-20.6836},
          {-80,-20},{-50,-20},{-50,-12}},
                                     color={0,0,127}));
  connect(reqFlo.y, yDam)
    annotation (Line(points={{92,0},{110,0}},               color={0,0,127}));

  connect(TRooHeaSet, dTHea.u1) annotation (Line(points={{-120,60},{-70,60},{-70,
          120},{-52,120}}, color={0,0,127}));
  connect(dTHea.y, hysWitHol.u)
    annotation (Line(points={{-28,120},{-12,120}}, color={0,0,127}));
  connect(TRoo, dTHea.u2) annotation (Line(points={{-120,-70},{-80,-70},{-80,100},
          {-40,100},{-40,108}}, color={0,0,127}));
  connect(minFloCoo.y, swi.u3) annotation (Line(points={{-38,40},{-20,40},{-20,52},
          {-12,52}}, color={0,0,127}));
  connect(minFloHea.y, swi.u1) annotation (Line(points={{-38,80},{-20,80},{-20,68},
          {-12,68}}, color={0,0,127}));
  connect(hysWitHol.y, swi.u2) annotation (Line(points={{12,120},{20,120},{20,80},
          {-16,80},{-16,60},{-12,60}}, color={255,0,255}));
  connect(swi.y, reqFlo.f1)
    annotation (Line(points={{12,60},{20,60},{20,4},{68,4}}, color={0,0,127}));
  connect(TRooCooSet, dTSet.u1) annotation (Line(points={{-120,0},{-90,0},{-90,-120},
          {-52,-120}}, color={0,0,127}));
  connect(TRooHeaSet, dTSet.u2) annotation (Line(points={{-120,60},{-70,60},{-70,
          -136},{-40,-136},{-40,-132}}, color={0,0,127}));
  connect(dTSet.y, greThr.u)
    annotation (Line(points={{-28,-120},{-12,-120}}, color={0,0,127}));
  connect(greThr.y, assMes.u)
    annotation (Line(points={{12,-120},{28,-120}}, color={255,0,255}));
annotation (
  defaultComponentName="terCon",
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
                    graphics={
        Text(
          extent={{-100,-62},{-66,-76}},
          lineColor={0,0,127},
          textString="TRoo"),
        Text(
          extent={{64,-38},{92,-58}},
          lineColor={0,0,127},
          textString="yVal"),
        Text(
          extent={{56,62},{90,40}},
          lineColor={0,0,127},
          textString="yDam"),
        Text(
          extent={{-96,82},{-36,60}},
          lineColor={0,0,127},
          textString="TRooHeaSet"),
        Text(
          extent={{-96,10},{-36,-10}},
          lineColor={0,0,127},
          textString="TRooCooSet")}),
 Documentation(info="<html>
<p>
Controller for terminal VAV box with hot water reheat and pressure independent damper.
It was implemented according to
<a href=\"https://newbuildings.org/sites/default/files/A-11_LG_VAV_Guide_3.6.2.pdf\">
[Advanced Variabled Air Volume System Design Guide]</a>, single maximum VAV reheat box
control.
The damper control signal <code>yDam</code> corresponds to the discharge air flow rate
set-point, normalized to the nominal value.
</p>
<ul>
<li>
In cooling demand, the damper control signal <code>yDam</code> is modulated between
a minimum value <code>ratVFloMin</code> (typically between 30% and 50%) and 1
(corresponding to the nominal value).
The control signal for the reheat coil valve <code>yVal</code> is 0
(corresponding to the valve fully closed).
</li>
<li>
In heating demand, the damper control signal <code>yDam</code> is fixed at the minimum value
<code>ratVFloMin</code>.
The control signal for the reheat coil valve <code>yVal</code> is modulated between
0 and 1 (corresponding to the valve fully open).
</li>
</ul>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/VAVReheat/vavBoxSingleMax.png\" border=\"1\"/>
</p>
<br/>
</html>", revisions="<html>
<ul>
<li>
April 24, 2020, by Jianjun Hu:<br/>
Refactored the model to implement a single maximum control logic.
The previous implementation led to a maximum air flow rate in heating demand.<br/>
The input connector <code>TDis</code> is removed. This is non backward compatible.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1873\">issue 1873</a>.
</li>
<li>
September 20, 2017, by Michael Wetter:<br/>
Removed blocks with blocks from CDL package.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-100,-140},{100,140}})));
end RoomVAV;
