within Buildings.Fluid.Storage.Ice.BaseClasses;
model StorageHeatTransferRate
  "Charging or discharging rate based on the curves"
  parameter Real coeCha[6]
    "Coefficients for charging curve";
  parameter Real dtCha "Time step of curve fitting data";

  parameter Real coeDisCha[6]
    "Coefficients for discharging curve";
  parameter Real dtDisCha "Time step of curve fitting data";

  Modelica.Blocks.Interfaces.RealOutput qNor(final quantity="1/s")
    "Normalized heat transfer rate: charging when postive, discharge when negative"
                                    annotation (Placement(transformation(extent={{100,-10},
            {120,10}}),           iconTransformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput fraCha "Fraction of charge in ice tank"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput lmtdSta "LMTD star"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));

  Modelica.Blocks.Interfaces.BooleanInput canFreeze
    "Set to true if tank can be charged"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.BooleanInput canMelt
    "Set to true if tank can be melted"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
protected
  Buildings.Fluid.Storage.Ice.BaseClasses.QStarCharging qStaCha(
    final coeff=coeCha,
    final dt=dtCha)
    "q* for charing mode"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Fluid.Storage.Ice.BaseClasses.QStarDischarging qStaDisCha(
    final coeff=coeDisCha,
    final dt=dtDisCha) "q* for discharging mode"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Add qSta "Effective normalized heat flow rate"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
equation
  connect(qStaCha.lmtdSta, lmtdSta) annotation (Line(points={{-42,26},{-60,26},{
          -60,-60},{-120,-60}}, color={0,0,127}));
  connect(lmtdSta, qStaDisCha.lmtdSta) annotation (Line(points={{-120,-60},{-60,
          -60},{-60,66},{-42,66}},   color={0,0,127}));
  connect(fraCha, qStaDisCha.fraCha) annotation (Line(points={{-120,0},{-52,0},{
          -52,74},{-42,74}},    color={0,0,127}));
  connect(fraCha, qStaCha.fraCha) annotation (Line(points={{-120,0},{-52,0},{-52,
          34},{-42,34}},   color={0,0,127}));
  connect(qStaCha.active, canFreeze) annotation (Line(points={{-42,38},{-82,38},
          {-82,40},{-120,40}}, color={255,0,255}));
  connect(qStaDisCha.active, canMelt) annotation (Line(points={{-42,78},{-82,78},
          {-82,80},{-120,80}}, color={255,0,255}));
  connect(qNor, qSta.y)
    annotation (Line(points={{110,0},{82,0}}, color={0,0,127}));
  connect(qStaCha.qNor, qSta.u2) annotation (Line(points={{-19,30},{34,30},{34,-6},
          {58,-6}}, color={0,0,127}));
  connect(qStaDisCha.qNor, qSta.u1) annotation (Line(points={{-19,70},{40,70},{40,
          6},{58,6}}, color={0,0,127}));
  annotation (defaultComponentName = "norQSta",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid), Text(
        extent={{-148,150},{152,110}},
        textString="%name",
        lineColor={0,0,255})}),
     Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This blocks calculate the normalized heat transfer rate for the ice tank in charging or discharging mode.
</p>
<p>The module use the following logic:</p>
<ul>
<li>If <code>canFreeze</code> and <code>canMelt</code> are both <code>false</code>: the heat transfer rate is 0</li>
<li>If <code>canMelt = true</code>: the heat transfer rate is the discharging rate calculated
using <a href=\"modelica://Buildings.Fluid.Storage.Ice.BaseClasses.QStarDischarging\">Buildings.Fluid.Storage.Ice.BaseClasses.QStarDischarging</a>
with coefficients for discharing mode.
</li>
<li>If <code>canFreeze = true</code>: the heat transfer rate is the charging rate calculated
using <a href=\"modelica://Buildings.Fluid.Storage.Ice.BaseClasses.QStarCharging\">Buildings.Fluid.Storage.Ice.BaseClasses.QStarCharging</a>
with coefficients for charging mode.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
January 26, 2022, by Michael Wetter:<br/>
Refactored model to new architecture.
</li>
<li>
December 8, 2021, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end StorageHeatTransferRate;
