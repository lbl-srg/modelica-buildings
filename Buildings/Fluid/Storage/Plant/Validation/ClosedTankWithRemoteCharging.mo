within Buildings.Fluid.Storage.Plant.Validation;
model ClosedTankWithRemoteCharging
  "(Draft) Validation model of the plant allowing remote charging"
  extends Modelica.Icons.Example;
  extends
    Buildings.Fluid.Storage.Plant.Validation.BaseClasses.PartialClosedTank(nom(
      final plaTyp=
        Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote));

  Modelica.Blocks.Sources.TimeTable set_mTan_flow(table=[0,0; 3600/7,0; 3600/7,
        -1; 3600/7*3,-1; 3600/7*3,0; 3600/7*4,0; 3600/7*4,1; 3600/7*6,1; 3600/7
        *6,-1])
            "Tank flow rate setpoint"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Modelica.Blocks.Sources.BooleanTable uRemCha(table={0,3600/7*6}, startValue=
        true) "Tank is being charged remotely"
    annotation (Placement(transformation(extent={{80,80},{60,100}})));
  Modelica.Blocks.Sources.BooleanTable uOnl(table={3600/7*2})
    "True = plant online (outputting CHW to the network); False = offline"
    annotation (Placement(transformation(extent={{82,40},{62,60}})));
  Modelica.Blocks.Sources.TimeTable set_mChi_flow(table=[0,0; 3600/7,0; 3600/7,
        1; 3600/7*5,1; 3600/7*5,0]) "Chiller flow rate setpoint"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Buildings.Fluid.Storage.Plant.BaseClasses.PumpValveControl conSupPum(
    final plaTyp=nom.plaTyp) "Control block for the secondary pump and valves"
    annotation (Placement(transformation(extent={{10,40},{30,60}})));
equation
  connect(set_mTan_flow.y,conSupPum. mTanSet_flow)
    annotation (Line(points={{-79,70},{6,70},{6,54},{9,54}}, color={0,0,127}));
  connect(tanBra.mTanBot_flow,conSupPum. mTanBot_flow)
    annotation (Line(points={{-12,11},{-12,48},{9,48}}, color={0,0,127}));
  connect(conSupPum.uOnl, uOnl.y) annotation (Line(points={{32,56},{56,56},{56,
          50},{61,50}}, color={255,0,255}));
  connect(conSupPum.uRemCha, uRemCha.y)
    annotation (Line(points={{32,60},{32,90},{59,90}}, color={255,0,255}));
  connect(set_mChi_flow.y, ideChiBra.mPumSet_flow)
    annotation (Line(points={{-79,-30},{-56,-30},{-56,-11}}, color={0,0,127}));
  connect(supPum.ySup_actual, conSupPum.ySup_actual) annotation (Line(points={{
          14,11},{14,34},{4,34},{4,40},{9,40}}, color={0,0,127}));
  connect(conSupPum.yPumSup, supPum.yPumSup)
    annotation (Line(points={{18,39},{18,11}}, color={0,0,127}));
  connect(conSupPum.yValSup, supPum.yValSup)
    annotation (Line(points={{22,39},{22,11}}, color={0,0,127}));
  annotation (
  experiment(Tolerance=1e-06, StopTime=3600),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Plant/Validation/ClosedTankWithRemoteCharging.mos"
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
end ClosedTankWithRemoteCharging;
