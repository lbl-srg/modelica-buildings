within Buildings.Examples.Tutorial.CDL;
model System2 "Open loop model with control architecture implemented"
  extends Buildings.Examples.Tutorial.CDL.BaseClasses.PartialOpenLoop;

  Controls.OpenLoopBoilerReturn conBoiRet
    "Controller for boiler return water temperature"
    annotation (Placement(transformation(extent={{100,-290},{120,-270}})));
  Controls.OpenLoopSystemOnOff conSysSta
    "Controller that switches the system on and off"
    annotation (Placement(transformation(extent={{-260,-60},{-240,-40}})));
  Controls.OpenLoopRadiatorSupply conRadSup
    "Controller for the mixing valve for the radiator supply water"
    annotation (Placement(transformation(extent={{-200,-160},{-180,-140}})));
  Controls.OpenLoopEquipmentOnOff conEquSta
    "Controller that switches the equipment on and off"
    annotation (Placement(transformation(extent={{-200,-220},{-180,-200}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal radPumCon(
    realTrue=mRad_flow_nominal)
    "Type conversion for radiator pump signal"
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal boiPumCon(
    realTrue=mBoi_flow_nominal)
    "Type conversion for boiler pump signal"
    annotation (Placement(transformation(extent={{-100,-290},{-80,-270}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal boiSigCon(
    realTrue=1)
    "Type conversion for boiler signal"
    annotation (Placement(transformation(extent={{-100,-260},{-80,-240}})));
equation
  connect(conSysSta.onSys, conEquSta.onSys) annotation (Line(points={{-238,-50},
          {-220,-50},{-220,-216},{-202,-216}}, color={255,0,255}));
  connect(conEquSta.onPum, boiPumCon.u) annotation (Line(points={{-178,-216},{-120,
          -216},{-120,-280},{-102,-280}}, color={255,0,255}));
  connect(radPumCon.u, conEquSta.onPum) annotation (Line(points={{-102,-70},{-120,
          -70},{-120,-216},{-178,-216}}, color={255,0,255}));
  connect(boiSigCon.u, conEquSta.onBoi) annotation (Line(points={{-102,-250},{-108,
          -250},{-108,-204},{-178,-204}}, color={255,0,255}));
  connect(radPumCon.y, pumRad.m_flow_in)
    annotation (Line(points={{-78,-70},{-62,-70}}, color={0,0,127}));
  connect(boiPumCon.y, pumBoi.m_flow_in)
    annotation (Line(points={{-78,-280},{-62,-280}}, color={0,0,127}));
  connect(boiSigCon.y, boi.y) annotation (Line(points={{-78,-250},{34,-250},{34,
          -302},{22,-302}}, color={0,0,127}));
  connect(conRadSup.yVal, valRad.y) annotation (Line(points={{-178,-150},{-62,
          -150}},            color={0,0,127}));
  connect(conEquSta.TBoi, boi.T) annotation (Line(points={{-202,-204},{-240,
          -204},{-240,-302},{-1,-302}}, color={0,0,127}));
  connect(conSysSta.TOut, senTOut.T) annotation (Line(points={{-262,-44},{-280,
          -44},{-280,30},{-298,30}}, color={0,0,127}));
  connect(conRadSup.TRoo, temRoo.T) annotation (Line(points={{-202,-144},{-268,
          -144},{-268,30},{-50,30}}, color={0,0,127}));
  connect(conSysSta.TRoo, temRoo.T) annotation (Line(points={{-262,-56},{-268,
          -56},{-268,30},{-50,30}}, color={0,0,127}));
  connect(temRet.T, conBoiRet.TRet)
    annotation (Line(points={{71,-280},{98,-280}}, color={0,0,127}));
  connect(conBoiRet.yVal, valBoi.y) annotation (Line(points={{122,-280},{140,
          -280},{140,-230},{72,-230}}, color={0,0,127}));
  connect(temSup.T, conRadSup.TSup) annotation (Line(points={{-61,-40},{-210,
          -40},{-210,-156},{-202,-156}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
In this step, we added the control architecture.
How the control is partitioned into various subcontrollers depends usually on
the need to avoid communication over the network and on how control is distributed to
different field controllers. Here, we
used the four controllers indicated by the shaded background in the figure of
<a href=\"modelica://Buildings.Examples.Tutorial.CDL\">
Buildings.Examples.Tutorial.CDL</a>.
One controller switches the overall system on and off,
one switches the boiler on and off,
one tracks the supply water temperature to the room and
one tracks the return water temperature that is fed to the boiler.
</p>
<h4>Implementation</h4>
<p>
This model was built as follows:
</p>
<ol>
<li>
<p>
First, we determined what functionality should be implemented in which controller, and what the inputs and outputs of the controllers are.
In this example, we used these controllers:
</p>
<ul>
<li>
<p>
Boiler return water controller, with input being the return water temperature <code>TRet</code> and output being the valve control signal <code>yVal</code>.
</p>
</li>
<li>
<p>
Radiator loop temperature controller, with input being the measured supply water temperature <code>TSup</code>,
the measured room air temperature <code>TRoo</code> and output being the valve control signal <code>yVal</code>.
</p>
</li>
<li>
<p>
System on/off controller, with inputs being the outdoor temperature <code>TOut</code> and the
room air temperature <code>TRoo</code>, and output being the system on/off signal <code>onSys</code>.
Note that how inputs and outputs are named can simplify usability. For example, we called the output <code>onSys</code>
so that a value of <code>true</code> is clearly understood as the system being on. If we had called it
<code>y</code>, then it would not have been clear what a value of <code>true</code> means.
</p>
</li>
<li>
<p>
Equipment controller, with inputs being the system on/off command and the boiler temperature,
and outputs being
the pump on/off signal <code>onPum</code> and the boiler on/off signal <code>onBoi</code>.
</p>
</li>
</ul>
</li>
<li>
<p>
To organize our code, we created package that we called <code>Controls</code>.
</p>
</li>
<li>
<p>
Next, we added the open loop controller for the boiler return water temperature.
This controller is implemented in
<a href=\"modelica://Buildings.Examples.Tutorial.CDL.Controls.OpenLoopBoilerReturn\">
Buildings.Examples.Tutorial.CDL.Controls.OpenLoopBoilerReturn</a>.
To implement it, we created a Modelica block, and added an input, using a
<a href=\"modelica://Buildings.Controls.OBC.CDL.Interfaces.RealInput\">
Buildings.Controls.OBC.CDL.Interfaces.RealInput</a>, called it <code>TRet</code>
for the measured return water temperature, and a
<a href=\"modelica://Buildings.Controls.OBC.CDL.Interfaces.RealOutput\">
Buildings.Controls.OBC.CDL.Interfaces.RealOutput</a>
for the valve control signal, which we called <code>yVal</code>.
</p>
<p>
To output the valve control signal, which we set for now to a constant value of <i>1</i>,
we used an instance of
<a href=\"modelica://Buildings.Controls.OBC.CDL.Reals.Sources.Constant\">
Buildings.Controls.OBC.CDL.Reals.Sources.Constant</a>,
set its parameter to <i>1</i>, and connected it to the output.
</p>
<p>
At this stage, because the control is open loop, we leave the input of the controller unconnected.
</p>
<p>
Looking at the Modelica file shows that we also added documentation in an <code>info</code> section,
a <code>defaultComponentName</code>, as well as graphical elements so that it is easily distinguishable
in a schematic diagram.
We also added the <code>unit</code> and <code>displayUnit</code> attributes.
</p>
<p>
In the next step of this tutorial, we will provide an actual implementation of the controller.
To better distinguish the open loop controller from the closed loop controller, we
color the icon of open loop controllers grey, and will change this color to white when we implement the actual control logic.
</p>
</li>
<li>
<p>
We did a similar process to add the other three open loop controllers. As before, we added all
inputs and outputs, and set the outputs to a constant.
</p>
</li>
<li>
<p>
Lastly, we instantiated these four controllers in the system model.
Because the pumps and the boiler take as a control input a real-valued signal, we used
<a href=\"modelica://Buildings.Controls.OBC.CDL.Conversions.BooleanToReal\">
Buildings.Controls.OBC.CDL.Conversions.BooleanToReal</a> to convert between the boolean-valued signal
and the real-valued inputs of these components. Whether this conversion is part of the
controller or done outside the controller is an individual design decision.
</p>
</li>
</ol>
<h4>Exercise</h4>
<p>
Create a model, such as this model.
To do so,
</p>
<ol>
<li>
<p>
Copy
<a href=\"modelica://Buildings.Examples.Tutorial.CDL.System1\">
Buildings.Examples.Tutorial.CDL.System1</a>.
</p>
</li>
<li>
<p>
Implement all four open loop controllers.
</p>
</li>
<li>
<p>
Delete the constant control inputs, instantiate the open loop controllers,
convert the signal as needed from <code>Boolean</code> to <code>Real</code>,
and connect the control inputs and outputs.
</p>
</li>
</ol>
<p>
Simulate the system to verify that you get the response shown below.
As we have not changed any of the control logic, simulating the system should give the same
response as for
<a href=\"modelica://Buildings.Examples.Tutorial.CDL.System1\">
Buildings.Examples.Tutorial.CDL.System1</a>.
</p>
<p align=\"center\">
<img alt=\"Open loop temperatures.\" src=\"modelica://Buildings/Resources/Images/Examples/Tutorial/CDL/System1/OpenLoopTemperatures.png\" border=\"1\"/>
</p>
</html>",
revisions="<html>
<ul>
<li>
February 18, 2020, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file=
     "modelica://Buildings/Resources/Scripts/Dymola/Examples/Tutorial/CDL/System2.mos"
        "Simulate and plot"),
    experiment(
      StartTime=1296000,
      StopTime=1382400,
      Tolerance=1e-06));
end System2;
