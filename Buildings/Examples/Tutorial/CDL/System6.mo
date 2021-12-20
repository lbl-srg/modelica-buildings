within Buildings.Examples.Tutorial.CDL;
model System6 "Closed loop model with all controls implemented"
  extends
    Buildings.Examples.Tutorial.CDL.BaseClasses.PartialOpenLoop;

  Controls.BoilerReturn conBoiRet
   "Controller for boiler return water temperature"
    annotation (Placement(transformation(extent={{100,-290},{120,-270}})));
  Controls.SystemOnOff conSysSta
    "Controller that switches the system on and off"
    annotation (Placement(transformation(extent={{-260,-60},{-240,-40}})));
  Controls.RadiatorSupply conRadSup
    "Controller for the mixing valve for the radiator supply water"
    annotation (Placement(transformation(extent={{-200,-160},{-180,-140}})));
  Controls.EquipmentOnOff conEquSta
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
  connect(conRadSup.yVal, valRad.y) annotation (Line(points={{-178,-150},{-62,-150}},
                       color={0,0,127}));
  connect(conEquSta.TBoi, boi.T) annotation (Line(points={{-202,-204},{-240,-204},
          {-240,-302},{-1,-302}}, color={0,0,127}));
  connect(conSysSta.TOut, senTOut.T) annotation (Line(points={{-262,-44},{-280,-44},
          {-280,30},{-298,30}}, color={0,0,127}));
  connect(conRadSup.TRoo, temRoo.T) annotation (Line(points={{-202,-144},{-268,-144},
          {-268,30},{-50,30}}, color={0,0,127}));
  connect(conSysSta.TRoo, temRoo.T) annotation (Line(points={{-262,-56},{-268,-56},
          {-268,30},{-50,30}}, color={0,0,127}));
  connect(temRet.T, conBoiRet.TRet)
    annotation (Line(points={{71,-280},{98,-280}}, color={0,0,127}));
  connect(conBoiRet.yVal, valBoi.y) annotation (Line(points={{122,-280},{140,-280},
          {140,-230},{72,-230}}, color={0,0,127}));

  connect(temSup.T, conRadSup.TSup) annotation (Line(points={{-61,-40},{-210,-40},
          {-210,-156},{-202,-156}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
In this step, we added the last controller, which is controlling the mixing valve for the
radiator supply water temperature.
</p>
<h4>Implementation</h4>
<p>
This model was built as follows:
</p>
<ol>
<li>
<p>
First, we copied the controller
<a href=\"modelica://Buildings.Examples.Tutorial.CDL.Controls.OpenLoopRadiatorSupply\">
Buildings.Examples.Tutorial.CDL.Controls.OpenLoopRadiatorSupply</a>
to create the block
<a href=\"modelica://Buildings.Examples.Tutorial.CDL.Controls.RadiatorSupply\">
Buildings.Examples.Tutorial.CDL.Controls.RadiatorSupply</a>.
</p>
</li>
<li>
<p>
In this new block, we used
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.Line\">
Buildings.Controls.OBC.CDL.Continuous.Line</a> to compute the set point for the supply water temperature
based on the room air temperature. This set point is then used in a PI controller
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.PID\">
Buildings.Controls.OBC.CDL.Continuous.PID</a> to modulate the mixing valve position
in order to track the supply water temperature set point.
</p>
</li>
<li>
<p>
To allow configuring the temperatures and the control gains, we exposed the main parameters of the controller,
see <a href=\"modelica://Buildings.Examples.Tutorial.CDL.Controls.RadiatorSupply\">
Buildings.Examples.Tutorial.CDL.Controls.RadiatorSupply</a>.
</p>
</li>
<li>
<p>
We also implemented the open loop validation
<a href=\"modelica://Buildings.Examples.Tutorial.CDL.Controls.Validation.RadiatorSupply\">
Buildings.Examples.Tutorial.CDL.Controls.Validation.RadiatorSupply</a>
to ensure that the controller is implemented correctly.
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
<a href=\"modelica://Buildings.Examples.Tutorial.CDL.System5\">
Buildings.Examples.Tutorial.CDL.System5</a>.
</p>
</li>
<li>
<p>
Implement the controller for the radiator supply water temperature control.
</p>
<p>
Make a small unit test to verify that the controller is implemented correctly.
</p>
</li>
<li>
<p>
Use this new controller instead of the open loop controller <code>conRadSup</code>.
</p>
</li>
</ol>
<p>
Simulate the system to verify that the mixing valve <code>conRadSup</code> is modulated and
the room air temperature <code>temRoo.T</code> is well tracked.
</p>
<p align=\"center\">
<img alt=\"Temperatures and control signals.\" src=\"modelica://Buildings/Resources/Images/Examples/Tutorial/CDL/System6/TemperaturesControl.png\" border=\"1\"/>
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
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-400,-360},{240, 100}})),
    __Dymola_Commands(file=
     "modelica://Buildings/Resources/Scripts/Dymola/Examples/Tutorial/CDL/System6.mos"
        "Simulate and plot"),
    experiment(
      StartTime=1296000,
      StopTime=1382400,
      Tolerance=1e-06));
end System6;
