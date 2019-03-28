within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass;
block Controller
  "Controller for chilled water minimum flow bypass valve"

  parameter Integer nSta = 3
    "Total number of stages, zero stage should be seem as one stage";
  parameter Modelica.SIunits.Time byPasSetTim = 300
    "Time to reset minimum by-pass flow";
  parameter Modelica.SIunits.VolumeFlowRate minFloSet[nSta] = {0, 0.0089, 0.0177}
    "Minimum flow rate at each chiller stage";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiWatPum
    "Indicate if there is any chilled water pump is proven on: true=ON, false=OFF"
    annotation (Placement(transformation(extent={{-140,80},{-100,120}}),
      iconTransformation(extent={{-120,80},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VBypas_flow(
    final min=0,
    final unit="m3/s",
    quantity="VolumeFlowRate") "Measured bypass flow rate"
    annotation (Placement(transformation(extent={{-140,50},{-100,90}}),
      iconTransformation(extent={{-120,60},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaUp "Indicate if there is stage up"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
      iconTransformation(extent={{-120,30},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uUpsDevSta
    "Status of resetting status of device before reset minimum bypass flow setpoint"
    annotation (Placement(transformation(extent={{-140,-10},{-100,30}}),
      iconTransformation(extent={{-120,0},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uSta "Current stage index"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}}),
      iconTransformation(extent={{-120,-20},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOnOff
    "Indicate if the stage require one chiller to be enabled while another is disabled"
    annotation (Placement(transformation(extent={{-140,-70},{-100,-30}}),
      iconTransformation(extent={{-120,-50},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEnaNexChi
    "Status to indicate that it starts to enable another chiller. This input used when the stage change needs chiller on/off"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
      iconTransformation(extent={{-120,-70},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaDow
    "Indicate if there is stage down"
    annotation (Placement(transformation(extent={{-140,-130},{-100,-90}}),
      iconTransformation(extent={{-120,-100},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValPos
    "Chilled water minimum flow bypass valve position"
    annotation (Placement(transformation(extent={{100,70},{120,90}}),
      iconTransformation(extent={{100,-10},{120,10}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.LimPID valPos(
    final yMax=1,
    final yMin=0,
    final reset=Buildings.Controls.OBC.CDL.Types.Reset.Parameter,
    final y_reset=1) "By pass valve position"
    annotation (Placement(transformation(extent={{40,110},{60,130}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.Subsequences.FlowSetpoint minBypSet(
    final nSta=nSta,
    final byPasSetTim=byPasSetTim,
    final minFloSet=minFloSet) "Minimum by-pass flow setpoint"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));

equation
  connect(uChiWatPum, not1.u)
    annotation (Line(points={{-120,100},{-62,100}}, color={255,0,255}));
  connect(VBypas_flow, valPos.u_m)
    annotation (Line(points={{-120,70},{50,70},{50,108}},color={0,0,127}));
  connect(valPos.y, yValPos)
    annotation (Line(points={{61,120},{86,120},{86,80},{110,80}},
      color={0,0,127}));
  connect(minBypSet.yChiWatBypSet, valPos.u_s)
    annotation (Line(points={{1,-20},{20,-20},{20,120},{38,120}},
      color={0,0,127}));
  connect(uStaUp, minBypSet.uStaUp)
    annotation (Line(points={{-120,40},{-40,40},{-40,-10},{-22,-10}},
      color={255,0,255}));
  connect(uSta, minBypSet.uSta)
    annotation (Line(points={{-120,-20},{-60,-20},{-60,-18},{-22,-18}},
      color={255,127,0}));
  connect(uOnOff, minBypSet.uOnOff)
    annotation (Line(points={{-120,-50},{-60,-50},{-60,-22},{-22,-22}},
      color={255,0,255}));
  connect(uStaDow, minBypSet.uStaDow)
    annotation (Line(points={{-120,-110},{-40,-110},{-40,-30},{-22,-30}},
      color={255,0,255}));
  connect(not1.y, valPos.trigger)
    annotation (Line(points={{-39,100},{42,100},{42,108}},
      color={255,0,255}));
  connect(minBypSet.uUpsDevSta, uUpsDevSta)
    annotation (Line(points={{-22,-14},{-60,-14},{-60,10},{-120,10}},
      color={255,0,255}));
  connect(minBypSet.uEnaNexChi, uEnaNexChi)
    annotation (Line(points={{-22,-26},{-50,-26},{-50,-80},{-120,-80}},
      color={255,0,255}));

annotation (
  defaultComponentName="minBypValCon",
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
       graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name")}),
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-140},{100,140}})),
  Documentation(info="<html>
<p>
Block that controls chilled water minimum flow bypass valve for primary-only
plants with a minimum flow bypass valve, 
according to ASHRAE RP-1711 Advanced Sequences of Operation for HVAC Systems Phase II –
Central Plants and Hydronic Systems (Draft 4 on January 7, 2019), 
section 5.2.8 Chilled water minimum flow bypass valve.
</p>
<p>
1. Bypass valve shall modulate to maintain minimum flow <code>VBypas_flow</code>
at a setpoint equal to the sum of the minimum chilled water flowrate of the chillers
commanded on run in each stage.
</p>
<table summary=\"summary\" border=\"1\">
<tr>
<th> Chiller stage </th> 
<th> Minimum flow </th>  
</tr>
<tr>
<td align=\"center\">0</td>
<td align=\"center\">0</td>
</tr>
<tr>
<td align=\"center\">1</td>
<td align=\"center\"><code>minFloSet</code>[1]</td>
</tr>
<tr>
<td align=\"center\">2</td>
<td align=\"center\"><code>minFloSet</code>[2]</td>
</tr>
<tr>
<td align=\"center\">...</td>
<td align=\"center\">...</td>
</tr>
</table>
<br/>

<p>
2. If there is any stage change requiring a chiller on and another chiller off,
the minimum flow setpoint shall temporarily change to include the minimum 
chilled water flowrate of both enabling chiller and disabled chiller prior
to starting the newly enabled chiller.
</p>
<p>
3. When any chilled water pump is proven on (<code>uChiWatPum</code> = true), 
the bypass valve PID loop shall be enabled. The valve shall be opened otherwise.
When enabled, the bypass valve loop shall be biased to start with the valve
100% open.
</p>
<p>
Note that when there is stage change thus requires changes of 
minimum bypass flow setpoint, the change should be slowly.
For example, this could be accomplished by resetting the setpoint X GPM/second, 
where X = (NewSetpoint - OldSetpoint) / <code>byPasSetTim</code>.
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
