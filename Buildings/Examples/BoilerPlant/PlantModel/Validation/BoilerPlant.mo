within Buildings.Examples.BoilerPlant.PlantModel.Validation;
model BoilerPlant "Validation for boiler plant model"
  extends Modelica.Icons.Example;
  replaceable package MediumA =
      Buildings.Media.Air;
  replaceable package MediumW =
      Buildings.Media.Water "Medium model";

  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal = 20000
    "Nominal heat flow rate of radiator";

//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//

//--------------------------------------------------------------------------------//

//--------------------------------------------------------------------------------//
//--------------------------------------------------------------------------------//

//--------------------------------------------------------------------------------//

//--------------------------------------------------------------------------------//

//--------------------------------------------------------------------------------//

//------------------------------------------------------------------------------//
//--- Weather data -------------------------------------------------------------//
//------------------------------------------------------------------------------//

  .Buildings.Examples.BoilerPlant.PlantModel.BoilerPlant boilerPlant(
      TRadRet_nominal=273.15 + 50)
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Controls.OBC.CDL.Logical.Sources.Constant con[2](k=fill(true, 2))
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Controls.OBC.CDL.Continuous.Sources.Constant con2(k=0)
    annotation (Placement(transformation(extent={{-110,-50},{-90,-30}})));
  Controls.OBC.CDL.Continuous.Hysteresis hys(uLow=273.15 + 60, uHigh=273.15 +
        70) annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  Controls.OBC.CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Controls.OBC.CDL.Routing.BooleanReplicator booRep(nout=2)
    annotation (Placement(transformation(extent={{80,10},{100,30}})));
  Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    annotation (Placement(transformation(extent={{50,-30},{70,-10}})));
  Controls.OBC.CDL.Routing.RealReplicator reaRep(nout=2)
    annotation (Placement(transformation(extent={{80,-30},{100,-10}})));
  Controls.OBC.CDL.Continuous.Sources.Constant con1(k=-Q_flow_nominal)
    annotation (Placement(transformation(extent={{-110,30},{-90,50}})));
  Controls.OBC.CDL.Continuous.Hysteresis hys1(uLow=273.15 + 21.7, uHigh=273.15
         + 23.89)
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  Controls.OBC.CDL.Logical.Not not2
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  Controls.OBC.CDL.Logical.And and2
    annotation (Placement(transformation(extent={{50,10},{70,30}})));
  Controls.OBC.CDL.Continuous.Sources.Constant con3(k=273.15 + 21)
    annotation (Placement(transformation(extent={{-110,-90},{-90,-70}})));
