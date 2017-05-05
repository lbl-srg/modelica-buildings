within Buildings.Experimental.ScalableModels;
package Controls


  block CoolingCoilTemperatureSetpoint
    "Set point scheduler for cooling coil"
    extends Modelica.Blocks.Icons.Block;
    import Buildings.Experimental.ScalableModels.Controls.OperationModes;
    parameter Modelica.SIunits.Temperature TCooOn=273.15+12
      "Cooling setpoint during on";
    parameter Modelica.SIunits.Temperature TCooOff=273.15+30
      "Cooling setpoint during off";
    Modelica.Blocks.Sources.RealExpression TSupSetCoo(
     y=if (mode.y == Integer(OperationModes.occupied) or
           mode.y == Integer(OperationModes.unoccupiedPreCool) or
           mode.y == Integer(OperationModes.safety)) then
            TCooOn else TCooOff) "Supply air temperature setpoint for cooling"
      annotation (Placement(transformation(extent={{-22,-50},{-2,-30}})));
    Modelica.Blocks.Interfaces.RealInput TSetHea(
      unit="K",
      displayUnit="degC") "Set point for heating coil"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    Modelica.Blocks.Math.Add add
      annotation (Placement(transformation(extent={{20,-10},{40,10}})));
    Modelica.Blocks.Sources.Constant dTMin(k=1)
      "Minimum offset for cooling coil setpoint"
      annotation (Placement(transformation(extent={{-20,10},{0,30}})));
    Modelica.Blocks.Math.Max max1
      annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
    Buildings.Experimental.ScalableModels.Controls.ControlBus controlBus
      annotation (Placement(transformation(extent={{-28,-90},{-8,-70}})));
    Modelica.Blocks.Routing.IntegerPassThrough mode
      annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
    Modelica.Blocks.Interfaces.RealOutput TSet(
      unit="K",
      displayUnit="degC") "Temperature set point"
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  equation
    connect(dTMin.y, add.u1) annotation (Line(
        points={{1,20},{10,20},{10,6},{18,6}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(add.y, max1.u1) annotation (Line(
        points={{41,6.10623e-16},{52,6.10623e-16},{52,-14},{58,-14}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(TSupSetCoo.y, max1.u2) annotation (Line(
        points={{-1,-40},{20,-40},{20,-26},{58,-26}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(controlBus.controlMode, mode.u) annotation (Line(
        points={{-18,-80},{38,-80}},
        color={255,204,51},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
    connect(max1.y, TSet) annotation (Line(
        points={{81,-20},{86,-20},{86,0},{110,0},{110,5.55112e-16}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(TSetHea, add.u2) annotation (Line(
        points={{-120,1.11022e-15},{-52,1.11022e-15},{-52,-6},{18,-6}},
        color={0,0,127},
        smooth=Smooth.None));
    annotation ( Icon(graphics={
          Text(
            extent={{44,16},{90,-18}},
            lineColor={0,0,255},
            textString="TSetCoo"),
          Text(
            extent={{-88,22},{-20,-26}},
            lineColor={0,0,255},
            textString="TSetHea")}));
  end CoolingCoilTemperatureSetpoint;

  block Economizer "Controller for economizer"
    import Buildings.Experimental.ScalableModels.Controls.OperationModes;
  import Buildings;
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
    Buildings.Experimental.ScalableModels.Controls.ControlBus controlBus
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
    Buildings.Experimental.ScalableModels.Controls.MixedAirTemperatureSetpoint TSetMix
      "Mixed air temperature setpoint"
      annotation (Placement(transformation(extent={{-20,64},{0,84}})));
    Buildings.Experimental.ScalableModels.Controls.EconomizerTemperatureControl yOATMix(Ti=Ti, k=k)
      "Control signal for outdoor damper to track mixed air temperature setpoint"
      annotation (Placement(transformation(extent={{20,160},{40,180}})));
    Buildings.Controls.Continuous.LimPID yOATFre(
      k=k,
      Ti=Ti,
      Td=60,
      controllerType=Modelica.Blocks.Types.SimpleController.PI,
      yMax=1,
      yMin=0)
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
    connect(max.y, extractor.u[Integer(OperationModes.occupied)]) annotation (Line(
        points={{101,-10},{118,-10}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(closed.y, extractor.u[Integer(OperationModes.unoccupiedOff)]) annotation (Line(
        points={{81,-80},{110,-80},{110,-10},{118,-10}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(closed.y, extractor.u[Integer(OperationModes.unoccupiedNightSetBack)]) annotation (Line(
        points={{81,-80},{110,-80},{110,-10},{118,-10}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(max.y, extractor.u[Integer(OperationModes.unoccupiedWarmUp)]) annotation (Line(
        points={{101,-10},{118,-10}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(max.y, extractor.u[Integer(OperationModes.unoccupiedPreCool)]) annotation (Line(
        points={{101,-10},{118,-10}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(closed.y, extractor.u[Integer(OperationModes.safety)]) annotation (Line(
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
    connect(extractor.y, yOA) annotation (Line(
        points={{141,-10},{170,-10},{170,80},{210,80}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(yOATFre.u_s, TMix) annotation (Line(points={{18,130},{-32,130},{-80,
            130},{-80,100},{-120,100}}, color={0,0,127}));
    connect(TFre.y, yOATFre.u_m) annotation (Line(points={{1,110},{14,110},{30,
            110},{30,118}}, color={0,0,127}));
    connect(yOATFre.y, min.u1) annotation (Line(points={{41,130},{48,130},{48,30},
            {10,30},{10,-4},{18,-4}}, color={0,0,127}));
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
            textString="yOA")}),
      Documentation(info="<html>
<p>
This is a controller for an economizer with
that adjust the outside air dampers to meet the set point
for the mixing air, taking into account the minimum outside
air requirement and an override for freeze protection.
</p>
</html>",   revisions="<html>
<ul>
<li>
December 20, 2016, by Michael Wetter:<br/>
Added type conversion for enumeration when used as an array index.<br/>
This is for
<a href=\"modelica://https://github.com/lbl-srg/modelica-buildings/issues/602\">#602</a>.
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

  block EconomizerTemperatureControl
    "Controller for economizer mixed air temperature"
    extends Modelica.Blocks.Icons.Block;
    import Buildings.Experimental.ScalableModels.Controls.OperationModes;
    Buildings.Controls.Continuous.LimPID con(
      k=k,
      Ti=Ti,
      yMax=0.995,
      yMin=0.005,
      Td=60,
      controllerType=Modelica.Blocks.Types.SimpleController.PI)
      "Controller for mixed air temperature"
      annotation (Placement(transformation(extent={{60,-10},{80,10}})));
    parameter Real k=1 "Gain of controller";
    parameter Modelica.SIunits.Time Ti "Time constant of Integrator block";
    Modelica.Blocks.Logical.Switch swi1
      annotation (Placement(transformation(extent={{0,-10},{20,10}})));
    Modelica.Blocks.Logical.Switch swi2
      annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
    Modelica.Blocks.Interfaces.RealOutput yOA
      "Control signal for outside air damper"
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    Modelica.Blocks.Interfaces.RealInput TRet "Return air temperature"
      annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
    Modelica.Blocks.Interfaces.RealInput TOut "Outside air temperature"
      annotation (Placement(transformation(extent={{-140,0},{-100,40}})));
    Modelica.Blocks.Interfaces.RealInput TMix "Mixed air temperature"
      annotation (Placement(transformation(extent={{-140,-40},{-100,0}})));
    Modelica.Blocks.Interfaces.RealInput TMixSet
      "Setpoint for mixed air temperature"
      annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
    Modelica.Blocks.Logical.Hysteresis hysConGai(uLow=-0.1, uHigh=0.1)
      "Hysteresis for control gain"
      annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
    Modelica.Blocks.Math.Feedback feedback
      annotation (Placement(transformation(extent={{-70,50},{-50,70}})));
  equation
    connect(swi1.y, con.u_s)    annotation (Line(
        points={{21,6.10623e-16},{30,0},{40,1.27676e-15},{40,6.66134e-16},{58,
            6.66134e-16}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(swi2.y, con.u_m)    annotation (Line(
        points={{21,-40},{70,-40},{70,-12}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(con.y, yOA)    annotation (Line(
        points={{81,6.10623e-16},{90.5,6.10623e-16},{90.5,5.55112e-16},{110,
            5.55112e-16}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(swi1.u1, TMix) annotation (Line(
        points={{-2,8},{-80,8},{-80,-20},{-120,-20}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(swi2.u3, TMix) annotation (Line(
        points={{-2,-48},{-80,-48},{-80,-20},{-120,-20}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(swi1.u3, TMixSet) annotation (Line(
        points={{-2,-8},{-60,-8},{-60,-60},{-120,-60}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(swi2.u1, TMixSet) annotation (Line(
        points={{-2,-32},{-60,-32},{-60,-60},{-120,-60}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(feedback.u1, TRet) annotation (Line(points={{-68,60},{-68,60},{-88,60},
            {-88,60},{-120,60}}, color={0,0,127}));
    connect(TOut, feedback.u2)
      annotation (Line(points={{-120,20},{-60,20},{-60,52}}, color={0,0,127}));
    connect(feedback.y, hysConGai.u) annotation (Line(points={{-51,60},{-48,60},{
            -46,60},{-42,60}}, color={0,0,127}));
    connect(hysConGai.y, swi2.u2) annotation (Line(points={{-19,60},{-12,60},{-12,
            -40},{-2,-40}}, color={255,0,255}));
    connect(hysConGai.y, swi1.u2) annotation (Line(points={{-19,60},{-12,60},{-12,
            0},{-2,0}}, color={255,0,255}));
    annotation ( Icon(coordinateSystem(
            preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
          Text(
            extent={{-92,78},{-66,50}},
            lineColor={0,0,127},
            textString="TRet"),
          Text(
            extent={{-88,34},{-62,6}},
            lineColor={0,0,127},
            textString="TOut"),
          Text(
            extent={{-86,-6},{-60,-34}},
            lineColor={0,0,127},
            textString="TMix"),
          Text(
            extent={{-84,-46},{-58,-74}},
            lineColor={0,0,127},
            textString="TMixSet"),
          Text(
            extent={{64,14},{90,-14}},
            lineColor={0,0,127},
            textString="yOA")}), Documentation(info="<html>
<p>
This controller outputs the control signal for the outside
air damper in order to regulate the mixed air temperature
<code>TMix</code>.
</p>
<h4>Implementation</h4>
<p>
If the control error <i>T<sub>mix,set</sub> - T<sub>mix</sub> &lt; 0</i>,
then more outside air is needed provided that <i>T<sub>out</sub> &lt; T<sub>ret</sub></i>,
where
<i>T<sub>out</sub></i> is the outside air temperature and
<i>T<sub>ret</sub></i> is the return air temperature.
However, if <i>T<sub>out</sub> &ge; T<sub>ret</sub></i>,
then less outside air is needed.
Hence, the control gain need to switch sign depending on this difference.
This is accomplished by taking the difference between these signals,
and then switching the input of the controller.
A hysteresis is used to avoid chattering, for example if
<code>TRet</code> has numerical noise in the simulation, or
measurement error in a real application.
</p>
</html>",   revisions="<html>
<ul>
<li>
April 1, 2016, by Michael Wetter:<br/>
Added hysteresis to avoid too many events that stall the simulation.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/502\">#502</a>.
</li>
<li>
March 8, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
  end EconomizerTemperatureControl;

  block FanVFD "Controller for fan revolution"
    extends Modelica.Blocks.Interfaces.SISO;
    import Buildings.Experimental.ScalableModels.Controls.OperationModes;
    Buildings.Controls.Continuous.LimPID con(
      yMax=1,
      Td=60,
      yMin=r_N_min,
      k=k,
      Ti=Ti,
      controllerType=controllerType) "Controller"
      annotation (Placement(transformation(extent={{-20,20},{0,40}})));
    Modelica.Blocks.Math.Gain gaiMea(k=1/xSet_nominal)
      "Gain to normalize measurement signal"
      annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
    parameter Real xSet_nominal "Nominal setpoint (used for normalization)";
    Buildings.Experimental.ScalableModels.Controls.ControlBus controlBus
      annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
    Modelica.Blocks.Routing.Extractor extractor(
      nin=6,
      index(start=1, fixed=true)) "Extractor for control signal"
      annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
    Modelica.Blocks.Sources.Constant off(k=0) "Off signal"
      annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
    Modelica.Blocks.Sources.Constant on(k=1) "On signal"
      annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
    Modelica.Blocks.Math.Gain gaiSet(k=1/xSet_nominal)
      "Gain to normalize setpoint signal"
      annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
    Modelica.Blocks.Interfaces.RealInput u_m
      "Connector of measurement input signal" annotation (Placement(
          transformation(
          extent={{-20,-20},{20,20}},
          rotation=90,
          origin={0,-120})));
    parameter Real r_N_min=0.01 "Minimum normalized fan speed";
    parameter Modelica.Blocks.Types.Init initType=Modelica.Blocks.Types.Init.NoInit
      "Type of initialization (1: no init, 2: steady state, 3/4: initial output)";
    parameter Real y_start=0 "Initial or guess value of output (= state)";

    parameter Modelica.Blocks.Types.SimpleController
      controllerType=.Modelica.Blocks.Types.SimpleController.PI
      "Type of controller"
      annotation (Dialog(group="Setpoint tracking"));
    parameter Real k=0.5 "Gain of controller"
      annotation (Dialog(group="Setpoint tracking"));
    parameter Modelica.SIunits.Time Ti=15 "Time constant of Integrator block"
      annotation (Dialog(group="Setpoint tracking"));

  equation
    connect(gaiMea.y, con.u_m) annotation (Line(
        points={{-39,6.10623e-16},{-10,6.10623e-16},{-10,18}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(con.y, extractor.u[Integer(OperationModes.occupied)]) annotation (Line(
        points={{1,30},{20,30},{20,-8},{-20,-8},{-20,-30},{18,-30}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(con.y, extractor.u[Integer(OperationModes.unoccupiedWarmUp)]) annotation (Line(
        points={{1,30},{20,30},{20,-8},{-20,-8},{-20,-30},{18,-30}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(con.y, extractor.u[Integer(OperationModes.unoccupiedPreCool)]) annotation (Line(
        points={{1,30},{20,30},{20,-8},{-20,-8},{-20,-30},{18,-30}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(off.y, extractor.u[Integer(OperationModes.unoccupiedOff)])  annotation (Line(
        points={{-39,-70},{-20,-70},{-20,-30},{18,-30}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(off.y, extractor.u[Integer(OperationModes.safety)])  annotation (Line(
        points={{-39,-70},{-20,-70},{-20,-30},{18,-30}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(on.y, extractor.u[Integer(OperationModes.unoccupiedNightSetBack)]) annotation (Line(
        points={{-39,-30},{18,-30}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(controlBus.controlMode, extractor.index) annotation (Line(
        points={{-70,80},{-70,-52},{30,-52},{30,-42}},
        color={255,204,51},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
    connect(gaiSet.y, con.u_s) annotation (Line(
        points={{-39,30},{-22,30}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(u_m, gaiMea.u) annotation (Line(
        points={{1.11022e-15,-120},{1.11022e-15,-92},{-80,-92},{-80,0},{-62,0},{
            -62,6.66134e-16}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(gaiSet.u, u) annotation (Line(
        points={{-62,30},{-90,30},{-90,1.11022e-15},{-120,1.11022e-15}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(extractor.y, y) annotation (Line(
        points={{41,-30},{70,-30},{70,5.55112e-16},{110,5.55112e-16}},
        color={0,0,127},
        smooth=Smooth.None));
    annotation ( Icon(graphics={Text(
            extent={{-90,-50},{96,-96}},
            lineColor={0,0,255},
            textString="r_N_min=%r_N_min")}), Documentation(revisions="<html>
<ul>
<li>
December 20, 2016, by Michael Wetter:<br/>
Added type conversion for enumeration when used as an array index.<br/>
This is for
<a href=\"modelica://https://github.com/lbl-srg/modelica-buildings/issues/602\">#602</a>.
</li>
</ul>
</html>"));
  end FanVFD;

  model MixedAirTemperatureSetpoint
    "Mixed air temperature setpoint for economizer"
    extends Modelica.Blocks.Icons.Block;
    Modelica.Blocks.Routing.Extractor TSetMix(
      nin=6,
      index(start=1, fixed=true)) "Mixed air setpoint temperature extractor"
      annotation (Placement(transformation(extent={{60,0},{80,20}})));
    Modelica.Blocks.Sources.Constant off(k=273.15 + 13)
      "Setpoint temperature to close damper"
      annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
    Buildings.Utilities.Math.Average ave(nin=2)
      annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
    Modelica.Blocks.Interfaces.RealInput TSupHeaSet
      "Supply temperature setpoint for heating"
      annotation (Placement(transformation(extent={{-140,40},{-100,80}}), iconTransformation(extent={{-140,40},{-100,80}})));
    Modelica.Blocks.Interfaces.RealInput TSupCooSet
      "Supply temperature setpoint for cooling"
      annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
    Modelica.Blocks.Sources.Constant TPreCoo(k=273.15 + 13)
      "Setpoint during pre-cooling"
      annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
    Buildings.Experimental.ScalableModels.Controls.ControlBus controlBus
      annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
    Modelica.Blocks.Interfaces.RealOutput TSet "Mixed air temperature setpoint"
      annotation (Placement(transformation(extent={{100,0},{120,20}})));
    Modelica.Blocks.Routing.Multiplex2 multiplex2_1
      annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  equation
    connect(TSetMix.u[1], ave.y) annotation (Line(
        points={{58,8.33333},{14,8.33333},{14,-60},{1,-60}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(ave.y, TSetMix.u[1])     annotation (Line(
        points={{1,-60},{42,-60},{42,8.33333},{58,8.33333}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(off.y, TSetMix.u[2]) annotation (Line(
        points={{-59,30},{40,30},{40,12},{58,12},{58,9}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(off.y, TSetMix.u[3]) annotation (Line(
        points={{-59,30},{40,30},{40,9.66667},{58,9.66667}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(off.y, TSetMix.u[4]) annotation (Line(
        points={{-59,30},{9.5,30},{9.5,10.3333},{58,10.3333}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(TPreCoo.y, TSetMix.u[5]) annotation (Line(
        points={{-59,-10},{0,-10},{0,11},{58,11}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(off.y, TSetMix.u[6]) annotation (Line(
        points={{-59,30},{40,30},{40,11.6667},{58,11.6667}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(controlBus.controlMode, TSetMix.index) annotation (Line(
        points={{-30,70},{-30,-14},{70,-14},{70,-2}},
        color={255,204,51},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
    connect(TSetMix.y, TSet) annotation (Line(
        points={{81,10},{110,10}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(multiplex2_1.y, ave.u) annotation (Line(
        points={{-39,-60},{-22,-60}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(TSupCooSet, multiplex2_1.u2[1]) annotation (Line(
        points={{-120,-60},{-90,-60},{-90,-66},{-62,-66}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(TSupHeaSet, multiplex2_1.u1[1]) annotation (Line(
        points={{-120,60},{-90,60},{-90,-54},{-62,-54}},
        color={0,0,127},
        smooth=Smooth.None));
  end MixedAirTemperatureSetpoint;

  model ModeSelector "Finite State Machine for the operational modes"

    Modelica.StateGraph.InitialStep initialStep
      annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
    Modelica.StateGraph.Transition start "Starts the system"
      annotation (Placement(transformation(extent={{-50,20},{-30,40}})));
    Buildings.Experimental.ScalableModels.Controls.State unOccOff(
      mode=Buildings.Experimental.ScalableModels.Controls.OperationModes.unoccupiedOff,
      nIn=3,
      nOut=4) "Unoccupied off mode, no coil protection"
      annotation (Placement(transformation(extent={{-20,20},{0,40}})));
    Buildings.Experimental.ScalableModels.Controls.State unOccNigSetBac(
      nOut=2,
      mode=Buildings.Experimental.ScalableModels.Controls.OperationModes.unoccupiedNightSetBack,
      nIn=1) "Unoccupied night set back"
      annotation (Placement(transformation(extent={{80,20},{100,40}})));

    Modelica.StateGraph.Transition t2(
      enableTimer=true,
      waitTime=60,
      condition=TRooMinErrHea.y > delTRooOnOff/2)
      annotation (Placement(transformation(extent={{28,20},{48,40}})));
    parameter Modelica.SIunits.TemperatureDifference delTRooOnOff(min=0.1)=1
      "Deadband in room temperature between occupied on and occupied off";
    parameter Modelica.SIunits.Temperature TRooSetHeaOcc=293.15
      "Set point for room air temperature during heating mode";
    parameter Modelica.SIunits.Temperature TRooSetCooOcc=299.15
      "Set point for room air temperature during cooling mode";
    parameter Modelica.SIunits.Temperature TSetHeaCoiOut=303.15
      "Set point for air outlet temperature at central heating coil";
    Modelica.StateGraph.Transition t1(condition=delTRooOnOff/2 < -TRooMinErrHea.y,
      enableTimer=true,
      waitTime=30*60)
      annotation (Placement(transformation(extent={{50,70},{30,90}})));
    inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
      annotation (Placement(transformation(extent={{160,160},{180,180}})));
    Buildings.Experimental.ScalableModels.Controls.ControlBus cb annotation (Placement(
          transformation(extent={{-168,130},{-148,150}}), iconTransformation(
            extent={{-176,124},{-124,176}})));
    Modelica.Blocks.Routing.RealPassThrough TRooSetHea
      "Current heating setpoint temperature"
      annotation (Placement(transformation(extent={{-80,170},{-60,190}})));
    Buildings.Experimental.ScalableModels.Controls.State morWarUp(
      mode=Buildings.Experimental.ScalableModels.Controls.OperationModes.unoccupiedWarmUp,
      nIn=2,
      nOut=1) "Morning warm up"
      annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));

    Modelica.StateGraph.TransitionWithSignal t6(enableTimer=true, waitTime=60)
      annotation (Placement(transformation(extent={{-76,-100},{-56,-80}})));
    Modelica.Blocks.Logical.LessEqualThreshold occThrSho(threshold=1800)
      "Signal to allow transition into morning warmup"
      annotation (Placement(transformation(extent={{-140,-190},{-120,-170}})));
    Modelica.StateGraph.TransitionWithSignal t5
      annotation (Placement(transformation(extent={{118,20},{138,40}})));
    Buildings.Experimental.ScalableModels.Controls.State occ(mode=Buildings.Experimental.ScalableModels.Controls.OperationModes.occupied,
        nIn=3) "Occupied mode"
      annotation (Placement(transformation(extent={{60,-100},{80,-80}})));
    Modelica.Blocks.Routing.RealPassThrough TRooMin
      annotation (Placement(transformation(extent={{-80,140},{-60,160}})));
    Modelica.Blocks.Math.Feedback TRooMinErrHea "Room control error for heating"
      annotation (Placement(transformation(extent={{-40,170},{-20,190}})));
    Modelica.StateGraph.Transition t3(condition=TRooMin.y + delTRooOnOff/2 >
          TRooSetHeaOcc or occupied.y)
      annotation (Placement(transformation(extent={{10,-100},{30,-80}})));
    Modelica.Blocks.Routing.BooleanPassThrough occupied
      "outputs true if building is occupied"
      annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
    Modelica.StateGraph.TransitionWithSignal t4(enableTimer=false)
      annotation (Placement(transformation(extent={{118,120},{98,140}})));
    Buildings.Experimental.ScalableModels.Controls.State morPreCoo(
      nIn=2,
      mode=Buildings.Experimental.ScalableModels.Controls.OperationModes.unoccupiedPreCool,
      nOut=1) "Pre-cooling mode"
      annotation (Placement(transformation(extent={{-40,-140},{-20,-120}})));

    Modelica.StateGraph.Transition t7(condition=TRooMin.y - delTRooOnOff/2 <
          TRooSetCooOcc or occupied.y)
      annotation (Placement(transformation(extent={{10,-140},{30,-120}})));
    Modelica.Blocks.Logical.And and1
      annotation (Placement(transformation(extent={{-100,-200},{-80,-180}})));
    Modelica.Blocks.Routing.RealPassThrough TRooAve "Average room temperature"
      annotation (Placement(transformation(extent={{-80,110},{-60,130}})));
    Modelica.Blocks.Sources.BooleanExpression booleanExpression(y=TRooAve.y <
          TRooSetCooOcc)
      annotation (Placement(transformation(extent={{-198,-224},{-122,-200}})));
    Buildings.Experimental.ScalableModels.Controls.PreCoolingStarter preCooSta(TRooSetCooOcc=
          TRooSetCooOcc) "Model to start pre-cooling"
      annotation (Placement(transformation(extent={{-140,-160},{-120,-140}})));
    Modelica.StateGraph.TransitionWithSignal t9
      annotation (Placement(transformation(extent={{-90,-140},{-70,-120}})));
    Modelica.Blocks.Logical.Not not1
      annotation (Placement(transformation(extent={{-48,-180},{-28,-160}})));
    Modelica.Blocks.Logical.And and2
      annotation (Placement(transformation(extent={{80,100},{100,120}})));
    Modelica.Blocks.Logical.Not not2
      annotation (Placement(transformation(extent={{0,100},{20,120}})));
    Modelica.StateGraph.TransitionWithSignal t8
      "changes to occupied in case precooling is deactivated"
      annotation (Placement(transformation(extent={{30,-30},{50,-10}})));
    Modelica.Blocks.MathInteger.Sum sum(nu=5)
      annotation (Placement(transformation(extent={{-186,134},{-174,146}})));
  equation
    connect(start.outPort, unOccOff.inPort[1]) annotation (Line(
        points={{-38.5,30},{-29.75,30},{-29.75,30.6667},{-21,30.6667}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(initialStep.outPort[1], start.inPort) annotation (Line(
        points={{-59.5,30},{-44,30}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(unOccOff.outPort[1], t2.inPort)         annotation (Line(
        points={{0.5,30.375},{8.25,30.375},{8.25,30},{34,30}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(t2.outPort, unOccNigSetBac.inPort[1])  annotation (Line(
        points={{39.5,30},{79,30}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(unOccNigSetBac.outPort[1], t1.inPort)   annotation (Line(
        points={{100.5,30.25},{112,30.25},{112,80},{44,80}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(t1.outPort, unOccOff.inPort[2])          annotation (Line(
        points={{38.5,80},{-30,80},{-30,30},{-21,30}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(cb.dTNexOcc, occThrSho.u)             annotation (Line(
        points={{-158,140},{-150,140},{-150,-180},{-142,-180}},
        color={255,204,51},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
    connect(t6.outPort, morWarUp.inPort[1]) annotation (Line(
        points={{-64.5,-90},{-41,-90},{-41,-89.5}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(t5.outPort, morWarUp.inPort[2]) annotation (Line(
        points={{129.5,30},{140,30},{140,-60},{-48,-60},{-48,-90.5},{-41,-90.5}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(unOccNigSetBac.outPort[2], t5.inPort)
                                           annotation (Line(
        points={{100.5,29.75},{113.25,29.75},{113.25,30},{124,30}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(cb.TRooMin, TRooMin.u) annotation (Line(
        points={{-158,140},{-92,140},{-92,150},{-82,150}},
        color={255,204,51},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
    connect(TRooSetHea.y, TRooMinErrHea.u1)
                                      annotation (Line(
        points={{-59,180},{-38,180}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(TRooMin.y, TRooMinErrHea.u2)
                                      annotation (Line(
        points={{-59,150},{-30,150},{-30,172}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(unOccOff.outPort[2], t6.inPort) annotation (Line(
        points={{0.5,30.125},{12,30.125},{12,-48},{-80,-48},{-80,-90},{-70,-90}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(morWarUp.outPort[1], t3.inPort) annotation (Line(
        points={{-19.5,-90},{16,-90}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(cb.occupied, occupied.u) annotation (Line(
        points={{-158,140},{-120,140},{-120,90},{-82,90}},
        color={255,204,51},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
    connect(occ.outPort[1], t4.inPort) annotation (Line(
        points={{80.5,-90},{172,-90},{172,130},{112,130}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(t4.outPort, unOccOff.inPort[3]) annotation (Line(
        points={{106.5,130},{-30,130},{-30,29.3333},{-21,29.3333}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(occThrSho.y, and1.u1) annotation (Line(
        points={{-119,-180},{-110,-180},{-110,-190},{-102,-190}},
        color={255,0,255},
        smooth=Smooth.None));
    connect(and1.y, t6.condition) annotation (Line(
        points={{-79,-190},{-66,-190},{-66,-102}},
        color={255,0,255},
        smooth=Smooth.None));
    connect(and1.y, t5.condition) annotation (Line(
        points={{-79,-190},{128,-190},{128,18}},
        color={255,0,255},
        smooth=Smooth.None));
    connect(cb.TRooAve, TRooAve.u) annotation (Line(
        points={{-158,140},{-100,140},{-100,120},{-82,120}},
        color={255,204,51},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
    connect(booleanExpression.y, and1.u2) annotation (Line(
        points={{-118.2,-212},{-110.1,-212},{-110.1,-198},{-102,-198}},
        color={255,0,255},
        smooth=Smooth.None));
    connect(preCooSta.y, t9.condition) annotation (Line(
        points={{-119,-150},{-80,-150},{-80,-142}},
        color={255,0,255},
        smooth=Smooth.None));
    connect(t9.outPort, morPreCoo.inPort[1]) annotation (Line(
        points={{-78.5,-130},{-59.75,-130},{-59.75,-129.5},{-41,-129.5}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(unOccOff.outPort[3], t9.inPort) annotation (Line(
        points={{0.5,29.875},{12,29.875},{12,0},{-100,0},{-100,-130},{-84,-130}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(cb, preCooSta.controlBus) annotation (Line(
        points={{-158,140},{-150,140},{-150,-144},{-136.2,-144}},
        color={255,204,51},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
    connect(morPreCoo.outPort[1], t7.inPort) annotation (Line(
        points={{-19.5,-130},{16,-130}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(t7.outPort, occ.inPort[2]) annotation (Line(
        points={{21.5,-130},{30,-130},{30,-128},{46,-128},{46,-90},{59,-90}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(t3.outPort, occ.inPort[1]) annotation (Line(
        points={{21.5,-90},{42,-90},{42,-89.3333},{59,-89.3333}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(occThrSho.y, not1.u) annotation (Line(
        points={{-119,-180},{-110,-180},{-110,-170},{-50,-170}},
        color={255,0,255},
        smooth=Smooth.None));
    connect(not1.y, and2.u2) annotation (Line(
        points={{-27,-170},{200,-170},{200,90},{66,90},{66,102},{78,102}},
        color={255,0,255},
        smooth=Smooth.None));
    connect(and2.y, t4.condition) annotation (Line(
        points={{101,110},{108,110},{108,118}},
        color={255,0,255},
        smooth=Smooth.None));
    connect(occupied.y, not2.u) annotation (Line(
        points={{-59,90},{-20,90},{-20,110},{-2,110}},
        color={255,0,255},
        smooth=Smooth.None));
    connect(not2.y, and2.u1) annotation (Line(
        points={{21,110},{78,110}},
        color={255,0,255},
        smooth=Smooth.None));
    connect(cb.TRooSetHea, TRooSetHea.u) annotation (Line(
        points={{-158,140},{-92,140},{-92,180},{-82,180}},
        color={255,204,51},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
    connect(t8.outPort, occ.inPort[3]) annotation (Line(
        points={{41.5,-20},{52,-20},{52,-90.6667},{59,-90.6667}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(unOccOff.outPort[4], t8.inPort) annotation (Line(
        points={{0.5,29.625},{12,29.625},{12,-20},{36,-20}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(occupied.y, t8.condition) annotation (Line(
        points={{-59,90},{-50,90},{-50,-40},{40,-40},{40,-32}},
        color={255,0,255},
        smooth=Smooth.None));
    connect(morPreCoo.y, sum.u[1]) annotation (Line(
        points={{-19,-136},{-8,-136},{-8,-68},{-192,-68},{-192,143.36},{-186,
            143.36}},
        color={255,127,0},
        smooth=Smooth.None));
    connect(morWarUp.y, sum.u[2]) annotation (Line(
        points={{-19,-96},{-8,-96},{-8,-68},{-192,-68},{-192,141.68},{-186,141.68}},
        color={255,127,0},
        smooth=Smooth.None));
    connect(occ.y, sum.u[3]) annotation (Line(
        points={{81,-96},{100,-96},{100,-108},{-192,-108},{-192,140},{-186,140}},
        color={255,127,0},
        smooth=Smooth.None));
    connect(unOccOff.y, sum.u[4]) annotation (Line(
        points={{1,24},{6,24},{6,8},{-192,8},{-192,138.32},{-186,138.32}},
        color={255,127,0},
        smooth=Smooth.None));
    connect(unOccNigSetBac.y, sum.u[5]) annotation (Line(
        points={{101,24},{112,24},{112,8},{-192,8},{-192,136.64},{-186,136.64}},
        color={255,127,0},
        smooth=Smooth.None));
    connect(sum.y, cb.controlMode) annotation (Line(
        points={{-173.1,140},{-158,140}},
        color={255,127,0},
        smooth=Smooth.None), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-220,
              -220},{220,220}})), Icon(coordinateSystem(
            preserveAspectRatio=true, extent={{-220,-220},{220,220}}), graphics={
            Rectangle(
            extent={{-200,200},{200,-200}},
            lineColor={0,0,0},
            fillPattern=FillPattern.Solid,
            fillColor={215,215,215}), Text(
            extent={{-176,80},{192,-84}},
            lineColor={0,0,255},
            textString="%name")}));
  end ModeSelector;

  type OperationModes = enumeration(
    occupied   "Occupied",
    unoccupiedOff   "Unoccupied off",
    unoccupiedNightSetBack   "Unoccupied, night set back",
    unoccupiedWarmUp   "Unoccupied, warm-up",
    unoccupiedPreCool   "Unoccupied, pre-cool",
    safety   "Safety (smoke, fire, etc.)") "Enumeration for modes of operation";

  block PreCoolingStarter "Outputs true when precooling should start"
    extends Modelica.Blocks.Interfaces.BooleanSignalSource;
    parameter Modelica.SIunits.Temperature TOutLim = 286.15
      "Limit for activating precooling";
    parameter Modelica.SIunits.Temperature TRooSetCooOcc
      "Set point for room air temperature during cooling mode";
    Buildings.Experimental.ScalableModels.Controls.ControlBus controlBus
      annotation (Placement(transformation(extent={{-72,50},{-52,70}})));
    Modelica.Blocks.Logical.GreaterThreshold greater(threshold=TRooSetCooOcc)
      annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
    Modelica.Blocks.Logical.LessThreshold greater2(threshold=1800)
      annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
    Modelica.Blocks.Logical.LessThreshold greater1(threshold=TOutLim)
      annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
    Modelica.Blocks.MathBoolean.And and3(nu=3)
      annotation (Placement(transformation(extent={{28,-6},{40,6}})));
  equation
    connect(controlBus.dTNexOcc, greater2.u) annotation (Line(
        points={{-62,60},{-54,60},{-54,-70},{-42,-70}},
        color={255,204,51},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
    connect(controlBus.TRooAve, greater.u) annotation (Line(
        points={{-62,60},{-54,60},{-54,10},{-42,10}},
        color={255,204,51},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
    connect(controlBus.TOut, greater1.u) annotation (Line(
        points={{-62,60},{-54,60},{-54,-30},{-42,-30}},
        color={255,204,51},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
    connect(and3.y, y) annotation (Line(
        points={{40.9,0},{110,0}},
        color={255,0,255},
        smooth=Smooth.None));
    connect(greater.y, and3.u[1]) annotation (Line(
        points={{-19,10},{6,10},{6,2.8},{28,2.8}},
        color={255,0,255},
        smooth=Smooth.None));
    connect(greater1.y, and3.u[2]) annotation (Line(
        points={{-19,-30},{6,-30},{6,0},{28,0},{28,2.22045e-016}},
        color={255,0,255},
        smooth=Smooth.None));
    connect(greater2.y, and3.u[3]) annotation (Line(
        points={{-19,-70},{12,-70},{12,-2.8},{28,-2.8}},
        color={255,0,255},
        smooth=Smooth.None));
  end PreCoolingStarter;

  block RoomTemperatureSetpoint
    "Set point scheduler for room temperature"
    extends Modelica.Blocks.Icons.Block;
    import Buildings.Experimental.ScalableModels.Controls.OperationModes;
    parameter Modelica.SIunits.Temperature THeaOn=293.15
      "Heating setpoint during on";
    parameter Modelica.SIunits.Temperature THeaOff=285.15
      "Heating setpoint during off";
    parameter Modelica.SIunits.Temperature TCooOn=297.15
      "Cooling setpoint during on";
    parameter Modelica.SIunits.Temperature TCooOff=303.15
      "Cooling setpoint during off";
    Buildings.Experimental.ScalableModels.Controls.ControlBus controlBus
      annotation (Placement(transformation(extent={{10,50},{30,70}})));
    Modelica.Blocks.Routing.IntegerPassThrough mode
      annotation (Placement(transformation(extent={{60,50},{80,70}})));
    Modelica.Blocks.Sources.RealExpression setPoiHea(
       y=if (mode.y == Integer(OperationModes.occupied) or mode.y == Integer(OperationModes.unoccupiedWarmUp)
           or mode.y == Integer(OperationModes.safety)) then THeaOn else THeaOff)
      annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
    Modelica.Blocks.Sources.RealExpression setPoiCoo(
      y=if (mode.y == Integer(OperationModes.occupied) or
            mode.y == Integer(OperationModes.unoccupiedPreCool) or
            mode.y == Integer(OperationModes.safety)) then TCooOn else TCooOff)
      "Cooling setpoint"
      annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  equation
    connect(controlBus.controlMode,mode. u) annotation (Line(
        points={{20,60},{58,60}},
        color={255,204,51},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
    connect(setPoiHea.y, controlBus.TRooSetHea) annotation (Line(
        points={{-59,80},{20,80},{20,60}},
        color={0,0,127},
        smooth=Smooth.None), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
    connect(setPoiCoo.y, controlBus.TRooSetCoo) annotation (Line(
        points={{-59,40},{20,40},{20,60}},
        color={0,0,127},
        smooth=Smooth.None), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
    annotation (                                Icon(graphics={
          Text(
            extent={{-92,90},{-52,70}},
            lineColor={0,0,255},
            textString="TRet"),
          Text(
            extent={{-96,50},{-56,30}},
            lineColor={0,0,255},
            textString="TMix"),
          Text(
            extent={{-94,22},{-26,-26}},
            lineColor={0,0,255},
            textString="VOut_flow"),
          Text(
            extent={{-88,-22},{-26,-60}},
            lineColor={0,0,255},
            textString="TSupHeaSet"),
          Text(
            extent={{-86,-58},{-24,-96}},
            lineColor={0,0,255},
            textString="TSupCooSet"),
          Text(
            extent={{42,16},{88,-18}},
            lineColor={0,0,255},
            textString="yOA")}));
  end RoomTemperatureSetpoint;

  block RoomVAV "Controller for room VAV box"
  import Buildings;
    extends Modelica.Blocks.Icons.Block;
    parameter Real kPDamHea = 0.5
      "Proportional gain for VAV damper in heating mode";
    Buildings.Controls.Continuous.LimPID conHea(
      yMax=1,
      xi_start=0.1,
      initType=Modelica.Blocks.Types.InitPID.InitialState,
      Td=60,
      yMin=0,
      controllerType=Modelica.Blocks.Types.SimpleController.PI,
      k=0.1,
      Ti=120) "Controller for heating"
      annotation (Placement(transformation(extent={{-20,50},{0,70}})));
    Buildings.Controls.Continuous.LimPID conCoo(
      yMax=1,
      reverseAction=true,
      Td=60,
      controllerType=Modelica.Blocks.Types.SimpleController.PI,
      k=0.1,
      Ti=120) "Controller for cooling (acts on damper)"
      annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
    Buildings.Experimental.ScalableModels.Controls.ControlBus controlBus
      annotation (Placement(transformation(extent={{-80,64},{-60,84}})));
    Modelica.Blocks.Interfaces.RealInput TRoo(final quantity="ThermodynamicTemperature",
                                            final unit = "K", displayUnit = "degC", min=0)
      "Measured room temperature"
      annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
    Modelica.Blocks.Interfaces.RealOutput yHea "Signal for heating coil valve"
      annotation (Placement(transformation(extent={{100,30},{120,50}})));
    Modelica.Blocks.Interfaces.RealOutput yDam "Signal for VAV damper"
      annotation (Placement(transformation(extent={{100,-60},{120,-40}})));
    Modelica.Blocks.Interfaces.RealInput TSup(displayUnit="degC")
      "Measured supply air temperature after heating coil"
      annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
    Buildings.Utilities.Math.SmoothMax smoothMax2(deltaX=0.1)
      annotation (Placement(transformation(extent={{12,-14},{32,6}})));
    Modelica.Blocks.Sources.Constant one(k=1)
      annotation (Placement(transformation(extent={{-60,-76},{-40,-56}})));
    Modelica.Blocks.Math.Add3 yDamHea(k2=kPDamHea, k3=-kPDamHea)
      "Outputs (unlimited) damper signal for heating."
      annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
    Modelica.Blocks.Math.Add add
      annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
    Modelica.Blocks.Sources.Constant zero(k=0.1)
      annotation (Placement(transformation(extent={{-20,10},{0,30}})));
    Buildings.Utilities.Math.SmoothMin smoothMin(deltaX=0.1)
      annotation (Placement(transformation(extent={{76,-60},{96,-40}})));
  equation
    connect(controlBus.TRooSetHea, conHea.u_s) annotation (Line(
        points={{-70,74},{-70,60},{-22,60}},
        color={255,204,51},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
    connect(controlBus.TRooSetCoo, conCoo.u_s) annotation (Line(
        points={{-70,74},{-70,-50},{-22,-50}},
        color={255,204,51},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
    connect(conHea.u_m, TRoo) annotation (Line(
        points={{-10,48},{-10,40},{-120,40}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(conCoo.u_m, TRoo) annotation (Line(
        points={{-10,-62},{-10,-80},{-80,-80},{-80,40},{-120,40}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(TRoo, yDamHea.u3) annotation (Line(
        points={{-120,40},{-80,40},{-80,-18},{-22,-18}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(yDamHea.u2, TSup) annotation (Line(
        points={{-22,-10},{-90,-10},{-90,-40},{-120,-40}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(one.y, yDamHea.u1) annotation (Line(
        points={{-39,-66},{-32,-66},{-32,-2},{-22,-2}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(conCoo.y, add.u2) annotation (Line(
        points={{1,-50},{8,-50},{8,-36},{38,-36}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(yDamHea.y, smoothMax2.u2) annotation (Line(
        points={{1,-10},{10,-10}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(smoothMax2.y, add.u1) annotation (Line(
        points={{33,-4},{34,-4},{34,-24},{38,-24}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(zero.y, smoothMax2.u1) annotation (Line(
        points={{1,20},{4,20},{4,2},{10,2}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(smoothMin.u1, add.y) annotation (Line(
        points={{74,-44},{68,-44},{68,-30},{61,-30}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(one.y, smoothMin.u2) annotation (Line(
        points={{-39,-66},{48,-66},{48,-56},{74,-56}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(conHea.y, yHea) annotation (Line(
        points={{1,60},{80,60},{80,40},{110,40}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(smoothMin.y, yDam) annotation (Line(
        points={{97,-50},{110,-50}},
        color={0,0,127},
        smooth=Smooth.None));
    annotation ( Icon(graphics={
          Text(
            extent={{-92,48},{-44,24}},
            lineColor={0,0,127},
            textString="TRoo"),
          Text(
            extent={{-92,-30},{-44,-54}},
            lineColor={0,0,127},
            textString="TSup"),
          Text(
            extent={{42,52},{90,28}},
            lineColor={0,0,127},
            textString="yHea"),
          Text(
            extent={{46,-36},{94,-60}},
            lineColor={0,0,127},
            textString="yCoo")}));
  end RoomVAV;

  model State
    "Block that outputs the mode if the state is active, or zero otherwise"
    extends Modelica.StateGraph.StepWithSignal;
   parameter Buildings.Experimental.ScalableModels.Controls.OperationModes mode
      "Enter enumeration of mode";
    Modelica.Blocks.Interfaces.IntegerOutput y "Mode signal (=0 if not active)"
      annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
  equation
     y = if localActive then Integer(mode) else 0;
    annotation (Icon(graphics={Text(
            extent={{-82,96},{82,-84}},
            lineColor={0,0,255},
            textString="state")}));
  end State;
end Controls;
