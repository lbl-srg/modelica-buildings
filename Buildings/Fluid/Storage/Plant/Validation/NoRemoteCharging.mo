within Buildings.Fluid.Storage.Plant.Validation;
model NoRemoteCharging
  "(Draft) Validation model of the plant not allowing remote charging"
  extends Modelica.Icons.Example;
  extends
    Buildings.Fluid.Storage.Plant.Validation.BaseClasses.PartialTankBranch(
      tanBra(final allowRemoteCharging=false),
      souChi(final m_flow=1));

  Modelica.Blocks.Sources.TimeTable set_mPumSec_flow(table=[0,1; 900,1; 900,-1;
        1800,-1; 1800,0; 2700,0; 2700,1; 3600,1])
    "Secondary mass flow rate setpoint"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Buildings.Controls.Continuous.LimPID conPID_PumSec(
    k=1,
    Ti=15) "PI controller" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-50,10})));
  Modelica.Blocks.Math.Gain gai(k=1/tanBra.mTan_flow_nominal) "Gain"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-50,-30})));
equation
  connect(gai.y, conPID_PumSec.u_m)
    annotation (Line(points={{-50,-19},{-50,-2}}, color={0,0,127}));
  connect(set_mPumSec_flow.y, conPID_PumSec.u_s)
    annotation (Line(points={{-79,10},{-62,10}}, color={0,0,127}));
  connect(conPID_PumSec.y, tanBra.yPum) annotation (Line(points={{-39,10},{-39,
          8},{-16,8},{-16,2},{-11,2}}, color={0,0,127}));
  connect(tanBra.mTan_flow, gai.u) annotation (Line(points={{11,2},{36,2},{36,-48},
          {-50,-48},{-50,-42}}, color={0,0,127}));
  annotation (__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Plant/Validation/NoRemoteCharging.mos"
        "Simulate and plot"),
  experiment(Tolerance=1e-06, StopTime=3600),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>
(Draft) This is a validation model where the plant is configured not to allow
remotely charging the tank.
</p>
</html>", revisions="<html>
<ul>
<li>
February 18, 2022 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end NoRemoteCharging;
