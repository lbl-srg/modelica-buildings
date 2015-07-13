within Buildings.Examples.VAVReheat.Controls;
block Economizer "Controller for economizer"
  import Buildings.Examples.VAVReheat.Controls.OperationModes;
  parameter Modelica.SIunits.TemperatureDifference dT(min=0.1)= 1
    "Temperture offset to activate economizer";
  parameter Modelica.SIunits.VolumeFlowRate VOut_flow_min(min=0)
    "Minimum outside air volume flow rate";
  Modelica.Blocks.Interfaces.RealInput TSupHeaSet
    "Supply temperature setpoint for heating"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}}), iconTransformation(extent={{-140,-40},{-100,0}})));
  Modelica.Blocks.Interfaces.RealInput TSupCooSet
    "Supply temperature setpoint for cooling"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealInput TMix "Measured mixed air temperature"
    annotation (Placement(transformation(extent={{-140,80},{-100,120}}), iconTransformation(extent={{-140,80},{-100,120}})));
  ControlBus controlBus
    annotation (Placement(transformation(extent={{-50,50},{-30,70}})));
  Modelica.Blocks.Interfaces.RealInput VOut_flow
    "Measured outside air flow rate"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}), iconTransformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput TRet "Return air temperature"
    annotation (Placement(transformation(extent={{-140,140},{-100,180}}), iconTransformation(extent={{-140,140},{-100,180}})));
  Modelica.Blocks.Math.Gain gain(k=1/VOut_flow_min) "Normalize mass flow rate"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Buildings.Controls.Continuous.LimPID conV_flow(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=k,
    Ti=Ti,
    yMax=0.995,
    yMin=0.005,
    Td=60) "Controller for outside air flow rate"
    annotation (Placement(transformation(extent={{-22,-20},{-2,0}})));
  Modelica.Blocks.Sources.Constant uni(k=1) "Unity signal"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  parameter Real k=1 "Gain of controller";
  parameter Modelica.SIunits.Time Ti "Time constant of Integrator block";
  Modelica.Blocks.Interfaces.RealOutput yOA
    "Control signal for outside air damper"
    annotation (Placement(transformation(extent={{200,70},{220,90}}), iconTransformation(extent={{200,70},{220,90}})));
  Modelica.Blocks.Routing.Extractor extractor(
    nin=6,
    index(start=1, fixed=true)) "Extractor for control signal"
    annotation (Placement(transformation(extent={{120,-20},{140,0}})));
  Modelica.Blocks.Sources.Constant closed(k=0) "Signal to close OA damper"
    annotation (Placement(transformation(extent={{60,-90},{80,-70}})));
  Modelica.Blocks.Math.Max max
    "Takes bigger signal (OA damper opens for temp. control or for minimum outside air)"
    annotation (Placement(transformation(extent={{80,-20},{100,0}})));
  MixedAirTemperatureSetpoint TSetMix "Mixed air temperature setpoint"
    annotation (Placement(transformation(extent={{-20,64},{0,84}})));
  EconomizerTemperatureControl yOATMix(Ti=Ti, k=k)
    "Control signal for outdoor damper to track mixed air temperature setpoint"
    annotation (Placement(transformation(extent={{20,160},{40,180}})));
  EconomizerTemperatureControl yOATFre(Ti=Ti, k=k)
    "Control signal for outdoor damper to track freeze temperature setpoint"
    annotation (Placement(transformation(extent={{20,120},{40,140}})));
  Modelica.Blocks.Math.Min min
    "Takes bigger signal (OA damper opens for temp. control or for minimum outside air)"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Modelica.Blocks.Sources.Constant TFre(k=273.15 + 3)
    "Setpoint for freeze protection"
    annotation (Placement(transformation(extent={{-20,100},{0,120}})));
