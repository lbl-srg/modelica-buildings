within Buildings.Experimental.DHC.EnergyTransferStations.Combined;
model HeatPumpHeatExchanger
  "Model of a substation with heat pump for heating, heat pump for domestic hot water, and compressor-less cooling"
  extends
    Buildings.Experimental.DHC.EnergyTransferStations.Combined.BaseClasses.PartialHeatPumpHeatExchanger(
      volMix_a(nPorts=4),
      volMix_b(nPorts=4));
  Buildings.Experimental.DHC.EnergyTransferStations.Combined.Subsystems.HeatPump proHotWat(
    redeclare final package Medium1 = MediumBui,
    redeclare final package Medium2 = MediumSer,
    final COP_nominal=COPHotWat_nominal,
    final TCon_nominal=THotWatSup_nominal,
    final TEva_nominal=TDisWatMin - dT_nominal,
    dT_nominal=dT_nominal,
    final Q1_flow_nominal=QHotWat_flow_nominal,
    final allowFlowReversal1=allowFlowReversalBui,
    final allowFlowReversal2=allowFlowReversalSer,
    final dp1_nominal=dp_nominal,
    final dp2_nominal=dp_nominal) if have_hotWat
    "Subsystem for hot water production"
    annotation (Placement(transformation(extent={{-10,24},{10,44}})));
  Buildings.Fluid.Sources.Boundary_pT      souColWat(
    redeclare final package Medium = MediumBui,
    use_T_in=true,
    nPorts=1) if have_hotWat
    "Source for cold water"
    annotation (Placement(transformation(extent={{-48,-50},{-28,-30}})));
  Buildings.Fluid.Sources.Boundary_pT sinSHW(redeclare final package Medium = MediumBui,
      nPorts=1)
               if have_hotWat
    "Sink for service hot water" annotation (Placement(
      transformation(
      extent={{10,-10},{-10,10}},
      rotation=180,
      origin={-60,60})));
  Buildings.Controls.OBC.CDL.Reals.Divide div1 if have_hotWat
    "Compute mass flow rate from load"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai(final k=
        cpBui_default) if have_hotWat "Times Cp"
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract delT if have_hotWat
    "Compute DeltaT needed on condenser side"
    annotation (Placement(transformation(extent={{-150,-20},{-130,0}})));
