within Buildings.DHC.Loads.HotWater.BaseClasses;
block HeatExchangerPumpController
  "Controller for pump of storage tank with external heat exchanger"
  parameter Modelica.Units.SI.MassFlowRate mDom_flow_nominal
    "Domestic hot water design flow rate (used for scaling)";
  parameter Modelica.Units.SI.PressureDifference dpPum_nominal(
    displayUnit="Pa",
    min=0)
    "Heating water pump head at full speed through heat exchanger";

  parameter Real k=0.1 "Proportioanl gain of circulation pump controller";
  parameter Real Ti=60 "Integrator time constant of circulation pump controller";
  parameter Real yMin(min=0) = 0.3 "Minimum controller output when pump is on";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput mDom_flow(
    final unit="kg/s")
    "Domestic hot water mass flow rate" annotation (Placement(transformation(
          extent={{-140,40},{-100,80}}), iconTransformation(extent={{-140,40},{-100,
            80}})));
  Modelica.Blocks.Interfaces.RealInput TDomSet(
    final unit="K",
    displayUnit="degC")
    "Temperature setpoint for domestic hot water source from heater"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));
  Modelica.Blocks.Interfaces.RealInput TDom(
    final unit="K",
    displayUnit="degC")
    "Measured hot water temperature" annotation (Placement(transformation(
          extent={{-140,-80},{-100,-40}}), iconTransformation(extent={{-120,-70},
            {-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dpPumHex(
    final unit="Pa",
    displayUnit="Pa")
    "Set point for pump head on heating water side"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hysMasFlo(
    uLow=mDom_flow_nominal/1E4,
    uHigh=2*mDom_flow_nominal/1E4,
    y(start=false))
    "Hysteresis used to switch secondary pump on and off"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));

  Buildings.Controls.OBC.CDL.Reals.PIDWithReset conPI(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    k=k,
    Ti=Ti,
    yMin=0.03,
    y_reset=0)
    "PI controller for pump"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swi "Switch for pump control"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

protected
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter pumHea(final k=dpPum_nominal)
    "Gain for hex pump head"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(final k=0) "Outputs zero"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
equation
  connect(conPI.y, pumHea.u)
    annotation (Line(points={{-18,0},{-2,0}}, color={0,0,127}));
  connect(hysMasFlo.y,conPI. trigger) annotation (Line(points={{-58,60},{-50,60},
          {-50,-26},{-36,-26},{-36,-12}},
                                color={255,0,255}));
  connect(hysMasFlo.u, mDom_flow) annotation (Line(points={{-82,60},{-102,60},{-102,
          60},{-120,60}}, color={0,0,127}));
  connect(pumHea.y, swi.u1)
    annotation (Line(points={{22,0},{40,0},{40,8},{58,8}}, color={0,0,127}));
  connect(con.y, swi.u3) annotation (Line(points={{42,-30},{50,-30},{50,-8},{58,
          -8}}, color={0,0,127}));
  connect(hysMasFlo.y, swi.u2) annotation (Line(points={{-58,60},{50,60},{50,0},
          {58,0}}, color={255,0,255}));
  connect(swi.y, dpPumHex)
    annotation (Line(points={{82,0},{120,0}}, color={0,0,127}));
  connect(TDomSet, conPI.u_s)
    annotation (Line(points={{-120,0},{-42,0}}, color={0,0,127}));
  connect(TDom, conPI.u_m) annotation (Line(points={{-120,-60},{-30,-60},{-30,-12}},
        color={0,0,127}));
  annotation (
    defaultComponentName="conPum",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          textColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name"),
        Text(
          extent={{-94,78},{-44,42}},
          textColor={0,0,127},
          textString="mDom_flow"),
        Text(
          extent={{-94,20},{-44,-16}},
          textColor={0,0,127},
          textString="TDomSet"),
        Text(
          extent={{-94,-42},{-44,-78}},
          textColor={0,0,127},
          textString="TDom"),
        Text(
          extent={{40,20},{90,-16}},
          textColor={0,0,127},
          textString="mHexSet_flow")}),
       Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
Controller for heat exchanger mass flow rate.
</p>
<p>
This controller outputs the set point for the head of the heat exchanger pump
on the heating side. The set point is calculated using a PI controller that tracks
the set point for the leaving domestic hot water temperature,
with a minimum controller output equal to <code>yMin</code>.
By default, <code>yMin=0.3</code>, which corresponds to a mass flow rate
of <i>10%</i> of the design flow rate.
</p>
<p>
If the measured domestic hot water flow rate is close to zero, then the
set point for the pump is also set to zero in order to stop the pump if there is no
domestic hot water flow rate.
</p>
</html>", revisions="<html>
<ul>
<li>
October 4, 2023, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end HeatExchangerPumpController;
