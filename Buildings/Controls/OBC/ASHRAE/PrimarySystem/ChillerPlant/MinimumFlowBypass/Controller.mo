within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass;
block Controller
  "Controller for chilled water minimum flow bypass valve"

  parameter Integer nSta = 3
    "Total number of stages, zero stage should be seem as one stage";
  parameter Modelica.SIunits.Time byPasSetTim = 300
    "Time to reset minimum by-pass flow";
  parameter Modelica.SIunits.VolumeFlowRate minFloSet[nSta] = {0, 0.0089, 0.0177}
    "Minimum flow rate at each chiller stage";
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PID
    "Type of controller"
    annotation (Dialog(group="Controller"));
  parameter Real k=1 "Gain of controller"
    annotation (Dialog(group="Controller"));
  parameter Modelica.SIunits.Time Ti=0.5 "Time constant of integrator block"
    annotation (Dialog(group="Controller"));
  parameter Modelica.SIunits.Time Td=0.1 "Time constant of derivative block"
    annotation (Dialog(group="Controller"));
  parameter Real yMax=1 "Upper limit of output"
    annotation (Dialog(group="Controller"));
  parameter Real yMin=0.1 "Lower limit of output"
    annotation (Dialog(group="Controller"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiWatPum
    "Indicate if there is any chilled water pump is proven on: true=ON, false=OFF"
    annotation (Placement(transformation(extent={{-140,50},{-100,90}}),
      iconTransformation(extent={{-120,80},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VBypas_flow(
    final min=0,
    final unit="m3/s",
    quantity="VolumeFlowRate") "Measured bypass flow rate"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
      iconTransformation(extent={{-120,60},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaUp "Indicate if there is stage up"
    annotation (Placement(transformation(extent={{-140,-10},{-100,30}}),
      iconTransformation(extent={{-120,30},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uUpsDevSta
    "Status of resetting status of device before reset minimum bypass flow setpoint"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}}),
      iconTransformation(extent={{-120,0},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uSta "Current stage index"
    annotation (Placement(transformation(extent={{-140,-70},{-100,-30}}),
      iconTransformation(extent={{-120,-20},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOnOff
    "Indicate if the stage require one chiller to be enabled while another is disabled"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
      iconTransformation(extent={{-120,-50},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEnaNexChi
    "Status to indicate that it starts to enable another chiller. This input used when the stage change needs chiller on/off"
    annotation (Placement(transformation(extent={{-140,-130},{-100,-90}}),
      iconTransformation(extent={{-120,-70},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaDow
    "Indicate if there is stage down"
    annotation (Placement(transformation(extent={{-140,-160},{-100,-120}}),
      iconTransformation(extent={{-120,-100},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValPos(
    final min=0,
    final max=1,
    final unit="1") "Chilled water minimum flow bypass valve position"
    annotation (Placement(transformation(extent={{100,120},{120,140}}),
      iconTransformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.CDL.Continuous.LimPID valPos(
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final yMax=yMax,
    final yMin=yMin,
    final reset=Buildings.Controls.OBC.CDL.Types.Reset.Parameter,
    final y_reset=1) "By pass valve position"
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.Subsequences.FlowSetpoint minBypSet(
    final nSta=nSta,
    final byPasSetTim=byPasSetTim,
    final minFloSet=minFloSet) "Minimum by-pass flow setpoint"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minFlo[nSta](
    final k=minFloSet)
    "Minimum bypass flow rate at each stage"
    annotation (Placement(transformation(extent={{-20,-110},{0,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax multiMax(final nin=nSta)
    annotation (Placement(transformation(extent={{20,-110},{40,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Division div
    "Normalized minimum flow setpoint"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Division div1
    "Normalized minimum bypass flow "
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi "Logical switch"
    annotation (Placement(transformation(extent={{40,120},{60,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant opeVal(k=1) "Valve open"
    annotation (Placement(transformation(extent={{-40,90},{-20,110}})));

equation
  connect(uStaUp, minBypSet.uStaUp)
    annotation (Line(points={{-120,10},{-40,10},{-40,-40},{-22,-40}},
      color={255,0,255}));
  connect(uSta, minBypSet.uSta)
    annotation (Line(points={{-120,-50},{-60,-50},{-60,-48},{-22,-48}},
      color={255,127,0}));
  connect(uOnOff, minBypSet.uOnOff)
    annotation (Line(points={{-120,-80},{-60,-80},{-60,-52},{-22,-52}},
      color={255,0,255}));
  connect(uStaDow, minBypSet.uStaDow)
    annotation (Line(points={{-120,-140},{-40,-140},{-40,-60},{-22,-60}},
      color={255,0,255}));
  connect(minBypSet.uUpsDevSta, uUpsDevSta)
    annotation (Line(points={{-22,-44},{-60,-44},{-60,-20},{-120,-20}},
      color={255,0,255}));
  connect(minBypSet.uEnaNexChi, uEnaNexChi)
    annotation (Line(points={{-22,-56},{-50,-56},{-50,-110},{-120,-110}},
      color={255,0,255}));
  connect(uChiWatPum, valPos.trigger)
    annotation (Line(points={{-120,70},{42,70},{42,78}}, color={255,0,255}));
  connect(minFlo.y, multiMax.u)
    annotation (Line(points={{1,-100},{18,-100}}, color={0,0,127}));
  connect(VBypas_flow, div1.u1)
    annotation (Line(points={{-120,40},{8,40},{8,46},{18,46}}, color={0,0,127}));
  connect(minBypSet.yChiWatBypSet, div.u1)
    annotation (Line(points={{1,-50},{12,-50},{12,-44},{18,-44}}, color={0,0,127}));
  connect(multiMax.y, div1.u2)
    annotation (Line(points={{41,-100},{60,-100},{60,-70},{8,-70},{8,34},{18,34}},
      color={0,0,127}));
  connect(multiMax.y, div.u2)
    annotation (Line(points={{41,-100},{60,-100},{60,-70},{8,-70},{8,-56},{18,-56}},
      color={0,0,127}));
  connect(div1.y, valPos.u_m)
    annotation (Line(points={{41,40},{50,40},{50,78}},  color={0,0,127}));
  connect(div.y, valPos.u_s)
    annotation (Line(points={{41,-50},{60,-50},{60,10},{0,10},{0,90},{38,90}},
      color={0,0,127}));
  connect(uChiWatPum, swi.u2)
    annotation (Line(points={{-120,70},{-60,70},{-60,130},{38,130}}, color={255,0,255}));
  connect(valPos.y, swi.u1)
    annotation (Line(points={{61,90},{80,90},{80,110},{20,110},{20,138},
      {38,138}}, color={0,0,127}));
  connect(opeVal.y, swi.u3)
    annotation (Line(points={{-19,100},{0,100},{0,122},{38,122}}, color={0,0,127}));
  connect(swi.y, yValPos)
    annotation (Line(points={{61,130},{110,130}}, color={0,0,127}));

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
          extent={{-80,60},{82,-60}},
          lineColor={28,108,200},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Polygon(
          points={{-80,60},{-14,4},{-80,-60},{-80,60}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid)}),
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-160},{100,160}})),
  Documentation(info="<html>
<p>
Block that controls chilled water minimum flow bypass valve for primary-only
plants with a minimum flow bypass valve, 
according to ASHRAE RP-1711 Advanced Sequences of Operation for HVAC Systems Phase II –
Central Plants and Hydronic Systems (Draft 4 on January 7, 2019), 
section 5.2.8 Chilled water minimum flow bypass valve.
</p>
<p>
The minimum bypass flow setpoint is specified by block 
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.Subsequences.FlowSetpoint\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.Subsequences.FlowSetpoint</a>.
</p>

<p>
When any chilled water pump is proven on (<code>uChiWatPum</code> = true), 
the bypass valve PID loop shall be enabled. The valve shall be opened otherwise.
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
