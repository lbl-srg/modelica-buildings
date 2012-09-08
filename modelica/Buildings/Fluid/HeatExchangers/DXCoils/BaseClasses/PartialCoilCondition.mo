within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses;
partial block PartialCoilCondition
  "Partial block for dry and wet coil condition"
  import Buildings;
  extends
    Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialCoilInterface;

  constant Boolean variableSpeedCoil
    "Flag, set to true for coil with variable speed";

  Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.CoolingCapacity cooCap[nSpe](
    each final m_flow_small=datCoi.m_flow_small,
    final per=datCoi.per) "Performance data"
    annotation (Placement(transformation(extent={{-14,40},{6,60}})));
  Modelica.Blocks.Routing.Replicator repMFlo(
    final nout=nSpe) "Massflow rate"
    annotation (Placement(transformation(extent={{-40,40},{-28,52}})));
  Modelica.Blocks.Routing.Replicator repTCon(
    final nout=nSpe) "Condenser air inlet temperature"
    annotation (Placement(transformation(extent={{-40,60},{-28,72}})));
  Modelica.Blocks.Routing.Replicator repTIn(
    final nout=nSpe) "Coil air inlet temperature"
    annotation (Placement(transformation(extent={{-40,20},{-28,32}})));

  Buildings.Utilities.Math.IntegerReplicator intRep(
    final nout=nSpe) "Replicator for coil stage"
    annotation (Placement(transformation(extent={{-40,80},{-28,92}})));
  SpeedShift speShiEIR(
    final variableSpeedCoil=variableSpeedCoil,
    final nSpe=nSpe,
    final speSet=datCoi.per.spe) "Interpolates EIR"
    annotation (Placement(transformation(extent={{32,64},{46,78}})));
  SpeedShift speShiQ_flow(
    final variableSpeedCoil=variableSpeedCoil,
    final nSpe=nSpe,
    final speSet=datCoi.per.spe) "Interpolates Q_flow"
    annotation (Placement(transformation(extent={{32,44},{46,58}})));
equation
  connect(repTCon.y, cooCap.TConIn) annotation (Line(
      points={{-27.4,66},{-22,66},{-22,54.8},{-15,54.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(repMFlo.y, cooCap.m_flow)    annotation (Line(
      points={{-27.4,46},{-24,46},{-24,50},{-15,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(repTIn.y, cooCap.TIn) annotation (Line(
      points={{-27.4,26},{-22,26},{-22,45.2},{-15,45.2}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(TConIn,repTCon. u) annotation (Line(
      points={{-110,50},{-93.6,50},{-93.6,66},{-41.2,66}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_flow, repMFlo.u)    annotation (Line(
      points={{-110,24},{-92,24},{-92,46},{-41.2,46}},
      color={0,0,127},
      smooth=Smooth.None));
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
  connect(stage, intRep.u) annotation (Line(
      points={{-110,100},{-50,100},{-50,86},{-41.2,86}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(intRep.y, cooCap.stage) annotation (Line(
      points={{-27.4,86},{-20,86},{-20,60},{-15,60}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(stage, speShiQ_flow.stage) annotation (Line(
      points={{-110,100},{20,100},{20,56.6},{30.6,56.6}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(speShiEIR.stage, stage) annotation (Line(
      points={{30.6,76.6},{20,76.6},{20,100},{-110,100}},
      color={255,127,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Documentation(info="<html>
<p>
This partial block provides initial calculations for 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DryCoil\"> 
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DryCoil</a> and
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.WetCoil\"> 
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.WetCoil</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
August 1, 2012 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>
</html>"),
    Icon(graphics));
end PartialCoilCondition;
