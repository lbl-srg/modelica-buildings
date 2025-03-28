within Buildings.Templates.Components.Chillers;
model Compression
  "Compression chiller"
  extends Buildings.Templates.Components.Interfaces.PartialChiller(
    final COP_nominal=abs(QChiWat_flow_nominal) / chi.PEle_nominal,
    final QCon_flow_nominal=chi.PEle_nominal - QChiWat_flow_nominal,
    final TConEnt_nominal=if dat.per.use_TConOutForTab then
      dat.TCon_nominal - QCon_flow_nominal / mCon_flow_nominal / cpCon_default
      else dat.TCon_nominal,
    final TConLvg_nominal=if dat.per.use_TConOutForTab then dat.TCon_nominal else
      dat.TCon_nominal + QCon_flow_nominal / mCon_flow_nominal / cpCon_default);
  Controls.StatusEmulator y1_actual
    "Compute chiller status"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=90,
      origin={60,0})));
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractSignal reqFloConWat(
    final nin=1,
    final nout=1,
    final extract={1})
    if typ == Buildings.Templates.Components.Types.Chiller.WaterCooled
    "Compute CW flow request" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,80})));
  Buildings.Controls.OBC.CDL.Logical.Not off
    "Return true if status is off"
    annotation (Placement(transformation(extent={{40,10},{20,30}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay delOff(
    delayTime=180)
    "Delay off status"
    annotation (Placement(transformation(extent={{-10,10},{-30,30}})));
  Buildings.Controls.OBC.CDL.Logical.Not reqFlo
    "Compute flow request"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=-90,
      origin={-40,50})));
  Buildings.Fluid.Chillers.ModularReversible.TableData2DLoadDep chi(
    redeclare final package MediumCon=MediumCon,
    redeclare final package MediumEva=MediumChiWat,
    final use_TLoaLvgForCtl=use_TChiWatSupForCtl,
    allowDifferentDeviceIdentifiers=true,
    final allowFlowReversalCon=allowFlowReversal1,
    final allowFlowReversalEva=allowFlowReversal2,
    final datCoo=dat.per,
    final dpCon_nominal=if have_dpCon then dpCon_nominal else 0,
    final dpEva_nominal=if have_dpChiWat then dpChiWat_nominal else 0,
    dTCon_nominal=0,
    final dTEva_nominal=TChiWatSup_nominal - TChiWatRet_nominal,
    final energyDynamics=energyDynamics,
    final have_switchover=have_switchover,
    final mCon_flow_nominal=mCon_flow_nominal,
    final mEva_flow_nominal=mChiWat_flow_nominal,
    final QCoo_flow_nominal=QChiWat_flow_nominal,
    final show_T=show_T,
    final tauCon=tau,
    final tauEva=tau,
    final TConCoo_nominal=dat.TCon_nominal,
    final TEvaCoo_nominal=if dat.per.use_TEvaOutForTab then TChiWatSup_nominal else TChiWatRet_nominal,
    use_intSafCtr=false)
    "Chiller"
    annotation (Placement(transformation(extent={{-10,-64},{10,-44}})));
equation
  connect(bus.y1, y1_actual.y1)
    annotation (Line(points={{0,100},{0,-20},{60,-20},{60,-12}},color={255,204,51},thickness=0.5));
  connect(y1_actual.y1_actual, bus.y1_actual)
    annotation (Line(points={{60,12},{60,94},{0,94},{0,100}},color={255,0,255}));
  connect(reqFloConWat.y[1], bus.y1ReqFloConWat) annotation (Line(points={{-60,
          92},{-60,96},{0,96},{0,100}}, color={255,0,255}));
  connect(y1_actual.y1_actual, off.u)
    annotation (Line(points={{60,12},{60,20},{42,20}},color={255,0,255}));
  connect(off.y, delOff.u)
    annotation (Line(points={{18,20},{-8,20}},color={255,0,255}));
  connect(delOff.y, reqFlo.u)
    annotation (Line(points={{-32,20},{-40,20},{-40,38}},color={255,0,255}));
  connect(reqFlo.y, bus.y1ReqFloChiWat)
    annotation (Line(points={{-40,62},{-40,94},{0,94},{0,100}},color={255,0,255}));
  connect(reqFlo.y, reqFloConWat.u[1]) annotation (Line(points={{-40,62},{-40,
          64},{-60,64},{-60,68}}, color={255,0,255}));
  connect(port_a2, chi.port_a2)
    annotation (Line(points={{100,-60},{10,-60}}, color={0,127,255}));
  connect(chi.port_b2, port_b2)
    annotation (Line(points={{-10,-60},{-100,-60}}, color={0,127,255}));
  connect(port_a1, chi.port_a1) annotation (Line(points={{-100,60},{-80,60},{-80,
          -48},{-10,-48}}, color={0,127,255}));
  connect(chi.port_b1, port_b1) annotation (Line(points={{10,-48},{80,-48},{80,60},
          {100,60}}, color={0,127,255}));
  connect(bus.y1, chi.on) annotation (Line(
      points={{0,100},{0,-40},{-20,-40},{-20,-54},{-12.2,-54}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.TSet, chi.TSet) annotation (Line(
      points={{0,100},{0,-40},{-20,-40},{-20,-52},{-12.2,-52}},
      color={255,204,51},
      thickness=0.5));
  annotation (
    defaultComponentName="chi",
    Documentation(
      info="<html>
<p>
This is a model for air-cooled or water-cooled compression chillers
where the capacity and input power are computed by interpolating manufacturer data
along the evaporator entering or leaving temperature, the 
condenser entering or leaving temperature and the part load ratio.
The model can be configured to represent either a cooling-only
chiller (<code>have_switchover=false</code>) or a heat-recovery chiller
(<code>have_switchover=true</code>) that can be controlled to track
either a CHW temperature setpoint or a HW temperature setpoint.
</p>
<p>
This model is a wrapper for
<a href=\"modelica://Buildings.Fluid.Chillers.ModularReversible.TableData2DLoadDep\">
Buildings.Fluid.Chillers.ModularReversible.TableData2DLoadDep</a>,
which the user may refer to for the modeling assumptions.
Note that, by default, internal safeties in this model are disabled.
</p>
<h4>Control points</h4>
<p>
The following input and output points are available.
</p>
<ul>
<li>
On/off command: <code>y1</code>, DO signal
</li>
<li>
(Only if <code>have_switchover=true</code>) Operating mode command: <code>y1Coo</code>,
DO signal, true for cooling, false for heating
</li>
<li>
Supply or return temperature setpoint <code>TSet</code>  
(the choice between supply and return temperature tracking
depends on the parameter: <code>use_TChiWatSupForCtl</code>),
AO signal corresponding to
<ul>
<li>CHW temperature setpoint if
<code>have_switchover=false</code> or if
<code>have_switchover=true</code> and <code>y1Coo=true</code>, or
</li>
<li>HW temperature setpoint if
<code>have_switchover=true</code> and <code>y1Coo=false</code>.
</li>
</ul>
</li>
<li>
Chiller status: <code>y1_actual</code>, DI signal
</li>
<li>
CHW flow request: <code>y1ReqFloChiWat</code>, DI signal
</li>
<li>
(Only if <code>typ=Buildings.Templates.Components.Types.Chiller.WaterCooled</code>)
CW flow request: <code>y1ReqFloConWat</code>, DI signal
</li>
</ul>
<h4>Model parameters</h4>
<p>
The design parameters and the chiller performance data are specified with an instance of
<a href=\"modelica://Buildings.Templates.Components.Data.Chiller\">
Buildings.Templates.Components.Data.Chiller</a>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
April 17, 2025, by Antoine Gautier:<br/>
Refactored with load-dependent 2D table data chiller model.
</li>
<li>
November 18, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end Compression;
