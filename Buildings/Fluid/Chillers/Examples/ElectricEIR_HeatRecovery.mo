within Buildings.Fluid.Chillers.Examples;
model ElectricEIR_HeatRecovery
  "Test model for chiller electric EIR with heat recovery"
  extends Modelica.Icons.Example;
  extends Buildings.Fluid.Chillers.Examples.BaseClasses.PartialElectric(
      P_nominal=-per.QEva_flow_nominal/per.COP_nominal,
      mEva_flow_nominal=per.mEva_flow_nominal,
      mCon_flow_nominal=per.mCon_flow_nominal,
    sou1(nPorts=1),
    sou2(nPorts=1),
    TSet(
     height=8,
     offset=273.15 + 25));

  parameter Data.ElectricEIR.ElectricEIRChiller_McQuay_WSC_471kW_5_89COP_Vanes
    per "Chiller performance data"
    annotation (Placement(transformation(extent={{60,78},{80,98}})));

  Buildings.Fluid.Chillers.ElectricEIR chi(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    have_switchover=true,
    per=per,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    dp1_nominal=6000,
    dp2_nominal=6000) "Chiller model"
    annotation (Placement(transformation(extent={{0,-2},{20,18}})));

  Controls.OBC.CDL.Logical.Sources.Constant fal(final k=false)
    "Constant false signal"
    annotation (Placement(transformation(extent={{30,50},{10,70}})));
equation
  connect(sou1.ports[1], chi.port_a1) annotation (Line(
      points={{-40,16},{0,16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(chi.port_b1, res1.port_a) annotation (Line(
      points={{20,16},{26,16},{26,40},{32,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou2.ports[1], chi.port_a2) annotation (Line(
      points={{40,4},{20,4}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(chi.port_b2, res2.port_a) annotation (Line(
      points={{0,4},{-10,4},{-10,-20},{-20,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(chi.on, greaterThreshold.y) annotation (Line(
      points={{-2,13},{-10,13},{-10,90},{-19,90}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(chi.TSet, TSet.y) annotation (Line(
      points={{-2,7},{-30,7},{-30,60},{-59,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fal.y, chi.coo)
    annotation (Line(points={{8,60},{2,60},{2,24}}, color={255,0,255}));
  annotation (
experiment(Tolerance=1e-6, StopTime=14400),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Chillers/Examples/ElectricEIR_HeatRecovery.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Example that simulates a heat recovery chiller operating in heating mode,
i.e., tracking a hot water supply temperature setpoint.
The chiller efficiency is computed based on the
condenser entering and evaporator leaving fluid temperature.
A bicubic polynomial is used to compute the chiller part load performance.
</p>
</html>", revisions="<html>
<ul>
<li>
January 11, 2023, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end ElectricEIR_HeatRecovery;
