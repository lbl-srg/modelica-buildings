within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass;
block Controller
  "Controller for chilled water minimum flow bypass valve"

  parameter Integer nChi "Total number of chillers";
  parameter Boolean isParallelChiller
    "Flag: true means that the plant has parallel chillers";
  parameter Real byPasSetTim(
    final unit="s",
    final quantity="Time")
    "Time constant for resetting minimum bypass flow";
  parameter Modelica.SIunits.VolumeFlowRate minFloSet[nChi]
    "Minimum chilled water flow through each chiller";
  parameter Modelica.SIunits.VolumeFlowRate maxFloSet[nChi]
    "Maximum chilled water flow through each chiller";
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(group="Controller"));
  parameter Real k=1 "Gain of controller"
    annotation (Dialog(group="Controller"));
  parameter Real Ti(
    final unit="s",
    final quantity="Time")=0.5 "Time constant of integrator block"
    annotation (Dialog(group="Controller", enable=controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
                                                  controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real Td(
    final unit="s",
    final quantity="Time")=0 "Time constant of derivative block"
    annotation (Dialog(group="Controller", enable=controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
                                                  controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real yMax=1 "Upper limit of output"
    annotation (Dialog(group="Controller"));
  parameter Real yMin=0.1 "Lower limit of output"
    annotation (Dialog(group="Controller"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiWatPum
    "Maximum status feedback of all the chilled water pumps: true means at least one pump is proven on"
    annotation (Placement(transformation(extent={{-140,110},{-100,150}}),
      iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWat_flow(
    final min=0,
    final unit="m3/s",
    quantity="VolumeFlowRate")
    "Measured chilled water flow rate through chillers"
    annotation (Placement(transformation(extent={{-140,70},{-100,110}}),
      iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaUp "Stage up logical signal"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
      iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uUpsDevSta
    "True only when the plant is in the chiller staging process and the upstream steps have finished"
    annotation (Placement(transformation(extent={{-140,10},{-100,50}}),
      iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uSubCha
    "Status to indicate that it starts to enable another chiller. This input is used when the stage change needs chiller on/off"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOnOff
    "Indicate if the stage change requires one chiller to be enabled while another is disabled"
    annotation (Placement(transformation(extent={{-140,-50},{-100,-10}}),
      iconTransformation(extent={{-140,-30},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[nChi]
    "Chiller status: true=ON"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
      iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nexEnaChi
    "Index of next chiller to be enabled"
    annotation (Placement(transformation(extent={{-140,-110},{-100,-70}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nexDisChi
    "Index of next chiller to be disabled"
    annotation (Placement(transformation(extent={{-140,-140},{-100,-100}}),
      iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaDow "Stage down logical signal"
    annotation (Placement(transformation(extent={{-140,-170},{-100,-130}}),
      iconTransformation(extent={{-140,-110},{-100,-70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValPos(
    final min=0,
    final max=1,
    final unit="1") "Chilled water minimum flow bypass valve position"
    annotation (Placement(transformation(extent={{100,110},{140,150}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Continuous.LimPID valPos(
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final yMax=yMax,
    final yMin=yMin,
    final reset=Buildings.Controls.OBC.CDL.Types.Reset.Parameter,
    final y_reset=1)  "By pass valve position PI controller"
    annotation (Placement(transformation(extent={{40,70},{60,90}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.Subsequences.FlowSetpoint minBypSet(
    final nChi=nChi,
    final isParallelChiller=isParallelChiller,
    final byPasSetTim=byPasSetTim,
    final minFloSet=minFloSet,
    final maxFloSet=maxFloSet)  "Minimum bypass flow setpoint"
    annotation (Placement(transformation(extent={{-20,-24},{0,-4}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minFlo[nChi](
    final k=minFloSet) "Minimum bypass flow rate at each stage"
    annotation (Placement(transformation(extent={{-20,-110},{0,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(final nin=nChi)
    "Sum of minimum chilled water flow of all chillers"
    annotation (Placement(transformation(extent={{20,-110},{40,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Division div
    "Normalized minimum flow setpoint"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Division div1
    "Normalized minimum bypass flow "
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi "Logical switch"
    annotation (Placement(transformation(extent={{40,120},{60,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant opeVal(
    final k=1) "Valve open"
    annotation (Placement(transformation(extent={{-40,100},{-20,120}})));

equation
  connect(uStaUp, minBypSet.uStaUp)
    annotation (Line(points={{-120,60},{-40,60},{-40,-5},{-22,-5}},
      color={255,0,255}));
  connect(uOnOff, minBypSet.uOnOff)
    annotation (Line(points={{-120,-30},{-60,-30},{-60,-21},{-22,-21}},
      color={255,0,255}));
  connect(uStaDow, minBypSet.uStaDow)
    annotation (Line(points={{-120,-150},{-40,-150},{-40,-23},{-22,-23}},
      color={255,0,255}));
  connect(minBypSet.uUpsDevSta, uUpsDevSta)
    annotation (Line(points={{-22,-7},{-46,-7},{-46,30},{-120,30}},
      color={255,0,255}));
  connect(minFlo.y, mulSum.u)
    annotation (Line(points={{2,-100},{18,-100}}, color={0,0,127}));
  connect(VChiWat_flow, div1.u1)
    annotation (Line(points={{-120,90},{-20,90},{-20,46},{18,46}}, color={0,0,127}));
  connect(minBypSet.yChiWatMinFloSet, div.u1)
    annotation (Line(points={{2,-14},{18,-14}},  color={0,0,127}));
  connect(mulSum.y, div1.u2)
    annotation (Line(points={{42,-100},{60,-100},{60,-70},{8,-70},{8,34},{18,34}},
      color={0,0,127}));
  connect(mulSum.y, div.u2)
    annotation (Line(points={{42,-100},{60,-100},{60,-70},{8,-70},{8,-26},{18,-26}},
      color={0,0,127}));
  connect(div1.y, valPos.u_m)
    annotation (Line(points={{42,40},{50,40},{50,68}}, color={0,0,127}));
  connect(div.y, valPos.u_s)
    annotation (Line(points={{42,-20},{60,-20},{60,10},{0,10},{0,80},{38,80}},
      color={0,0,127}));
  connect(uChiWatPum, swi.u2)
    annotation (Line(points={{-120,130},{38,130}}, color={255,0,255}));
  connect(valPos.y, swi.u1)
    annotation (Line(points={{62,80},{80,80},{80,100},{20,100},{20,138},{38,138}},
      color={0,0,127}));
  connect(opeVal.y, swi.u3)
    annotation (Line(points={{-18,110},{0,110},{0,122},{38,122}}, color={0,0,127}));
  connect(swi.y, yValPos)
    annotation (Line(points={{62,130},{120,130}}, color={0,0,127}));
  connect(uChiWatPum, valPos.trigger)
    annotation (Line(points={{-120,130},{10,130},{10,60},{44,60},{44,68}},
      color={255,0,255}));
  connect(nexEnaChi, minBypSet.nexEnaChi)
    annotation (Line(points={{-120,-90},{-50,-90},{-50,-13},{-22,-13}},
      color={255,127,0}));
  connect(minBypSet.nexDisChi, nexDisChi)
    annotation (Line(points={{-22,-15},{-46,-15},{-46,-120},{-120,-120}},
      color={255,127,0}));
  connect(minBypSet.uChi, uChi)
    annotation (Line(points={{-22,-10},{-54,-10},{-54,-60},{-120,-60}},
      color={255,0,255}));
  connect(uSubCha, minBypSet.uSubCha)
    annotation (Line(points={{-120,0},{-60,0},{-60,-18},{-22,-18}},
      color={255,0,255}));

annotation (
  defaultComponentName="minBypValCon",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
       graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-60,40},{80,-40}},
          lineColor={28,108,200},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Polygon(
          points={{-60,40},{-20,0},{-60,-40},{-60,40}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-102,54},{-68,44}},
          lineColor={255,0,255},
          textString="uStaUp"),
        Text(
          extent={{-102,36},{-50,26}},
          lineColor={255,0,255},
          textString="uUpsDevSta"),
        Text(
          extent={{-100,-24},{-76,-34}},
          lineColor={255,0,255},
          textString="uChi"),
        Text(
          extent={{-98,-44},{-56,-56}},
          lineColor={255,127,0},
          textString="nexEnaChi"),
        Text(
          extent={{-100,-64},{-56,-74}},
          lineColor={255,127,0},
          textString="nexDisChi"),
        Text(
          extent={{-104,-4},{-66,-14}},
          lineColor={255,0,255},
          textString="uOnOff"),
        Text(
          extent={{-100,16},{-60,6}},
          lineColor={255,0,255},
          textString="uSubCha"),
        Text(
          extent={{-100,-84},{-60,-94}},
          lineColor={255,0,255},
          textString="uStaDow"),
        Text(
          extent={{-98,98},{-54,84}},
          lineColor={255,0,255},
          textString="uChiWatPum"),
        Text(
          extent={{-98,74},{-54,64}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VChiWat_flow"),
        Text(
          extent={{68,6},{102,-4}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yValPos")}),
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-160},{100,160}})),
  Documentation(info="<html>
<p>
Block that controls chilled water minimum flow for primary-only
plants with a minimum flow bypass valve,
according to ASHRAE RP-1711 Advanced Sequences of Operation for HVAC Systems Phase II –
Central Plants and Hydronic Systems (Draft 4 on March 26, 2019),
section 5.2.8 Chilled water minimum flow bypass valve.
</p>
<p>
The minimum chilled water flow setpoint is specified by block
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.Subsequences.FlowSetpoint\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.Subsequences.FlowSetpoint</a>.
</p>

<p>
When any chilled water pump is proven on (<code>uChiWatPum</code> = true),
the bypass valve PID loop shall be enabled. The valve shall be opened 100% otherwise.
When enabled, the bypass valve loop shall be biased to start with the valve
100% open.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 31, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