equation
  connect(VOut_flow, gain.u) annotation (Line(
      points={{-120,40},{-92,40},{-92,-50},{-62,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.y, conV_flow.u_m) annotation (Line(
      points={{-39,-50},{-12,-50},{-12,-22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(uni.y, conV_flow.u_s) annotation (Line(
      points={{-39,-10},{-24,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(controlBus.controlMode, extractor.index) annotation (Line(
      points={{-40,60},{-40,20},{60,20},{60,-40},{130,-40},{130,-22}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(max.y, extractor.u[OperationModes.occupied]) annotation (Line(
      points={{101,-10},{118,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(closed.y, extractor.u[OperationModes.unoccupiedOff]) annotation (Line(
      points={{81,-80},{110,-80},{110,-10},{118,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(closed.y, extractor.u[OperationModes.unoccupiedNightSetBack]) annotation (Line(
      points={{81,-80},{110,-80},{110,-10},{118,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(max.y, extractor.u[OperationModes.unoccupiedWarmUp]) annotation (Line(
      points={{101,-10},{118,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(max.y, extractor.u[OperationModes.unoccupiedPreCool]) annotation (Line(
      points={{101,-10},{118,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(closed.y, extractor.u[OperationModes.safety]) annotation (Line(
      points={{81,-80},{110,-80},{110,-10},{118,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSupHeaSet, TSetMix.TSupHeaSet) annotation (Line(
      points={{-120,-20},{-80,-20},{-80,80},{-22,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSupCooSet, TSetMix.TSupCooSet) annotation (Line(
      points={{-120,-80},{-72,-80},{-72,68},{-22,68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(controlBus, TSetMix.controlBus) annotation (Line(
      points={{-40,60},{-13,60},{-13,81}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(yOATMix.TRet, TRet) annotation (Line(
      points={{18,176},{-90,176},{-90,160},{-120,160}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(controlBus.TOut, yOATMix.TOut) annotation (Line(
      points={{-40,60},{-40,172},{18,172}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(yOATMix.TMix, TMix) annotation (Line(
      points={{18,168},{-80,168},{-80,100},{-120,100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(yOATMix.TMixSet, TSetMix.TSet) annotation (Line(
      points={{18,164},{6,164},{6,75},{1,75}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(yOATMix.yOA, max.u1) annotation (Line(
      points={{41,170},{74,170},{74,-4},{78,-4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(min.u2, conV_flow.y) annotation (Line(
      points={{18,-16},{10,-16},{10,-10},{-1,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(min.y, max.u2) annotation (Line(
      points={{41,-10},{60,-10},{60,-16},{78,-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(min.u1, yOATFre.yOA) annotation (Line(
      points={{18,-4},{10,-4},{10,50},{50,50},{50,130},{41,130}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(yOATFre.TRet, TRet) annotation (Line(
      points={{18,136},{-60,136},{-60,160},{-120,160}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(controlBus.TOut, yOATFre.TOut) annotation (Line(
      points={{-40,60},{-40,132},{18,132}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(yOATFre.TMix, TMix) annotation (Line(
      points={{18,128},{-80,128},{-80,100},{-120,100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TFre.y, yOATFre.TMixSet) annotation (Line(
      points={{1,110},{10,110},{10,124},{18,124}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(extractor.y, yOA) annotation (Line(
      points={{141,-10},{170,-10},{170,80},{210,80}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{200,200}})), Icon(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{200,200}}), graphics={
        Rectangle(
          extent={{-100,200},{200,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-90,170},{-50,150}},
          lineColor={0,0,255},
          textString="TRet"),
        Text(
          extent={{-86,104},{-46,84}},
          lineColor={0,0,255},
          textString="TMix"),
        Text(
          extent={{-90,60},{-22,12}},
          lineColor={0,0,255},
          textString="VOut_flow"),
        Text(
          extent={{-90,-2},{-28,-40}},
          lineColor={0,0,255},
          textString="TSupHeaSet"),
        Text(
          extent={{-86,-58},{-24,-96}},
          lineColor={0,0,255},
          textString="TSupCooSet"),
        Text(
          extent={{138,96},{184,62}},
          lineColor={0,0,255},
          textString="yOA")}));
end Economizer;
