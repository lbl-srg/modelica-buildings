within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses;
partial model PartialDXCoil "Partial model for DX coil"
  extends
    Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.EssentialParameters;
  extends Buildings.Fluid.BaseClasses.IndexMassFraction(final substanceName = "water");
  extends Buildings.Fluid.Interfaces.TwoPortHeatMassExchanger(
    redeclare package Medium = Medium,
    redeclare final Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir vol(
      prescribedHeatFlowRate=true),
    final m_flow_nominal = datCoi.sta[nSta].nomVal.m_flow_nominal);

  Modelica.Blocks.Interfaces.RealInput TConIn(
    unit="K",
    displayUnit="degC")
    "Outside air dry bulb temperature for an air cooled condenser or wetbulb temperature for an evaporative cooled condenser"
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));
  Modelica.Blocks.Interfaces.RealOutput P(
    quantity="Power",
    unit="W") "Electrical power consumed by the unit"
    annotation (Placement(transformation(extent={{100,80},{120,100}})));
  Modelica.Blocks.Interfaces.RealOutput QSen_flow(quantity="Power", unit="W")
    "Sensible heat flow rate"
    annotation (Placement(transformation(extent={{100,60},{120,80}})));
  Modelica.Blocks.Interfaces.RealOutput QLat_flow(quantity="Power", unit="W")
    "Latent heat flow rate"
    annotation (Placement(transformation(extent={{100,40},{120,60}})));

  Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DXCooling dxCoo(
    redeclare final package Medium = Medium,
    final datCoi=datCoi) "DX cooling coil operation"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));

  Evaporation eva(redeclare final package Medium = Medium,
                  final nomVal=datCoi.sta[nSta].nomVal,
                  final computeReevaporation = computeReevaporation)
    "Model that computes evaporation of water that accumulated on the coil surface"
    annotation (Placement(transformation(extent={{-8,-80},{12,-60}})));
  parameter Boolean computeReevaporation=true
    "Set to true to compute reevaporation of water that accumulated on coil"
    annotation (Evaluate=true, Dialog(tab="Dynamics", group="Moisture balance"));

  // Flow reversal is not needed. Also, if ff < ffMin/4, then
  // Q_flow and EIR are set the zero. Hence, it is safe to assume
  // forward flow, which will avoid an event
protected
  Modelica.SIunits.SpecificEnthalpy hEvaIn=
    inStream(port_a.h_outflow) "Enthalpy of air entering the cooling coil";
  Modelica.SIunits.Temperature TEvaIn = Medium.temperature_phX(p=port_a.p, h=hEvaIn, X=XEvaIn)
    "Dry bulb temperature of air entering the cooling coil";
  Modelica.SIunits.MassFraction XEvaIn[Medium.nXi] = inStream(port_a.Xi_outflow)
    "Mass fraction/absolute humidity of air entering the cooling coil";

  Modelica.Blocks.Sources.RealExpression p(final y=port_a.p)
    "Inlet air pressure"
    annotation (Placement(transformation(extent={{-90,4},{-70,24}})));
  Modelica.Blocks.Sources.RealExpression X(final y=XEvaIn[i_x])
    "Inlet air mass fraction"
    annotation (Placement(transformation(extent={{-56,26},{-36,46}})));
  Modelica.Blocks.Sources.RealExpression T(final y=TEvaIn)
    "Inlet air temperature"
    annotation (Placement(transformation(extent={{-90,18},{-70,38}})));
  Modelica.Blocks.Sources.RealExpression m(final y=port_a.m_flow)
    "Inlet air mass flow rate"
    annotation (Placement(transformation(extent={{-90,34},{-70,54}})));
  Modelica.Blocks.Sources.RealExpression h(final y=hEvaIn)
    "Inlet air specific enthalpy"
    annotation (Placement(transformation(extent={{-56,12},{-36,32}})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow q "Heat extracted by coil"
    annotation (Placement(transformation(extent={{42,44},{62,64}})));
  BaseClasses.InputPower pwr "Electrical power consumed by the unit"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));

  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TVol
    "Temperature of the control volume"
    annotation (Placement(transformation(extent={{66,16},{78,28}})));
initial algorithm
  // Make sure that |Q_flow_nominal[nSta]| >= |Q_flow_nominal[i]| for all stages because the data
  // of nSta are used in the evaporation model
  for i in 1:(nSta-1) loop
    assert(datCoi.sta[i].nomVal.Q_flow_nominal >= datCoi.sta[nSta].nomVal.Q_flow_nominal,
    "Error in DX coil performance data: Q_flow_nominal of the highest stage must have
    the biggest value in magnitude. Obtained " + Modelica.Math.Vectors.toString(
    {datCoi.sta[i].nomVal.Q_flow_nominal for i in 1:nSta}, "Q_flow_nominal"));
   end for;

