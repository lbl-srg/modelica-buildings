within Buildings.Fluid.Storage.Plant.Validation;
model WithRemoteCharging
  "(Draft) Validation model of the plant allowing remote charging"
  extends Modelica.Icons.Example;
  extends
    Buildings.Fluid.Storage.Plant.Validation.BaseClasses.PartialTankBranch(
      nom(final allowRemoteCharging=true),
      souChi(final use_m_flow_in=true));

  Modelica.Blocks.Sources.TimeTable set_mTan_flow(table=[0,0; 3600/7,0; 3600/7,
        -1; 3600/7*3,-1; 3600/7*3,0; 3600/7*4,0; 3600/7*4,1; 3600/7*6,1; 3600/7
        *6,-1])
            "Tank flow rate setpoint"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Modelica.Blocks.Sources.BooleanTable uRemCha(table={0,3600/7*6}, startValue=
        true) "Tank is being charged remotely"
    annotation (Placement(transformation(extent={{100,80},{80,100}})));
  Modelica.Blocks.Sources.BooleanTable uOnl(table={3600/7*2})
    "True = plant online (outputting CHW to the network); False = offline"
    annotation (Placement(transformation(extent={{100,40},{80,60}})));
  Modelica.Blocks.Sources.TimeTable set_mChi_flow(table=[0,0; 3600/7,0; 3600/7,
        1; 3600/7*5,1; 3600/7*5,0]) "Chiller flow rate setpoint"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Buildings.Fluid.Storage.Plant.BaseClasses.ReversiblePumpValveControl
    conPumSec "Control block for the secondary pump and near-by valves"
    annotation (Placement(transformation(extent={{10,40},{30,60}})));
equation
  connect(set_mChi_flow.y, souChi.m_flow_in)
    annotation (Line(points={{-79,30},{-70,30},{-70,38},{-62,38}},
                                                       color={0,0,127}));
  connect(set_mTan_flow.y, conPumSec.mTanSet_flow)
    annotation (Line(points={{-79,70},{6,70},{6,58},{9,58}}, color={0,0,127}));
  connect(tanBra.mTan_flow, conPumSec.mTan_flow)
    annotation (Line(points={{-12,11},{-12,54},{9,54}}, color={0,0,127}));
  connect(supPum.yValCha_actual, conPumSec.yValCha_actual) annotation (Line(
        points={{14,11},{14,36},{4,36},{4,46},{9,46}}, color={0,0,127}));
  connect(supPum.yValDis_actual, conPumSec.yValDis_actual) annotation (Line(
        points={{10,11},{10,34},{2,34},{2,50},{9,50}}, color={0,0,127}));
  connect(conPumSec.uOnl, uOnl.y) annotation (Line(points={{32,54},{74,54},{74,
          50},{79,50}}, color={255,0,255}));
  connect(conPumSec.uRemCha, uRemCha.y)
    annotation (Line(points={{32,58},{32,90},{79,90}}, color={255,0,255}));
  connect(conPumSec.yPum, supPum.yPum)
    annotation (Line(points={{20,39},{20,11}}, color={0,0,127}));
  connect(conPumSec.yValCha, supPum.yValCha)
    annotation (Line(points={{24,39},{24,11}}, color={0,0,127}));
  connect(conPumSec.yValDis, supPum.yValDis)
    annotation (Line(points={{28,39},{28,11}}, color={0,0,127}));
  annotation (
  experiment(Tolerance=1e-06, StopTime=3600),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Plant/Validation/WithRemoteCharging.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
(Draft) This is a validation model where the plant is configured to allow
remotely charging the tank.
<p>
Operation modes implemented in time tables:
</p>
<table summary= \"operation modes\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<thead>
  <tr>
    <th></th>
    <th>Plant</th>
    <th>Chiller</th>
    <th>Tank</th>
    <th>Flow direction</th>
    <th>Tank flow rate setpoint</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td>1.</td>
    <td>off</td>
    <td>off</td>
    <td>off</td>
    <td>N/A</td>
    <td>0</td>
  </tr>
  <tr>
    <td>2.</td>
    <td>off</td>
    <td>on</td>
    <td>charging</td>
    <td>N/A</td>
    <td>-1</td>
  </tr>
  <tr>
    <td>3.</td>
    <td>on</td>
    <td>on</td>
    <td>charging</td>
    <td>normal</td>
    <td>-1</td>
  </tr>
  <tr>
    <td>4.</td>
    <td>on</td>
    <td>on</td>
    <td>off</td>
    <td>normal</td>
    <td>0</td>
  </tr>
  <tr>
    <td>5.</td>
    <td>on</td>
    <td>on</td>
    <td>discharging</td>
    <td>normal</td>
    <td>1</td>
  </tr>
  <tr>
    <td>6.</td>
    <td>on</td>
    <td>off</td>
    <td>discharging</td>
    <td>normal</td>
    <td>1</td>
  </tr>
  <tr>
    <td>7.</td>
    <td>on</td>
    <td>off</td>
    <td>charging</td>
    <td>reverse</td>
    <td>-1</td>
  </tr>
</tbody>
</table>
</html>", revisions="<html>
<ul>
<li>
February 18, 2022 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end WithRemoteCharging;
