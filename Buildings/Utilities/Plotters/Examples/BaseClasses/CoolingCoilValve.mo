within Buildings.Utilities.Plotters.Examples.BaseClasses;
block CoolingCoilValve "Cooling coil valve position control sequence"

  parameter Real alc_prop_k(final unit="1/F") = 1/100
    "Recorded proportional controller gain"
    annotation(Evaluate=true, Dialog(group="Controller"));

  parameter Real alc_int_k(final unit="1/F") = 0.5/100
    "Recorded integral controller gain"
    annotation(Evaluate=true, Dialog(group="Controller"));

  parameter Real alc_k_unit_conv = 9/5
    "Unit converter for controller gains from the ALC control logic"
    annotation(Evaluate=true, Dialog(tab="Advanced", group="Parameters"));

  parameter Modelica.SIunits.Temperature TOutCooCut = 50 * (5/9) - 32 * (5/9) + 273.15
    "Recorded outdoor air temperature cooling threshold"
    annotation(Evaluate=true, Dialog(group="Enable"));

  parameter Modelica.SIunits.Temperature TOutDelta = 2 * (5/9) - 32 * (5/9) + 273.15
    "Recorded outdoor air temperature cooling threshold hysteresis delta"
    annotation(Evaluate=true, Dialog(group="Enable"));

  parameter Real FanFeeCut = 15/100
    "Recorded fan feedback threshold"
    annotation(Evaluate=true, Dialog(group="Enable"));

  parameter Real FanFeeDelta = 10/100
    "Recorded fan feedback threshold hysteresis delta"
    annotation(Evaluate=true, Dialog(group="Enable"));

  parameter Modelica.SIunits.Temperature TSupHighLim = 50 * (5/9) - 32 * (5/9) + 273.15
    "Recorded minimum supply air temperature for defining the upper limit of the valve position"
    annotation(Evaluate=true, Dialog(group="Controller"));

  parameter Modelica.SIunits.Temperature TSupHigLim = 42 * (5/9) - 32 * (5/9) + 273.15
    "Recorded maximum supply air temperature for defining the upper limit of the valve position"
    annotation(Evaluate=true, Dialog(group="Controller"));

  parameter Modelica.SIunits.Time interval(min = 1) = 15
    "Recorded interval at which integration part of the output gets updated"
    annotation(Evaluate=true, Dialog(group="Controller"));

  parameter Boolean reverseActing=false "Controller reverse action"
    annotation(Evaluate=true, Dialog(tab="Advanced", group="Controller"));

  parameter Real k(final unit="1/K") = alc_prop_k * alc_k_unit_conv
    "Proportional controller gain"
    annotation(Evaluate=true, Dialog(tab="Advanced", group="Controller"));

  parameter Real Ti(final unit="s") = k*interval/(alc_int_k * alc_k_unit_conv)
    "Integral controller gain"
    annotation(Evaluate=true, Dialog(tab="Advanced", group="Controller"));

  parameter Real uMax(
    final min=0,
    final max=1,
    final unit="1") = 1
    "Maximum controller signal"
    annotation(Evaluate=true, Dialog(tab="Advanced", group="Controller"));

  parameter Real uMin(
    final min=0,
    final max=1,
    final unit="1") = 0
    "Minimum controller signal"
    annotation(Evaluate=true, Dialog(tab="Advanced", group="Controller"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uFanSta
    "Optional additional status signal"
    annotation (Placement(transformation(extent={{-160,-120},{-120,-80}}),
    iconTransformation(extent={{-120,-90},{-100,-70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uFanFee "Supply fan feedback"
    annotation (Placement(transformation(extent={{-160,-80},{-120,-40}}),
        iconTransformation(extent={{-120,-50},{-100,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    final quantity = "ThermodynamicTemperature")
    "Measured supply air temperature (SAT)"
    annotation (Placement(transformation(extent={{-160,20},{-120,60}}),
      iconTransformation(extent={{-120,70},{-100,90}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupSet(
    final unit="K",
    final quantity = "ThermodynamicTemperature") "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-160,70},{-120,110}}),
      iconTransformation(extent={{-120,30},{-100,50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    final quantity = "ThermodynamicTemperature")
    "Measured outdoor air temperature"
    annotation (Placement(transformation(extent={{-160,-40},{-120,0}}),
      iconTransformation(extent={{-120,-10},{-100,10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCooVal(
    final min=0,
    final max=1,
    final unit="1") "Cooling valve control signal"
    annotation (Placement(transformation(extent={{120,-10},{140,10}}),
      iconTransformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset limPI(
    final reverseActing=reverseActing,
    final k=k,
    final Ti = Ti,
    final yMax=1,
    final yMin=0,
    final y_reset=0)
    "Custom PI controller"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));

  Buildings.Controls.OBC.CDL.Continuous.Line higLim(
    final limitBelow=true,
    final limitAbove=true)
    "Defines lower limit of the cooling valve signal at low range SATs"
    annotation (Placement(transformation(extent={{80,-30},{100,-10}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yCooValMin(
    final k=uMin)
    "Minimal control loop signal limit when supply air temperature is at a defined high limit"
    annotation (Placement(transformation(extent={{0,-100},{20,-80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yCooValMax(
    final k=uMax)
    "Minimal control loop signal limit when supply air temperature is at a defined low limit"
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis TOutThr(
    final uLow = TOutCooCut - TOutDelta,
    final uHigh = TOutCooCut)
    "Determines whether the outdoor air temperature is below a treashold"
    annotation (Placement(transformation(extent={{-110,-30},{-90,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis uFanFeeThr(
    final uLow=FanFeeCut - FanFeeDelta,
    final uHigh= FanFeeCut)
    "Checks if the fan status is above a threshold"
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSupMin(
    final k=TSupHigLim)
    "Low range supply air temperature low limit"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSupMax(
    final k=TSupHighLim)
    "Low range supply air temperature high limit"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));

  Buildings.Controls.OBC.CDL.Logical.And3 andIntErr
    "Outputs controller enable signal"
    annotation (Placement(transformation(extent={{-70,-70},{-50,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.Min min
    "Switches the signal between controller and low range limiter signals"
    annotation (Placement(transformation(extent={{80,20},{100,40}})));

  Buildings.Controls.OBC.CDL.Logical.Change cha
    "Detect signal change"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Product pro
    annotation (Placement(transformation(extent={{40,74},{60,94}})));

equation
  connect(TOut, TOutThr.u)
    annotation (Line(points={{-140,-20},{-112,-20}}, color={0,0,127}));
  connect(TOutThr.y, andIntErr.u1)
    annotation (Line(points={{-88,-20},{-86,-20},{-86,-52},{-72,-52}}, color={255,0,255}));
  connect(TSup, higLim.u)
    annotation (Line(points={{-140,40},{20,40},{20,-20},{78,-20}}, color={0,0,127}));
  connect(yCooVal,min. y)
    annotation (Line(points={{130,0},{114,0},{114,30},{102,30}},color={0,0,127}));
  connect(TSupMax.y, higLim.x2)
    annotation (Line(points={{62,-50},{64,-50},{64,-24},{68,-24},{68,-24},{78,-24}},
    color={0,0,127}));
  connect(yCooValMax.y, higLim.f2)
    annotation (Line(points={{62,-90},{70,-90},{70,-28},{78,-28}}, color={0,0,127}));
  connect(higLim.y,min. u2)
    annotation (Line(points={{102,-20},{106,-20},{106,0},{70,0},{70,24},{78,24}}, color={0,0,127}));
  connect(TSupSet, limPI.u_s)
    annotation (Line(points={{-140,90},{-92,90},{-92,90},{-42,90}}, color={0,0,127}));
  connect(TSup, limPI.u_m)
    annotation (Line(points={{-140,40},{-30,40},{-30,78}}, color={0,0,127}));
  connect(andIntErr.u2, uFanFeeThr.y)
    annotation (Line(points={{-72,-60},{-88,-60}}, color={255,0,255}));
  connect(uFanFee, uFanFeeThr.u)
    annotation (Line(points={{-140,-60},{-112,-60}}, color={0,0,127}));
  connect(andIntErr.y, cha.u)
    annotation (Line(points={{-48,-60},{-42,-60}}, color={255,0,255}));
  connect(cha.y, limPI.trigger)
    annotation (Line(points={{-18,-60},{-16,-60},{-16,20},{-36,20},{-36,78}},
                                      color={255,0,255}));
  connect(TSupMin.y, higLim.x1)
    annotation (Line(points={{22,-50},{26,-50},{26,-12},{78,-12}},color={0,0,127}));
  connect(yCooValMin.y, higLim.f1)
    annotation (Line(points={{22,-90},{30,-90},{30,-16},{78,-16}},
    color={0,0,127}));
  connect(uFanSta, andIntErr.u3) annotation (Line(points={{-140,-100},{-82,-100},
          {-82,-68},{-72,-68}}, color={255,0,255}));
  connect(andIntErr.y, booToRea.u) annotation (Line(points={{-48,-60},{-46,-60},
          {-46,-20},{-42,-20}},color={255,0,255}));
  connect(limPI.y, pro.u1) annotation (Line(points={{-18,90},{38,90}},
                color={0,0,127}));
  connect(booToRea.y, pro.u2) annotation (Line(points={{-18,-20},{0,-20},{0,78},
          {38,78}},color={0,0,127}));
  connect(min.u1, pro.y)
    annotation (Line(points={{78,36},{72,36},{72,84},{62,84}},color={0,0,127}));
  annotation (
    defaultComponentName = "cooVal",
    Icon(graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{20,58}}, color={28,108,200}),
        Text(
          extent={{-108,138},{102,110}},
          lineColor={0,0,127},
          textString="%name"),
        Text(
          extent={{-64,-132},{60,-18}},
          lineColor={0,0,127},
          textString="Cooling coil valve")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,
            120}}), graphics={
        Rectangle(
          extent={{-10,120},{120,-120}},
          lineColor={217,217,217},
          fillColor={217,217,217},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{80,-102},{120,-110}},
          lineColor={0,0,127},
          textString="Limiter for
low TSup"),
        Rectangle(
          extent={{-120,0},{-12,-120}},
          lineColor={217,217,217},
          fillColor={217,217,217},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-48,-106},{-20,-112}},
          lineColor={0,0,127},
          textString="Enbale/Disable"),
        Rectangle(
          extent={{-120,120},{-12,2}},
          lineColor={217,217,217},
          fillColor={217,217,217},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-112,12},{-92,6}},
          lineColor={0,0,127},
          textString="Controller")}),
    Documentation(info="<html>
<p>
Control sequence that outputs the cooling coil valve position. The implementation is according to
the ALC EIKON control sequence implementation in one of LBNL buildings.
</p>
</html>", revisions="<html>
<ul>
<li>
April 09, 2018, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end CoolingCoilValve;
