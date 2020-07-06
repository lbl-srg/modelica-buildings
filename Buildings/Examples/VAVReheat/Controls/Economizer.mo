within Buildings.Examples.VAVReheat.Controls;
block Economizer "Controller for economizer"
  import Buildings.Examples.VAVReheat.Controls.OperationModes;
  parameter Modelica.SIunits.Temperature TFreSet=277.15
    "Lower limit for mixed air temperature for freeze protection";
  parameter Modelica.SIunits.TemperatureDifference dTLock(min=0.1) = 1
    "Temperature difference between return and outdoor air for economizer lockout";
  parameter Modelica.SIunits.VolumeFlowRate VOut_flow_min(min=0)
    "Minimum outside air volume flow rate";

  ControlBus controlBus
    annotation (Placement(transformation(extent={{50,-90},{70,-70}}),
        iconTransformation(extent={{50,-90},{70,-70}})));
  Modelica.Blocks.Interfaces.RealInput uOATSup
    "Control signal for outdoor air damper from supply temperature controller"
    annotation (Placement(transformation(extent={{-140,140},{-100,180}}),
        iconTransformation(extent={{-140,140},{-100,180}})));
  Modelica.Blocks.Interfaces.RealInput TMix "Measured mixed air temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput VOut_flow
    "Measured outside air flow rate" annotation (Placement(transformation(
          extent={{-140,-100},{-100,-60}}), iconTransformation(extent={{-140,-100},
            {-100,-60}})));
  Modelica.Blocks.Interfaces.RealInput TRet "Return air temperature"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealOutput yRet
    "Control signal for return air damper"
    annotation (Placement(transformation(
          extent={{200,-20},{240,20}}),
          iconTransformation(extent={{200,-20},{240, 20}})));
  Modelica.Blocks.Interfaces.RealOutput yOA
    "Control signal for outside air damper" annotation (Placement(
        transformation(extent={{200,60},{240,100}}),iconTransformation(extent={{200,60},
            {240,100}})));

  Modelica.Blocks.Math.Gain gain(k=1/VOut_flow_min) "Normalize mass flow rate"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Buildings.Controls.Continuous.LimPID conV_flow(
    k=k,
    Ti=Ti,
    yMax=0.995,
    yMin=0.005,
    Td=60) "Controller for outside air flow rate"
    annotation (Placement(transformation(extent={{-10,-20},{10,0}})));
  Modelica.Blocks.Sources.Constant uni(k=1) "Unity signal"
    annotation (Placement(transformation(extent={{-50,-20},{-30,0}})));
  parameter Real k=1 "Gain of controller";
  parameter Modelica.SIunits.Time Ti "Time constant of integrator block";
  Modelica.Blocks.Routing.Extractor extractor(nin=6, index(start=1, fixed=true))
    "Extractor for control signal"
    annotation (Placement(transformation(extent={{130,-10},{150,10}})));
  Modelica.Blocks.Sources.Constant closed(k=0) "Signal to close OA damper"
    annotation (Placement(transformation(extent={{10,30},{30,50}})));
  Modelica.Blocks.Math.Max max
    "Takes bigger signal (OA damper opens for temp. control or for minimum outside air)"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Buildings.Controls.Continuous.LimPID yOATFre(
    k=k,
    Ti=Ti,
    Td=60,
    yMax=1,
    yMin=0)
    "Control signal for outdoor damper to track freeze temperature setpoint"
    annotation (Placement(transformation(extent={{-30,70},{-10,90}})));
  Modelica.Blocks.Math.Min min
    "Takes bigger signal (OA damper opens for temp. control or for minimum outside air)"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Modelica.Blocks.Sources.Constant TFre(k=TFreSet)
    "Setpoint for freeze protection"
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter invSig(p=1, k=-1)
    "Invert control signal for interlocked damper"
    annotation (Placement(transformation(extent={{170,-10},{190,10}})));
  Modelica.Blocks.Logical.Hysteresis hysLoc(final uLow=0, final uHigh=dTLock)
                      "Hysteresis for economizer lockout"
    annotation (Placement(transformation(extent={{-30,110},{-10,130}})));
  Modelica.Blocks.Math.Feedback feedback
    annotation (Placement(transformation(extent={{-70,110},{-50,130}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swiOA
    "Switch to close outdoor air damper"
    annotation (Placement(transformation(extent={{50,110},{70,130}})));
equation
  connect(VOut_flow, gain.u) annotation (Line(
      points={{-120,-80},{-92,-80},{-92,-60},{-62,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.y, conV_flow.u_m) annotation (Line(
      points={{-39,-60},{0,-60},{0,-22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(uni.y, conV_flow.u_s) annotation (Line(
      points={{-29,-10},{-12,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(controlBus.controlMode, extractor.index) annotation (Line(
      points={{60,-80},{140,-80},{140,-12}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(max.y, extractor.u[Integer(OperationModes.occupied)]) annotation (
      Line(
      points={{101,0},{128,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(closed.y, extractor.u[Integer(OperationModes.unoccupiedOff)])
    annotation (Line(
      points={{31,40},{110,40},{110,0},{128,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(closed.y, extractor.u[Integer(OperationModes.unoccupiedNightSetBack)])
    annotation (Line(
      points={{31,40},{110,40},{110,0},{128,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(max.y, extractor.u[Integer(OperationModes.unoccupiedWarmUp)])
    annotation (Line(
      points={{101,0},{128,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(max.y, extractor.u[Integer(OperationModes.unoccupiedPreCool)])
    annotation (Line(
      points={{101,0},{128,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(closed.y, extractor.u[Integer(OperationModes.safety)]) annotation (
      Line(
      points={{31,40},{110,40},{110,0},{128,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(min.u2, conV_flow.y) annotation (Line(
      points={{28,-6},{20,-6},{20,-10},{11,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(min.y, max.u2) annotation (Line(
      points={{51,0},{60,0},{60,-6},{78,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(yOATFre.u_s, TMix) annotation (Line(points={{-32,80},{-88,80},{-88,0},
          {-120,0}},                  color={0,0,127}));
  connect(TFre.y, yOATFre.u_m) annotation (Line(points={{-29,40},{-20,40},{-20,68}},
                          color={0,0,127}));
  connect(yOATFre.y, min.u1) annotation (Line(points={{-9,80},{0,80},{0,6},{28,6}},
                                    color={0,0,127}));
  connect(yRet, invSig.y)
    annotation (Line(points={{220,0},{192,0}}, color={0,0,127}));
  connect(extractor.y, invSig.u)
    annotation (Line(points={{151,0},{168,0}}, color={0,0,127}));
  connect(extractor.y, yOA) annotation (Line(points={{151,0},{160,0},{160,80},{220,
          80}},     color={0,0,127}));
  connect(feedback.y, hysLoc.u)
    annotation (Line(points={{-51,120},{-32,120}}, color={0,0,127}));
  connect(TRet, feedback.u1) annotation (Line(points={{-120,80},{-94,80},{-94,120},
          {-68,120}}, color={0,0,127}));
  connect(controlBus.TOut, feedback.u2) annotation (Line(
      points={{60,-80},{60,-40},{-60,-40},{-60,112}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(swiOA.y, max.u1) annotation (Line(points={{72,120},{80,120},{80,100},{
          60,100},{60,6},{78,6}}, color={0,0,127}));
  connect(closed.y, swiOA.u3) annotation (Line(points={{31,40},{40,40},{40,112},
          {48,112}}, color={0,0,127}));
  connect(hysLoc.y, swiOA.u2)
    annotation (Line(points={{-9,120},{48,120}}, color={255,0,255}));
  connect(uOATSup, swiOA.u1) annotation (Line(points={{-120,160},{40,160},{40,128},
          {48,128}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{200,
            200}})),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{200,
            200}}), graphics={
        Rectangle(
          extent={{-100,200},{200,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-90,90},{-50,70}},
          lineColor={0,0,255},
          textString="TRet"),
        Text(
          extent={{-90,12},{-50,-8}},
          lineColor={0,0,255},
          textString="TMix"),
        Text(
          extent={{-94,-54},{-26,-102}},
          lineColor={0,0,255},
          textString="VOut_flow"),
        Text(
          extent={{138,96},{184,62}},
          lineColor={0,0,255},
          textString="yOA"),
        Text(
          extent={{140,20},{186,-14}},
          lineColor={0,0,255},
          textString="yRet"),
        Text(
          extent={{-92,170},{-52,150}},
          lineColor={0,0,255},
          textString="uOA")}),
    Documentation(info="<html>
<p>
This is a controller for an economizer, that adjusts the mixed air dampers
to fulfill three control functions.
</p>
<ol>
<li>
Minimum outside air requirement, based on the outdoor air flow rate
measurement
</li>
<li>
Freeze protection, based on the mixed air temperature measurement
</li>
<li>
Supply air cooling, based on the logic implemented in 
<a href=\"modelica://Buildings.Examples.VAVReheat.Controls.SupplyAirTemperature\">
Buildings.Examples.VAVReheat.Controls.SupplyAirTemperature</a>
</li>
</ol>
</p>
</html>", revisions="<html>
<ul>
<li>
July 6, 2020, by Antoine Gautier:<br/>
Refactoring to allow supply air temperature control in sequence with the coils.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2024\">#2024</a>.
</li>
<li>
December 20, 2016, by Michael Wetter:<br/>
Added type conversion for enumeration when used as an array index.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/602\">#602</a>.
</li>
<li>
April 26, 2016, by Michael Wetter:<br/>
Changed controller for freeze protection as the old implementation closed
the outdoor air damper during summer.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/511\">#511</a>.
</li>
</ul>
</html>"));
end Economizer;