equation
  connect(TConIn, dxCoo.TConIn)  annotation (Line(
      points={{-110,30},{-94,30},{-94,54},{-94,54},{-94,55},{-21,55}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m.y, dxCoo.m_flow)  annotation (Line(
      points={{-69,44},{-66,44},{-66,52.4},{-21,52.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T.y, dxCoo.TEvaIn)       annotation (Line(
      points={{-69,28},{-62,28},{-62,50},{-21,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(p.y, dxCoo.p)  annotation (Line(
      points={{-69,14},{-58,14},{-58,47.6},{-21,47.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(X.y, dxCoo.XEvaIn)      annotation (Line(
      points={{-35,36},{-30,36},{-30,45},{-21,45}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(h.y, dxCoo.hEvaIn)     annotation (Line(
      points={{-35,22},{-26,22},{-26,42.3},{-21,42.3}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dxCoo.EIR, pwr.EIR)  annotation (Line(
      points={{1,58},{6,58},{6,76},{18,76}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dxCoo.Q_flow, pwr.Q_flow)  annotation (Line(
      points={{1,54},{10,54},{10,70},{18,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dxCoo.SHR, pwr.SHR)  annotation (Line(
      points={{1,50},{14,50},{14,64},{18,64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(q.port, vol.heatPort) annotation (Line(
      points={{62,54},{66,54},{66,22},{-12,22},{-12,-10},{-9,-10}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(pwr.P, P)    annotation (Line(
      points={{41,76},{50.5,76},{50.5,90},{110,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dxCoo.Q_flow, q.Q_flow) annotation (Line(
      points={{1,54},{42,54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(eva.mWat_flow, dxCoo.mWat_flow) annotation (Line(
      points={{-10,-66},{-18,-66},{-18,8},{8,8},{8,42},{1,42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dxCoo.TCoiSur, vol.TWat) annotation (Line(
      points={{1,46},{10,46},{10,6},{-22,6},{-22,-14.8},{-11,-14.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dxCoo.TCoiSur, eva.TWat) annotation (Line(
      points={{1,46},{10,46},{10,6},{-22,6},{-22,-72},{-10,-72}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m.y, eva.mAir_flow) annotation (Line(
      points={{-69,44},{-66,44},{-66,-78},{-10,-78}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TVol.port, q.port) annotation (Line(
      points={{66,22},{66,54},{62,54}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pwr.QSen_flow, QSen_flow) annotation (Line(
      points={{41,70},{110,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pwr.QLat_flow, QLat_flow) annotation (Line(
      points={{41,64},{94,64},{94,50},{110,50}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(eva.mTotWat_flow, vol.mWat_flow) annotation (Line(
      points={{13,-70},{20,-70},{20,-32},{-16,-32},{-16,-18},{-11,-18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TVol.T, eva.TEvaOut) annotation (Line(
      points={{78,22},{88,22},{88,-94},{8,-94},{8,-82}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(vol.X_w, eva.XEvaOut) annotation (Line(
      points={{13,-6},{40,-6},{40,-90},{-4,-90},{-4,-82}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (              defaultComponentName="dxCoi", Documentation(info="<html>
<p>
This partial model is the base class for
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.SingleSpeed\">
Buildings.Fluid.HeatExchangers.DXCoils.SingleSpeed</a>
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.MultiStage\">
Buildings.Fluid.HeatExchangers.DXCoils.MultiStage</a> and
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.VariableSpeed\">
Buildings.Fluid.HeatExchangers.DXCoils.VariableSpeed</a>.
</p>
<p>
See
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.UsersGuide\">
Buildings.Fluid.HeatExchangers.DXCoils.UsersGuide</a>
for an explanation of the model.
</p>
</html>",
revisions="<html>
<ul>
<li>
May 6, 2015 by Michael Wetter:<br/>
Added <code>prescribedHeatFlowRate=true</code> for <code>vol</code>.
</li>
<li>
August 31, 2013, by Michael Wetter:<br/>
Updated model due to change in
<code>Buildings.Fluid.BaseClasses.IndexMassFraction</code>.
</li>
<li>
September 24, 2012 by Michael Wetter:<br/>
Revised documentation.
</li>
<li>
September 4, 2012 by Michael Wetter:<br/>
Moved assignments to declaration section to avoid mixing graphical modeling with textual
modeling in <code>equation</code> section.
Redeclare medium model as <code>Modelica.Media.Interfaces.PartialCondensingGases</code>
to remove errors during model check.
Added output connectors for sensible and latent heat flow rate.
</li>
<li>
April 12, 2012 by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>

</html>"),
    Icon(graphics={Text(
          extent={{-138,64},{-80,46}},
          lineColor={0,0,127},
          textString="TConIn"), Text(
          extent={{58,98},{102,78}},
          lineColor={0,0,127},
          textString="P"),      Text(
          extent={{54,60},{98,40}},
          lineColor={0,0,127},
          textString="QLat"),   Text(
          extent={{54,80},{98,60}},
          lineColor={0,0,127},
          textString="QSen")}));
end PartialDXCoil;