equation

  connect(con.y, boilerPlant.uPumSta) annotation (Line(points={{-88,0},{-52,0}},
                                color={255,0,255}));
  connect(con2.y, boilerPlant.uBypValSig) annotation (Line(points={{-88,-40},{
          -80,-40},{-80,-6},{-52,-6}},
                                    color={0,0,127}));
  connect(hys.y, not1.u)
    annotation (Line(points={{12,20},{18,20}},     color={255,0,255}));
  connect(booRep.y, boilerPlant.uBoiSta) annotation (Line(points={{102,20},{110,
          20},{110,40},{-60,40},{-60,6},{-52,6}},            color={255,0,255}));
  connect(booToRea.y, reaRep.u)
    annotation (Line(points={{72,-20},{78,-20}},   color={0,0,127}));
  connect(reaRep.y, boilerPlant.uHotIsoVal) annotation (Line(points={{102,-20},
          {110,-20},{110,-40},{-70,-40},{-70,3},{-52,3}},
                                                    color={0,0,127}));
  connect(reaRep.y, boilerPlant.uPumSpe) annotation (Line(points={{102,-20},{
          110,-20},{110,-40},{-70,-40},{-70,-3},{-52,-3}},
                                                   color={0,0,127}));
  connect(con1.y, boilerPlant.QRooInt_flowrate) annotation (Line(points={{-88,40},
          {-70,40},{-70,9},{-52,9}},          color={0,0,127}));
  connect(boilerPlant.ySupTem, hys.u) annotation (Line(points={{-28,4},{-20,4},
          {-20,20},{-12,20}},   color={0,0,127}));
  connect(boilerPlant.yZonTem, hys1.u) annotation (Line(points={{-28,8},{-24,8},
          {-24,-20},{-12,-20}},     color={0,0,127}));
  connect(hys1.y, not2.u)
    annotation (Line(points={{12,-20},{18,-20}},   color={255,0,255}));
  connect(not2.y, booToRea.u)
    annotation (Line(points={{42,-20},{48,-20}},   color={255,0,255}));
  connect(booRep.u, and2.y)
    annotation (Line(points={{78,20},{72,20}},     color={255,0,255}));
  connect(not1.y, and2.u1)
    annotation (Line(points={{42,20},{48,20}},     color={255,0,255}));
  connect(not2.y, and2.u2) annotation (Line(points={{42,-20},{46,-20},{46,12},{
          48,12}},    color={255,0,255}));
  connect(booToRea.y, boilerPlant.uRadIsoVal) annotation (Line(points={{72,-20},
          {76,-20},{76,-50},{-60,-50},{-60,-9},{-52,-9}},   color={0,0,127}));
  connect(con3.y, boilerPlant.TOutAir) annotation (Line(points={{-88,-80},{-49,
          -80},{-49,-12}},      color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
This part of the system model adds to the model that is implemented in
<a href=\"modelica://Buildings.Examples.Tutorial.Boiler.System5\">
Buildings.Examples.Tutorial.Boiler.System5</a>
weather data, and it changes the control to PI control.
</p>
<h4>Implementation</h4>
<p>
This model was built as follows:
</p>
<ol>
<li>
<p>
First, we copied the model
<a href=\"modelica://Buildings.Examples.Tutorial.Boiler.System5\">
Buildings.Examples.Tutorial.Boiler.System5</a>
and called it
<code>Buildings.Examples.Tutorial.Boiler.System6</code>.
</p>
</li>
<li>
<p>
Next, we added the weather data as shown in the figure below.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/Tutorial/Boiler/System6Weather.png\" border=\"1\"/>
</p>
<p>
The weather data reader is implemented using
</p>
<pre>
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=\"modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos\")
    \"Weather data reader\";
</pre>
<p>
The yellow icon in the middle of the figure is an instance of
<a href=\"modelica://Buildings.BoundaryConditions.WeatherData.Bus\">
Buildings.BoundaryConditions.WeatherData.Bus</a>.
This is required to extract the dry bulb temperature from the weather data bus.
</p>
<p>
Note that we changed the instance <code>TOut</code> from
<a href=\"modelica://Modelica.Thermal.HeatTransfer.Sources.FixedTemperature\">
Modelica.Thermal.HeatTransfer.Sources.FixedTemperature</a>
to
<a href=\"modelica://Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature\">
Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature</a>
in order to use the dry-bulb temperature as an input signal.
</p>
</li>
</ol>
<!-- ============================================== -->
<p>
This completes the closed loop control.
When simulating the model
for <i>2</i> days, or <i>172800</i> seconds, the
response shown below should be seen.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/Tutorial/Boiler/System6Temperatures1.png\" border=\"1\"/>
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/Tutorial/Boiler/System6Temperatures2.png\" border=\"1\"/>
</p>
<p>
The figure shows that the boiler temperature is regulated between
<i>70</i>&deg;C and
<i>90</i>&deg;C,
that
the boiler inlet temperature is above
<i>60</i>&deg;C,
and that the room temperature and the supply water temperature are
maintained at their set point.
</p>
</html>", revisions="<html>
<ul>
<li>
March 6, 2017, by Michael Wetter:<br/>
Added missing density to computation of air mass flow rate.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/673\">#673</a>.
</li>
<li>
July 2, 2015, by Michael Wetter:<br/>
Changed control input for <code>conPIDBoi</code> and set
<code>reverseActing=false</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/436\">#436</a>.
</li>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
March 1, 2013, by Michael Wetter:<br/>
Added nominal pressure drop for valves as
this parameter no longer has a default value.
</li>
<li>
January 27, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-120,-120},{120,
            120}})),
    __Dymola_Commands(file=
     "modelica://Buildings/Resources/Scripts/Dymola/Examples/Tutorial/Boiler/System6.mos"
        "Simulate and plot"),
    experiment(
      StopTime=60000,
      Interval=1,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    Icon(coordinateSystem(extent={{-120,-120},{120,120}})));
end BoilerPlant;
