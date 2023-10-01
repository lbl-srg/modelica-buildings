within Buildings.Examples.VAVReheat.BaseClasses.Controls;
block RoomVAV "Controller for room VAV box"
  extends Modelica.Blocks.Icons.Block;

  parameter Boolean have_preIndDam = true
    "True: the terminal box has pressure independent damper";
  parameter Real ratVFloMin(final unit="1") = 0.3
    "Minimum airflow set point (ratio to nominal)";
  parameter Real ratVFloHea(final unit="1") = ratVFloMin
    "Heating airflow set point (ratio to nominal)";
  parameter Modelica.Units.SI.VolumeFlowRate V_flow_nominal(min=0)=0.1
    "Norminal air volume flow rate"
    annotation (Dialog(enable=not have_preIndDam));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController cooController=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI "Type of controller"
    annotation (Dialog(group="Cooling controller"));
  parameter Real kCoo=0.1 "Gain of controller"
    annotation (Dialog(group="Cooling controller"));
  parameter Modelica.Units.SI.Time TiCoo=120
    "Time constant of integrator block" annotation (Dialog(group=
          "Cooling controller", enable=cooController == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
           or cooController == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Modelica.Units.SI.Time TdCoo=60 "Time constant of derivative block"
    annotation (Dialog(group="Cooling controller", enable=cooController ==
          Buildings.Controls.OBC.CDL.Types.SimpleController.PD or cooController
           == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController heaController=
      Buildings.Controls.OBC.CDL.Types.SimpleController.PI "Type of controller"
    annotation (Dialog(group="Heating controller"));
  parameter Real kHea=0.1 "Gain of controller"
    annotation (Dialog(group="Heating controller"));
  parameter Modelica.Units.SI.Time TiHea=120
    "Time constant of integrator block" annotation (Dialog(group=
          "Heating controller", enable=heaController == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
           or heaController == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Modelica.Units.SI.Time TdHea=60 "Time constant of derivative block"
    annotation (Dialog(group="Heating controller", enable=heaController ==
          Buildings.Controls.OBC.CDL.Types.SimpleController.PD or heaController
           == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController damController=
      Buildings.Controls.OBC.CDL.Types.SimpleController.PI "Type of damper position controller"
    annotation (Dialog(group="Damper controller", enable=not have_preIndDam));
  parameter Real kDam=0.1 "Gain of controller"
    annotation (Dialog(group="Damper controller", enable=not have_preIndDam));
  parameter Modelica.Units.SI.Time TiDam=120
    "Time constant of integrator block"
    annotation (Dialog(group="Damper controller",
       enable=not have_preIndDam and (damController == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
           or damController == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Modelica.Units.SI.Time TdDam=60 "Time constant of derivative block"
    annotation (Dialog(group="Damper controller",
       enable=not have_preIndDam and (damController == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
           or damController == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRooHeaSet(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC")
    "Setpoint temperature for room for heating"
    annotation (Placement(transformation(extent={{-160,60},{-120,100}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRooCooSet(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC")
    "Setpoint temperature for room for cooling"
    annotation (Placement(transformation(extent={{-160,0},{-120,40}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRoo(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC")
    "Measured room temperature"
    annotation (Placement(transformation(extent={{-160,-70},{-120,-30}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VDis_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") if not have_preIndDam
    "Measured primary discharge airflow rate"
    annotation (Placement(transformation(extent={{-160,-140},{-120,-100}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDam "Signal for VAV damper"
    annotation (Placement(transformation(extent={{120,0},{160,40}}),
        iconTransformation(extent={{100,30},{140,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yVal "Signal for heating coil valve"
    annotation (Placement(transformation(extent={{120,-70},{160,-30}}),
        iconTransformation(extent={{100,-70},{140,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.PID conHea(
    yMax=yMax,
    Td=TdHea,
    yMin=yMin,
    k=kHea,
    Ti=TiHea,
    controllerType=heaController,
    Ni=10) "Controller for heating"
    annotation (Placement(transformation(extent={{50,-60},{70,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.PID conCoo(
    yMax=yMax,
    Td=TdCoo,
    k=kCoo,
    Ti=TiCoo,
    controllerType=cooController,
    yMin=yMin,
    reverseActing=false) "Controller for cooling (acts on damper)"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Line reqFlo "Required flow rate"
    annotation (Placement(transformation(extent={{30,10},{50,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cooMax(k=1)
    "Cooling maximum flow"
    annotation (Placement(transformation(extent={{-30,-30},{-10,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minFloCoo(
    final k=ratVFloMin) "Minimum air flow set point"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conOne(k=1)
    "Constant 1"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conZer(k=0)
    "Constant 0"
    annotation (Placement(transformation(extent={{-32,40},{-12,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysWitHol(
    final uLow=-dTHys,
    final uHigh=0)
    "Output true if room temperature below heating set point"
    annotation (Placement(transformation(extent={{-40,150},{-20,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract dTHea
    "Heating loop control error"
    annotation (Placement(transformation(extent={{-80,150},{-60,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minFloHea(
    final k=ratVFloHea) "Minimum air flow set point in heating mode"
    annotation (Placement(transformation(extent={{-80,110},{-60,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    "Switch between heating and deadband air flow rate"
    annotation (Placement(transformation(extent={{-30,70},{-10,90}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(message=
    "The difference between cooling and heating set points must be greater than dTHys")
    "Assert message"
    annotation (Placement(transformation(extent={{10,-110},{30,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract dTSet
    "Difference between cooling and heating set points"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(t=dTHys)
    "Test for overlap of heating and cooling set points "
    annotation (Placement(transformation(extent={{-40,-110},{-20,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.PID conDam(
    final yMax=yMax,
    final Td=TdDam,
    final yMin=yMin,
    final k=kDam,
    final Ti=TiDam,
    final controllerType=damController,
    Ni=10) if not have_preIndDam
           "Damper position setpoint"
    annotation (Placement(transformation(extent={{80,10},{100,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide VDis_flowNor if
       not have_preIndDam
    "Normalized discharge volume flow rate"
    annotation (Placement(transformation(extent={{10,-150},{30,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant norFlo(
    final k=V_flow_nominal) if not have_preIndDam
    "Norminal airflow rate"
    annotation (Placement(transformation(extent={{-80,-170},{-60,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai(
    final k=1) if
       have_preIndDam "Dummy block to enable or disable connection"
    annotation (Placement(transformation(extent={{80,50},{100,70}})));

protected
  parameter Real yMax=1 "Upper limit of PID control output";
  parameter Real yMin=0 "Lower limit of PID control output";
  parameter Modelica.Units.SI.TemperatureDifference dTHys(final min=0) = 0.5
    "Hysteresis width for switching minimum air flow rate";
equation
  connect(TRooCooSet, conCoo.u_s)
    annotation (Line(points={{-140,20},{-82,20}},
                                                color={0,0,127}));
  connect(TRoo, conHea.u_m) annotation (Line(points={{-140,-50},{-100,-50},{-100,
          -70},{60,-70},{60,-62}},   color={0,0,127}));
  connect(TRooHeaSet, conHea.u_s) annotation (Line(points={{-140,80},{-90,80},{-90,
          -50},{48,-50}},      color={0,0,127}));
  connect(conHea.y, yVal)
    annotation (Line(points={{72,-50},{140,-50}},  color={0,0,127}));
  connect(conZer.y, reqFlo.x1)
    annotation (Line(points={{-10,50},{10,50},{10,28},{28,28}},
                                                            color={0,0,127}));
  connect(cooMax.y, reqFlo.f2) annotation (Line(points={{-8,-20},{10,-20},{10,12},
          {28,12}},color={0,0,127}));
  connect(conOne.y, reqFlo.x2) annotation (Line(points={{-58,-20},{-40,-20},{-40,
          16},{28,16}}, color={0,0,127}));
  connect(conCoo.y, reqFlo.u)
    annotation (Line(points={{-58,20},{28,20}},
                                              color={0,0,127}));
  connect(TRoo, conCoo.u_m) annotation (Line(points={{-140,-50},{-100,-50},{-100,
          0},{-70,0},{-70,8}},       color={0,0,127}));

  connect(TRooHeaSet, dTHea.u1) annotation (Line(points={{-140,80},{-90,80},{-90,
          166},{-82,166}}, color={0,0,127}));
  connect(dTHea.y, hysWitHol.u)
    annotation (Line(points={{-58,160},{-42,160}}, color={0,0,127}));
  connect(TRoo, dTHea.u2) annotation (Line(points={{-140,-50},{-100,-50},{-100,154},
          {-82,154}},           color={0,0,127}));
  connect(minFloCoo.y, swi.u3) annotation (Line(points={{-58,60},{-50,60},{-50,72},
          {-32,72}}, color={0,0,127}));
  connect(minFloHea.y, swi.u1) annotation (Line(points={{-58,120},{-50,120},{-50,
          88},{-32,88}},
                     color={0,0,127}));
  connect(hysWitHol.y, swi.u2) annotation (Line(points={{-18,160},{-10,160},{-10,
          100},{-40,100},{-40,80},{-32,80}},
                                       color={255,0,255}));
  connect(swi.y, reqFlo.f1)
    annotation (Line(points={{-8,80},{0,80},{0,24},{28,24}}, color={0,0,127}));
  connect(TRooCooSet, dTSet.u1) annotation (Line(points={{-140,20},{-110,20},{-110,
          -94},{-82,-94}},
                       color={0,0,127}));
  connect(TRooHeaSet, dTSet.u2) annotation (Line(points={{-140,80},{-90,80},{-90,
          -106},{-82,-106}},            color={0,0,127}));
  connect(dTSet.y, greThr.u)
    annotation (Line(points={{-58,-100},{-42,-100}}, color={0,0,127}));
  connect(greThr.y, assMes.u)
    annotation (Line(points={{-18,-100},{8,-100}}, color={255,0,255}));
  connect(reqFlo.y, conDam.u_s)
    annotation (Line(points={{52,20},{78,20}}, color={0,0,127}));
  connect(VDis_flow, VDis_flowNor.u1) annotation (Line(points={{-140,-120},{-30,
          -120},{-30,-134},{8,-134}}, color={0,0,127}));
  connect(norFlo.y, VDis_flowNor.u2) annotation (Line(points={{-58,-160},{-30,-160},
          {-30,-146},{8,-146}}, color={0,0,127}));
  connect(VDis_flowNor.y, conDam.u_m)
    annotation (Line(points={{32,-140},{90,-140},{90,8}},   color={0,0,127}));
  connect(conDam.y, yDam)
    annotation (Line(points={{102,20},{140,20}}, color={0,0,127}));
  connect(reqFlo.y, gai.u) annotation (Line(points={{52,20},{60,20},{60,60},{78,
          60}}, color={0,0,127}));
  connect(gai.y, yDam) annotation (Line(points={{102,60},{110,60},{110,20},{140,
          20}}, color={0,0,127}));
annotation (
  defaultComponentName="terCon",
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
                    graphics={
        Text(
          extent={{-100,-22},{-66,-36}},
          textColor={0,0,127},
          textString="TRoo"),
        Text(
          extent={{64,-38},{92,-58}},
          textColor={0,0,127},
          textString="yVal"),
        Text(
          extent={{56,62},{90,40}},
          textColor={0,0,127},
          textString="yDam"),
        Text(
          extent={{-96,92},{-36,70}},
          textColor={0,0,127},
          textString="TRooHeaSet"),
        Text(
          extent={{-96,40},{-36,20}},
          textColor={0,0,127},
          textString="TRooCooSet"),
        Text(
          extent={{-96,-72},{-48,-86}},
          textColor={0,0,127},
          textString="VDis_flow",
          visible=not have_preIndDam)}),
 Documentation(info="<html>
<p>
Controller for terminal VAV box with hot water reheat.
It is based on the control logic \"dual maximum with constant volume heating\" as
described in the Advanced VAV System Design Guide (EDR 2007).
The controller could be used for units with the pressure independent damper and the
units with the exponential damper, by setting the flag <code>have_preIndDam</code>.
</p>
<p>
Two separate control loops, the cooling loop and the heating loop, are implemented
to maintain space temperature within a temperature dead band (with a required minimum
width of 0.5 K).
For the terminal boxes with the pressure independent damper, the damper control
signal <code>yDam</code> corresponds to the discharge air flow rate
set point, normalized to the nominal value. While for the boxes with the exponential
damper, the damper position <code>yDam</code> is controlled by a PID loop to track the discharge
airflow setpoint.
The control signal for the reheat coil valve <code>yVal</code> corresponds to the
fractional opening (1 corresponding to the valve fully open).
</p>
<p>
For the termnal boxes with the pressure independent damper (<code>have_preIndDam=true</code>),
</p>
<ul>
<li>
Inside the dead band, <code>yDam</code> is fixed at the minimum value <code>ratVFloMin</code>
and  <code>yVal</code> is 0.
</li>
<li>
In heating demand, <code>yDam</code> is fixed at the heating value <code>ratVFloHea</code>,
and <code>yVal</code> is modulated between 0 and 1.
</li>
<li>
In cooling demand, <code>yDam</code> is modulated between the minimum value
<code>ratVFloMin</code> and 1, and <code>yVal</code> is 0.
</li>
</ul>
<p>
For the termnal boxes with the exponential damper (<code>have_preIndDam=false</code>),
</p>
<ul>
<li>
Inside the dead band, <code>yDam</code> is controlled to track the minimum value <code>ratVFloMin</code>
and  <code>yVal</code> is 0.
</li>
<li>
In heating demand, <code>yDam</code> is controlled to track the heating value <code>ratVFloHea</code>,
and <code>yVal</code> is modulated between 0 and 1.
</li>
<li>
In cooling demand, <code>yDam</code> is controlled to track the airflow rate modulated
between the minimum value <code>ratVFloMin</code> and 1, and <code>yVal</code> is 0.
</li>
</ul>
<p>
Note that a single maximum control logic can be represented by simply setting
<code>ratVFloHea</code> equal to <code>ratVFloMin</code> (default setting).
</p>
<p>
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/VAVReheat/vavBoxDualMax.png\" border=\"1\"/>
</p>
<h4>References</h4>
<p>
EDR (Energy Design Resources).
<i>Advanced Variable Air Volume System Design Guide</i>.
Pacific Gas and Electric Company, 2007.
</p>
<br/>
</html>", revisions="<html>
<ul>
<li>
January 30, 2023, by Jianjun Hu:<br/>
Added flag to choose different damper type and added control for the boxes with the exponential damper.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3139\">#3139</a>.
</li>
<li>
July 10, 2020, by Antoine Gautier:<br/>
Implemented a dual maximum with constant volume heating control logic.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2028\">#2028</a>.
</li>
<li>
April 24, 2020, by Jianjun Hu:<br/>
Refactored the model to implement a single maximum control logic.
The previous implementation led to a maximum air flow rate in heating demand.<br/>
The input connector <code>TDis</code> is removed. This is non backward compatible.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1873\">#1873</a>.
</li>
<li>
September 20, 2017, by Michael Wetter:<br/>
Removed blocks with blocks from CDL package.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-120,-180},{120,180}})));
end RoomVAV;