equation
  connect(souColWat.ports[1], proHotWat.port_a1) annotation (Line(points={{-28,-40},
          {-20,-40},{-20,40},{-10,40}}, color={0,127,255}));
  connect(sinSHW.ports[1], proHotWat.port_b1) annotation (Line(points={{-50,60},
          {14,60},{14,40},{10,40}},    color={0,127,255}));
  connect(THotWatSupSet, proHotWat.TSupSet) annotation (Line(points={{-320,-40},
          {-160,-40},{-160,36},{-86,36},{-86,37},{-12,37}},
                                          color={0,0,127}));
  connect(enaSHW.y, proHotWat.uEna) annotation (Line(points={{-118,80},{-114,80},
          {-114,43},{-12,43}}, color={255,0,255}));
  connect(proHotWat.PPum, PPumHeaTot.u[2]) annotation (Line(points={{12,34},{176,
          34},{176,420},{188,420},{188,420.5}},
                                              color={0,0,127}));
  connect(proHotWat.mEva_flow, masFloHeaTot.u[2]) annotation (Line(points={{12,31},
          {218,31},{218,-139.5},{268,-139.5}},
                                           color={0,0,127}));
  connect(proHotWat.mEva_flow, masFloHea.u2) annotation (Line(points={{12,31},{18,
          31},{18,-240},{-6,-240},{-6,-252}}, color={0,0,127}));
  connect(proHotWat.PHea, PHeaTot.u[2]) annotation (Line(points={{12,37},{240,
          37},{240,80},{256,80},{256,80.5},{268,80.5}},
                              color={0,0,127}));
  connect(TColWat, souColWat.T_in) annotation (Line(points={{-320,-80},{-60,-80},
          {-60,-36},{-50,-36}}, color={0,0,127}));
  connect(proHotWat.port_a2, volMix_a.ports[4]) annotation (Line(points={{10,28},
          {14,28},{14,20},{-260,20},{-260,-360}}, color={0,127,255}));
  connect(proHotWat.port_b2, volMix_b.ports[4])
    annotation (Line(points={{-10,28},{-14,28},{-14,0},{260,0},{260,-360}},
                                                           color={0,127,255}));
  connect(gai.y,div1. u2) annotation (Line(points={{-98,-10},{-80,-10},{-80,-30},
          {-120,-30},{-120,-56},{-102,-56}},          color={0,0,127}));
  connect(QReqHotWat_flow,div1. u1) annotation (Line(points={{-320,-120},{-290,-120},{
          -290,-44},{-102,-44}},
                            color={0,0,127}));
  connect(delT.y,gai. u)
    annotation (Line(points={{-128,-10},{-122,-10}}, color={0,0,127}));
  connect(TColWat,delT. u2) annotation (Line(points={{-320,-80},{-156,-80},{
          -156,-16},{-152,-16}},
                            color={0,0,127}));
  connect(THotWatSupSet,delT. u1) annotation (Line(points={{-320,-40},{-160,-40},
          {-160,-4},{-152,-4}},
                            color={0,0,127}));
  connect(div1.y, proHotWat.m1_flow) annotation (Line(points={{-78,-50},{-70,
          -50},{-70,34},{-12,34}}, color={0,0,127}));
  annotation (
  Documentation(info="<html>
<p>
This model uses the base energy transfer station defined in
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.BaseClasses.PartialHeatPumpHeatExchanger\">
Buildings.Experimental.DHC.EnergyTransferStations.Combined.BaseClasses.PartialHeatPumpHeatExchanger</a>.
</p>
<h4>Domestic Hot Water</h4>
<p>
Domestic hot water is produced using a dedicated water-to-water heat pump
on-demand with no storage.
</p>
<p>
Heating is enabled based on the input signal <code>uSHW</code>
which is held for <i>15</i> minutes, meaning that,
when enabled, the mode remains active for at least <i>15</i> minutes and,
when disabled, the mode cannot be enabled again for at least <i>15</i> minutes.
The enable signal should be computed externally based
on a schedule (to lock out the system during off-hours), ideally in conjunction
with the number of requests or any other signal representative of the load.
</p>
<p>
When enabled,
</p>
<ul>
<li>
The heat pump and the evaporator and condenser hydronics are controlled
based on the principles described in
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.Subsystems.HeatPump_Old\">
Buildings.Experimental.DHC.EnergyTransferStations.Combined.Subsystems.HeatPump</a>.
</li>
<li>
The condensor water mass flow rate is computed based on the domestic hot water
heating load (input <code>QReqHotWat_flow</code>) where the temperature of water is boosted from the
domestic cold water temperature (input <code>TColWat</code>) to the desired domestic hot water
distribution temperature (parameter <code>THotWatSup_nominal</code>), according
to the following equation:
<p align=\"center\" style=\"font-style:italic;\">
<code>QReqHotWat_flow</code> = m&#775; cp (<code>THotWatSup_nominal</code> - <code>TColWat</code>)
</p>
</li>
</ul>
</html>",
  revisions="<html>
<ul>
<li>
September 13, 2023, by David Blum:<br/>
Extended from partial base class.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3063\">
issue 3063</a>.
</li>
<li>
May 17, 2023, by David Blum:<br/>
Assigned dp_nominal to <code>pum1HexChi</code>.<br/>
Corrected calculation of heat pump evaporator mass flow control.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3379\">
issue 3379</a>.
</li>
<li>
February 23, 2021, by Antoine Gautier:<br/>
Refactored with subsystem models and partial ETS base class.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1769\">
issue 1769</a>.
</li>
<li>
December 12, 2017, by Michael Wetter:<br/>
Removed call to <code>Modelica.Utilities.Files.loadResource</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1097\">issue 1097</a>.
</li>
</ul>
</html>"));
end HeatPumpHeatExchanger;
