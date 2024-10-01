within Buildings.Fluid.Storage.Ice_nturef.BaseClasses;
model NormalizedHeatFlowRate
  "Charging or discharging rate based on the curves"
  extends Modelica.Blocks.Icons.Block;

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
  Modelica.Blocks.Interfaces.RealInput SOC "State of charge"
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
  Modelica.Blocks.Math.Add SOCCom(final k2=-1) "1 - SOC"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Modelica.Blocks.Sources.Constant const(k=1) "Constant output of 1"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));

  Buildings.Fluid.Storage.Ice_nturef.BaseClasses.QStar qStaCha(final coeff=
        coeCha, final dt=dtCha) "q* for charing mode"
    annotation (Placement(transformation(extent={{20,-16},{40,4}})));
  Buildings.Fluid.Storage.Ice_nturef.BaseClasses.QStar qStaDisCha(final coeff=
        coeDisCha, final dt=dtDisCha) "q* for discharging mode"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract qSta
    "Effective normalized heat flow rate"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

equation
  connect(qStaCha.lmtdSta, lmtdSta) annotation (Line(points={{18,-12},{0,-12},{
          0,-60},{-120,-60}},   color={0,0,127}));
  connect(lmtdSta, qStaDisCha.lmtdSta) annotation (Line(points={{-120,-60},{0,
          -60},{0,64},{18,64}},      color={0,0,127}));
  connect(SOC, qStaCha.x) annotation (Line(points={{-120,0},{-60,0},{-60,-6},{
          18,-6}}, color={0,0,127}));
  connect(qStaCha.active, canFreeze) annotation (Line(points={{18,0},{-56,0},{
          -56,40},{-120,40}},  color={255,0,255}));
  connect(qStaDisCha.active, canMelt) annotation (Line(points={{18,76},{-96,76},
          {-96,80},{-120,80}}, color={255,0,255}));
  connect(qNor, qSta.y)
    annotation (Line(points={{110,0},{82,0}}, color={0,0,127}));
  connect(SOCCom.u2, SOC) annotation (Line(points={{-42,24},{-60,24},{-60,0},{-120,
          0}}, color={0,0,127}));
  connect(const.y, SOCCom.u1) annotation (Line(points={{-59,60},{-50,60},{-50,36},
          {-42,36}}, color={0,0,127}));
  connect(qStaDisCha.x, SOCCom.y) annotation (Line(points={{18,70},{-10,70},{
          -10,30},{-19,30}}, color={0,0,127}));
  connect(qStaCha.qNor, qSta.u1)
    annotation (Line(points={{41,-6},{48,-6},{48,6},{58,6}}, color={0,0,127}));
  connect(qStaDisCha.qNor, qSta.u2) annotation (Line(points={{41,70},{52,70},{52,
          -6},{58,-6}}, color={0,0,127}));
  annotation (defaultComponentName = "norQSta",
  Icon(coordinateSystem(preserveAspectRatio=false),
    graphics={Text(textColor = {0, 0, 88}, extent = {{-32, 62}, {58, -34}}, textString = "q*")}),
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
using <a href=\"modelica://Buildings.Fluid.Storage.Ice.BaseClasses.QStar\">Buildings.Fluid.Storage.Ice.BaseClasses.QStar</a>
with coefficients for discharing mode.
</li>
<li>If <code>canFreeze = true</code>: the heat transfer rate is the charging rate calculated
using <a href=\"modelica://Buildings.Fluid.Storage.Ice.BaseClasses.QStar\">Buildings.Fluid.Storage.Ice.BaseClasses.QStar</a>
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
end NormalizedHeatFlowRate;
