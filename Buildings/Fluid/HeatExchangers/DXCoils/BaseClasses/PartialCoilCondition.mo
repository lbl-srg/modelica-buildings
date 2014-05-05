within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses;
partial block PartialCoilCondition
  "Partial block for dry and wet coil conditions"
  extends
    Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialCoilInterface;

  constant Boolean variableSpeedCoil
    "Flag, set to true for coil with variable speed";

  Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.CoolingCapacity cooCap(
    final sta=datCoi.sta,
    final nSta=datCoi.nSta,
    final m_flow_small=datCoi.m_flow_small) "Performance data"
    annotation (Placement(transformation(extent={{-14,40},{6,60}})));

protected
  SpeedShift speShiEIR(
    final variableSpeedCoil=variableSpeedCoil,
    final nSta=nSta,
    final speSet=datCoi.sta.spe) "Interpolates EIR"
    annotation (Placement(transformation(extent={{32,64},{46,78}})));
  SpeedShift speShiQ_flow(
    final variableSpeedCoil=variableSpeedCoil,
    final nSta=nSta,
    final speSet=datCoi.sta.spe) "Interpolates Q_flow"
    annotation (Placement(transformation(extent={{32,44},{46,58}})));
equation

  connect(cooCap.EIR, speShiEIR.u)
                                  annotation (Line(
      points={{7,54},{10,54},{10,65.4},{30.6,65.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cooCap.Q_flow, speShiQ_flow.u)
                                        annotation (Line(
      points={{7,46},{12,46},{12,45.4},{30.6,45.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speShiEIR.y, EIR)
                           annotation (Line(
      points={{46.7,71},{60.5,71},{60.5,80},{110,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRat, speShiEIR.speRat)
                                   annotation (Line(
      points={{-110,76},{14,76},{14,71},{30.6,71}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRat, speShiQ_flow.speRat)
                                      annotation (Line(
      points={{-110,76},{14,76},{14,51},{30.6,51}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speShiQ_flow.y, Q_flow)
                                 annotation (Line(
      points={{46.7,51},{60,51},{60,40},{110,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(stage, speShiQ_flow.stage) annotation (Line(
      points={{-110,100},{20,100},{20,56.6},{30.6,56.6}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(speShiEIR.stage, stage) annotation (Line(
      points={{30.6,76.6},{20,76.6},{20,100},{-110,100}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(cooCap.m_flow, m_flow) annotation (Line(
      points={{-15,50},{-92,50},{-92,24},{-110,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cooCap.TConIn, TConIn) annotation (Line(
      points={{-15,54.8},{-96,54.8},{-96,54},{-96,54},{-96,50},{-110,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cooCap.stage, stage) annotation (Line(
      points={{-15,60},{-60,60},{-60,100},{-110,100}},
      color={255,127,0},
      smooth=Smooth.None));
  annotation ( Documentation(info="<html>
<p>
This partial block is the base class for
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DryCoil\">
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DryCoil</a> and
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.WetCoil\">
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.WetCoil</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
August 1, 2012 by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialCoilCondition;
