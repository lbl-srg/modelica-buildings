within Buildings.Fluid.CHPs.Rankine.Examples;
model ORC_FluidPort "Example ORC with fluid port implementation"
  extends BaseClasses.PartialORC(
    redeclare Buildings.Fluid.CHPs.Rankine.BottomingCycle_FluidPort ORC(
      redeclare final package Medium = MediumEva,
      final m_flow_nominal = mEva_flow_nominal,
      final UA=50,
      eva(
        final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)),
    souEva(nPorts=1),
    sinEva(nPorts=1));
  extends Modelica.Icons.Example;

equation
  connect(souEva.ports[1],ORC.port_a)  annotation (Line(points={{-60,50},{-40,
          50},{-40,0},{-10,0}}, color={0,127,255}));
  connect(ORC.port_b, sinEva.ports[1]) annotation (Line(points={{10,0},{40,0},{
          40,50},{60,50}}, color={0,127,255}));
annotation(experiment(StopTime=1, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/CHPs/Rankine/Examples/ORC_FluidPort.mos"
  "Simulate and plot"),
  Documentation(info="<html>
<p>
This model demonstrates the use of
<a href=\"modelica://Buildings.Fluid.CHPs.Rankine.BottomingCycle_FluidPort\">
Buildings.Fluid.CHPs.Rankine.BottomingCycle_FluidPort</a>.
</html>",revisions="<html>
<ul>
<li>
June 30, 2023, by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3433\">#3433</a>.
</li>
</ul>
</html>"));
end ORC_FluidPort;
