within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses;
partial block PartialCoilCondition
  "Partial block for dry and wet coil condition"
  extends
    Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialCoilInterface;
public
  Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.CoolingCapacity cooCap[nSpe](
    each m_flow_small=datCoi.m_flow_small,
    per=datCoi.per) "Performance data"
    annotation (Placement(transformation(extent={{-14,40},{6,60}})));
  Modelica.Blocks.Routing.Replicator repMFlo(
    nout=nSpe) "Massflow rate"
    annotation (Placement(transformation(extent={{-40,40},{-28,52}})));
  Modelica.Blocks.Routing.Replicator repTCon(
    nout=nSpe) "Condenser air inlet temperature"
    annotation (Placement(transformation(extent={{-40,60},{-28,72}})));
  Modelica.Blocks.Routing.Replicator repTIn(
    nout=nSpe) "Coil air inlet temperature"
    annotation (Placement(transformation(extent={{-40,20},{-28,32}})));

  Buildings.Utilities.Math.BooleanReplicator booRep(
    nout=nSpe) "On-off signal"
    annotation (Placement(transformation(extent={{-40,80},{-28,92}})));
  SpeedShift speShiEIR(
    nSpe=nSpe,
    speSet=datCoi.per.spe) "Interpolates EIR"
    annotation (Placement(transformation(extent={{20,66},{34,80}})));
  SpeedShift speShiQ_flow(
    nSpe=nSpe,
    speSet=datCoi.per.spe) "Interpolates Q_flow"
    annotation (Placement(transformation(extent={{20,40},{34,54}})));
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
  connect(on, booRep.u) annotation (Line(
      points={{-110,100},{-64,100},{-64,86},{-41.2,86}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(booRep.y, cooCap.on) annotation (Line(
      points={{-27.4,86},{-18,86},{-18,60},{-15,60}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(cooCap.EIR, speShiEIR.u)
                                  annotation (Line(
      points={{7,54},{10,54},{10,69.5},{18.6,69.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cooCap.Q_flow, speShiQ_flow.u)
                                        annotation (Line(
      points={{7,46},{12,46},{12,43.5},{18.6,43.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speShiEIR.y, EIR)
                           annotation (Line(
      points={{34.7,69.5},{60.5,69.5},{60.5,80},{110,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRat, speShiEIR.speRat)
                                   annotation (Line(
      points={{-110,76},{14,76},{14,76.5},{18.6,76.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRat, speShiQ_flow.speRat)
                                      annotation (Line(
      points={{-110,76},{14,76},{14,50.5},{18.6,50.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speShiQ_flow.y, Q_flow)
                                 annotation (Line(
      points={{34.7,43.5},{40,43.5},{40,40},{110,40}},
      color={0,0,127},
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
</html>"));
end PartialCoilCondition;
