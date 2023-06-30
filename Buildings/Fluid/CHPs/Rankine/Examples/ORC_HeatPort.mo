within Buildings.Fluid.CHPs.Rankine.Examples;
model ORC_HeatPort "Example ORC model with heat port implementation"
  extends BaseClasses.PartialORC(
    redeclare Buildings.Fluid.CHPs.Rankine.BottomingCycle_HeatPort ran);
  extends Modelica.Icons.Example;

  Buildings.Fluid.HeatExchangers.EvaporatorCondenser eva(
    redeclare final package Medium = MediumEva,
    final allowFlowReversal=false,
    final m_flow_nominal=mEva_flow_nominal,
    final from_dp=false,
    final dp_nominal=0,
    final linearizeFlowResistance=true,
    final T_start=sinEva.T,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final UA=50) "Evaporator"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
        rotation=180,
        origin={0,50})));
equation
  connect(eva.port_ref,ran. port_a) annotation (Line(points={{-1.27676e-15,44},{
          -1.27676e-15,27},{0,27},{0,10}}, color={191,0,0}));
  connect(souEva.ports[1], eva.port_a)
    annotation (Line(points={{-60,50},{-10,50}}, color={0,127,255}));
  connect(sinEva.ports[1], eva.port_b)
    annotation (Line(points={{60,50},{10,50}}, color={0,127,255}));
annotation(Documentation(info="<html>
<p>
This model demonstrates how the model
<a href=\"modelica://Buildings.Fluid.CHPs.Rankine.BottomingCycle_HeatPort\">
Buildings.Fluid.CHPs.Rankine.BottomingCycle</a>
can be connected to heat exchangers.
</html>",revisions="<html>
<ul>
<li>
June 13, 2023, by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3433\">#3433</a>.
</li>
</ul>
</html>"));
end ORC_HeatPort;
